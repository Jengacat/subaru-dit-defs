# EcuFlash definitions

EcuFlash shows each table in one unit, so the definitions come in two sets with the same tables:

| Folder | Base file | Units |
|---|---|---|
| `Imperial/` | `FA20DIT_BASE_EcuFlash.xml`, `FB16DIT_BASE_EcuFlash.xml` (Levorg 1.6) | psi (gauge for boost), psia, °F, ft-lb, mph |
| `Metric/` | `FA20DIT_BASE_METRIC_EcuFlash.xml`, `FB16DIT_BASE_METRIC_EcuFlash.xml` (Levorg 1.6) | kPa (absolute for boost and manifold pressure), MPa (rail pressure), °C, Nm, km/h |

Units both systems use (g/rev, RPM, %, AFR, degrees, g/s) are the same in both. **Install one set only:** the ROM
files in both have the same IDs, and EcuFlash would load whichever it finds first.

In each set a base file defines every table once (one base for the 2.0 ROMs, one for the Levorg 1.6 ROMs); each ROM
has a small file named by calibration ID (`FA20DIT_<calibration ID>_EcuFlash.xml` or
`FB16DIT_<calibration ID>_EcuFlash.xml`) that gives that ROM's addresses and whatever differs. EcuFlash picks the ROM
file by the ID inside your ROM, and the ROM file pulls in the base.

**Install:** from the folder you chose, copy the base file for your engine **and** the file(s) for your ROM(s) into the same folder
under your EcuFlash metadata folder (for example `rommetadata\subaru\FA20DIT\`), then restart EcuFlash. Copying the
whole folder is fine too. Without the base file, the ROM files don't load. To switch sets later, delete the old files
first.

**Using it:**
- Table folders are numbered in tuning order (`01.02 Fueling - …`).
- EcuFlash opens at the **Beginner** user level, where most tables are greyed out. Set the level under the options
  (gear icon) → User Level: **Intermediate** or **Advanced** for normal tuning, **Developer** to see everything.
- **DTCs:** folder `11.03 Diagnostics & Switches - DTC Switches`, in code order. Every code has two tables next to
  each other: `(P0420) Catalyst System Efficiency Below Threshold (Bank 1)` (enabled or disabled) and the same name
  with `[Fail-Safe]` (whether a failed test of this code triggers fail-safe). EcuFlash can't show both in one table,
  as RomRaider does, because the two bits are in different parts of the ROM. The value shows the state and,
  in brackets, the whole byte the code shares with up to seven others, e.g. `enabled [41]`. **To flip a code, select
  the value and press Increment ( `]` ) once.** Don't use Decrement: from "enabled" it steps to a different byte and
  would change another code. If a table shows `(no match)`, too many of the other codes in its byte have been changed
  for the list to cover; use the 103-byte mask table in the same folder instead (each row lists the code on each bit;
  bit values 1, 2, 4 … 128).
- **Calibration switches:** folder `11.02 Diagnostics & Switches - Calibration Switches` (EGR Enable, the
  transmission coding and the rest). Each shows **on** or **off**; to flip one, select the value and press
  Increment ( `]` ). Most switches have their byte to themselves. Where a byte holds several (EGR Enable, for
  example), the value also shows the whole byte in brackets, `on [20]`, and the DTC rule applies: Increment once,
  no Decrement. The byte's other bits belong to other functions and are left as the ROM has them.
- **Checksum:** the 2015–2018 (2 MB) definitions use EcuFlash's built-in `subaruhitachi` checksum module, which
  corrects the checksum when you save. I checked it in EcuFlash 1.44.4870: the result is byte-identical to the
  checksum tool's. The 2.5 MB definitions (2019 Levorg STI LF9F000R and the 2019–2020 Levorg 1.6 ROMs) have no checksum module, because that module gets
  the 2.5 MB layout wrong: fix those ROMs with the checksum tool. Either way, run `verify` on the file you're about to
  flash (see the main README).

Writing to the ECU with EcuFlash has not been tested on this ECU yet.
