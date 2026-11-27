# RomRaider definition

`FA20DIT_RomRaider.xml` covers every supported 2.0 ROM and the Ascent / Legacy XT in one file, `FB16DIT_RomRaider.xml`
every supported Levorg 1.6 ROM, and `FA24DIT_RomRaider.xml` the 2022+ WRX; RomRaider picks the right section from the
ROM's calibration ID. They can all be installed together.

The Ascent and Legacy / Outback XT (FA24 Early) run a later build of the FA20DIT software, so their sections are in
the FA20DIT file and build on it.

Each file uses RomRaider's inheritance to stay small (about 12 MB and 8 MB): the tables common to every ROM are in a
shared `FA20DIT_BASE` / `FB16DIT_BASE` section, which never matches a ROM, and each ROM's section lists only its own
addresses, user levels and tables. If you see a `…_BASE` entry in the Definition Manager, that's expected.

**Install:** RomRaider → ECU Definitions → ECU Definition Manager → Add, select `FA20DIT_RomRaider.xml` (Levorg 1.6: `FB16DIT_RomRaider.xml`), then
open your ROM.

**User levels:** tables are tiered from Beginner to Debug. Set Settings → User Level to choose what you see:

| Level | Shows |
|---|---|
| Beginner | The core tuning tables (fuel, timing, boost, torque, limits). |
| Intermediate | Their compensations and the tables that have to move with them. |
| Advanced / Highest | Model, filter and control-loop tables. |
| Debug | Tables this ROM's own calibration switches off, tables of unused code paths, and tables only the other transmission coding uses. The same table can be at Advanced in another ROM. |

To hide tables above your level instead of showing them greyed out, untick "List tables that are above my userlevel"
in the settings.

**Units:** load in g/rev, torque in ft-lb, boost in psi, rail pressure in psi and temperatures in °F by default. Other
scales (%, Nm, kPa, MPa, °C) are available from each table's View menu.

**Checksum.** Every file corrects the checksum when you save, 2 MB and 2.5 MB ROMs alike, with the `FA20Sum16`
module in `checksum/`. Keep the `checksum/` folder in the same folder as the XML: RomRaider loads
`checksum/com/romraider/maps/checksum/FA20Sum16.class` from there (source: `checksum/FA20Sum16.java`). This needs
[RomRaider 1.1.1](https://github.com/RomRaider/RomRaider/releases) or later, which can load a checksum module from the
definition folder (my change, [RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248)); RomRaider
1.0.0 and 1.1.0 can't open the ROMs with these files. Run `checksum.py verify` before flashing all the same.

## 2022+ WRX (FA24DIT_RomRaider.xml)

`FA24DIT_RomRaider.xml` covers the four supported 2022+ WRX ROMs, with a shared `FA24DIT_BASE` section like
the others. It corrects the checksum on save with the `RH850Sum16` module in `checksum/` (RomRaider 1.1.1 or later).

Keep the `checksum/` folder in the same folder as the XML: RomRaider loads
`checksum/com/romraider/maps/checksum/RH850Sum16.class` from there. The source is `checksum/RH850Sum16.java`
(compile against RomRaider with `javac -cp RomRaider.jar -source 8 -target 8 -d checksum checksum/RH850Sum16.java`
if you'd rather build it yourself). With it, RomRaider marks an edited ROM's checksum as invalid until you save, and
the saved file passes `checksum.py verify`.

Images are 4032 KB (see the [2022+ WRX guide](../../docs/WRX_2022plus.md)). The user levels and units work
as above; trouble codes have one Enabled switch per code, without a Fail-Safe cell.
