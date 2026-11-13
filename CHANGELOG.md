# Changelog

## v0.9.0-beta (unreleased)

First public release.

- README: PCMFlash is reported to read and write these ECUs and to correct the checksum when it flashes (not
  tested by me).
- New: **Low-DAM boost cut** (Boost Feedback & Compensations, Advanced level), all ROMs: four values for a latch that
  forces wastegate duty to 0 % when DAM drops below a threshold, armed by a pass over the fine-learning knock cells
  (Arming Count, Cell Threshold, DAM Threshold, DAM Release). Switched off in every stock calibration.
- New: **Levorg 1.6 (FB16DIT)**, 19 ROMs, 2014–2020: `FB16DIT_RomRaider.xml` and Imperial / Metric EcuFlash sets. The
  1.6's ECU runs the same software as the 2.0's, so the tables and descriptions are shared; the stock logger file works
  for it too. No logging patch for these ROMs yet. Thanks to reokov for the ROMs.
- Table names no longer carry "(Off in Stock)" or "(Unused)", and the descriptions no longer quote stock values: those
  were true for one calibration only (about 500 tables differ between the USDM and JDM ROMs). Whether a table is
  switched off now sets its user level per ROM: Debug where the ROM's own calibration switches it off, Advanced where
  it doesn't. "Transient Fuel Throttle-Rate Gain (Off in Stock)" is now "(MT Coding)".
- The RomRaider file is smaller (12 MB, was 24 MB): ROMs that share a layout list only what differs.
- README: the supported ROMs are listed per model; per-ROM notes and credits moved to `definitions/README.md`.
- New: eight more ROMs. 2014 Middle East WRX (LF75401P) and seven Levorg 2.0 ROMs, 2014–2017 (LV9N100A, LV9N301A,
  LV9N302A, LF75401D, LF79100K, LF79101K, LF79100S): RomRaider and EcuFlash definitions, logger, logging patch, CAN
  dictionary (now 37 ROMs). Thanks to reokov for the ROMs.
- DTCs reorganised: one folder (DTC Switches), in code order. RomRaider: one table per code with two cells, Enabled
  and Fail-Safe (needs RomRaider 1.0.0 or later). EcuFlash: the code's table and its `[Fail-Safe]` table side by side.
  The two "class" folders are gone: they only recorded what kind of code each one is.
- Fixed: on LV9N000C, Injector 2/4 Rail Pressure Offset and its axes were defined 4 bytes too high.
- Units: the EcuFlash definitions now come in two sets, `definitions/ecuflash/Imperial/` (psi, °F, ft-lb, mph) and
  `definitions/ecuflash/Metric/` (kPa / MPa, °C, Nm, km/h); install one. The RomRaider definition has an imperial and
  a metric scale on every table whose unit depends on the system (added: MAP sensor gain and offset in psi, throttle
  area in in², mph per 1000 rpm, mph per s, purge flow in CFM). EcuFlash axis titles no longer show the unit twice.
- Licensed under the GNU General Public License, version 3 (GPL-3.0); see LICENSE.
- Reading 2019+ ECUs: the README now covers FastECU's read-only 2.5 MB protocol (in FastECU's source since
  miikasyvanen/FastECU#159, not yet tested on a car) alongside PCMFlash.
- RomRaider definition covering 23 FA20DIT ROMs (2015–2018 WRX 6MT and CVT, WRX S4, 2016 Forester tS, the 2015 and
  2017 Forester XT, early-2015 "LV9N" calibrations), and an EcuFlash definition for each. Eleven of them share their
  code and table layout byte for byte with another supported ROM and use its table list.
- 1,123–1,212 tables, scalars and switches per ROM, plus about 900 DTC enable and fail-safe switches. Tables are
  grouped by purpose in tuning order, carry a plain-English summary, and are tiered by user level (Beginner to Debug).
- Default units for tuners: load in g/rev, torque in ft-lb, boost in psi, rail pressure in psi, temperatures in °F,
  with alternate scales.
- Logger definition for stock ROMs: 46 SSM parameters, 156 trouble codes for RomRaider's DTC tab, and 32 standard
  OBD-II parameters (including actual fuel rail pressure). A logging patch adds 24 more parameters (knock corrections,
  rail pressure target, target boost, combustion mode, target torque and more) on every supported ROM.
- Checksum tool and logging-patch tool.
- Tuning guide: workflows, how the logic works, appendices and a table reference.
- CAN dictionary for passive logging: every frame the ECU receives and sends, for 31 ROMs (2014–2018 WRX,
  WRX S4, Levorg, Forester XT/tS), with a DBC for all of them and each signal's RAM address per ROM. The ROMs fall
  into nine layout groups; the differences (the Foresters' alternate frames, 2017+ changes) are listed per group.

Since the first draft of this release:

- EcuFlash: every DTC now has its own table in each class (Enable, Circuit, Performance, Fail-Safe), as in RomRaider;
  press Increment to flip a code. The mask tables remain as an overview.
- EcuFlash: the definitions use EcuFlash's `subaruhitachi` checksum module, which corrects the checksum on save
  (byte-identical to the checksum tool in EcuFlash 1.44.4870).
- EcuFlash: one shared base file plus a small file per ROM (about 17 MB in total instead of 118 MB). Copy the base file
  along with your ROM's file.
- Axis names fixed: "Spark Air Compensation Limiter Baro Factor" on LF79100N/LF79100P (was labelled coolant), "A/F
  Sensor Exhaust Model Condensate at Start" (coolant × intake air temperature) and "Cruise Vehicle Speed Filter Weight"
  (speed error × speed).
- Names for P0140, P0401 and P0402.
- New: 2019 JDM Levorg STI 2.0 (LF9F000R), the first 2019+ (2.5 MB, SH72544R) ROM: RomRaider and EcuFlash
  definitions, 1,211 tables, scalars and switches plus 924 DTC switches, the logger (SSM, OBD, DTC tab), the logging
  patch and the CAN dictionary (now 32 ROMs). Thanks to reokov for the ROM. EcuFlash doesn't correct its checksum.
- Logger DTC tab: on LF9F000R four positions hold other codes (P226B, P24B9, P24BA, P24BB); those entries name both.
- New: 2018 Malaysian Forester XT CVT (LF9C000a, lowercase "a"): same code and layout as LF9C000C. RomRaider and
  EcuFlash definitions, logger, logging patch and CAN dictionary (now 33 ROMs). Thanks to Hafiez STi for the ROM.

Not yet validated on a running engine; see the README's known issues.
