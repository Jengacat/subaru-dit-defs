# Definitions

Table definitions for the supported FA20DIT, FB16DIT and FA24DIT ROMs (see the [supported ROMs](../README.md#supported-roms)
lists).

| Folder | For | Files |
|---|---|---|
| [`romraider/`](romraider/) | RomRaider | `FA20DIT_RomRaider.xml` covers every supported 2.0 ROM, `FB16DIT_RomRaider.xml` every supported Levorg 1.6 ROM, `FA24DIT_RomRaider.xml` the Ascent and Legacy / Outback XT, and `FA24DIT_RH850_RomRaider.xml` the 2022+ WRX (also as `FA24DIT_RH850_RomRaider_Checksum.xml`, with the `checksum/` folder). |
| [`ecuflash/`](ecuflash/) | EcuFlash | Imperial and Metric sets: a base file per engine plus one file per ROM, named by calibration ID. Also `read_subaruhitachish72544.xml`, a read template for the 2.5 MB (2019+) ECUs (untested; see the [main README](../README.md#reading-your-ecu)). |

Both carry the same tables, scalings and descriptions. Each table has a plain-English summary first and the detail
after it, and tables are grouped by purpose in tuning order. The descriptions say what the ECU does with a table, not
what a particular car's calibration holds: stock values differ between markets, models and the two engines.

EcuFlash corrects this ECU's checksum on save for 2 MB ROMs; RomRaider can't until
[pull request #248](https://github.com/RomRaider/RomRaider/pull/248) is merged and released. Until then, run
[`tools/checksum.py`](../tools/) or `tools/checksum.ps1` on every ROM edited in RomRaider, and on every 2.5 MB ROM,
before flashing. The 2022+ WRX has its own rule and its own options; see
[2022+ WRX: what's different](../README.md#2022-wrx-whats-different).

## Notes on individual ROMs

*2019 Levorg STI (LF9F000R):* this is the first 2019+ ROM (Hitachi SH72544R, 2.5 MB). The calibration is almost the
same as the 2018 WRX S4's, but the code and layout are new, so check it carefully. Logging (SSM, OBD, the logging
patch) and the CAN dictionary cover it too. Four of its trouble codes sit where other ROMs have P0244, P0451, P0452
and P0453, so in the logger's DTC tab those four names also give its code. EcuFlash can't correct its checksum: use
the checksum tool. Writing a 2.5 MB ECU isn't supported by any open tool yet; see
[Reading your ECU](../README.md#reading-your-ecu).

*ROMs from Subaru's dealer software (added 2026-11):* 42 ROMs (LF75401J–N, LF75404H, LF755…, LF78001F,
LF78002D–Z, LF78200B, LF79100Q/R, LF79103P, LF79110N, LF9C100M/R/X, LF9C102P, LF9C200B/N, LF9D012h, LF9D030g,
LF9G002S/003T, LF9K000D/E, LV9N302E–L, LV9N303K, LV9N601M/N and the Levorg 1.6 LV3C100T) come from the full images in
Subaru's dealer reflash packages rather than from a read of a car. 26 of them run exactly the same code as a ROM
already supported, so they use its table list at the same addresses. The other 16 are builds of their own, ported
and checked like the others: I compared every table with the ROM it was ported from, and checked each table placed by
position against the decompiled code of both ROMs. Tables I could not confirm are left out rather than guessed, which
is why a few of these ROMs have fewer tables than their neighbours (LV3C100T most of all). Model, year and market come
from the package names: where marked "(unconfirmed)" or "not confirmed" I could not check them, and LF75500A's package
says Forester XT although its software is from the WRX family. The logging patch and the CAN dictionary do not cover
these ROMs yet. The 2019–2021 WRX ROMs (LF9D…, LF9G…, LF9K…) are 2.5 MB ECUs: EcuFlash can't correct their checksum
(use the checksum tool), and no open tool writes those ECUs yet.

*Malaysian Forester XT (LF9C000a):* the ID really ends in a lowercase "a". The code and table layout are the same
as LF9C000C's; only a few calibration bytes differ.

*Levorg 2.0 (2014–2017):* six of the seven Levorg ROMs run the same code as a
WRX ROM in this table; LV9N301A / LV9N302A are a build of their own, ported and checked like the others.

*Outdated:* LV9N000C is an early calibration that Subaru superseded (its tune is 99.7% the same as LV9N101C's). It
is still fully supported. When you open it, RomRaider shows its "ECU Revision is Obsolete" notice ("A newer version of
this ECU revision exists"), with a link to RomRaider's general ECU revision list rather than to this repo. The notice
can be switched off with its "Always display this message" box or in RomRaider's settings ("Warn me when opening out
of date image revision"). The EcuFlash definition does not carry this flag.

*Levorg 1.6 (FB16DIT, 2014–2020):* the 1.6's ECU runs the same software as the 2.0's. For each 1.6 ROM I paired every
function with the 2.0 ROM of the same software version; 98–99.9 % are identical instruction for instruction, so each
table is found by the same instruction that reads it in the 2.0. Where the code differs I read it. The five 2015 ROMs
(LF76…) are a software build I have no 2.0 ROM of; they sit between two 2.0 builds and needed the most hand work.
In the 2014–2017 ROMs the knock background function is a shorter version: it has four extra rows, Knock Background
Clear Step (Event 1–4). The 2019 and 2020 ROMs are 2.5 MB: EcuFlash can't correct their checksum (use the checksum
tool), and no open tool writes those ECUs yet. Model years and markets are as the ROMs were supplied. The
descriptions were written on the 2.0 and have not all been re-read against the 1.6.

*2016 Australian Forester XT (LF78002H; supplied as a 2017):* the same software version as the Forester tS (LF78001H), and nearly the same
code (its ID shares the LF780 prefix, but the two are separate builds, so neither definition fits the other ROM). Its
definition was moved from LF78001H instruction for instruction, with the 2017 USDM Forester XT (LF78103B) as a second
reference.

*User levels differ between ROMs:* a table that a ROM's own calibration switches off is at the Debug level in that
ROM and at Advanced in a ROM that uses it.

*Partial ports:* LF78001H, LF78002H and the LV9N ROMs have fewer tables than the WRX ROMs; tables I could not place with
confidence are left out rather than guessed.

*2022+ WRX (FA24DIT, RH850: LHBHB10B, LHBKC40M, LHBP400b, LHBT210V):* a new ECU (Renesas RH850/E1M-S2) with new
software, so these definitions are not a port of the SH ones. I placed every table from these ROMs' own code; where
a table does the same job as one in the Ascent definition, it carries that table's name, folder, user level and
description. The 2023 ROM is the reference; the 2022, 2024 and CVT ROMs were placed from it table by table and
checked against their own code. Things worth knowing before you edit:

- **How sure I am.** Each description ends with one of: nothing extra (accepted after review); "Identified from this
  ECU's code." (I read the code that uses it); "Unverified: matched by data / through the code / by value …" (placed
  by its match to the Ascent table of that name, without reading its code in full here; treat with care); "Axis
  input inferred: …" (the axis label comes from another table that shares the same breakpoint array).
- **User levels.** Levels 1–4 are normal tuning tables. Debug holds alternates the ECU only selects under a
  calibration switch, tables of code paths the ROM's coding doesn't use (the other transmission, for example), and
  internal values. Leave Debug alone unless you know what reads the table.
- **"(Monitor)" tables.** Copies read only by the ECU's torque monitor (88 pairs: requested torque, maximum and
  reference torque, the boost IAT and baro multipliers, and the monitor's own pedal curve). The monitor recomputes
  the torque the driver may have from them and checks the engine against it; if the check fails, the ECU closes
  the throttle until the engine is restarted (inferred). Keep each copy identical to its main table: copy the main
  table and paste it into the copy. Torque Monitor Fault Mode = 0 blocks the only route from the check to the
  throttle, which I read in the code, but that is untested on a car and switches off a safety check.
- **"(Idle State Group 1/2)" tables.** The idle controller picks one of each pair by its state: on the manual car,
  in practice group 1 = in gear and group 2 = neutral. Edit both together unless you know the difference.
- **"(AT/CVT …)" tables** are used only when the ROM is coded AT/CVT or the transmission controller asks for them
  over CAN. On the manual ROMs they are at Debug.
- **Drive Mode tables.** See the [main README](../README.md#2022-wrx-whats-different). On the manual car the pedal
  map is the per-gear set Requested Torque (Drive Mode 1, Default, Neutral / Gear 1–6), used while Requested Torque
  Gear Maps Switch is on; the plain Requested Torque (Drive Mode 1, Default) is used while it is off. Mode 2 copies
  of a few tables (surge damping, torque fall, pedal scaling) are listed next to the default ones; edit both to keep
  the modes alike.
- **Fuel.** The fuel factor is 256 + the largest of five enrichment sources (the Primary Open Loop Fueling base map
  and its blended TGV / AVCS group, warm-up, fuel-cut recovery and two others), and the open-loop part is capped. To
  lean the mixture, edit both Primary Open Loop Fueling paths; to richen it, either one is enough. Closed Loop
  Fueling Target adds to the factor (128 = stoichiometric).
- **Injector.** The pulse is quantity × Injector Flow Compensation (by rail pressure) × Injector Small Pulse
  Compensation + Injector Latency, floored at Injector Minimum Pulse Width. Injector Scaling sets the injector size.
  After an injector change, revisit all five.
- **Ignition.** The four Base Timing maps are blended (TGV open against closed by TGV opening, then EGR off against
  EGR active by the EGR rate): edit matching cells in all four. Fired timing is the lower of that base and Primary
  Ignition plus the knock terms, capped by Maximum Ignition Timing.
- **Boost.** Target Boost (Electronic Wastegate) by rpm and target torque, times the IAT and baro tables; the
  wastegate position is the feed-forward table plus feedback on boost error.
- **Injection timing** (Fueling // Injection Timing) is in degrees before compression TDC, larger = earlier. The
  units follow the Ascent's injection-angle code, which this ECU's scheduler matches, but they are not confirmed on a
  car: change them in small steps while logging.
- **DTCs.** One switch per code (254 on 2022, 312 on the others). Clearing one stops that code from setting or being
  reported; its monitor still runs. Names follow the Ascent definition where the code is the same; some codes have
  no name yet and show their code only.
- **CVT ROM (LHBT210V).** The ROM is coded AT/CVT, so the AT/CVT tables are at normal levels and the manual-only
  tables at Debug. Its model year is not confirmed (see the [main README](../README.md#supported-roms)).

## Credits

- **reokov**: submitted reads (many of the Levorg 2.0 ROMs, most of the Levorg 1.6 ROMs and others), the list of known
  calibration IDs behind [ROM_IDS](../docs/ROM_IDS.md), the ECU ID and model-revision information, testing of the
  definitions and tools on real cars, and many suggestions: the EcuFlash SH72544R read-template tip for 2.5 MB ECUs,
  listing the supported ROMs per model, and leads on tables to add (the engine-speed limit in P and N on the CVT ROMs,
  the alternator charge control).
- The RomRaider forum, where several of the ROMs were posted.
