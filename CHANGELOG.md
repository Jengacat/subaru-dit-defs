# Changelog

## v0.9.0-beta (unreleased)

First public release.

- New: **Ascent (FA24DIT)**, three ROMs: LT8D800A (2019), LT8F300C (2020) and LT8H300D (2021), all USDM CVT, in
  their own files (`FA24DIT_RomRaider.xml`, `FA24DIT_BASE_EcuFlash.xml` and its Metric twin), 103 ROMs in all. The
  Ascent runs a later build of the FA20DIT software, so most tables are carried over at its own addresses: about
  1,030 entries on the 2019 and 2020 ROMs (placed from both the 2020 WRX and the 2021 Ascent, which agree wherever
  both place a table), 870 on the 2021 ROM, whose code changed more. Boost is new: the Ascent drives an electric
  wastegate, and its boost group covers the boost target and its IAT, baro and coolant corrections, the wastegate
  position feed-forward and compensations, the boost feedback (proportional, integral, limits), the feed-forward-only
  threshold, the fixed positions (low rpm, engine off, closed), the learned-seat limits, the actuator motor tables
  and limits, and the P0244 position-error limit. The WRX boost tables still sit in the Ascent ROM, but nothing uses
  their results, so they are left out. Position is shown as % open (0 % = seated); that scale and the boost-pressure
  unit are inferred. First release: not yet checked against a read from a car.
- New: **charging system, part 2**, in every definition (folder 09.03), 17 to 19 entries per ROM:
  - how the ECU decides the battery is charged: a state-of-charge estimate from the battery sensor's current (battery
    capacity, charge efficiency, reset value) and, early in each charge cycle, a state-of-charge threshold (stock
    94-95 %) above which it switches to the low Battery Charged target. Raising Battery Charged SOC Threshold is a
    second way to make the charge cut rarer;
  - the cycle length, the check window and the limits of adaptive charging;
  - the charging-voltage feedback: proportional table, integral steps, limits and gain, deadbands, minimum rpm.
  The battery-capacity and charge-efficiency entries are not in every ROM: the 2014-2015 LV9N builds lack the first
  two, the 2017 and later builds the efficiency tables (their place is not confirmed yet).
- New: **charging system target voltages**, in every definition (folder 09.03): the target for each charging mode
  (normal 14.3 V, battery charged 12.2 V, accessory load 13.5 V), the adaptive mode's limits, the overall minimum and
  maximum, the start value and the temperature correction. Once the ECU counts the battery as charged it aims for
  the low "battery charged" target, so the alternator stops charging and the car runs on the battery down to about
  12.2 V; raising that target to the normal one keeps it charging. The logic that decides when the battery counts
  as charged is not defined yet. Thanks to reokov for the lead.
- New: **Park/Neutral RPM Limit (AT/CVT)** and its hysteresis, in every definition (folder 04.02). On an automatic/CVT
  car the ECU cuts cylinders above this speed while the selector is in P or N (4,000 rpm, released 500 rpm lower, in
  every stock calibration); it does nothing on a manual-coded ECU. Thanks to reokov, who found it in LF9F000R.
- New: **LV9N002E** (2015 WRX), 100 ROMs in all: a later build of the LV9N000C software (13 changed functions); every
  table placed by exact code match from LV9N000C and LV9N101C. Thanks for the read.
- New: **two more submitted Levorg 1.6 ROMs**, 99 in all: LF9D200d (2019 JDM) and LF9F200P (2020 JDM), both 2.5 MB
  ECUs. Each is a separate build, close to a supported one (8 and 3 changed functions against LF9D100e and LF9F100P);
  every table was placed from two supported ROMs that agree, and the few placed by layout were confirmed against the
  decompiled code. Thanks for the reads.
- docs/ROM_IDS.md corrected against the code of every complete ROM: LF791… has two builds (LF79110N is separate) and
  LF9D0… three (LF9D012h and LF9D030g are different WRX builds); 18 groups have more than one ROM, 13 of them a single
  build. The groups table now lists every group with a supported ROM (seven Levorg 1.6 groups were missing), the count
  of unread IDs in supported groups is fixed (119), and the page notes that no two groups share code so far.
- New: **two submitted Levorg 1.6 ROMs**, 97 in all: LF76402R (2016 JDM) and LF79200U (2017 JDM). Each runs the same
  code as a supported Levorg 1.6 (LF76401R, LF79201U), so its tables sit at the same addresses; LF76402R's calibration
  differs from LF76401R's mainly in the EGR Valve Flow Model. Thanks for the reads.
