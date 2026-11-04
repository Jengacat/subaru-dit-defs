# subaru-dit-defs

RomRaider and EcuFlash definitions, a logger definition and a tuning guide for Subaru's **FA20DIT** engine ECU
(Hitachi SH72543R): the 2015–2018 WRX and the 2016 Forester tS.

The definitions were built from scratch from my own analysis of the stock ROMs. No existing community definition was
used as a source, so table names, scalings and descriptions are my own. Every table carries a plain-English summary
and a description of what the ECU does with it.

Across the supported ROMs, each definition averages roughly **1,200 entries**: about 1,000 maps and curves and
about 140 single values and switches. On top of that, each has about 900 DTC enable switches. The exact count for
each ROM is in the [table below](#supported-roms).

> **Status: beta.** The definitions have been checked table by table against the ECU code and load cleanly in
> RomRaider, but **nothing has been validated on a running engine or flashed to a car yet.** Read the
> [known issues](#known-issues) before you use them, and always keep a stock read of the ECU.

## Supported ROMs

| Model | Model year | Transmission | Market | ROM (calibration ID) | Tables, scalars & switches | DTC switches | Logging patch |
|---|---|---|---|---|---|---|---|
| WRX | 2015 | 6MT | USDM | **LF75404S** | 1189 | 904 | yes |
| WRX | 2015 | 6MT | USDM | **LF75300S** | 1189 | 904 | yes |
| WRX (early software) | 2015 | 6MT | Australia | **LV9N100F** | 1123 | 888 | yes |
| WRX (early software) | 2015 | 6MT | Gulf (GCC) | **LV9N101I** | 1123 | 888 | yes |
| WRX (early software) | 2015 | 6MT | not confirmed | **LV9N101F** | 1123 | 888 | yes |
| WRX (early software) | 2015 | CVT | USDM | **LV9N101C** | 1123 | 888 | yes |
| WRX S4 (early software) | 2015 | CVT | Japan | **LV9N100B** | 1123 | 888 | yes |
| WRX S4 | 2015 | CVT | Japan | **LF75300F** | 1189 | 904 | yes |
| WRX | 2015 | CVT | Canada | **LF75200T** | 1167 | 904 | yes |
| WRX | 2015–2016 (not stated) | CVT | not confirmed | **LF75300L** | 1189 | 904 | yes |
| Forester XT (early software; briefly also the WRX CVT) — *outdated* | early 2015 | CVT | USDM | **LV9N000C** | 1123 | 888 | yes |
| WRX | 2016 | 6MT | not confirmed | **LF75300H** | 1189 | 904 | yes |
| WRX | 2016 | 6MT | Singapore | **LF75301K** | 1189 | 904 | yes |
| Forester tS (STI) | 2016 | CVT | Australia | **LF78001H** | 1198 | 908 | yes |
| WRX | 2017 | 6MT | not confirmed | **LF79002P** | 1207 | 912 | yes |
| WRX | 2017 | 6MT (later revision) | not confirmed | **LF79100P** | 1207 | 912 | yes |
| WRX | 2017 | CVT | not confirmed | **LF79100N** | 1207 | 912 | yes |
| Forester XT | 2017 | CVT | USDM | **LF78103B** | 1195 | 912 | yes |
| Forester XT | 2017 | CVT | Europe | **LF9C000C** | 1212 | 912 | yes |
| WRX | 2018 | 6MT | not confirmed | **LF9C100P** | 1212 | 912 | yes |
| WRX S4 | 2018 | CVT | Japan | **LF9C001K** | 1212 | 912 | yes |

*Outdated:* LV9N000C is an early calibration that Subaru superseded (its tune is 99.7% the same as LV9N101C's). It
is still fully supported. When you open it, RomRaider shows its "ECU Revision is Obsolete" notice ("A newer version of
this ECU revision exists"), with a link to RomRaider's general ECU revision list rather than to this repo. The notice
can be switched off with its "Always display this message" box or in RomRaider's settings ("Warn me when opening out
of date image revision"). The EcuFlash definition does not carry this flag.

The calibration ID is the ROM's identifier, stored in the ROM itself; RomRaider/EcuFlash
pick the matching definition from it automatically. A ROM with a different ID is **not supported**, even if it is the
same model year; flashing with a definition for another ID will corrupt the calibration.

### Not supported yet

| ROM | Why |
|---|---|
| LF75300G (2016 WRX CVT), LF75300T (2015 WRX CVT), LV9N101D (2015 USDM WRX), LV9N002F (2014 Australian WRX) | The only copies I have are incomplete (1.5 MB) reads. A complete read would make them supportable quickly. |
| Other 2015–2018 WRX and Forester XT calibrations (e.g. LF75403T, LF75404H, LF75403G, LF79103P, LF79102N, LF9C102P, LF9C002N, LF61803B, LF75403A, LF78106B, LF9C002B) | I don't have these ROMs. [Submit one](#submitting-a-rom) and I can add it. |
| 2019+ WRX (LF9D…, LF9G…) | These ECUs have 2.5 MB of flash and a newer boot block, and EcuFlash only reads and writes 2 MB. PCMFlash may read them in full (see [Reading your ECU](#reading-your-ecu)); an open tool for reading and writing the 2.5 MB ECUs is in the works. |
| 2022+ WRX (FA24DIT) | Different engine and ECU generation; not started. |

## What's included

| Folder | Contents |
|---|---|
| `definitions/romraider/` | `FA20DIT_RomRaider.xml`: one file covering every supported ROM. |
| `definitions/ecuflash/` | One EcuFlash definition per ROM. |
| `logger/` | `FA20DIT_Logger.xml` (stock SSM and OBD parameters, trouble codes) and `FA20DIT_Logger_LogPatch.xml` (stock plus the logging-patch parameters). `FA20DIT_Logger_LogPatch_only.xml` holds only the new parameters, for merging into your own logger file. |
| `tools/checksum.py`, `tools/checksum.ps1` | Check and fix the ROM checksum (Python, or PowerShell for Windows). **Required before flashing an edited ROM** (see below). |
| `tools/logpatch/` | The logging patch: `make_logpatch.py` and one spec per supported ROM. |
| `docs/guide/` | [The tuning guide](docs/guide/README.md): workflows, how the logic works, appendices and a table reference. |
| `extras/can/` | A DBC file of the ECU's CAN messages, for passive logging with a CAN interface. |

## Quick start

### Editing with RomRaider
1. Add `definitions/romraider/FA20DIT_RomRaider.xml` in RomRaider's Definition Manager.
2. Open your ROM. Tables are grouped by purpose (Fueling, Ignition Timing, Boost Control, …) in tuning order.
3. Set the user level (Settings → User Level) to match what you want to see: **Beginner** and **Intermediate** cover
   normal tuning; **Debug** shows tables that are off in stock, unused, or only used by the other transmission. Also
   untick "List tables that are above my userlevel" if you want higher-level tables hidden rather than greyed out.

### Editing with EcuFlash
Copy the file for your ROM from `definitions/ecuflash/` into your EcuFlash metadata folder (for example
`rommetadata/subaru/`) and restart EcuFlash. Table folders are numbered in tuning order (`01.02 Fueling - …`).

### Fix the checksum before every flash

This ECU checks a 16-bit checksum over the whole flash, and a ROM with a bad checksum won't run. **EcuFlash may
correct it** when it writes the ROM, but that hasn't been confirmed for this ECU. **RomRaider can't correct it yet**:
RomRaider 1.0.0 and 1.1.0 can't load a checksum module from a definition folder, so the definition can't include one
until my fix
([RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248)) is merged and released. Until then, run every edited ROM through the checksum
tool and confirm it with `verify` before flashing:

```
python3 tools/checksum.py fix  edited.bin  edited_fixed.bin
python3 tools/checksum.py verify  edited_fixed.bin
```

On Windows without Python, use the PowerShell version (Windows PowerShell 5.1 or later, nothing to install):

```
powershell -ExecutionPolicy Bypass -File tools\checksum.ps1 fix  edited.bin  edited_fixed.bin
powershell -ExecutionPolicy Bypass -File tools\checksum.ps1 verify  edited_fixed.bin
```

Every line of `verify` must say OK. A ROM with a bad checksum sets P0605 or is refused by the ECU. The Python tool
needs only Python 3 (no extra packages).

### Logging

`logger/FA20DIT_Logger.xml` works with any supported ROM in RomRaider Logger. Over SSM it has 46 parameters and
shows pending and stored trouble codes in the DTC tab. Switch the logger protocol to OBD for 32 standard OBD-II
parameters, including actual fuel rail pressure. On a stock ROM some of the most useful values (feedback knock
correction, target boost, target torque, combustion mode, the rail-pressure target) can't be read with RomRaider at
all. The **logging patch** fixes that. See the [logger README](logger/README.md).

### The logging patch

The patch points 41 unused entries of the ECU's SSM parameter table at RAM values worth logging, adding 24 parameters:
target and throttle torque, base timing, FBKC / FLKC / KCA / total knock correction, combustion mode, rail pressure
actual and target, target boost, boost pressure, wastegate duty and feedback, closed-loop target, A/F correction and
learning, throttle-model values, the throttle target, cam targets and injector pulse. Nothing else in the ROM changes,
and the checksum is fixed for you. Patch your own (stock or tuned) ROM with the spec for its calibration ID:

```
python3 tools/logpatch/make_logpatch.py tools/logpatch/specs/logpatch_LF75404S.json your_rom.bin your_rom_logpatch.bin
```

The tool refuses a ROM of another calibration ID, a ROM whose checksum is already bad, and any slot that is not
unused. Then log with `logger/FA20DIT_Logger_LogPatch.xml` (parameters L01–L24). The patch uses the same slots on
every supported ROM, so one logger file covers all of them.

## Units

The definitions default to: engine load in **g/rev** (% available as an alternate scale; 100 % = 1.293 g/rev), torque in
**ft-lb** (Nm alternate), boost in **psi gauge**, manifold pressure in psia, rail pressure in **psi** (MPa alternate),
temperatures in **°F** (°C alternate), AFR (λ alternate), timing in degrees BTDC, injector size as flow in g/s.
Switch scales from the table's View menu in RomRaider.

## Known issues

- **Untested on hardware.** No ROM edited with these definitions has been flashed and driven yet. Start from a known
  good stock read, change little at a time and log everything.
- **Checksum.** EcuFlash may correct this ECU's checksum, but that isn't confirmed. RomRaider can't load a
  checksum module from a definition folder in versions 1.0.0 and 1.1.0; my fix is in
  [RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248), and once it is merged and released the RomRaider definition will correct the
  checksum on save. Until then, use `tools/checksum.py` or `tools/checksum.ps1` (above) on every edited ROM.
- **Writing with EcuFlash** has not been tested on this ECU.
- **Inferred items.** Everything is decoded from the ECU code; where the code doesn't settle a meaning, the description
  says "inferred". In particular, the **SI-Drive positions** of the drive-mode maps (mode 4 = Sport Sharp, 2 = Sport,
  3 = Intelligent, 1 = default) are inferred from the stock maps.
- **Hard limits in the code** that no table changes: manifold pressure reads at most 256 kPa absolute (about 22.4 psi
  boost at sea level); the overboost cut can't trigger above about 236 kPa absolute; engine load is clamped at
  3.31 g/rev. See the guide's [hard limits chapter](docs/guide/C11.md).
- **Partial ports.** LF78001H and the LV9N images have fewer tables than the WRX images; tables I could not place with
  confidence are left out rather than guessed.

## Reading your ECU

Use EcuFlash with the **larger, 2 MB** read setting. A smaller read stops partway through the flash and is not usable:
a complete read of a 2015–2018 ECU is exactly **2,097,152 bytes**. Keep that stock read somewhere safe before you
change anything.

EcuFlash may not show the calibration ID if it has no definition for the ROM yet. That's fine: the ID is inside the
file (open it with these definitions, or submit it as below and I'll identify it).

**PCMFlash** (commercial, licensed per module) is another option for reading and writing. I haven't tested it on
these ECUs myself, so treat it as an alternative to EcuFlash rather than a recommendation.

The 2019 and later WRX ECUs (and presumably other DIT cars) have 2.5 MB of flash, which EcuFlash can't read in full. A
2 MB read of one of those is incomplete. PCMFlash may be able to read them: a 2019 JDM Levorg STI 2.0 (LF9F000R) on
the RomRaider forum was read in full (2,621,440 bytes, valid checksum) with PCMFlash's "Levorg 2018+ 2.0 DIT CAT
(Hitachi SH72544/2.5 MB)" module and a Tactrix OpenPort 2.0. Whether that module also covers the 2019+ WRX isn't
confirmed. I'm still building an open tool for reading and writing the 2.5 MB ECUs.

## Submitting a ROM

Have a ROM that isn't supported, or a complete read of one listed above as incomplete? Open a
[ROM submission](../../issues/new?template=rom_submission.yml) issue. Please send a **raw `.bin` read of a stock
ECU**, made as described in [Reading your ECU](#reading-your-ecu), not a modified tune and not a container format from a flashing tool (those can contain your VIN). Issue
attachments are public, so don't include anything you wouldn't post publicly.

## Reporting a problem

If a table looks wrong, a scaling doesn't match what you log, or something behaves differently on the car, open a
[bug report](../../issues/new?template=bug_report.yml) with the ROM ID, the table name and, ideally, a log.

## Disclaimer

Modifying an engine ECU can damage the engine, void warranties, and may not be legal for road use where you live.
These files are provided as-is, without warranty of any kind. You are responsible for what you flash to a car.
Subaru, WRX, Forester, SI-Drive and STI are trademarks of Subaru Corporation; this project is not affiliated with or
endorsed by Subaru.

Generative AI tools were used in creating and maintaining this repository, including the analysis behind the
definitions, the documentation and the tooling. All of it remains untested on a running engine; check it against your
own logs before relying on it.
