#!/usr/bin/env python3
"""FA20DIT (SH72543R) flash checksum: verify or fix an image.

What the ECU checks (read, LF75404S; the same code and constants are in LF75300H):
  * Sum: the 16-bit sum of all big-endian words from 0x6000 up to 0x200000 must be 0x5AA5.
      - Boot block 0x3180..0x31FE (UDS RoutineControl, reply 0x71): BSR 0x357E with R4 = 0x6000,
        R5 = 0x200000, compares the result with 0x5AA5 (negative reply 7F 31 12/13 otherwise).
      - Application 0x095A3A (background, 0x20000 bytes per pass from 0x6000): helper 0x884 (plain u16 add),
        result compared with the words at 0x1FFFE0 and 0x1FFFE2 (both 0x5AA5 in stock). A mismatch sets
        FFF99819 bit 6 -> FFF8A1F2 bit 0, and marks monitor slot 373 (P0605, ROM error) complete (FFF8A162).
        The check is skipped only when 0x1FFFE0 = 0x0001 and 0x1FFFE2 = 0xFFFF.
      - Both stock images sum to exactly 0x5AA5; the word at 0x1FFFFE is the free correction word
        (0x5733 in LF75404S, 0x84D3 in LF75300H), so it is the one this tool rewrites.
  * Validity markers (boot 0x000C54): word 0x6000 = 0x5555, word 0x1FFFF2 = 0xAAAA, and word 0x006C equal to
    word 0x6010. Any mismatch sets FFF99819 bit 1. This tool only reports them; it never edits them.
  * Not integrity checks (reported for information): the OBD mode 09 CVN (0x06B8C4: rotate-left-and-add over
    0x10000..split and split..0x1FFFE0, served by 0x0AE722 InfoType 6; see cvn()) and a CRC-16/CCITT over
    0x6014..0x1FFFF2 without 0x6080..0x60A1 (0x06B91E -> FFF8065A). Both change with any edit and are
    recomputed by the ECU itself; neither is stored in the image.

2.5 MB images (2019+, SH72544R; read, LF9F000R): the same rules with the end of flash at 0x280000.
  * Boot 0x313A..0x317E (RoutineControl): BSR 0x351E (byte-identical to LF75404S's 0x357E word-sum helper) with
    R4 = 0x6000, R5 = 0x280000, result compared with 0x5AA5.
  * Boot 0x000C54: word 0x6000 = 0x5555, word 0x27FFF2 = 0xAAAA, word 0x006C = word 0x6010 (else FFF99819 bit 1).
  * Application 0x0B3E52: 0x6000..0x280000 in 0x20000-byte passes through helper 0x884, compared with the words at
    0x27FFE0 / 0x27FFE2; skipped when they are 0x0001 / 0xFFFF; mismatch sets FFF99819 bit 6 (P0605).
  * The correction word is the last word, 0x27FFFE (not read by any check; both 2.5 MB stock images sum to 0x5AA5
    with it). CVN routine 0x07C794: 0x10000..split and split..0x27FFE0 plus 0x7970..0x10000 (split 0x68B90).

usage: checksum.py verify IMAGE...
       checksum.py fix IMAGE [OUT]      (in place without OUT)
"""
import struct
import sys

START, END, SUMLOC, TARGET = 0x6000, 0x200000, 0x1FFFFE, 0x5AA5
MARKERS = [(0x6000, 0x5555, 'word 0x6000 = 0x5555'), (0x1FFFF2, 0xAAAA, 'word 0x1FFFF2 = 0xAAAA')]
REFWORDS = 0x1FFFE0
SIZES = (0x200000, 0x280000)


def set_size(n):
    """Point the module constants at a 2 MB or a 2.5 MB image (see the docstring)."""
    global END, SUMLOC, MARKERS, REFWORDS
    END, SUMLOC, REFWORDS = n, n - 2, n - 0x20
    MARKERS = [(0x6000, 0x5555, 'word 0x6000 = 0x5555'), (n - 0xE, 0xAAAA, 'word 0x%06X = 0xAAAA' % (n - 0xE))]


def w16(d, a):
    return struct.unpack_from('>H', d, a)[0]


def sum16(d, lo=START, hi=None, skip=None):
    hi = END if hi is None else hi
    s = 0
    for a in range(lo, hi, 2):
        if a != skip:
            s += w16(d, a)
    return s & 0xFFFF


def correction(d):
    """The word for 0x1FFFFE that makes the sum 0x5AA5."""
    return (TARGET - sum16(d, skip=SUMLOC)) & 0xFFFF


