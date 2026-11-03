#!/usr/bin/env python3
"""Make a logging-patched FA20DIT image: re-point spare SSM 0xA8 index slots at RAM variables, fix the checksum.

What is changed: only the u32 pointer words of the chosen slots in the 848-entry index table (SPEC 'table') and the
checksum correction word 0x1FFFFE (same rule as tools/checksum.py (or tools/checksum.ps1): u16 big-endian word sum 0x6000..0x1FFFFF =
0x5AA5). Nothing else.

Checks before writing (any failure aborts, nothing is written):
  * image is 2 MB and contains the spec's calibration ID; the table base is the literal the A8 handler loads (found as a u32 in the image);
  * the table holds 848 pointers; its "spare" pointers are the two most common values, both into ROM and pointing at
    a constant 0x00 / 0xFF byte (0x1D0C9 / 0x1D0CA in LF75404S);
  * every slot to patch currently holds one of the spare pointers (so no logged parameter is displaced) and no slot is
    listed twice;
  * every new pointer is in RAM 0xFFF80000..0xFFF9FFFF; a pointer that another (stock) slot already holds is reported.
Checks after patching (verification, also run on the written file):
  * byte diff against the input: changed bytes lie only inside the patched table words and the correction word;
  * every patched slot reads back as the requested RAM address and was spare before;
  * checksum: sum16 = 0x5AA5, and the validity markers are unchanged (tools/checksum.py (or tools/checksum.ps1) report()).

usage: make_logpatch.py SPEC.json ROM OUT.bin
       make_logpatch.py --verify SPEC.json ROM PATCHED.bin      (verification only)"""
import collections
import os
import json
import struct
import sys

sys.dont_write_bytecode = True  # keep the repo untouched (no __pycache__ write)
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
import checksum  # noqa: E402  (the repo's checksum rule, read-only import)

N = 0x350
RAM_LO, RAM_HI = 0xFFF80000, 0xFFFA0000


def u32(d, a):
    return struct.unpack_from('>I', d, a)[0]


def table_info(d, base):
    ptrs = [u32(d, base + 4 * i) for i in range(N)]
    c = collections.Counter(ptrs)
    spare = [a for a, _ in c.most_common(2)]
    for a in spare:
        if not (a < 0x200000 and d[a] in (0x00, 0xFF)):
            raise SystemExit('spare pointer %06X is not a constant 0x00/0xFF ROM byte' % a)
    return ptrs, set(spare)


def check_spec(spec, d):
    base = int(spec['table'], 16)
    if len(d) != checksum.END:
        raise SystemExit('image size %d, expected %d' % (len(d), checksum.END))
    # the spec's RAM addresses are per calibration: refuse an image of another calibration ID
    if d.find(spec['calid'].encode('ascii')) < 0:
        raise SystemExit('calibration ID %s not found in the image: this spec is for another ROM' % spec['calid'])
    if d.find(struct.pack('>I', base)) < 0:
        raise SystemExit('table base %06X is not loaded as a literal anywhere in the image' % base)
    ptrs, spare = table_info(d, base)
    seen = set()
    patches = []
    for e in spec['entries']:
        s, ram = int(e['slot'], 16), int(e['ram'], 16)
        if s in seen:
            raise SystemExit('slot 0x%03X listed twice' % s)
        seen.add(s)
        if not 0 < s < N:
            raise SystemExit('slot 0x%03X out of range' % s)
        if ptrs[s] not in spare:
            raise SystemExit('slot 0x%03X is not spare (points at %08X)' % (s, ptrs[s]))
        if not RAM_LO <= ram < RAM_HI:
            raise SystemExit('slot 0x%03X: %08X is not RAM' % (s, ram))
        patches.append((s, ram, e))
    stock_ram = {p: i for i, p in enumerate(ptrs) if RAM_LO <= p < RAM_HI}
    notes = ['slot 0x%03X: %08X is already behind stock index 0x%03X' % (s, r, stock_ram[r])
             for s, r, _ in patches if r in stock_ram]
    return base, ptrs, spare, patches, notes


def verify(spec, src, out):
    base, ptrs, spare, patches, notes = check_spec(spec, src)
    ok = True
    allowed = set(range(checksum.SUMLOC, checksum.SUMLOC + 2))
    for s, _, _ in patches:
        allowed |= set(range(base + 4 * s, base + 4 * s + 4))
    diff = [i for i in range(len(src)) if src[i] != out[i]]
    outside = [i for i in diff if i not in allowed]
    words = sorted({(i - base) // 4 for i in diff if base <= i < base + 4 * N})
    print('  diff: %d bytes changed, %d table words (slots %s), correction word %s; outside allowed: %d'
          % (len(diff), len(words), ','.join('0x%03X' % w for w in words),
             'changed' if any(i in diff for i in (checksum.SUMLOC, checksum.SUMLOC + 1)) else 'unchanged',
             len(outside)))
    if outside:
        ok = False
        print('  FAIL: bytes changed outside the patched words: %s' % ', '.join('%06X' % i for i in outside[:20]))
    bad = [s for s, ram, _ in patches if u32(out, base + 4 * s) != ram or ptrs[s] not in spare]
    print('  slots: %d patched, all were spare before and read back as requested: %s'
          % (len(patches), 'yes' if not bad else 'NO (%s)' % bad))
    ok &= not bad
    other = [w for w in words if w not in {s for s, _, _ in patches}]
    if other:
        ok = False
        print('  FAIL: table words changed that are not in the spec: %s' % other)
    for n in notes:
        print('  note:', n)
    print('  checksum (tools/checksum.py (or tools/checksum.ps1) rule):')
    ok &= checksum.report(out)
    print('  RESULT: %s' % ('PASS' if ok else 'FAIL'))
    return ok


def main():
    a = sys.argv[1:]
    if a and a[0] == '--verify':
        spec, src, out = json.load(open(a[1])), open(a[2], 'rb').read(), open(a[3], 'rb').read()
        sys.exit(0 if verify(spec, src, out) else 1)
    if len(a) != 3:
        sys.exit(__doc__)
    spec, src = json.load(open(a[0])), open(a[1], 'rb').read()
    if not checksum.report(src):
        sys.exit('input image does not pass the checksum check; refusing to patch')
    base, ptrs, spare, patches, notes = check_spec(spec, src)
    d = bytearray(src)
    for s, ram, _ in patches:
        struct.pack_into('>I', d, base + 4 * s, ram)
    old = checksum.w16(d, checksum.SUMLOC)
    struct.pack_into('>H', d, checksum.SUMLOC, checksum.correction(d))
    open(a[2], 'wb').write(d)
    print('%s: %s, table %06X, %d slots re-pointed, correction word 0x%04X -> 0x%04X -> %s'
          % (a[1].split('/')[-1], spec['calid'], base, len(patches), old, checksum.w16(d, checksum.SUMLOC), a[2]))
    written = open(a[2], 'rb').read()
    sys.exit(0 if verify(spec, src, written) else 1)


if __name__ == '__main__':
    main()
