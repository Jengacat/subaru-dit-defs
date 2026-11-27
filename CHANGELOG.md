# Changelog

## Unreleased

- **The RomRaider definitions now correct the checksum when you save.** What used to be the `_Checksum` files are now
  the regular ones: `FA20DIT_RomRaider.xml`, `FB16DIT_RomRaider.xml` and `FA24DIT_RomRaider.xml`, each with the
  `checksum/` folder next to it. They need RomRaider 1.1.1 or later; RomRaider 1.0.0 and 1.1.0 can't open the ROMs
  with them. The separate `…_Checksum.xml` files are gone: if you installed one, switch to the regular file.
- README: "Editing with EcuFlash" is now "Editing with EcuFlash or FastECU": how to point FastECU at the files, what
  it does with the checksum, and how to flip DTC and calibration switches in its drop-downs. Tested in FastECU's
  current source: 2 MB ROMs save with the checksum corrected; 2.5 MB ROMs save without it (run the checksum tool).
- README: the definitions need RomRaider 1.1.1, which is fully supported. Tested in 1.1.1: opening, editing and saving
  2 MB, 2.5 MB and RH850 ROMs (checksum corrected on save, `checksum.py verify` OK) and the two-cell DTC tables.
- EcuFlash user levels fixed (the 2.0 / 1.6 files, the `FA24_Early` Ascent / Legacy XT files and the RH850 `FA24DIT_*`
  files). EcuFlash counts its levels the other way from RomRaider, so at Beginner the core tables were the ones greyed
  out. Now Beginner shows the core tables (fueling, timing, boost, requested torque, rev limits, throttle maps),
  Intermediate and Advanced add more, and Developer shows everything. FastECU has no user levels and is unaffected.
- EcuFlash file headers reworded.
- Real units on the RH850 ROMs (`FA24DIT_*`): about 125 tables and 30 axes that showed raw numbers now display in
  units. These include the cranking and after-start fuel multipliers and enrichments, the start-sequence, catalyst
  heating, idle state, surge damping and decel fuel cut staging times (in seconds), the TGV air flow limits (g/s),
  wastegate feed-forward and boost feedback (% of wastegate position), the exhaust temperature model filters, DAM step
  gain, the open-loop enrichment cap (as an AFR) and the rail pressure, closed-loop error and target torque axes.
  The calibration switches (Barometric Sensor Enable, EGR Enable, Open Loop Fueling: Use Alternate Map and others)
  are now on/off switches, as on the 2.0 ROMs. About 20 tables keep raw units because I haven't worked out what
  their numbers mean yet: the knock thresholds and a few start, learning and throttle model values.
- Cleaner descriptions everywhere: every table, value and logger parameter description in every definition and logger
  file now explains what the setting does, without memory addresses or notes on how it was found. Debug-level tables
  keep their plain explanation; the technical detail behind them is gone from the published files.
- Every table axis now has a real name (Engine Speed, Ignition Timing, Boost, Throttle Opening and so on). About
  4,000 axes in the 2.0 and 1.6 RomRaider files used to be labelled just "Axis".
- Logger parameters that used to carry an address in their name are renamed: Throttle Signal 2, Throttle or Pedal
  Signal A / B, Closed Loop Lambda, Closed Loop Target (Lambda), Fuel Correction, Knock Module Value A / B, AVCS
  Value 1-4, Long-Term Fuel Trim (Learned Cell) and A/F Learning (Active Cell). The cam advance / retard parameters
  keep their names without the address.
- New: **knock margin terms** on the 2019-2021 2.0 / 1.6 ROMs, the Ascent and the Legacy / Outback XT (5 tables,
  Knock Control). The knock margin index that the knock torque cap's margin trigger watches is Knock Margin Base
  (engine speed x load), less intake air temperature 2, plus a spark term (how far the primary ignition sits above
  the timing ceiling) and an A/F term (richer adds margin), each with its own weight map (0 in stock).
- New: **cam 2 AVCS tables** on 198 ROMs: the four Exhaust AVCS Feedback Oil Factor tables for cam 2 and the two AVCS
  Activation Delay After Start curves for cam 2. Stock data equals the cam 1 tables; until now only cam 1 was editable.