def cvn_ranges(d):
    """The CVN ranges, read from the CVN routine's literal pool (FFE7FFFF, split, 00010000, RAM, [00010000, extra],
    001FFFE0). High word: 0x10000..split. Low word: split..0x1FFFE0, plus extra..0x10000 where the pool has it.
    LF75404S/LF75300H split 0x59490; LF79002P 0x63930; LF9C100P 0x63380 with the extra range 0x78C0..0x10000
    (decompiled routine, resources/analysis/ghidra)."""
    i = d.find(bytes.fromhex('ffe7ffff'))
    end = struct.pack('>I', len(d) - 0x20)                 # 001FFFE0, or 0027FFE0 in a 2.5 MB image
    while i >= 0:
        if d[i + 8:i + 12] == bytes.fromhex('00010000'):
            sp = struct.unpack_from('>I', d, i + 4)[0]
            extra = None
            if d[i + 16:i + 20] == bytes.fromhex('00010000') and d[i + 24:i + 28] == end:
                extra = struct.unpack_from('>I', d, i + 20)[0]
            return sp, extra
        i = d.find(bytes.fromhex('ffe7ffff'), i + 1)
    return 0x59490, None


def cvn_split(d):
    return cvn_ranges(d)[0]


def cvn(d):
    """OBD mode 09 CVN as the ECU computes it (0x06B9FA in LF75404S): start with the first word rotated left
    one bit, then for every further word add it and rotate left one bit (16-bit). Checked against the CVN the
    reading tool stored for LF79002P (2492319A) and LF9C100P (F8DFAB8B): both equal."""
    def rs(lo, hi):
        v = (w16(d, lo) << 1 | w16(d, lo) >> 15) & 0xFFFF
        for a in range(lo + 2, hi, 2):
            v = (v + w16(d, a)) & 0xFFFF
            v = (v << 1 | v >> 15) & 0xFFFF
        return v
    sp, extra = cvn_ranges(d)
    lo = rs(sp, len(d) - 0x20)
    if extra is not None:
        lo = (lo + rs(extra, 0x10000)) & 0xFFFF
    return (rs(0x10000, sp) << 16) | lo


def report(d):
    ok = True
    if len(d) not in SIZES:
        print('  size %d, expected %d or %d' % (len(d), SIZES[0], SIZES[1]))
        return False
    set_size(len(d))
    s = sum16(d)
    good = s == TARGET
    ok &= good
    print('  sum16 0x%04X..0x%06X = 0x%04X (need 0x%04X) %s; correction word 0x%06X = 0x%04X%s'
          % (START, END, s, TARGET, 'OK' if good else 'BAD', SUMLOC, w16(d, SUMLOC),
             '' if good else ' (should be 0x%04X)' % correction(d)))
    for a, v, txt in MARKERS:
        m = w16(d, a) == v
        ok &= m
        print('  marker %s: %s' % (txt, 'OK' if m else 'BAD (0x%04X)' % w16(d, a)))
    m = w16(d, 0x6C) == w16(d, 0x6010)
    ok &= m
    print('  marker word 0x006C = word 0x6010 (0x%04X / 0x%04X): %s' % (w16(d, 0x6C), w16(d, 0x6010), 'OK' if m else 'BAD'))
    ref = (w16(d, REFWORDS), w16(d, REFWORDS + 2))
    m = ref == (TARGET, TARGET)
    print('  runtime reference words 0x%06X/%02X = 0x%04X/0x%04X: %s' % (REFWORDS, (REFWORDS + 2) & 0xFF, ref[0], ref[1],
                                                                        'OK' if m else 'UNEXPECTED'))
    ok &= m
    print('  info: CVN (mode 09, as the ECU computes it; matches the reader CVN on LF79002P and LF9C100P) %08X, range split 0x%05X'
          % (cvn(d), cvn_split(d)))
    return ok


def main():
    if len(sys.argv) < 3 or sys.argv[1] not in ('verify', 'fix'):
        sys.exit(__doc__)
    if sys.argv[1] == 'verify':
        bad = 0
        for f in sys.argv[2:]:
            print(f)
            bad += not report(open(f, 'rb').read())
        sys.exit(1 if bad else 0)
    src = sys.argv[2]
    out = sys.argv[3] if len(sys.argv) > 3 else src
    d = bytearray(open(src, 'rb').read())
    if len(d) not in SIZES:
        sys.exit('%s: size %d, expected %d or %d' % (src, len(d), SIZES[0], SIZES[1]))
    set_size(len(d))
    old, new = w16(d, SUMLOC), correction(d)
    struct.pack_into('>H', d, SUMLOC, new)
    open(out, 'wb').write(d)
    print('%s: correction word 0x%04X -> 0x%04X, written to %s' % (src, old, new, out))
    print(out)
    sys.exit(0 if report(d) else 1)


if __name__ == '__main__':
    main()
