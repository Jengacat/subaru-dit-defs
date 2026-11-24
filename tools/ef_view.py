#!/usr/bin/env python3
"""2022+ WRX (FA24DIT, RH850): EcuFlash view copies of the 4032 KB images (3 MB), and merging an edited view back into the full image.

EcuFlash 1.44 matches an image only through one of its built-in memory models, and none of them is the size of
these 4032 KB images (tested 2026-11-22: "There are no memory models suitable for this ROM"). The largest that fits
is Generic3072K (3 MB), so the EcuFlash definitions name that model and EcuFlash opens a copy of the first 3 MB of
the file. Every table and value of the definitions lies in the first 1 MB, the ID string included, so the copy shows
the whole calibration. The last 1008 KB (code, and the checksum balancing word at file offset 0x3EFF7E) never leave
the full image.

usage:
  ef_view.py view  FULL.bin VIEW.bin           first 3 MB of FULL -> VIEW (open VIEW in EcuFlash)
  ef_view.py merge FULL.bin VIEW.bin OUT.bin   FULL with its first 3 MB taken from the edited VIEW, then the
                                               16-bit sum set back to 0x5AA5 (same rule and correction word as
                                               tools/checksum.py fix); lists the changed ranges
FULL is the image the view was made from (merge refuses another one: the parts outside the edits must match).
"""
import struct
import sys

FULL_SIZE, VIEW_SIZE = 0x3F0000, 0x300000        # 4032 KB image (CPU 0x10000-0x3FFFFF); EcuFlash Generic3072K
BALANCE, TARGET = 0x3EFF7E, 0x5AA5               # file offset of the balancing word (CPU 0x3FFF7E); sum target


def wsum(d):
    return sum(struct.unpack('<%dH' % (len(d) // 2), bytes(d))) & 0xFFFF


def load(path, size, what):
    d = open(path, 'rb').read()
    if len(d) != size:
        sys.exit('%s: %d bytes, expected %d (%s)' % (path, len(d), size, what))
    return d


def ranges(a, b):
    out, i, n = [], 0, len(a)
    while i < n:
        if a[i] != b[i]:
            j = i
            while j < n and a[j] != b[j]:
                j += 1
            out.append((i, j))
            i = j
        i += 1
    return out


def main(a):
    if len(a) == 3 and a[0] == 'view':
        full = load(a[1], FULL_SIZE, 'a full RH850 image')
        if wsum(full) != TARGET:
            print('warning: %s sum is %04X, not %04X (already edited?)' % (a[1], wsum(full), TARGET))
        open(a[2], 'wb').write(full[:VIEW_SIZE])
        print('%s: first %d bytes of %s; open it in EcuFlash, then merge it back' % (a[2], VIEW_SIZE, a[1]))
    elif len(a) == 4 and a[0] == 'merge':
        full = load(a[1], FULL_SIZE, 'the full image the view was made from')
        view = load(a[2], VIEW_SIZE, 'an EcuFlash view copy')
        ch = ranges(full[:VIEW_SIZE], view)
        if sum(e - s for s, e in ch) > 0x40000:
            sys.exit('%d bytes differ from %s: the view was not made from this image' % (sum(e - s for s, e in ch), a[1]))
        out = bytearray(view + full[VIEW_SIZE:])
        old = struct.unpack_from('<H', out, BALANCE)[0]
        new = (old + TARGET - wsum(out)) & 0xFFFF
        struct.pack_into('<H', out, BALANCE, new)
        assert wsum(out) == TARGET and len(out) == FULL_SIZE
        open(a[3], 'wb').write(out)
        for s, e in ch:
            print('changed file 0x%06X-0x%06X (%d bytes, CPU 0x%06X)' % (s, e - 1, e - s, s + 0x10000))
        print('%s: %d edited range(s); balancing word at file 0x%06X %04X -> %04X; sum %04X' %
              (a[3], len(ch), BALANCE, old, new, wsum(out)))
    else:
        sys.exit(__doc__)


if __name__ == '__main__':
    main(sys.argv[1:])
