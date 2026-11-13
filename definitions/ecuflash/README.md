# EcuFlash definitions

EcuFlash shows each table in one unit, so the definitions come in two sets with the same tables:

| Folder | Base file | Units |
|---|---|---|
| `Imperial/` | `FA20DIT_BASE_EcuFlash.xml` | psi (gauge for boost), psia, °F, ft-lb, mph |
| `Metric/` | `FA20DIT_BASE_METRIC_EcuFlash.xml` | kPa (absolute for boost and manifold pressure), MPa (rail pressure), °C, Nm, km/h |

Units both systems use (g/rev, RPM, %, AFR, degrees, g/s) are the same in both. **Install one set only:** the ROM
files in both have the same IDs, and EcuFlash would load whichever it finds first.

In each set the base file defines every table once; each ROM has a small file named by calibration ID
(`FA20DIT_<calibration ID>_EcuFlash.xml`) that gives that ROM's addresses and whatever differs. EcuFlash picks the ROM
file by the ID inside your ROM, and the ROM file pulls in the base.

**Install:** from the folder you chose, copy the base file **and** the file(s) for your ROM(s) into the same folder
under your EcuFlash metadata folder (for example `rommetadata\subaru\FA20DIT\`), then restart EcuFlash. Copying the
whole folder is fine too. Without the base file, the ROM files don't load. To switch sets later, delete the old files
first.

**Using it:**
- Table folders are numbered in tuning order (`01.02 Fueling - …`).
- EcuFlash opens at the **Beginner** user level, where most tables are greyed out. Set the level under the options
  (gear icon) → User Level: **Intermediate** or **Advanced** for normal tuning, **Developer** to see everything.
- **DTCs:** every code has its own table in each of the four classes (Enable, Circuit, Performance, Fail-Safe), named
  as in RomRaider, e.g. `(P0420) Catalyst System Efficiency Below Threshold (Bank 1)`. The value shows the state and,
  in brackets, the whole byte the code shares with up to seven others, e.g. `enabled [41]`. **To flip a code, select
  the value and press Increment ( `]` ) once.** Don't use Decrement: from "enabled" it steps to a different byte and
  would change another code. If a table shows `(no match)`, too many of the other codes in its byte have been changed
  for the list to cover; use the 103-byte mask table in the same folder instead (each row lists the code on each bit;
  bit values 1, 2, 4 … 128).
- **Checksum:** the 2015–2018 (2 MB) definitions use EcuFlash's built-in `subaruhitachi` checksum module, which
  corrects the checksum when you save. I checked it in EcuFlash 1.44.4870: the result is byte-identical to the
  checksum tool's. The 2019 Levorg STI (LF9F000R, 2.5 MB) definition has no checksum module, because that module gets
  the 2.5 MB layout wrong: fix those ROMs with the checksum tool. Either way, run `verify` on the file you're about to
  flash (see the main README).

Writing to the ECU with EcuFlash has not been tested on this ECU yet.