- New: **42 more ROMs**, 95 in all: 2015–2021 WRX, 2016–2018 Forester XT, 2015–2017 Legacy/Outback and a 2018
  Levorg 1.6, calibrations taken from Subaru's dealer reflash packages, including the 2019–2021 WRX (2.5 MB ECUs).
  26 run the same code as a ROM already supported; 16 are separate builds, ported and checked table by table against
  their source ROM and against the decompiled code. The logging patch and CAN dictionary don't cover the new ROMs yet.
- Dynamic Advance Multiplier tables show 0 to 1 with three decimals (they were raw numbers up to 16).
- README: the table counts per ROM include the nine pedal speed limiter entries added earlier.
- docs/ROM_IDS.md made more accurate: an ID's first five characters group related ROMs but are not a software version.
  The page now gives each group's engine (2.0 or 1.6) and how many code builds my ROMs of it contain, flags the
  three groups with more than one build, marks the IDs I have only partial reads of, and lists all 53 supported ROMs.
  README: the 2013–2015 Forester XT IDs (LF61…, AF5G… and others) are marked as an older ECU this repo doesn't cover.
- New: **the speed limiter that the stock calibrations actually use**, in every definition (folder 04.02). It limits
  the pedal request by vehicle speed (about 180 km/h on the JDM cars, 228–232 km/h on the USDM WRX): four
  Vehicle Speed Limit (Pedal) tables, their minimum rpm, an rpm-based fallback for when the speed signal is lost, and
  a Pedal Limits Disable switch. The fuel-cut Vehicle Speed Limit set, which is off in every stock ROM, is a separate
  limiter. Tuning guide chapter 9 updated.
- EcuFlash: the calibration switches (folder 11.02: EGR Enable, transmission coding and the rest) are on/off toggles
  instead of whole-byte numbers. Select the value and press Increment to flip one. In RomRaider they were already
  checkboxes; their descriptions no longer give the bit number.
- New: **2017 Australian Forester XT (LF78002H)**: RomRaider and EcuFlash definitions (1,202 entries, 227 DTCs),
  logging patch and CAN dictionary. It runs nearly the same code as the Forester tS (LF78001H) but is a separate build,
  so it has its own definition.
- New: **logging patch for the Levorg 1.6 ROMs**: a spec for each of the 19, checked against each ROM's own code. The
  existing `FA20DIT_Logger_LogPatch.xml` works with them unchanged (same slots).
- CAN dictionary: now 53 ROMs, all the Levorg 1.6 ROMs included. They behave exactly like the 2.0 ROMs of the same
  software.
- README: the entry counts per ROM include the four low-DAM boost cut values.
- Descriptions: below the Debug level every table now shows only a short plain-English description (no addresses or
  code references); Debug tables keep the full engineering detail.
- Tuning guide updated and renamed **Subaru DIT Tuning Guide**: it covers the Levorg 1.6 (new section 1.10), quotes
  stock values as the reference ROM's (LF75404S) and says "unused on the reference ROM" where a table is gated out
  there, uses the current table names, and adds the low-DAM boost cut (C14, A14), the 1.6-only tables, the logging
  and checksum updates, and fresh screenshots.
- README: shorter Known issues section (the details are in the definitions README, the EcuFlash README and the guide).
- README: PCMFlash is reported to read and write these ECUs and to correct the checksum when it flashes (not
  tested by me).
- New: **Low-DAM boost cut** (Boost Feedback & Compensations, Advanced level), all ROMs: four values for a latch that
  forces wastegate duty to 0 % when DAM drops below a threshold, armed by a pass over the fine-learning knock cells
  (Arming Count, Cell Threshold, DAM Threshold, DAM Release). Switched off in every stock calibration.
- New: **Levorg 1.6 (FB16DIT)**, 19 ROMs, 2014–2020: `FB16DIT_RomRaider.xml` and Imperial / Metric EcuFlash sets. The
  1.6's ECU runs the same software as the 2.0's, so the tables and descriptions are shared; the stock logger file works
  for it too. Thanks to reokov for the ROMs.
- Table names no longer carry "(Off in Stock)" or "(Unused)", and the descriptions no longer quote stock values: those
  were true for one calibration only (about 500 tables differ between the USDM and JDM ROMs). Whether a table is
  switched off now sets its user level per ROM: Debug where the ROM's own calibration switches it off, Advanced where
  it doesn't. "Transient Fuel Throttle-Rate Gain (Off in Stock)" is now "(MT Coding)".
- The RomRaider file is smaller (7.8 MB, was 24 MB): ROMs that share a layout list only what differs, and descriptions below the Debug level are short.
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
