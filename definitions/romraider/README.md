# RomRaider definition

`FA20DIT_RomRaider.xml` covers every supported ROM in one file; RomRaider picks the right section from the ROM's
calibration ID.

**Install:** RomRaider → ECU Definitions → ECU Definition Manager → Add, select `FA20DIT_RomRaider.xml`, then open your
ROM.

**User levels:** tables are tiered from Beginner to Debug. Set Settings → User Level to choose what you see:

| Level | Shows |
|---|---|
| Beginner | The core tuning tables (fuel, timing, boost, torque, limits). |
| Intermediate | Their compensations and the tables that have to move with them. |
| Advanced / Highest | Model, filter and control-loop tables. |
| Debug | Tables that are off in stock, unused, or only used by the other transmission coding. |

To hide tables above your level instead of showing them greyed out, untick "List tables that are above my userlevel"
in the settings.

**Units:** load in g/rev, torque in ft-lb, boost in psi, rail pressure in psi and temperatures in °F by default. Other
scales (%, Nm, kPa, MPa, °C) are available from each table's View menu.

RomRaider does not fix this ECU's checksum on save; use the [checksum tool](../../tools/) before flashing.
