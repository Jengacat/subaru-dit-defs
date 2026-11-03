# Changelog

## v0.9.0-beta (unreleased)

First public release.

- RomRaider definition covering eight FA20DIT ROMs (2015–2018 WRX 6MT, 2016 Forester tS CVT, two early-2015
  calibrations), and an EcuFlash definition for each.
- 1,122–1,211 tables, scalars and switches per ROM, plus about 900 DTC enable and fail-safe switches. Tables are
  grouped by purpose in tuning order, carry a plain-English summary, and are tiered by user level (Beginner to Debug).
- Default units for tuners: load in g/rev, torque in ft-lb, boost in psi, rail pressure in psi, temperatures in °F,
  with alternate scales.
- SSM logger definition, and a logging patch adding 24 parameters (knock corrections, rail pressure, target boost,
  combustion mode, target torque and more) on every supported ROM.
- Checksum tool and logging-patch tool.
- Tuning guide: workflows, how the logic works, appendices and a table reference.
- CAN DBC for passive logging.

Not yet validated on a running engine; see the README's known issues.
