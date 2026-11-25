# Definitions

Table definitions for the supported FA20DIT, FB16DIT and FA24DIT ROMs (see the [supported ROMs](../README.md#supported-roms)
lists).

| Folder | For | Files |
|---|---|---|
| [`romraider/`](romraider/) | RomRaider | `FA20DIT_RomRaider.xml` covers every supported 2.0 ROM, `FB16DIT_RomRaider.xml` every supported Levorg 1.6 ROM, the Ascent and Legacy / Outback XT (FA24 Early) inside the FA20DIT file, and `FA24DIT_RomRaider.xml` the 2022+ WRX (also as `FA24DIT_RomRaider_Checksum.xml`, with the `checksum/` folder). |
| [`ecuflash/`](ecuflash/) | EcuFlash, FastECU | Imperial and Metric sets: a base file per engine plus one file per ROM, named by calibration ID (the Ascent / Legacy XT files are `FA24_Early_*`, with a second base, `FA24_Early_BASE`, on top of the FA20DIT one; the 2022+ WRX files are made for FastECU). Also `read_subaruhitachish72544.xml`, a read template for the 2.5 MB (2019+) ECUs (untested; see the [main README](../README.md#reading-your-ecu)). |

Both carry the same tables, scalings and descriptions. Each table has a plain-English summary first and the detail
after it, and tables are grouped by purpose in tuning order. The descriptions say what the ECU does with a table, not
what a particular car's calibration holds: stock values differ between markets, models and the two engines.

EcuFlash corrects this ECU's checksum on save for 2 MB ROMs, and RomRaider does with the `_Checksum` files (see the
[RomRaider README](romraider/)). Otherwise, and for every 2.5 MB ROM edited in EcuFlash, run
[`tools/checksum.py`](../tools/) or `tools/checksum.ps1` before flashing. The 2022+ WRX has its own rule and its own options; see
[2022+ WRX: what's different](../docs/WRX_2022plus.md).

## Notes on individual ROMs

*2019 Levorg STI (LF9F000R):* this is the first 2019+ ROM (Hitachi SH72544R, 2.5 MB). The calibration is almost the
same as the 2018 WRX S4's, but the code and layout are new, so check it carefully. Logging (SSM, OBD, the logging
patch) and the CAN dictionary cover it too. Four of its trouble codes sit where other ROMs have P0244, P0451, P0452
and P0453, so in the logger's DTC tab those four names also give its code. EcuFlash can't correct its checksum: use
the checksum tool. Writing a 2.5 MB ECU isn't supported by any open tool yet; see
[Reading your ECU](../README.md#reading-your-ecu).

The 2019–2021 WRX ROMs (LF9D…, LF9G…, LF9K…) are 2.5 MB ECUs: EcuFlash can't correct their checksum
(use the checksum tool), and no open tool writes those ECUs yet.

*User levels differ between ROMs:* a table that a ROM's own calibration switches off is at the Debug level in that
ROM and at Advanced in a ROM that uses it.

*Partial ports:* LF78001H, LF78002H and the LV9N ROMs have fewer tables than the WRX ROMs; tables I could not place with
confidence are left out rather than guessed.

*2022+ WRX (FA24DIT files, RH850: LHBHB10B, LHBKC40M, LHBP400b, LHBT210V):* a new ECU (Renesas RH850/E1M-S2) with new
software, so these definitions are not a port of the SH ones. I placed every table from these ROMs' own code; where
a table does the same job as one in the Ascent definition, it carries that table's name, folder, user level and
description. The 2023 ROM is the reference; the 2022, 2024 and CVT ROMs were placed from it table by table and
checked against their own code. Things worth knowing before you edit:

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
- **Drive Mode tables.** See the [2022+ WRX guide](../docs/WRX_2022plus.md). On the manual car the pedal
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

## Credits

- **reokov**: submitted reads (many of the Levorg 2.0 ROMs, most of the Levorg 1.6 ROMs and others), the list of known
  calibration IDs behind [ROM_IDS](../docs/ROM_IDS.md), the ECU ID and model-revision information, testing of the
  definitions and tools on real cars, and many suggestions: the EcuFlash SH72544R read-template tip for 2.5 MB ECUs,
  listing the supported ROMs per model, and leads on tables to add (the engine-speed limit in P and N on the CVT ROMs,
  the alternator charge control).
- **Gekido and RayTheSavage** Supplied multiple RH850 ROM's and contributed significantly to building a FastECU module for reading RH850 ECU's
- The RomRaider forum, where several of the ROMs were posted.