- New: **misfire detection thresholds** on the 2018-2021 2.0 / 1.6 ROMs, the Ascent and the Legacy / Outback XT (22
  tables, Diagnostics > Monitor Thresholds): two threshold sets (A and B) by engine speed and load, each with variants
  for two transmission flags, an alternate and a window map (65535 = no detection), coolant multipliers and a
  learned-value multiplier. The threshold logic is read from the code; that the monitor is the misfire monitor is
  inferred (it compares against a crank acceleration value).
- New: **Knock Event Enrichment** on every 2019-2021 2.0 and 1.6 ROM, the Ascent and the Legacy / Outback XT (5
  tables, folder Open Loop & Enrichment Targets). This is 2019+ code: while one of the knock torque cap's triggers is
  set, the ECU adds fuel from a table by engine speed and load (Trigger A, Trigger B, Margin), then fades it out (Decay)
  or ramps it (Ramp, margin trigger). In stock only Trigger A adds fuel, up to about 39 %. Read from the code: the
  value divides the lambda target by 1 + value / 256, the same 1/256-of-fuel unit as the other enrichments.
- New: **the logging patch and SUBUDS for 135 more ROMs**, 238 in all: every supported 2.0 and 1.6 ROM except
  LV9H000D, and all five 2019–2021 Ascents (LT8D700A and LT8F200C added). 101 of the new ones run byte-identical code to
  a ROM that already had a spec; 32 were moved from a sibling through its address map with a second sibling as the
  cross-check. Every patched image passes the patch tool's checks, and every SUBUDS address was checked in the emulator
  against the ECU's own SSM read (238 images, no mismatches). Not yet run on a car.
- Found: **the 2020–2021 Legacy / Outback XT ECU has no SSM services** (no SSM init or read in its diagnostic service
  table, read in all four ROMs), so the SSM logger files, the logging patch and SUBUDS don't apply to it; log it with
  RomRaider's OBD protocol for now.
- Changed: `make_logpatch.py` accepts a dealer-software image whose only differences from a car read are the reference
  words the ECU uses to skip its background checksum check, or a missing boot block; the patch touches neither.
- Docs: the README says once, in its introduction, that every definition is placed from its ROM's own code.
- Releases are built automatically: dating a version heading in this changelog makes GitHub build the four zips and
  publish the release.

## v0.9.0-beta (2026-11-25)

First public release. Downloads: one zip per ECU family (FA20DIT, FB16DIT, FA24 Early, RH850) on the
[release page](https://github.com/Jengacat/subaru-dit-defs/releases/tag/v0.9.0-beta).

- Docs: the README starts with the quick start, and the ROM lists are sorted by model, year, transmission and market.
  The logging-patch and SUBUDS pages say which ROMs they cover (those marked "yes", plus the RH850 ROMs for
  SUBUDS) instead of "every ROM". The `_Checksum` RomRaider files work with RomRaider 1.1.1, and FastECU's current source lists the 2.5 MB read
  and corrects the 2.5 MB and RH850 checksums (not in a FastECU release yet).
- New: **395 more entries on 37 ROMs** (267 tables, 128 scalars), found by checking every ROM against the others that
  run exactly the same code: when all of them name a table or setting and a ROM's own file didn't, it's added there
  too. Most of them are on the 2019-2020 Ascent (about 40 each: after-start enrichment, catalyst heating, rail
  pressure fallbacks, drive-mode cruise tables), the Levorg 1.6 LF76 ROMs (13-15 each), the knock torque cap on
  LF9D010h / LF9D012h / LG7D501B, and per-cylinder timing trim and knock event settings on LF78002C / LF78002H /
  LF780Z2E / LF79200T. Where the Ascent or Legacy XT only carries an unused copy of WRX boost code, those boost names
  are left out.
- Fixed: on the Ascent and Legacy / Outback XT, **EGR Upstream Pressure Estimate** pointed at the Baro Adder table;
  both are now where the code reads them (the real estimate added on 8 of the 9 ROMs). On LF73100A the Idle Feedback
  Carry-Over Limit tables were swapped (Positive / Negative). On the 2019-2020 Ascent, Catalyst Heating Phase 2
  Injection Angle Base Spark Adder is labelled TGV Normal like on every other ROM with that code.
- Changed: on the RH850 ROMs (`FA24DIT_*`), the rail pressure axis of **Injector Flow Compensation (set 1)** is now
  titled **Rail Pressure (Plus RPM/Load Offset)**, like the other rail pressure axes. Same values; only the title
  changed.
- Changed: **RH850 logging (2022+ WRX, 2023+ Ascent and Legacy / Outback XT) moves to SUBUDS.** The mode-22 lists
  `logger/FA24DIT_LHBKC40M_DIDs.csv` and `_Torque.csv` are replaced by 97 parameters in `DIT_Logger_SUBUDS.xml`, under
  a new module **ECU-RH850** (CAN ID 0x7A2): the values the ECU publishes as data identifiers, read where it keeps
  them, with addresses from each of the 35 ROMs' own identifier tables (the CSVs held the 2023 ROM's only).
  Snapshot copies are left out. Needs the SUBUDS build subuds-22plus-update-2 or later; subuds-test-1 can't read the
  file any more. Not tested on a car yet.
