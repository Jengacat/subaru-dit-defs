# EcuFlash definitions

EcuFlash shows each table in one unit, so the definitions come in two sets with the same tables:

| Folder | Base file | Units |
|---|---|---|
| `Imperial/` | `FA20DIT_BASE_EcuFlash.xml` (plus `FA24_Early_BASE_EcuFlash.xml` for the Ascent / Legacy XT), `FB16DIT_BASE_EcuFlash.xml` (Levorg 1.6), `FA24DIT_BASE_EcuFlash.xml` (2022+ WRX) | psi (gauge for boost), psia, °F, ft-lb, mph |
| `Metric/` | `FA20DIT_BASE_METRIC_EcuFlash.xml` (plus `FA24_Early_BASE_METRIC_EcuFlash.xml`), `FB16DIT_BASE_METRIC_EcuFlash.xml` (Levorg 1.6), `FA24DIT_BASE_METRIC_EcuFlash.xml` (2022+ WRX) | kPa (absolute for boost and manifold pressure), MPa (rail pressure), °C, Nm, km/h |

**Ascent and Legacy / Outback XT (FA24 Early):** their ROM files (`FA24_Early_LT8…`, `FA24_Early_LG7…`) include
`FA24_Early_BASE_EcuFlash.xml`, which includes `FA20DIT_BASE_EcuFlash.xml`: install both base files. EcuFlash and
FastECU both handle this.

**FastECU** reads these EcuFlash files too, and shows the same values as EcuFlash. On the 2019+ (2.5 MB) ROMs the flash method is
FastECU's 2.5 MB protocol (`sub_ecu_hitachi_sh72544r_can_2_5mb`), so FastECU picks it and corrects the checksum on
save (its current source); EcuFlash shows that name under ROM Info and otherwise works as before.

Units both systems use (g/rev, RPM, %, AFR, degrees, g/s) are the same in both. **Install one set only:** the ROM
files in both have the same IDs, and EcuFlash would load whichever it finds first.

In each set a base file defines every table once (one base for the 2.0 ROMs, one for the Levorg 1.6 ROMs, one for the
2022+ WRX, and `FA24_Early_BASE` adding the Ascent's differences to the 2.0 base); each ROM has a small file named by
calibration ID (`FA20DIT_<calibration ID>_EcuFlash.xml`, `FB16DIT_…`, `FA24_Early_…` or `FA24DIT_…`) that gives that
ROM's addresses and whatever differs. EcuFlash picks the ROM
file by the ID inside your ROM, and the ROM file pulls in the base.

**Install:** from the folder you chose, copy the base file for your engine **and** the file(s) for your ROM(s) into the same folder
under your EcuFlash metadata folder (for example `rommetadata\subaru\FA20DIT\`), then restart EcuFlash. Copying the
whole folder is fine too. Without the base file, the ROM files don't load. To switch sets later, delete the old files
first.

**Using it:**
- Table folders are numbered in tuning order (`01.02 Fueling - …`).
- User level, under the options (gear icon) → User Level: **Beginner** shows the core tables (fueling, timing,
  boost, requested torque, rev limits, throttle maps), **Intermediate** and **Advanced** add more, and **Developer**
  shows everything, including the debug-level tables. Tables above your level are greyed out.
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
- **Checksum:** EcuFlash corrects the checksum when you save a 2015–2018 (2 MB) ROM. It can't for the 2019+ (2.5 MB)
  ROMs: fix those with the checksum tool, or edit them in FastECU, which corrects it. Either way, run `verify` on the file you're about to
  flash (see the main README).

Writing to the ECU with EcuFlash has not been tested on this ECU yet.

## 2022+ WRX (FA24DIT files): made for FastECU

`FA24DIT_BASE_EcuFlash.xml` (Metric: `FA24DIT_BASE_METRIC_EcuFlash.xml`) plus `FA24DIT_<calibration ID>_EcuFlash.xml`
for each supported 2022+ WRX ROM (the list is in the main README).

**As they are, these files are only fully compatible with FastECU.** FastECU opens the full 4032 KB image with them
(set its EcuFlash definitions folder to `Imperial/` or `Metric/`), and built from its current source (not a release yet) it also corrects the checksum on save
([miikasyvanen/FastECU#166](https://github.com/miikasyvanen/FastECU/pull/166)).
EcuFlash itself can't load the right memory model: it only opens a ROM through one of its built-in models, and none is
the size of these images (the full image gives "Unknown ROM Image"). The files name its 3 MB model
**Generic3072K**, so EcuFlash can open a copy of the first 3 MB; every table is in the first 1 MB, so the copy shows
the whole calibration. To edit in EcuFlash anyway (tested in 1.44.4870), install the files as above (for example under
`rommetadata\subaru\FA24DIT\`) and:

1. `python3 tools/ef_view.py view stock.bin stock_view.bin` (or `tools\ef_view.ps1` with the same arguments).
2. Open `stock_view.bin` in EcuFlash, edit, save.
3. `python3 tools/ef_view.py merge stock.bin stock_view.bin edited.bin`: writes the full 4032 KB image with the
   checksum corrected, and refuses a copy made from a different image.

**Never flash the view copy.** The files have no checksum module; the merge step does that job. DTCs show one table
per code (enabled or disabled); flip one with Increment ( `]` ) as above. FastECU reads these same files and opens the
full image without a copy (see the [2022+ WRX guide](../../docs/WRX_2022plus.md)).
