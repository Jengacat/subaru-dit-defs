// FA20DIT flash checksum for RomRaider, our own code (GPLv2+ like RomRaider, whose interface it implements).
// The 16-bit sum of all big-endian words in [start, end) must equal target; the word at sumloc is the correction.
// Stock FA20DIT (LF75404S / LF75300H): start 0x6000, end 0x200000, sumloc 0x1FFFFE, target 0x5AA5
// (boot 0x31CC and application 0x095A3A, see tools/defs/checksum.py).
// Loaded by RomRaider as a custom checksum: <checksum type="FA20Sum16" path="/checksum/" .../>, the class file at
// <definition dir>/checksum/com/romraider/maps/checksum/FA20Sum16.class.
package com.romraider.maps.checksum;

import java.util.Map;

public final class FA20Sum16 implements ChecksumManager {
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
        return ((d[a] & 0xFF) << 8) | (d[a + 1] & 0xFF);
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
        d[sumloc] = (byte) (c >> 8);
        d[sumloc + 1] = (byte) c;
        return 1;
    }
}
