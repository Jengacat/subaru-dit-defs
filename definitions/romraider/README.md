# RomRaider definition

`FA20DIT_RomRaider.xml` covers every supported 2.0 ROM in one file, and `FB16DIT_RomRaider.xml` every supported
Levorg 1.6 ROM; RomRaider picks the right section from the ROM's calibration ID. Both can be installed together.

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

RomRaider can't correct this ECU's checksum on save yet: versions 1.0.0 and 1.1.0 can't load a checksum module from
a definition folder. My fix is in [RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248); once it is merged and released, the definition
will correct the checksum on save. Until then, use the [checksum tool](../../tools/) before flashing.