- New: **knock torque cap** on the 2019+ ROMs (WRX, Levorg STI and Levorg 1.6) and on the Ascent and Legacy / Outback
  XT: six **Maximum Torque (Knock Cap, …)** curves by rpm, the ramp rate, the margin trigger's threshold, hysteresis,
  switch and coolant condition. This is code the 2015 WRX doesn't have, found by comparing a 2021 WRX against it, and
  it caps target torque on its own, next to Maximum Torque (Knock Event). The tuning guide (5.3) explains the three
  triggers. LF9D010h, LF9D012h and LG7D501B don't get it yet: their trigger code differs, so I couldn't place all of
  it.
- New: **7 more 2.0 ROMs**, the last FA20DIT ones I hold except one: LV9H000D (2015 USDM WRX 6MT, the calibration
  LF75404S replaced) and six whose model isn't confirmed (LF73100A, LF77000C, LF77000D, LF77000Q, LF79130P,
  LF9C400P). Each runs a build of its own, ported from the two closest supported builds and checked through RomRaider
  and EcuFlash like the others; tables I couldn't place from the code are left out (LV9H000D has about 50 fewer than
  the 2015 WRX, LF77000D / Q about 90 fewer than the LF780 ROMs). AV9D100E is held back: its trouble-code table
  differs from every supported ROM's, so it still needs its DTC switches placed by hand. No logging-patch spec for
  these yet.
- New: **11 RH850 ROMs for the 2023+ Ascent and Legacy / Outback XT** (`FA24DIT_*`, the same ECU and software line
  as the 2022+ WRX): LHBK240Y (2023 Ascent), LHBK240G (2023 Legacy / Outback XT), LHBKG01H / 00H / 01G (2024 Outback
  XT), LHBR200G / 300G (2025 Legacy / Outback XT) and, year unknown, LHBP201A, LHBK230H, LHBK240Z, LHBK231Z (model
  from the calibration; the last two unconfirmed). Each placed from its own code through the closest supported ROM
  and checked through RomRaider, EcuFlash and FastECU. The 2023 builds have no second surge damping phase factor
  set, so those tables are left out of them.
