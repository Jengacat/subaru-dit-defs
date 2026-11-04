# Changelog

## v0.9.0-beta (unreleased)

First public release.

- RomRaider definition covering ten FA20DIT ROMs (2015–2018 WRX 6MT, 2015 WRX CVT, 2015 Australian WRX 6MT,
  2016 Forester tS CVT, 2015 Forester XT, 2017 European Forester XT), and an EcuFlash definition for each.
- 1,123–1,212 tables, scalars and switches per ROM, plus about 900 DTC enable and fail-safe switches. Tables are
  grouped by purpose in tuning order, carry a plain-English summary, and are tiered by user level (Beginner to Debug).
- Default units for tuners: load in g/rev, torque in ft-lb, boost in psi, rail pressure in psi, temperatures in °F,
  with alternate scales.
- Logger definition for stock ROMs: 46 SSM parameters, 156 trouble codes for RomRaider's DTC tab, and 32 standard
  OBD-II parameters (including actual fuel rail pressure). A logging patch adds 24 more parameters (knock corrections,
  rail pressure target, target boost, combustion mode, target torque and more) on every supported ROM.
- Checksum tool and logging-patch tool.
- Tuning guide: workflows, how the logic works, appendices and a table reference.
- CAN DBC for passive logging.

Not yet validated on a running engine; see the README's known issues.
