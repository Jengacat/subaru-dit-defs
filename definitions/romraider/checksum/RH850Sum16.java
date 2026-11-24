// RH850 (2022+ WRX) flash checksum for RomRaider, my own code (GPLv2+ like RomRaider, whose interface it implements).
// The 16-bit sum of all little-endian words in [start, end) of the image file must equal target; the word at sumloc
// is the correction. Image file offset = CPU address - 0x10000. Stock images (LHBHB10B, LHBKC40M, LHBP400b): start 0x0,
// end 0x3F0000 (the whole 4032 KB file), sumloc 0x3EFF7E (CPU 0x3FFF7E, the trailer word that differs per build),
// target 0x5AA5. The rule holds on all three stock images; which word the factory balances is inferred, not read.
// Loaded by RomRaider as a custom checksum: <checksum type="RH850Sum16" path="/checksum/" .../>, the class file at
// <definition dir>/checksum/com/romraider/maps/checksum/RH850Sum16.class.
package com.romraider.maps.checksum;

import java.util.Map;

public final class RH850Sum16 implements ChecksumManager {
    private int start, end, sumloc, target;

    private static int hex(String s) {
        s = s.trim().toLowerCase();
        return Integer.parseInt(s.startsWith("0x") ? s.substring(2) : s, 16);
    }

    @Override
    public void configure(Map<String, String> vars) {
        start = hex(vars.get("start"));
        end = hex(vars.get("end"));
        sumloc = hex(vars.get("sumloc"));
        target = hex(vars.get("target"));
    }

    @Override
    public int getNumberOfChecksums() {
        return 1;
    }

    private static int word(byte[] d, int a) {
        return (d[a] & 0xFF) | ((d[a + 1] & 0xFF) << 8);
    }

    /** The correction word that makes the sum equal target. */
    private int correction(byte[] d) {
        int s = 0;
        for (int a = start; a < end; a += 2)
            if (a != sumloc) s += word(d, a);
        return (target - s) & 0xFFFF;
    }

    @Override
    public int validate(byte[] d) {
        if (d == null || d.length < end) return 0;
        return correction(d) == word(d, sumloc) ? 1 : 0;
    }

    @Override
    public int update(byte[] d) {
        if (d == null || d.length < end) return 0;
        int c = correction(d);
        if (c == word(d, sumloc)) return 0;
        d[sumloc] = (byte) c;
        d[sumloc + 1] = (byte) (c >> 8);
        return 1;
    }
}
