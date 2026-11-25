# RomRaider definition

`FA20DIT_RomRaider.xml` covers every supported 2.0 ROM and the Ascent / Legacy XT in one file, `FB16DIT_RomRaider.xml`
every supported Levorg 1.6 ROM, and `FA24DIT_RomRaider.xml` the 2022+ WRX; RomRaider picks the right section from the
ROM's calibration ID. They can all be installed together.

The Ascent and Legacy / Outback XT run a later build of the FA20DIT software, so their sections inherit a small
`FA24_Early_BASE` section (FA24 Early), which in turn inherits `FA20DIT_BASE`: it holds only their own tables (the electric
wastegate group, for one) and what differs (the 2.4 L g/rev factor, user levels, descriptions), and drops the 2.0
tables they don't have.

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

**Checksum.** Each file also comes as `…_Checksum.xml`, which corrects the checksum when you save; install only one
of the two for each engine:

| File | Checksum | RomRaider |
|---|---|---|
| `FA20DIT_RomRaider.xml`, `FB16DIT_RomRaider.xml` | Not corrected: run the [checksum tool](../../tools/) after saving | 1.0.0 or later |
| `FA20DIT_RomRaider_Checksum.xml`, `FB16DIT_RomRaider_Checksum.xml` | Corrected on save, 2 MB and 2.5 MB ROMs alike, by the `FA20Sum16` module in `checksum/` | A RomRaider that can load a checksum module from the definition folder: my change for that ([RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248)) is merged into RomRaider after 1.1.0, so use the next RomRaider release, or until it is out a RomRaider built from the current source. RomRaider 1.0.0 and 1.1.0 can't open the images with it |

Keep the `checksum/` folder in the same folder as the XML: RomRaider loads
`checksum/com/romraider/maps/checksum/FA20Sum16.class` from there (source: `checksum/FA20Sum16.java`). On 2 MB and
2.5 MB ROMs of all three families (FA20DIT, FA24 Early, FB16DIT) I edited a cell and saved with it: every saved file
was byte-identical to the checksum tool's output. Either way, run `checksum.py verify` before flashing.

## 2022+ WRX (FA24DIT_RomRaider.xml)

`FA24DIT_RomRaider.xml` covers the four supported 2022+ WRX ROMs, with a shared `FA24DIT_BASE` section like
the others. It comes in two versions; install only one:

| File | Checksum | RomRaider |
|---|---|---|
| `FA24DIT_RomRaider.xml` | Not corrected: run `tools/checksum.py` (or `.ps1`) after saving | 1.0.0 or later |
| `FA24DIT_RomRaider_Checksum.xml` | Corrected on save, by the `RH850Sum16` module in `checksum/` | A RomRaider that can load a checksum module from the definition folder: my change for that ([RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248)) is merged into RomRaider after 1.1.0, so use the next RomRaider release, or until it is out a RomRaider built from the current source. RomRaider 1.0.0 and 1.1.0 can't open the images with it |

For the checksum version, keep the `checksum/` folder in the same folder as the XML: RomRaider loads
`checksum/com/romraider/maps/checksum/RH850Sum16.class` from there. The source is `checksum/RH850Sum16.java`
(compile against RomRaider with `javac -cp RomRaider.jar -source 8 -target 8 -d checksum checksum/RH850Sum16.java`
if you'd rather build it yourself). With it, RomRaider marks an edited ROM's checksum as invalid until you save, and
the saved file passes `checksum.py verify`.

Images are 4032 KB (see the [main README](../../README.md#2022-wrx-whats-different)). The user levels and units work
as above; trouble codes have one Enabled switch per code, without a Fail-Safe cell.