- New: **27 more ROMs**, most of them builds whose code differs from every supported ROM, each ported from the two
  closest supported builds and checked through RomRaider and EcuFlash like the others: 20 for the 2.0 (WRX, Legacy,
  Outback and ten whose model isn't confirmed), 6 for the Levorg 1.6 and LG7F300F (Legacy / Outback XT, FA24 Early).
  A few tables whose reading code changed in these builds are left out of them until I can place them from the code
  (some knock and cam limit tables on the LF76… Levorg 1.6 ROMs, the knock event group on LV9N300x / LV9N301K, the
  A/F sensor scaling on LV9N002I). LF76000C is a 2.0 calibration on Levorg 1.6 code. No logging-patch spec for these
  yet.
- Changed: the catalyst-heating spark retard tables and the phase 2 exit thresholds are scaled as the requested spark
  torque share (% torque from spark), replacing a raw "progress" axis; Catalyst Heating Spark Retard (Phase 2) and
  Torque Reduction Spark Retard are one table in the ROM, and both descriptions now say so.
- Changed: the table counts in the ROM lists are refreshed from the current files.
- New: **12 more 2022+ WRX ROMs** (`FA24DIT_*`): LHBH740C (2022 CVT) and, year unknown, LHBH720D, LHBH740A,
  LHBH800A, LHBHA00A, LHBHB00A, LHBP100e, LHBP100a, LHBT110a, LHBT120a, LHBT120g, LHBT130h (two 6MT, the rest CVT).
- Changed: LHBKC20P / 20R / 20L and LHBP300d are now listed with year unknown (they have no engine string; sharing
  code with a dated ROM doesn't date them, since the 2023 Ascent and Legacy/Outback share code too).
- Changed: **2022+ WRX**: Catalyst Heating Progress Maximum is now Catalyst Heating Spark Torque Share Maximum, shown in
  % torque from spark (256 = 100 %), like the two Catalyst Heating Phase 2 Exit Threshold tables. The value the
  ECU compares with these is the requested spark torque share, the same one as the FA20/FA24 axis of that name.
- Fixed: **2024 and 2026 WRX**: HPFP Solenoid Window End Limit and its Alternate were on each other's addresses.
- Fixed: **2024 and 2026 WRX** (LHBP400b, LHBP300d, LHBP301c, LHBT210V): the eight Target Torque Rise Stage 2 Torque
  and Start Torque tables of path B were on each other's addresses (stage 2 and start swapped, modes shifted). These
  ROMs keep the tables in a different order from the 2023 one; they are now placed by where the code stores each
  result. Stock values are all zero, so only edits made to them are affected.
- Changed: LHBT210V is listed as a 2026 (from the engine string in the ROM).
- New: **8 more 2022+ WRX ROMs** (`FA24DIT_*`): LHBHD00B (2022 6MT), LHBHC01C (2022–23 CVT), LHBKC30M (2023 6MT),
  LHBKC20P / LHBKC20R / LHBKC20L (2023 6MT / CVT / CVT, year not confirmed), LHBP300d (2024 6MT, year not confirmed)
  and LHBP301c (2024 CVT). Each is placed from its own code through the closest supported ROM; the first four ROMs'
  tables are unchanged.
- Fixed: **2022+ WRX mode-22 PIDs** (`logger/FA24DIT_LHBKC40M_Torque.csv`) used header 7E0, which this ECU only
  answers with OBD services; they now use 7DF.
- New: **44 more ROMs** that run exactly the same code as a supported ROM, with only the calibration different:
  38 for the 2.0 and 6 for the Levorg 1.6. None of them is in Subaru's update database, so model, year and market
  aren't confirmed; most are in a new "2.0, model not confirmed" list, and the transmission shown is read from each
  ROM's coding. Each ROM is filed under its own engine, read from its calibration (some run the other engine's code).
  No logging-patch spec for these yet.
- Fixed: **LF79101T and LF9F000Q** (Levorg 1.6) showed load in g/rev with the 2.0's factor, about 25 % too high; they
  now use the 1.6's (100 % = 1.034 g/rev).
- New: **49 more ROMs**, all earlier calibrations that a dealer update replaced (unstarred in the ROM lists): 45 for
  the 2.0 (WRX, Forester XT, Legacy, Levorg 2.0) and 4 for the Levorg 1.6 (LF9B002G, LF9D001e, LF79101T, LF9F000Q).
  Each runs exactly the same code as a ROM that was already supported, with only the calibration different, so its
  definition is that ROM's, at the same addresses; every table was checked through RomRaider and EcuFlash as for the
  others. LF75300G and LF75300T are among them: I now have complete reads of both. Two of the Levorg ROMs (LF79101T,
  LF9F000Q) run the 2.0's code but carry a 1.6 calibration, so they are in the FB16DIT files. No logging-patch spec
  for these yet.
- New: **RomRaider files that correct the checksum when you save** for the 2.0 and 1.6 ROMs:
  `FA20DIT_RomRaider_Checksum.xml` (Ascent / Legacy XT included) and `FB16DIT_RomRaider_Checksum.xml`, with the
  `FA20Sum16` module in `definitions/romraider/checksum/`. They need a RomRaider that loads checksum modules from the
  definition folder: my change for that (RomRaider pull request #248) is merged, so the next RomRaider release, or a
  build from the current source. The plain files are unchanged.
- Fixed: on the Ascent and Legacy / Outback XT, P0299 Underboost Error Threshold and Underboost Time sat in an
  "Unsorted" folder with code addresses in their descriptions; they are now with the other boost trouble-code
  settings, described in plain words.
- New: **2022+ WRX (FA24DIT files, RH850 ECU)**: LHBHB10B (2022 6MT), LHBKC40M (2023 6MT), LHBP400b (2024 6MT) and
  LHBT210V (CVT, 2025 or later). A new ECU generation with new software, placed from its own code; tables that do the
  same job as an Ascent table carry its name. 1,266–1,332 tables, values and switches per ROM, plus one switch per
  trouble code (254 / 312). RomRaider file in two versions (plain, and one that corrects the checksum on save with a
  RomRaider that loads checksum modules), and Imperial and Metric sets in EcuFlash format, made for FastECU
  (EcuFlash itself can only open a 3 MB copy of these ROMs). See "2022+ WRX: what's different" in the README.
- New: **`tools/checksum.py` and `checksum.ps1` handle 2022+ WRX ROMs** (4032 KB, little-endian sum, picked by file
  size). The 2 MB and 2.5 MB behaviour is unchanged.
- New: **`tools/ef_view.py` / `ef_view.ps1`**: the 3 MB copy of a 2022+ WRX ROM that EcuFlash can open, and merging
  the edited copy back with the checksum fixed.
- New: 2022+ WRX mode-22 logging list (`logger/FA24DIT_*.csv`, 88 ready-made PIDs for OBD apps) and a CAN DBC
  (`extras/can/FA24DIT_CAN.dbc`).
- Changed: **the `FA24DIT_*` files are now the 2022+ WRX's.** The Ascent and Legacy / Outback XT (FA24DIT engine on the
  older SH72544R ECU) are now the **FA24 Early** set, built on the FA20DIT files whose software they share: their
  RomRaider sections are in `FA20DIT_RomRaider.xml`, and in EcuFlash `FA24_Early_<calibration ID>_EcuFlash.xml` sits
  on a small `FA24_Early_BASE` that includes the FA20DIT base. Their logger and CAN files are now `FA24_Early_*`. Every Ascent table is unchanged: I loaded all eight ROMs with the old
  and new files in RomRaider and compared every value, address, user level, folder, unit and description, and checked
  the EcuFlash set table by table and in EcuFlash and FastECU. Delete any earlier `FA24DIT_RomRaider.xml` or
  `FA24DIT_*_EcuFlash.xml` you installed for the Ascent.
- Fixed: **SI-Drive names of the Requested Torque maps on the 2019 and 2020 Ascent** (LT8D700A, LT8D800A, LT8F200C,
  LT8F300C). The eight main maps had their drive modes in the wrong order: the map the ECU uses in Sport Sharp (the one
  that reaches full torque by half pedal) was named Intelligent, and so on. I ran each ROM's own torque code with the
  drive mode set to each position to confirm which map it uses. The 2021 Ascent, the Legacy / Outback XT, the monitor
  copies and the other drive-mode tables were already right. If you edited one of these maps on a 2019 or 2020
  Ascent, check that your change is on the map for the mode you meant.
- Fixed: **FastECU showed some EcuFlash scalings wrong** (load in g/rev, boost in psi, mph and a few others, on every
  engine): FastECU evaluates `x/256*0.015516` as `x/(256*0.015516)` and doesn't read exponent notation. Those
  scalings are now written as a single factor (`x*0.000060609375`), which FastECU, EcuFlash and RomRaider all read
  the same way. The values EcuFlash shows are unchanged.
- Fixed: **load in g/rev on the 1.6 (FB16DIT) and 2.4 (FA24DIT) definitions** used the 2.0 L factor, so g/rev read
  25 % high on the 1.6 and 17 % low on the 2.4. Each engine now uses its own (100 % = 1.034 g/rev on the 1.6, 1.552
  on the 2.4). Load in % was always right, and the 2.0 definitions are unchanged.
- New: **11 earlier calibrations** from the dealer update packages, each placed from the calibration that later
  replaced it: WRX LF75403G, LF75403T, LF79102N, LF9C002N, LF9D011g; Forester XT LF75403A, LF78106B, LF9C002B;
  Ascent LT8D700A, LT8F200C; Legacy / Outback XT LG7D430B. No logging patch for them yet.
- New: the ROM lists mark the newest calibration for each car with ★ (see the README).
- New: **2020 and 2021 Legacy / Outback XT** (LG7D501B, LG7F301F), in the FA24DIT files next to the Ascent. Same
  software as the Ascent, electric wastegate included; a few tables are not placed yet and there is no logging patch
  for them yet (see the README).
- New: **per-cylinder ignition timing trim** (four tables, one per cylinder, by rpm and load, plus the enable
  switch). Timing added to or taken from one cylinder only. The switch is already on in the 2017 Forester XT, every
  2018-2021 WRX ROM I have and most 1.6 ROMs, so on those you only need to fill in the tables (they are zero on the WRX;
  the 1.6, the 2018 Levorg and the Ascent use up to 2.5 degrees). On the 2014-2017 2.0 ROMs the switch is off.
- New: more tables that are flat on the 2015 WRX but calibrated on other ROMs:
  - manifold-pressure model transient thresholds and hysteresis (in gear and neutral) and its rising-transient gain;
  - the TGV-closed weight of the coolant timing compensation;
  - transient fuel film gains by coolant (normal, AT/CVT, manual) and the negative-film rpm multiplier and limit;
  - intake and exhaust AVCS enable delay after start (by engine-off time and oil temperature);
  - the DAM-weighted EGR timing term and its weight (single and multiple injection);
  - the AT/CVT start-spark torque adder pair.
- I also checked about 30 other code-read tables that turned out to be second pointers to data that is already
  defined. Editing the existing table already changes them, so they are not listed separately.

- New: **charge-control enable for 2017 and later ROMs** (including the 1.6 and the Ascent). These ROMs replaced
  the fixed delay after start with two tables: a delay by estimated state of charge at start and battery sensor
  value, and an amount of charge the battery must take back since the start. Charge control may begin when either
  is reached. Also found on the 2015 1.6 ROMs, where an older entry was sitting on one of these tables; that entry
  is removed.
- New: **knock-event detector on more ROMs and on the Ascent.** The 2016-2017 2.0 ROMs and the 2014 ROMs now have
  it too (their trip latches by itself, so they have no latch switch). On the Ascent the knocking-cylinder part is
  switched on in stock and a trip caps torque by rpm (122 to 207 ft-lb); both its tables are defined.
- Changed: **units audit.** I checked every table on every ROM (about 150,000 table entries): each one is in the
  RomRaider file and both EcuFlash sets, every axis has a unit, the Imperial set shows no metric unit (and the
  reverse) wherever both exist, and each table shows the same unit on every ROM. Fixed along the way:
  - two axes of the injection timing and rail pressure multipliers and one of the TGV torque threshold offset are
    oil temperature (they showed raw);
  - the cranking fuel tables now show milliseconds (raw still available in RomRaider; the unit is inferred);
  - TGV position axes show volts, the exhaust model's ratio axis shows a ratio, and the idle air request axes use
    the idle air unit;
  - gains, model units, CAN values and sensor values that have no physical unit now say what they are instead of
    "raw";
  - the adaptive charging settings show mV per A, counts and so on.
  About 25 tables still show raw, because the input they are indexed by is not identified yet.
- Changed: **1.6 re-read finished.** Every 1.6 "off in stock" entry whose switch differs from the 2.0 is now
  settled: about 22-62 per ROM are on in the 1.6 calibration and show at their normal level, the rest stay at Debug.
  The 1.6 ROMs from 2016 on use only the sea-level AVCS targets (the altitude set is zeroed and never blended in),
  and their drive-mode maps differ per mode as on the 2.0.

- New: **knock-event detector and its torque limit** (2017 Forester XT, 2018-2021 WRX and the 2017-2020 1.6 ROMs:
  21 ROMs; older ROMs either lack it or have a version I have not defined). These ROMs carry a
  detector beside DAM: one part counts cylinders knocking while knock correction is already deep, the other watches
  for ignition timing pulled down to a floor. When it trips (and, if the latch is on, until the learned values are
  reset) the new **Maximum Torque (Knock Event)** table caps torque by rpm and pedal. It is switched off on the 2.0
  WRX ROMs I have; on the 1.6 the knocking-cylinder part is on, and on several 1.6 ROMs the table is
  filled (0 to about 166 ft-lb). Switches, counts, thresholds and the timing floor tables are all defined, in
  Knock Control and Torque Limits.
- New: **DAM Initial Value, DAM Step and DAM Step-Up Knock-Free Events** on every ROM. The step is zeroed on every
  ROM I have, so DAM moves only through DAM Step Gain (FLKC Cell); the start value is 0.69 on the 2.0, 1.0 on many
  1.6 ROMs and 0.31 on the Ascent.
- New: **charging, part 3.** The adaptive-charging current loop on every 2.0 and 1.6 ROM: target battery current by
  state of charge, its gain and integral settings. On the 2015-2016 ROMs also the charge-control delay after start
  and the table that lengthens it after a low-battery start (2017 and later ROMs use a different rule, not defined
  yet). The two charge-efficiency tables now reach the 2017 and later ROMs too.
- Changed: **1.6 (FB16DIT) "off in stock" entries re-read.** About 20 to 35 entries per 1.6 ROM that the 2.0 leaves
  switched off are switched on in the 1.6 calibration (for example the EGR tip-out limit, the alternate DAM base
  timing blend, special-start cranking fuel, the tip-in extra pulse and the external torque limit factors). Those
  now show at their normal user level instead of Advanced; the ones I could confirm are still off stay at Debug.
- Fixed: two Ascent boost scalings were missing their metric (kPa / Nm) versions.

- New: **logging without the patch (SUBUDS).** `logger/DIT_Logger_SUBUDS.xml`, one file for every model,
  reads the stock and logging-patch parameters straight from RAM on a stock ROM, for a RomRaider build with the
  SUBUDS protocol (test builds on my RomRaider fork). Every address is checked in an emulator against the ECU's own
  SSM read, on all 103 ROMs. Not yet run on a car.
- Changed: the stock logger files' header comment no longer lists ROMs (it was out of date).
- New: **logging and CAN for every ROM.** The logging patch now has a spec for all 103 ROMs, and I checked the stock
  logger file against each ROM's own SSM table. The CAN dictionary covers all 100 2.0 and 1.6 ROMs.
- New: **Ascent logging** (`logger/FA24_Early_Logger*.xml`). The stock SSM parameters carry over, except wastegate duty
  (the Ascent's electric wastegate doesn't use it). The DTC tab lists 155 of the Ascent's codes. The logging patch
  adds the Ascent's boost target and pressure plus eight new parameters for the electric wastegate: motor duty,
  position, position command, feed-forward position, control mode, sensor voltage, boost error and the boost target
  before corrections (L25–L32).
- New: **Ascent CAN, first pass** (`extras/can/FA24_Early_CAN.*`). The Ascent runs a different CAN network from the WRX:
  15 received and 9 sent frame IDs, none shared with the FA20DIT. The sent frames are mapped field by field, with
  engine speed and other values named where they match a WRX signal. For the received frames only the first byte
  and a counter are mapped so far.

- New: **Ascent (FA24DIT)**, three ROMs: LT8D800A (2019), LT8F300C (2020) and LT8H300D (2021), all USDM CVT, in
  their own files at first (now the FA24 Early set, see the entry above), 103 ROMs in all. The
  Ascent runs a later build of the FA20DIT software, so most tables are carried over at its own addresses: about
  1,138 entries on each ROM (the same set on all three), placed from the 2020 WRX and from each other (wherever two sources place a table they
  agree), including the tip-in torque rise per drive mode, surge-damping timing and the rest of the torque model, plus the
  Park/Neutral rpm limit, the speed limiter and the charging system from each ROM's own code. Boost is new: the Ascent drives an electric
  wastegate, and its boost group covers the boost target and its IAT, baro and coolant corrections, the wastegate
  position feed-forward and compensations, the boost feedback (proportional, integral, limits), the feed-forward-only
  threshold, the fixed positions (low rpm, engine off, closed), the learned-seat limits, the actuator motor tables
  and limits (in % duty), and the P0234 (overboost), P0299 (underboost) and P0244 (position error) limits. The boost
  target table is by rpm and target torque, as on the WRX. The WRX boost tables still sit in the Ascent ROM, but nothing uses
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
