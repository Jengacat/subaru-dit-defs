# subaru-dit-defs

RomRaider and EcuFlash definitions, logging tools and a tuning guide for Subaru's Direct-Injected Turbocharged engine ECUs, covering the FA20DIT, FB16DIT and FA24DIT engine platforms. The list of supported ROMs is below.

The definitions were built from scratch from my own analysis of stock ROMs. No existing community definition was
used as a source, so table names, scalings and descriptions are my own. Every table in every ROM's definition is
placed from that ROM's own code. Every table also carries
a plain-English summary and a description of what the ECU does with it.

Across the supported ROMs, each definition averages roughly **1,280 entries**: about 1,090 maps and curves and
about 190 single values and switches. On top of that, each has a table for every trouble code (about 225), with its enable and fail-safe settings. The exact count for
each ROM is in the [ROM lists](#rom-lists).

> **Status: beta. Nothing has been validated on a running engine or flashed to a car yet.** Read the
> [known issues](#known-issues) before you use them, and always keep a stock read of the ECU.

## Downloads

Download the zip for your car from the [latest release](../../releases/latest). Each one has only the files those cars
need, in this repository's folder layout, plus a `START_HERE.md` with the steps:

| Car | Zip |
|---|---|
| 2014–2021 WRX and WRX S4, 2015–2018 Forester XT and tS, 2015–2017 Legacy and Outback, Levorg 2.0 | `subaru-dit-defs_<version>_FA20DIT.zip` |
| 2014–2020 Levorg 1.6 | `subaru-dit-defs_<version>_FB16DIT.zip` |
| 2019–2021 Ascent and Legacy / Outback XT | `subaru-dit-defs_<version>_FA24-Early.zip` |
| 2022+ WRX, 2023+ Ascent and Legacy / Outback XT | `subaru-dit-defs_<version>_RH850.zip` |

The zips are as of their release; this repository always has the newest files (the [changelog](CHANGELOG.md) lists
what changed).

## Quick start

Check that your ROM is supported first: find its calibration ID in the [ROM lists](#rom-lists) below. [What's
included](#whats-included) describes every folder.

### Editing with RomRaider
1. Use **[RomRaider 1.1.1](https://github.com/RomRaider/RomRaider/releases)** (or later). The definitions need it:
   RomRaider 1.0.0 and 1.1.0 can't open the ROMs with them. 1.1.1 is fully supported: I've tested opening, editing and
   saving 2 MB, 2.5 MB and RH850 (2022+) ROMs in it, DTC tables included, and it corrects the checksum on save.
   Keep the `checksum/` folder next to the XML files, since that's where RomRaider loads the checksum module from.
   Add `definitions/romraider/FA20DIT_RomRaider.xml` in RomRaider's Definition Manager (for a Levorg 1.6,
   `FB16DIT_RomRaider.xml`; for a 2022+ WRX or a 2023+ Ascent / Legacy / Outback XT, `FA24DIT_RomRaider.xml`, see the [2022+ WRX guide](docs/WRX_2022plus.md); the
   Ascent and Legacy XT (FA24 Early) are in the FA20DIT file; having several installed is fine).
2. Open your ROM. Tables are grouped by purpose (Fueling, Ignition Timing, Boost Control, …) in tuning order.
3. Set the user level (Settings → User Level) to match what you want to see: **Beginner** and **Intermediate** cover
   normal tuning; **Debug** shows tables your ROM's own calibration switches off, tables of unused code paths, and
   tables only the other transmission uses. Also
   untick "List tables that are above my userlevel" if you want higher-level tables hidden rather than greyed out.

**Trouble codes (DTCs)** are in Diagnostics & Switches → DTC Switches, one table per code, in code order. Each has
two cells: **Enabled** (1 = the code can set and report, 0 = it never sets) and **Fail-Safe** (1 = a failed test of
this code raises the ECU's fail-safe request; what that request limits isn't decoded yet). They work in RomRaider
1.1.1: changing a cell and saving changes exactly that code's bit (RomRaider versions before 1.0.0 would change the
wrong one).

### Editing with EcuFlash or FastECU
Both read the EcuFlash-format files in `definitions/ecuflash/`. Pick a unit system: `Imperial/` (psi, °F, ft-lb, mph)
or `Metric/` (kPa / MPa, °C, Nm, km/h). You need that folder's base file (`FA20DIT_BASE_EcuFlash.xml`, or
`FA20DIT_BASE_METRIC_EcuFlash.xml`; for a Levorg 1.6, `FB16DIT_BASE_EcuFlash.xml` or `FB16DIT_BASE_METRIC_EcuFlash.xml`;
for an Ascent or Legacy XT, the FA20DIT base **and** `FA24_Early_BASE_EcuFlash.xml` or
`FA24_Early_BASE_METRIC_EcuFlash.xml`) and the file for your ROM, in one folder. The base file is required: it holds
the table definitions, and the ROM file only its addresses. Install only one of the two sets: both use the same ROM
IDs. Table folders are numbered in tuning order (`01.02 Fueling - …`). For a 2022+ WRX or a 2023+ Ascent / Legacy /
Outback XT, see the [2022+ WRX guide](docs/WRX_2022plus.md).

- **EcuFlash:** put the files in a folder under your EcuFlash metadata folder (for example
  `rommetadata/subaru/FA20DIT/`) and restart EcuFlash. Its user level (options, gear icon → User Level) works like
  RomRaider's: Beginner shows the core tables and Developer shows everything; tables above your level are greyed out.
  EcuFlash corrects the checksum on save for 2015–2018 (2 MB) ROMs only. On the 2019+ (2.5 MB) ROMs, ROM Info shows
  FastECU's protocol name as the flash method; that is for FastECU and doesn't affect editing in EcuFlash.
- **FastECU:** in Edit → Settings, under "EcuFlash Definition Files Directory", choose the folder with the files
  (subfolders are searched too) and make sure EcuFlash definitions are enabled. Open your ROM and FastECU finds its
  definition by calibration ID, which also selects the right protocol. FastECU has no user levels, so every table is
  listed. On save it corrects the checksum of both 2015–2018 (2 MB) and 2019+ (2.5 MB) ROMs, Ascent and Legacy XT
  included. Tested with FastECU's current source (0.1.0-beta.7); older FastECU releases don't correct the 2.5 MB
  checksum, so use the [checksum tool](tools/README.md#checksum) with those.

Each DTC has two tables next to each other, in code order: the code itself (enabled or not) and `[Fail-Safe]`
(whether it triggers fail-safe). The calibration switches (folder 11.02, EGR Enable and the like) show as on/off. The
value in brackets is the whole byte, which the switch shares with others.

- **EcuFlash:** to flip one, select its value and press **Increment ( `]` ) once**; don't use Decrement.
- **FastECU:** each one is a drop-down. Pick the entry just above or below the current one with the other word (for
  example `yes [0F]` → `no [0E]`), so that only this switch's bit changes.

The [EcuFlash README](definitions/ecuflash/README.md) explains why.

### Logging

`logger/FA20DIT_Logger.xml` works in RomRaider Logger with every supported 2.0 and 1.6 ROM: I checked each ROM's own
SSM parameter table against it. Over SSM it has 46 parameters and
shows pending and stored trouble codes in the DTC tab. Switch the logger protocol to OBD for 32 standard OBD-II
parameters, including actual fuel rail pressure. On a stock ROM some of the most useful values (feedback knock
correction, target boost, target torque, combustion mode, the rail-pressure target) can't be read with RomRaider at
all. The **logging patch** fixes that. See the [logger README](logger/README.md).

The **Ascent** has its own logger files, `logger/FA24_Early_Logger*.xml`. Its SSM table has the same layout, so the stock
parameters carry over, except wastegate duty: the Ascent drives an electric wastegate, and that slot shows a value
nothing uses. Its DTC tab lists the Ascent's own codes at each position. The **Legacy / Outback XT (FA24 Early)** run
the same ECU software, but the Legacy / Outback XT (2020–2021) ECU has no SSM services at all (its diagnostic service table has no SSM init or read, read from all four ROMs), so neither these files nor the logging patch apply there: log it with RomRaider's OBD protocol for now.

### The logging patch

The patch points 41 unused entries of the ECU's SSM parameter table at RAM values worth logging, adding 24 parameters:
target and throttle torque, base timing, FBKC / FLKC / KCA / total knock correction, combustion mode, rail pressure
actual and target, target boost, boost pressure, wastegate duty and feedback, closed-loop target, A/F correction and
learning, throttle-model values, the throttle target, cam targets and injector pulse. Nothing else in the ROM changes,
and the checksum is fixed for you. Patch your own (stock or tuned) ROM with the spec for its calibration ID:

```
python3 tools/logpatch/make_logpatch.py tools/logpatch/specs/logpatch_LF75404S.json your_rom.bin your_rom_logpatch.bin
```

Every supported 2.0 and 1.6 ROM has a spec except LV9H000D (2015 USA WRX, an early build), and so do all five 2019–2021 Ascent ROMs: 238 in all. The **Logging patch** column of the ROM lists says which ("yes"). SUBUDS (below), which needs no patch, covers the same 238 ROMs. The 2020–2021 Legacy / Outback XT has no SSM, so the patch doesn't apply there (see the Ascent's notes below). The tool refuses a ROM of another calibration ID, a ROM whose checksum is already bad, and any slot that is not
unused. Then log with `logger/FA20DIT_Logger_LogPatch.xml` (parameters L01–L24). The patch uses the same slots on
every ROM with a spec, so one logger file covers all of them.

On the **Ascent**, log with `logger/FA24_Early_Logger_LogPatch.xml` instead. It has L01–L24 except the WRX wastegate pair
(L13, L14), and adds the electric wastegate: motor duty, position, position command, the feed-forward position,
control mode and position sensor voltage, plus boost error and the boost target before its corrections (L25–L32).
Target boost (L11) and boost pressure (L12) are the Ascent's own. The Legacy / Outback XT has no logging-patch spec yet.

The SSM files above don't cover the **RH850 ECU** (2022+ WRX, 2023+ Ascent and Legacy / Outback XT): it has no SSM
logging over CAN. It logs through SUBUDS instead (below), with the same `DIT_Logger_SUBUDS.xml` and the module
**ECU-RH850** selected: 97 parameters, the values the ECU itself publishes as UDS data identifiers (knock corrections,
DAM, target boost, wastegate, wideband lambda, cams and OCVs, throttle and pedal, switches and more), at each ROM's
own addresses, on all 35 supported RH850 ROMs. RomRaider's OBD protocol still logs the standard OBD-II parameters.
Not tested on a car yet; see [the logger guide](logger/README.md#rh850-ecu-subuds).

### Logging without a patch (SUBUDS)

**SUBUDS** is a RomRaider logger protocol I added that reads values straight from the ECU's RAM over CAN, using
diagnostic services the ECU allows without a security unlock. It works on a stock ROM with no reflash, so everything
the logging patch adds can be logged without it. One logger file, `logger/DIT_Logger_SUBUDS.xml`, covers the 238 SH-ECU ROMs
that also have a logging-patch spec (every 2.0 and 1.6 ROM except LV9H000D, and the five Ascents) and all 35 RH850 ROMs. It needs a RomRaider build with the protocol:
[my fork of RomRaider](https://github.com/Jengacat/RomRaider/tree/subuds-pr) has it, with Windows and Linux
builds on the fork's [subuds-22plus-update-2 release](https://github.com/Jengacat/RomRaider/releases/tag/subuds-22plus-update-2)
It hasn't been run on a car yet. Once it has, the protocol will go to the RomRaider project. If you try it, please
[open an issue](../../issues/new/choose) with how it went. Details: [logger README](logger/README.md#logging-without-the-patch-subuds).

## What's included

| Folder | Contents |
|---|---|
| `definitions/romraider/` | `FA20DIT_RomRaider.xml`: one file covering every supported 2.0 ROM and the Ascent / Legacy XT (FA24 Early). `FB16DIT_RomRaider.xml`: the same for the Levorg 1.6. `FA24DIT_RomRaider.xml`: the 2022+ WRX and the 2023+ Ascent and Legacy / Outback XT (RH850 ECU). Each corrects the checksum when you save, with the `checksum/` folder next to it (RomRaider 1.1.1 or later). |
| `definitions/ecuflash/Imperial/`, `definitions/ecuflash/Metric/` | The same EcuFlash definitions in two unit systems (EcuFlash can't switch units itself). Each folder has a base file per engine (every table) plus one small file per ROM; install one of the two. The Ascent / Legacy XT files are `FA24_Early_*`, on top of the FA20DIT base. The RH850 files (`FA24DIT_*`: 2022+ WRX, 2023+ Ascent and Legacy / Outback XT) are made for FastECU; EcuFlash can only open a 3 MB copy of those ROMs. |
| `logger/` | `FA20DIT_Logger.xml` (stock SSM and OBD parameters, trouble codes; also for the Levorg 1.6) and `FA20DIT_Logger_LogPatch.xml` (stock plus the logging-patch parameters). `FA20DIT_Logger_LogPatch_only.xml` holds only the new parameters, for merging into your own logger file. `FA24_Early_Logger*.xml`: the same three for the 2019–2021 Ascent (the Legacy / Outback XT has no SSM). `DIT_Logger_SUBUDS.xml`: the same parameters without the patch, on the 238 SH-ECU ROMs with a patch spec and all 35 RH850 ROMs, for a RomRaider build with the SUBUDS protocol. |
| `tools/checksum.py`, `tools/checksum.ps1` | Check and fix the ROM checksum of 2 MB, 2.5 MB and RH850 (4032 KB: 2022+ WRX, 2023+ Ascent and Legacy / Outback XT) ROMs (Python, or PowerShell for Windows). Needed for 2019+ ROMs edited in EcuFlash; `verify` checks any file before you flash it ([how to use](tools/README.md#checksum)). |
| `tools/ef_view.py`, `tools/ef_view.ps1` | RH850 ROMs only (2022+ WRX, 2023+ Ascent and Legacy / Outback XT): make the 3 MB copy of a ROM that EcuFlash can open, and merge the edited copy back with the checksum fixed. |
| `tools/logpatch/` | The logging patch: `make_logpatch.py` (and `make_logpatch.ps1` for Windows) and a spec for each ROM it covers (238: every 2.0 and 1.6 ROM except LV9H000D, and the five Ascents). |
| `docs/guide/` | [The tuning guide](docs/guide/README.md): workflows, how the logic works, appendices and a table reference. |
| `extras/can/` | The CAN dictionary: every frame the ECU receives and sends, for 100 of the 2.0 and 1.6 ROMs (`FA20DIT_CAN_RAM.csv` lists them), with a DBC for CAN tools and each signal's RAM address per ROM. `FA24_Early_CAN.*`: a first pass for the Ascent, which uses different frame IDs. `FA24DIT_CAN.dbc`: the 2022+ WRX (read from the WRX; not checked on the RH850 Ascent and Legacy / Outback XT). |

## ROM lists

Open your model for its ROM list. Model years and markets are as the ROMs were supplied to me. For the ROMs I took
from Subaru's dealer software, model, year and market come from the package names; "(unconfirmed)" and "not
confirmed" mark the ones I could not check. "Logging patch: yes" means the logging patch has a spec
for that ROM; SUBUDS logging covers the same ROMs (the RH850 ROMs log through SUBUDS too, see their notes).

★ marks the newest calibration Subaru released for that car (the one a dealer update installs). Unstarred ROMs
were later replaced by an update, or are builds that Subaru's update database doesn't cover (mostly JDM).

<details>
<summary><b>WRX and WRX S4</b>: 99 ROMs, 2014–2021</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| WRX (early software) | 2015 | 6MT | Australia | **LV9N100F** | 1208 | 222 | yes |
| WRX (early software) | 2015 | 6MT | Europe / General | **LV9N002I** | 1206 | 222 | yes |
| WRX (early software) | 2015 | 6MT | Europe / General | **LV9N300F** | 1233 | 222 | yes |
| WRX (early software) | 2015 | 6MT | Europe / General | **LV9N300I** | 1233 | 222 | yes |
| WRX (early software) | 2015 | 6MT | Europe / General | **LV9N301F** | 1246 | 222 | yes |
| WRX (early software) | 2015 | 6MT | Gulf (GCC) | **LV9N101I** | 1208 | 222 | yes |
| WRX | 2015 | 6MT | Middle East | **LF75301P** | 1281 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LF75200S** | 1257 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LF75300S** | 1281 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LF75400S** | 1281 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LF75402S** | 1281 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LF75403S** | 1281 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LF75404S** ★ | 1281 | 226 | yes |
| WRX | 2015 | 6MT | USA | **LV9H000D** | 1160 | 222 | not yet |
| WRX (early software) | 2015 | 6MT | not confirmed | **LV9N101F** | 1208 | 222 | yes |
| WRX (early software) | 2015 | 6MT | not confirmed | **LV9N302F** ★ | 1246 | 222 | yes |
| WRX (early software) | 2015 | 6MT | not confirmed | **LV9N302I** ★ | 1246 | 222 | yes |
| WRX | 2015 | CVT | Canada | **LF75200T** | 1257 | 226 | yes |
| WRX (early software) | 2015 | CVT | Europe / General | **LV9N001E** | 1206 | 222 | yes |
| WRX (early software) | 2015 | CVT | Europe / General | **LV9N101G** | 1208 | 222 | yes |
| WRX (early software) | 2015 | CVT | Europe / General | **LV9N101H** | 1208 | 222 | yes |
| WRX (early software) | 2015 | CVT | Europe / General | **LV9N300E** | 1233 | 222 | yes |
| WRX (early software) | 2015 | CVT | Europe / General | **LV9N300H** | 1233 | 222 | yes |
| WRX (early software) | 2015 | CVT | Europe / General | **LV9N301E** | 1246 | 222 | yes |
| WRX | 2015 | CVT | USA | **LF75300T** | 1281 | 226 | yes |
| WRX | 2015 | CVT | USA | **LF75402T** | 1281 | 226 | yes |
| WRX | 2015 | CVT | USA | **LF75403T** | 1281 | 226 | yes |
| WRX | 2015 | CVT | USA | **LF75500T** ★ | 1281 | 226 | yes |
| WRX (early software) | 2015 | CVT | USA | **LV9N101C** | 1208 | 222 | yes |
| WRX | 2015–2016 (not stated) | CVT | not confirmed | **LF75300L** | 1281 | 226 | yes |
| WRX (early software) | 2015 | CVT | not confirmed | **LV9N302E** ★ | 1246 | 222 | yes |
| WRX (early software) | 2015 | CVT | not confirmed | **LV9N302G** ★ | 1246 | 222 | yes |
| WRX (early software) | 2015 | CVT | not confirmed | **LV9N302H** ★ | 1246 | 222 | yes |
| WRX (early software) | 2015 | not confirmed | not confirmed | **LV9N002E** | 1208 | 222 | yes |
| WRX | 2016 | 6MT | Europe / General | **LF75300K** | 1281 | 226 | yes |
| WRX | 2016 | 6MT | Europe / General | **LF75300M** | 1281 | 226 | yes |
| WRX | 2016 | 6MT | Europe / General | **LF75400K** | 1281 | 226 | yes |
| WRX | 2016 (supplied as 2014) | 6MT | Middle East | **LF75401P** ★ | 1281 | 226 | yes |
| WRX | 2016 | 6MT | Singapore | **LF75301K** | 1281 | 226 | yes |
| WRX | 2016 | 6MT | USA | **LF75402H** | 1281 | 226 | yes |
| WRX | 2016 | 6MT | USA | **LF75404H** ★ | 1281 | 226 | yes |
| WRX | 2016 | 6MT | not confirmed | **LF75300H** | 1281 | 226 | yes |
| WRX | 2016 | 6MT | not confirmed | **LF75401K** ★ | 1281 | 226 | yes |
| WRX | 2016 | 6MT | not confirmed | **LF75401M** ★ | 1281 | 226 | yes |
| WRX | 2016 | CVT | Europe / General | **LF75300J** | 1281 | 226 | yes |
| WRX | 2016 | CVT | Europe / General | **LF75301J** | 1281 | 226 | yes |
| WRX | 2016 | CVT | Europe / General | **LF75301L** | 1281 | 226 | yes |
| WRX | 2016 | CVT | Europe / General | **LF75400N** | 1281 | 226 | yes |
| WRX | 2016 | CVT | USA | **LF75300G** | 1281 | 226 | yes |
| WRX | 2016 | CVT | USA | **LF75401G** | 1281 | 226 | yes |
| WRX | 2016 | CVT | USA | **LF75403G** | 1281 | 226 | yes |
| WRX | 2016 | CVT | USA | **LF75500G** ★ | 1281 | 226 | yes |
| WRX | 2016 | CVT | not confirmed | **LF75401J** ★ | 1281 | 226 | yes |
| WRX | 2016 | CVT | not confirmed | **LF75401L** ★ | 1281 | 226 | yes |
| WRX | 2016 | CVT | not confirmed | **LF75401N** ★ | 1281 | 226 | yes |
| WRX | 2017 | 6MT | Europe / General | **LF79001R** | 1297 | 228 | yes |
| WRX | 2017 | 6MT | Europe / General | **LF9C000R** | 1337 | 228 | yes |
| WRX | 2017 | 6MT | USA | **LF79101P** | 1311 | 228 | yes |
| WRX | 2017 | 6MT | USA | **LF79103P** ★ | 1311 | 228 | yes |
| WRX | 2017 | 6MT | not confirmed | **LF79002P** | 1297 | 228 | yes |
| WRX | 2017 | 6MT | not confirmed | **LF79100R** ★ | 1311 | 228 | yes |
| WRX | 2017 | 6MT | not confirmed | **LF9C100M** ★ | 1337 | 228 | yes |
| WRX | 2017 | 6MT | not confirmed | **LF9C100R** ★ | 1337 | 228 | yes |
| WRX | 2017 | 6MT | not confirmed | **LF9C100X** ★ | 1337 | 228 | yes |
| WRX | 2017 | 6MT (later revision) | not confirmed | **LF79100P** | 1311 | 228 | yes |
| WRX | 2017 | CVT | Europe / General | **LF79002Q** | 1297 | 228 | yes |
| WRX | 2017 | CVT | USA | **LF79002N** | 1297 | 228 | yes |
| WRX | 2017 | CVT | USA | **LF79102N** | 1311 | 228 | yes |
| WRX | 2017 | CVT | USA | **LF79110N** ★ | 1311 | 228 | yes |
| WRX | 2017 | CVT | not confirmed | **LF79100N** | 1311 | 228 | yes |
| WRX | 2017 | CVT | not confirmed | **LF79100Q** ★ | 1311 | 228 | yes |
| WRX | 2018 | 6MT | USA | **LF9C001P** | 1337 | 228 | yes |
| WRX | 2018 | 6MT | USA | **LF9C101P** | 1337 | 228 | yes |
| WRX | 2018 | 6MT | USA | **LF9C102P** ★ | 1337 | 228 | yes |
| WRX | 2018 | 6MT | not confirmed | **LF9C100P** | 1337 | 228 | yes |
| WRX | 2018 | CVT | USA | **LF9C001N** | 1337 | 228 | yes |
| WRX | 2018 | CVT | USA | **LF9C002N** | 1337 | 228 | yes |
| WRX | 2018 | CVT | USA | **LF9C200N** ★ | 1337 | 228 | yes |
| WRX | 2019 | 6MT | USA | **LF9D010h** | 1307 | 229 | yes |
| WRX | 2019 (2.5 MB ECU) | 6MT | USA | **LF9D012h** ★ | 1349 | 229 | yes |
| WRX | 2019 | CVT | USA | **LF9D010g** | 1359 | 229 | yes |
| WRX | 2019 (2.5 MB ECU) | CVT | USA | **LF9D011g** | 1359 | 229 | yes |
| WRX | 2019 (2.5 MB ECU) | CVT | USA | **LF9D030g** ★ | 1353 | 229 | yes |
| WRX | 2020 | 6MT | USA | **LF9G001T** | 1358 | 231 | yes |
| WRX | 2020 | 6MT | USA | **LF9G002T** | 1358 | 231 | yes |
| WRX | 2020 (2.5 MB ECU) | 6MT | USA | **LF9G003T** ★ | 1358 | 231 | yes |
| WRX | 2020 (2.5 MB ECU) | CVT | USA | **LF9G002S** ★ | 1358 | 231 | yes |
| WRX | 2021 (2.5 MB ECU) | 6MT | USA | **LF9J001E** | 1358 | 231 | yes |
| WRX | 2021 (2.5 MB ECU) | 6MT | USA | **LF9K000E** ★ | 1358 | 231 | yes |
| WRX | 2021 (2.5 MB ECU) | CVT | USA | **LF9J000D** | 1358 | 231 | yes |
| WRX | 2021 (2.5 MB ECU) | CVT | USA | **LF9K000D** ★ | 1358 | 231 | yes |
| WRX S4 | 2015 | CVT | Japan | **LF75300F** | 1281 | 226 | yes |
| WRX S4 (early software) | 2015 | CVT | Japan | **LV9N100B** | 1208 | 222 | yes |
| WRX S4 | 2018 | CVT | Japan | **LF9C001K** | 1337 | 228 | yes |
| WRX S4 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF79001M** | 1297 | 228 | yes |
| WRX S4 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF79100M** | 1311 | 228 | yes |
| WRX S4 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF79101L** | 1311 | 228 | yes |
| WRX S4 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF79101M** | 1311 | 228 | yes |
| WRX S4 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LV9N301B** | 1246 | 222 | yes |

</details>

<details>
<summary><b>WRX 2022+ (FA24DIT, RH850 ECU)</b>: 24 ROMs, 2022–2026 (first release, read the notes below)</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| WRX | 2022 | 6MT | USA | **LHBHB10B** | 1266 | 254 | no (see below) |
| WRX | 2022 | 6MT | USA | LHBHD00B | 1266 | 254 | no (see below) |
| WRX | 2022 | CVT | USA | LHBH740C | 1266 | 254 | no (see below) |
| WRX | 2022–2023 | CVT | USA | LHBHC01C | 1266 | 254 | no (see below) |
| WRX | 2023 | 6MT | USA | LHBKC30M | 1290 | 312 | no (see below) |
| WRX | 2023 | 6MT | USA | **LHBKC40M** | 1290 | 312 | no (see below) |
| WRX | 2024 | 6MT | USA | **LHBP400b** | 1300 | 312 | no (see below) |
| WRX | 2024 | CVT | USA | LHBP301c | 1300 | 312 | no (see below) |
| WRX | 2026 | CVT | USA | **LHBT210V** | 1332 | 312 | no (see below) |
| WRX | not confirmed | 6MT | not confirmed | LHBH720D | 1266 | 254 | no (see below) |
| WRX | not confirmed | 6MT | not confirmed | LHBKC20P | 1290 | 312 | no (see below) |
| WRX | not confirmed | 6MT | not confirmed | LHBP300d | 1300 | 312 | no (see below) |
| WRX | not confirmed | 6MT | not confirmed | LHBT130h | 1332 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBH740A | 1266 | 254 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBH800A | 1266 | 254 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBHA00A | 1266 | 254 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBHB00A | 1266 | 254 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBKC20L | 1290 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBKC20R | 1290 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBP100a | 1300 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBP100e | 1300 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBT110a | 1332 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBT120a | 1332 | 312 | no (see below) |
| WRX | not confirmed | CVT | not confirmed | LHBT120g | 1332 | 312 | no (see below) |

Year and market come from the engine string in the ROM where it
has one, or from Subaru's bulletins; where neither says, they are "unknown". The model is WRX for all of them: those without an engine string share
most of their calibration with the WRX ROMs (60–85 %) and only about a third with the Legacy, Outback and Ascent ROMs
on this ECU. The transmission is read from each ROM's coding.

The 2022+ WRX has a new ECU generation: a Renesas RH850/E1M-S2 with new software, not a build of the SH software
the other definitions cover. 
Every tool works a little differently on this ECU, so read [2022+ WRX: what's different](docs/WRX_2022plus.md)
before you start.

There is no logging patch: this ECU has no SSM
logging over CAN, so the patch has nothing to extend. Mode-22 (UDS) logging works instead; see
[Logging](#logging).

</details>

<details>
<summary><b>Forester XT and tS</b>: 32 ROMs, 2015–2018</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| Forester XT (early software; briefly also the WRX CVT) — *outdated* | early 2015 | CVT | USA | **LV9N000C** | 1208 | 222 | yes |
| Forester XT | 2016 (supplied as 2017) | CVT | Australia | **LF78002H** ★ | 1293 | 227 | yes |
| Forester XT | 2016 | CVT | Europe / General | **LF78000D** | 1288 | 227 | yes |
| Forester XT | 2016 | CVT | Europe / General | **LF78000F** | 1288 | 227 | yes |
| Forester XT | 2016 | CVT | Europe / General | **LF78001E** | 1288 | 227 | yes |
| Forester XT | 2016 | CVT | Europe / General | **LF78001G** | 1288 | 227 | yes |
| Forester XT | 2016 | CVT | Europe / General | **LF78001Z** | 1288 | 227 | yes |
| Forester XT | 2016 | CVT | not confirmed | **LF78001F** ★ | 1293 | 227 | yes |
| Forester XT | 2016 | CVT | not confirmed | **LF78002D** ★ | 1293 | 227 | yes |
| Forester XT | 2016 | CVT | not confirmed | **LF78002E** ★ | 1293 | 227 | yes |
| Forester XT | 2016 | CVT | not confirmed | **LF78002G** ★ | 1293 | 227 | yes |
| Forester XT | 2016 | CVT | not confirmed | **LF78002J** ★ | 1293 | 227 | yes |
| Forester XT | 2016 | CVT | not confirmed | **LF78002Z** ★ | 1293 | 227 | yes |
| Forester XT | 2017 | CVT | Europe | **LF9C000C** | 1337 | 228 | yes |
| Forester XT | 2017 | CVT | USA | **LF78101B** | 1288 | 228 | yes |
| Forester XT | 2017 | CVT | USA | **LF78102B** | 1288 | 228 | yes |
| Forester XT | 2017 | CVT | USA | **LF78103B** | 1288 | 228 | yes |
| Forester XT | 2017 | CVT | USA | **LF78104B** | 1288 | 228 | yes |
| Forester XT | 2017 | CVT | USA | **LF78106B** | 1288 | 228 | yes |
| Forester XT | 2017 | CVT | USA | **LF78200B** ★ | 1288 | 228 | yes |
| Forester XT | 2018 | CVT | Malaysia | **LF9C000a** | 1337 | 228 | yes |
| Forester XT | 2018 | CVT | USA | **LF9C000B** | 1337 | 228 | yes |
| Forester XT | 2018 | CVT | USA | **LF9C002B** | 1337 | 228 | yes |
| Forester XT | 2018 | CVT | USA | **LF9C200B** ★ | 1337 | 228 | yes |
| Forester tS (STI) | 2016 | CVT | Australia | **LF78001H** | 1288 | 227 | yes |
| Forester XT (unconfirmed) | 2016 | CVT | USA | **LF75200A** | 1257 | 226 | yes |
| Forester XT (unconfirmed) | 2016 | CVT | USA | **LF75301A** | 1281 | 226 | yes |
| Forester XT (unconfirmed) | 2016 | CVT | USA | **LF75402A** | 1281 | 226 | yes |
| Forester XT (unconfirmed) | 2016 | CVT | USA | **LF75403A** | 1281 | 226 | yes |
| Forester XT (unconfirmed) | 2016 | CVT | USA | **LF75500A** ★ | 1281 | 226 | yes |
| Forester XT (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF78003A** | 1288 | 227 | yes |
| Forester XT (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF9C000A** | 1337 | 228 | yes |

</details>

<details>
<summary><b>Legacy and Outback</b>: 7 ROMs, 2015–2017</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| Legacy | 2016 | CVT | Europe / General | **LV9N300L** | 1233 | 222 | yes |
| Outback | 2015 | CVT | Europe / General | **LV9N301K** | 1233 | 222 | yes |
| Legacy (unconfirmed) | 2016 | CVT | not confirmed | **LV9N302L** ★ | 1246 | 222 | yes |
| Legacy (unconfirmed) | 2017 | CVT | Europe / General | **LV9N600M** | 1246 | 222 | yes |
| Legacy (unconfirmed) | 2017 | CVT | not confirmed | **LV9N601M** ★ | 1246 | 222 | yes |
| Outback (unconfirmed) | 2015 | CVT | not confirmed | **LV9N303K** ★ | 1246 | 222 | yes |
| Outback (unconfirmed) | 2017 | CVT | not confirmed | **LV9N601N** ★ | 1246 | 222 | yes |

</details>

<details>
<summary><b>Levorg 2.0</b>: 12 ROMs, 2014–2019</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| Levorg 2.0 (early software) | 2014 | CVT | Japan | **LV9N301A** | 1246 | 222 | yes |
| Levorg 2.0 (early software) | 2014 | CVT | Japan | **LV9N302A** | 1246 | 222 | yes |
| Levorg 2.0 | 2015 | CVT | Japan | **LF75401D** | 1281 | 226 | yes |
| Levorg 2.0 STI | 2017 | CVT | Japan | **LF79100K** | 1311 | 228 | yes |
| Levorg 2.0 STI | 2017 | CVT | Japan | **LF79101K** | 1311 | 228 | yes |
| Levorg 2.0GT-S (early software) | 2014 | CVT | Japan | **LV9N100A** | 1208 | 222 | yes |
| Levorg 2.0GT-S | 2017 | CVT | Australia | **LF79100S** ★ | 1311 | 228 | yes |
| Levorg 2.0GT-S | 2017 | CVT | Europe / General | **LF79002S** | 1297 | 228 | yes |
| Levorg STI 2.0 (2.5 MB ECU) | 2019 | CVT | Japan | **LF9F000R** | 1358 | 231 | yes |
| Levorg 2.0 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF75300D** | 1281 | 226 | yes |
| Levorg 2.0 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LF79001K** | 1297 | 228 | yes |
| Levorg 2.0 or WRX S4 (unconfirmed) | not confirmed | CVT | Japan (unconfirmed) | **LV9N302B** | 1246 | 222 | yes |

</details>

<details>
<summary><b>Levorg 1.6 (FB16DIT)</b>: 40 ROMs, 2014–2020</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| Levorg 1.6 | 2014 | CVT | Japan | **LV9N303J** | 1251 | 222 | yes |
| Levorg 1.6 | 2014 | CVT | Japan | **LV9N340J** | 1249 | 222 | yes |
| Levorg 1.6 | 2015 | CVT | Europe | **LF76400Q** | 1284 | 226 | yes |
| Levorg 1.6 | 2015 | CVT | Japan | **LF76401R** | 1284 | 226 | yes |
| Levorg 1.6 | 2015 | CVT | Japan | **LF76500R** | 1284 | 226 | yes |
| Levorg 1.6 | 2015 | CVT | Japan | **LF76600R** | 1284 | 226 | yes |
| Levorg 1.6 | 2016 (supplied as 2015) | CVT | Europe | **LF76500Q** ★ | 1284 | 226 | yes |
| Levorg 1.6 | 2016 | CVT | Europe / General | **LF76200Q** | 1264 | 226 | yes |
| Levorg 1.6 | 2016 | CVT | Europe / General | **LF76301Q** | 1280 | 226 | yes |
| Levorg 1.6 | 2016 | CVT | Japan | **LF76402R** | 1284 | 226 | yes |
| Levorg 1.6 | 2016 | CVT | Japan | **LF79201U** | 1310 | 228 | yes |
| Levorg 1.6 | 2016 | CVT | Japan | **LF79202U** | 1315 | 228 | yes |
| Levorg 1.6 | 2016 | CVT | Japan | **LF79400U** | 1310 | 228 | yes |
| Levorg 1.6 | 2017 | CVT | Europe | **LF79200T** | 1310 | 228 | yes |
| Levorg 1.6 | 2017 | CVT | Europe | **LF79300T** ★ | 1310 | 228 | yes |
| Levorg 1.6 | 2017 | CVT | Europe / General | **LF79101T** | 1311 | 228 | yes |
| Levorg 1.6 | 2017 | CVT | Japan | **LF79200U** | 1310 | 228 | yes |
| Levorg 1.6 | 2017 (facelift) | CVT | Japan | **LF9B003U** | 1341 | 228 | yes |
| Levorg 1.6 | 2017 (facelift) | CVT | Japan | **LF9B200U** | 1337 | 228 | yes |
| Levorg 1.6 | 2018 (facelift; supplied as 2017) | CVT | Europe | **LF9B100G** ★ | 1341 | 228 | yes |
| Levorg 1.6 | 2018 | CVT | Europe / General | **LF9B002G** | 1341 | 228 | yes |
| Levorg 1.6 | 2018 | CVT | Europe / General | **LV3C001T** | 1236 | 228 | yes |
| Levorg 1.6 | 2018 | CVT | not confirmed | **LV3C100T** ★ | 1236 | 228 | yes |
| Levorg 1.6 | 2019 (2.5 MB ECU) | CVT | Europe | **LF9D100e** ★ | 1355 | 229 | yes |
| Levorg 1.6 | 2019 | CVT | Europe / General | **LF9D001e** | 1359 | 229 | yes |
| Levorg 1.6 | 2019 (2.5 MB ECU) | CVT | Japan | **LF9D000d** | 1359 | 229 | yes |
| Levorg 1.6 | 2019 (2.5 MB ECU) | CVT | Japan | **LF9D200d** | 1359 | 229 | yes |
| Levorg 1.6 | 2020 (2.5 MB ECU) | CVT | Europe | **LF9F100Q** ★ | 1356 | 231 | yes |
| Levorg 1.6 | 2020 | CVT | Europe / General | **LF9F000Q** | 1358 | 231 | yes |
| Levorg 1.6 | 2020 (2.5 MB ECU) | CVT | Japan | **LF9F100P** | 1358 | 231 | yes |
| Levorg 1.6 | 2020 (2.5 MB ECU) | CVT | Japan | **LF9F200P** | 1358 | 231 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF76100R** | 1264 | 226 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF76200R** | 1264 | 226 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF76301R** | 1280 | 226 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF76400R** | 1284 | 226 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF79101U** | 1311 | 228 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF79300U** | 1310 | 228 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LF9F000P** | 1358 | 231 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LV9N301J** | 1246 | 222 | yes |
| Levorg 1.6 | not confirmed | CVT | not confirmed | **LV9N302J** | 1251 | 222 | yes |

</details>

<details>
<summary><b>2.0, model not confirmed</b>: 44 ROMs</summary>

Calibrations that aren't in Subaru's update database, so model, year and market aren't known. The transmission is read from each ROM's own coding.

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| not confirmed | not confirmed | 6MT | not confirmed | **LF75600H** | 1281 | 226 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF75600S** | 1281 | 226 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF79120P** | 1311 | 228 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF79130P** | 1304 | 228 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9C300P** | 1337 | 228 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9C400P** | 1329 | 228 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9D000j** | 1359 | 229 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9D000m** | 1359 | 229 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9D040h** | 1359 | 229 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9D050h** | 1358 | 229 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9F000V** | 1358 | 231 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9F000Y** | 1358 | 231 | yes |
| not confirmed | not confirmed | 6MT | not confirmed | **LF9L000E** | 1358 | 231 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF73100A** | 1232 | 226 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF75100D** | 1257 | 226 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF75300E** | 1281 | 226 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF75401E** | 1281 | 226 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF75401F** | 1281 | 226 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF76000C** | 1259 | 199 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF77000C** | 1284 | 227 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF77000D** | 1201 | 227 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF77000Q** | 1201 | 227 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF78001C** | 1288 | 227 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF78002C** | 1293 | 227 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF780Z2E** | 1293 | 227 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF79001L** | 1297 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF79100L** | 1311 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000E** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000F** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000L** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000Q** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000Y** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000Z** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C000b** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9C001D** | 1337 | 228 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9D000f** | 1359 | 229 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9D000i** | 1359 | 229 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9D000k** | 1359 | 229 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9D000n** | 1359 | 229 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9F000U** | 1358 | 231 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9F000W** | 1358 | 231 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9F000Z** | 1358 | 231 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LF9J000C** | 1358 | 231 | yes |
| not confirmed | not confirmed | CVT | not confirmed | **LV9N000A** | 1206 | 222 | yes |

</details>

<details>
<summary><b>Ascent and Legacy / Outback XT (FA24 Early: FA24DIT on the SH72544R)</b>: 9 ROMs, 2019–2021 (first release, read the notes below)</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| Ascent 2.4 | 2019 | CVT | USA | **LT8D700A** | 1331 | 250 | yes |
| Ascent 2.4 | 2019 | CVT | USA | **LT8D800A** ★ | 1331 | 250 | yes |
| Ascent 2.4 | 2020 | CVT | USA | **LT8F200C** | 1331 | 250 | yes |
| Ascent 2.4 | 2020 | CVT | USA | **LT8F300C** ★ | 1331 | 250 | yes |
| Ascent 2.4 | 2021 | CVT | USA | **LT8H300D** ★ | 1304 | 251 | yes |
| Legacy / Outback XT 2.4 | 2020 | CVT | USA | **LG7D430B** | 1304 | 250 | no SSM (see notes) |
| Legacy / Outback XT 2.4 | 2020 | CVT | USA | **LG7D501B** ★ | 1295 | 250 | no SSM (see notes) |
| Legacy / Outback XT 2.4 | 2021 | CVT | USA | **LG7F301F** ★ | 1302 | 250 | no SSM (see notes) |
| Legacy / Outback XT 2.4 | not confirmed | CVT | not confirmed | **LG7F300F** | 1302 | 250 | no SSM (see notes) |

The Ascent and Legacy XT run a later build of the same ECU software, so most tables are the FA20DIT ones. Boost
control is different: they have an electric wastegate, with its own Boost Control group (target, wastegate
position, feedback and actuator limits).

**Logging.** The Ascent logs over SSM with `FA24_Early_Logger*.xml`, the logging patch and SUBUDS, like the 2.0. The
Legacy / Outback XT ECU has no SSM services (its diagnostic service table has no SSM init or read; read in all four
ROMs), so for now only RomRaider's OBD protocol logs it.

**Use the FA24 Early files, not FA24DIT.** The above models have the FA24DIT engine,
but their ECU's runs a later build of the FA20DIT software, so their definitions build on the FA20DIT ones. RomRaider
sections are in `FA20DIT_RomRaider.xml`, and the EcuFlash files need `FA20DIT_BASE_EcuFlash.xml` as well as
`FA24_Early_BASE_EcuFlash.xml`. The `FA24DIT_*` files are for the 2022+ WRX and the 2023+ Ascent and Legacy /
Outback XT (RH850 ECU, next section).

</details>

<details>
<summary><b>Ascent and Legacy / Outback XT 2023+ (FA24DIT, RH850 ECU)</b>: 11 ROMs, 2023–2025 (first release, read the notes below)</summary>

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTCs | Logging patch |
|---|---|---|---|---|---|---|---|
| Ascent 2.4 | 2023 | CVT | USA | **LHBK240Y** | 1271 | 311 | no (see below) |
| Ascent 2.4 | not confirmed | CVT | not confirmed | LHBP201A | 1300 | 312 | no (see below) |
| Legacy / Outback XT 2.4 | 2023 | CVT | USA | LHBK240G | 1271 | 311 | no (see below) |
| Legacy / Outback XT 2.4 | 2025 | CVT | USA | LHBR200G | 1300 | 312 | no (see below) |
| Legacy / Outback XT 2.4 | 2025 | CVT | USA | LHBR300G | 1300 | 312 | no (see below) |
| Legacy / Outback XT 2.4 | not confirmed | CVT | not confirmed | LHBK230H | 1271 | 311 | no (see below) |
| Outback XT 2.4 | 2024 | CVT | USA | LHBKG00H | 1290 | 312 | no (see below) |
| Outback XT 2.4 | 2024 | CVT | USA | LHBKG01G | 1290 | 312 | no (see below) |
| Outback XT 2.4 | 2024 | CVT | USA | **LHBKG01H** | 1290 | 312 | no (see below) |
| Ascent 2.4 (unconfirmed) | not confirmed | CVT | not confirmed | LHBK231Z | 1271 | 311 | no (see below) |
| Ascent 2.4 (unconfirmed) | not confirmed | CVT | not confirmed | LHBK240Z | 1271 | 311 | no (see below) |

These cars moved to the same RH850 ECU as the 2022+ WRX, with the same software line: 98–99.7 % of their functions
are the WRX ROMs' own. **Use the `FA24DIT_*` files** and
read [2022+ WRX: what's different](docs/WRX_2022plus.md); everything in it (ROM size, checksum, EcuFlash's 3 MB
copy, FastECU) applies to these ROMs too. The calibration is their own: only about a third of it matches the WRX.

The 2023 Ascent and Legacy / Outback XT builds (LHBK2…) have no second set of surge damping phase factors above
1800 RPM, so those tables and their RPM split aren't in their files. One fewer DTC there: P0047 isn't in their
fault table.

Year and market come from Subaru's bulletins where a ROM is listed; otherwise they are "unknown". For those, the model
comes from the calibration: LHBP201A matches the 2023 Ascent for 99 % of its calibration, LHBK230H the 2023 Legacy /
Outback for 99.9 %. LHBK240Z and LHBK231Z are closer to the Ascent (89 %) than to the Legacy / Outback (78 %), not
enough to be sure, so they are listed as unconfirmed.

There is no logging patch (no SSM logging over CAN on this ECU). They log through SUBUDS like the 2022+ WRX, with
each ROM's own addresses ([logger guide](logger/README.md#rh850-ecu-subuds)).

</details>

Notes on individual ROMs and credits are in the [definitions README](definitions/README.md#notes-on-individual-roms).

The calibration ID is the ROM's identifier, stored in the ROM itself; RomRaider/EcuFlash
pick the matching definition from it automatically. A ROM with a different ID is **not supported**, even if it is the
same model year; flashing with a definition for another ID will corrupt the calibration.

### Missing definitions

<details>
<summary><b>ROMs without a definition yet</b>, and why</summary>

| ROM | Why |
|---|---|
| LV9N101D (2015 USDM WRX), LV9N002F (2014 Australian WRX) | The only copies I have are incomplete (1.5 MB) reads. A complete read would make them supportable quickly. |
| Other 2015–2018 WRX and Forester XT calibrations | I don't have these ROMs. [Submit one](#submitting-a-rom) and I can add it. |
| 2013–2015 Forester XT with an AF5G…, AF56…, AF6A…, LF61…, LF6A… or LF7B… ID (e.g. LF61803B) | An older 1.5 MB ECU (SH705x) with different software; not covered by these definitions. |
| Other 2019+ calibrations | These ECUs have 2.5 MB of flash and a newer boot block, like the supported 2019–2021 WRX (LF9D…, LF9G…, LF9K…) and Levorg STI (LF9F000R), so a complete read makes them supportable. EcuFlash can open 2.5 MB ROMs. |
| Other Ascent and Legacy / Outback XT calibrations (LT8…, LG7… IDs) | Same software family as the supported ROMs; each needs a read and a port. |
| Other RH850 calibrations (LHB… IDs: 2022+ WRX, 2023+ Ascent and Legacy / Outback XT) | The same ECU generation as the supported LHB… ROMs. A later calibration of a supported build ports quickly; a different build needs its code read again. [Submit one](#submitting-a-rom) as a 4032 KB or 4 MB image. |

</details>

A list of the calibration IDs known for these ECUs, and how each relates to the supported ROMs, is in
[docs/ROM_IDS.md](docs/ROM_IDS.md).

## Units

Every table whose unit depends on the system has both an imperial and a metric scale.

- **RomRaider:** one file with both. Tables open in: engine load in **g/rev** (% available as an alternate scale;
  100 % = 1.293 g/rev on the 2.0, 1.034 on the 1.6, 1.552 on the 2.4), torque in **ft-lb** (Nm), boost in **psi gauge** (kPa absolute, psia), manifold pressure in
  psia (kPa absolute), rail pressure in **psi** (MPa, kPa), temperatures in **°F** (°C), vehicle speed in **km/h** as
  stored (mph), AFR (λ), timing in degrees BTDC, injector size as flow in g/s. Switch scales from the table's View
  menu. Exception: about 40 tables (mostly coolant-temperature compensations) have a fixed list of temperatures as
  their axis, which RomRaider can't rescale; those labels are in °F.
- **EcuFlash:** has one scale per table, so there are two sets. **Imperial**: psi, °F, ft-lb, mph. **Metric**: kPa
  (absolute for boost and manifold pressure), MPa for rail pressure, °C, Nm, km/h. Units that both systems use (g/rev,
  RPM, %, AFR, degrees, g/s) are the same in both.
- **Logger:** every parameter with a unit-specific value already offers both (choose in RomRaider's logger).

## Known issues

- **Untested on hardware.** No ROM edited with these definitions has been flashed and driven yet. Start from a known
  good stock read, change little at a time and log everything.
- **Checksum.** A ROM with a bad checksum won't run. RomRaider 1.1.1 and FastECU (current source) fix it when you
  save; EcuFlash does only for 2015–2018 (2 MB) ROMs, so run 2019+ ROMs edited in EcuFlash through the
  [checksum tool](tools/README.md#checksum). Its `verify` checks any file before you flash it.
- **RomRaider 1.1.1 is required.** It's fully supported and tested with these definitions; RomRaider 1.0.0 and 1.1.0
  can't open the ROMs with them.
- **Ascent and Legacy / Outback XT (FA24 Early): first release.** Not yet checked against a read from a car. The checksum is the same as the 2.5 MB WRX's. These ROMs come
  from Subaru's dealer software, which has no boot block, so `verify` reports one boot marker as BAD on them; a full
  read from a car should pass.
- **RH850 ECU (2022+ WRX, 2023+ Ascent and Legacy / Outback XT): first release.** Not yet checked against a car. Its checksum
  rule is not yet proven on a car (see the [2022+ WRX guide](docs/WRX_2022plus.md)). The "(Monitor)" tables are copies the ECU's
  torque monitor reads: keep each one equal to its main table, or the monitor can close the throttle (see the
  [definitions README](definitions/README.md#notes-on-individual-roms)). Some codes in the DTC list have no name yet.
  Its EcuFlash-format files are only fully usable in FastECU: EcuFlash can't load the right memory model for these
  ROMs and needs the 3 MB copy.
- **Ascent files renamed.** The Ascent and Legacy / Outback XT now use the FA24 Early files: their RomRaider
  sections are in `FA20DIT_RomRaider.xml`, and their EcuFlash, logger and CAN files are `FA24_Early_*`. Delete any earlier `FA24DIT_RomRaider.xml` or `FA24DIT_*_EcuFlash.xml` you
  installed for them; those names are the 2022+ WRX's now.
- **Inferred items** are marked "inferred" in their descriptions; everything else is read from the ECU code.

## Reading your ECU

Read your ECU and keep that stock file somewhere safe before you change anything. A complete read is exactly the size
below; a smaller file stopped partway and isn't usable. If the reading tool doesn't show a calibration ID, that's
fine: the ID is inside the file (open it with these definitions, or [submit it](#submitting-a-rom) and I'll identify it).

| ECU | Cars | Complete read | Read it with |
|---|---|---|---|
| Hitachi SH72543R, 2 MB | 2014–2020 2.0 and 1.6 (every ROM in the lists not marked "2.5 MB ECU") | 2,097,152 bytes | EcuFlash, with the **2 MB** read setting |
| Hitachi SH72544R, 2.5 MB | 2019–2021 ROMs marked "(2.5 MB ECU)" in the lists, and the 2019–2021 Ascent and Legacy / Outback XT | 2,621,440 bytes | FastECU (read-only) |
| Renesas RH850, 4032 KB | 2022+ WRX, 2023+ Ascent and Legacy / Outback XT | 4,128,768 bytes | FastECU (read-only) |

**FastECU** (free, open source, works with a Tactrix OpenPort 2.0) has a read protocol for each of the newer ECUs,
both of which I added to the project. They're in FastECU 0.1.0-beta.7 and its current source:

- **2.5 MB:** "Subaru 2019+ 2.0 DIT CAN (Hitachi SH72544R/2.5MB), read only"
  ([miikasyvanen/FastECU#159](https://github.com/miikasyvanen/FastECU/pull/159)).
- **RH850:** "Subaru 2022+ DIT CAN (Renesas RH850/4MB)", under the vehicles WRX, Ascent, Legacy and Outback 2.4 DIT
  ([miikasyvanen/FastECU#165](https://github.com/miikasyvanen/FastECU/pull/165)). Writing is switched off in it.

Both read with the ECU's own diagnostic memory read, so nothing is written to the ECU. **Neither has been run on a car
yet.** If you try one, please [let me know](../../issues/new/choose) how it went, with the size of the file you got.

**EcuFlash** reads the 2 MB ECU. For the 2.5 MB ECU, the read template `read_subaruhitachish72544.xml` (in
[`Imperial`](definitions/ecuflash/Imperial/read_subaruhitachish72544.xml) and `Metric`) adds a 2560k read, but
whether EcuFlash can actually read that ECU is untested. EcuFlash has no support for the RH850 ECU.

**PCMFlash** (commercial, licensed per module) is reported to read and write the 2 MB ECU with its "Subaru Hitachi"
module (module 16, [module list](https://ecutools.eu/chip-tuning/pcmflash/#subproduct-group-8037)) and to correct the
checksum when it flashes. A 2019 JDM Levorg STI 2.0 (LF9F000R) was read in full with its "Levorg 2018+ 2.0 DIT CAT
(Hitachi SH72544/2.5 MB)" module. I haven't tested PCMFlash myself.

**Writing** the 2.5 MB and RH850 ECUs isn't supported by any free tool yet: FastECU's protocols for them only read.

## Submitting a ROM

Have a ROM that isn't supported, or a complete read of one listed above as incomplete? Open a
[ROM submission](../../issues/new?template=rom_submission.yml) issue. Please send a **raw `.bin` read of a stock
ECU**, made as described in [Reading your ECU](#reading-your-ecu), not a modified tune and not a container format from a flashing tool (those can contain your VIN). Issue
attachments are public, so don't include anything you wouldn't post publicly.

## Reporting a problem

If a table looks wrong, a scaling doesn't match what you log, or something behaves differently on the car, open a
[bug report](../../issues/new?template=bug_report.yml) with the ROM ID, the table name and, ideally, a log.

## License

Copyright (C) 2026 Jengacat.

The definitions, logger files, documentation and tools in this repository are free software: you can redistribute
them and/or modify them under the terms of the GNU General Public License, version 3, as published by the Free
Software Foundation. See [LICENSE](LICENSE) for the full text. They are distributed in the hope that they will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

## Disclaimer

Modifying an engine ECU can damage the engine, void warranties, and may not be legal for road use (including
emissions rules) where you live.
These files are provided as-is, without warranty of any kind. You are responsible for what you flash to a car.
Subaru, WRX, STI, Forester, Levorg, SI-Drive and other Subaru model, trim and feature names are trademarks of Subaru
Corporation or its affiliates. Other product and company names (including Tactrix, OpenPort, EcuFlash, RomRaider,
PCMFlash, FastECU and Hitachi) are trademarks of their respective owners. This project is not affiliated with or
endorsed by any of them.

Generative AI tools were used in creating and maintaining this repository, including the analysis behind the
definitions, the documentation and the tooling. All of it remains untested on a running engine; check it against your
own logs before relying on it.
