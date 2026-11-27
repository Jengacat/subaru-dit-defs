# 2022+ WRX (FA24DIT, RH850 ECU): what's different

The 2022+ WRX has a new ECU generation (a Renesas RH850/E1M-S2 with new software), so every tool works a little
differently on it. The 2023+ Ascent and Legacy / Outback XT have the same ECU and the same software line, and
everything here applies to their ROMs too. Read this before you start; the supported ROMs are listed in the
[main README](../README.md#rom-lists).

- **ROM files.** The definitions use a 4032 KB image (the flash without its 64 KB boot block). A 4 MB image works
  once its first 65,536 bytes are removed; the checksum tool tells you if you have one.
- **Checksum.** A different rule from the other ECUs, which `tools/checksum.py` and `checksum.ps1` handle (same
  commands as in [Fix the checksum before every flash](../README.md#fix-the-checksum-before-every-flash)). Not yet proven on a car.
- **RomRaider.** `FA24DIT_RomRaider.xml` (keep its `checksum/` folder next to it) corrects the sum when you save.
  It needs [RomRaider 1.1.1](https://github.com/RomRaider/RomRaider/releases) or later, which can load a checksum
  module from the definition folder (my change, [RomRaider pull request #248](https://github.com/RomRaider/RomRaider/pull/248));
  RomRaider 1.0.0 and 1.1.0 can't open the ROMs with it.
- **FastECU, or EcuFlash with a copy.** The EcuFlash-format files (`FA24DIT_*_EcuFlash.xml`) are made for
  **FastECU**, which opens the full image with them (see FastECU below). EcuFlash itself (1.44) can't load the right memory model
  for these ROMs: none of its built-in models is the size of these images, so it only opens a 3 MB copy (every table
  is in the first 1 MB). To use EcuFlash anyway, make the copy, edit and save it, then merge it back; the merge fixes
  the checksum:

  ```
  python3 tools/ef_view.py view  stock.bin  stock_view.bin
  python3 tools/ef_view.py merge stock.bin  stock_view.bin  edited.bin
  ```

  (`powershell -ExecutionPolicy Bypass -File tools\ef_view.ps1 …` on Windows, same arguments.) **Never flash the
  view copy**: it lacks the end of the image. Install the base file and your ROM's file as for the other ECUs
  (`FA24DIT_BASE_EcuFlash.xml`, or `FA24DIT_BASE_METRIC_EcuFlash.xml`, plus `FA24DIT_<calibration ID>_EcuFlash.xml`).
- **FastECU** reads the EcuFlash files and opens the full image directly, no copy needed. Its checksum module for
  this ECU is in FastECU's current source (merged in
  [miikasyvanen/FastECU#166](https://github.com/miikasyvanen/FastECU/pull/166), not in a FastECU release yet): with the vehicle set to "WRX 2.4 DIT (VB)" it corrects the sum on save. Otherwise use the
  checksum tool.
- **The three tools agree:** the same edit saved in RomRaider, FastECU and EcuFlash gives the same file as the
  checksum tool. Whether the ECU accepts it is not yet tested.
- **DTCs** have one switch per code (enabled or not): this ECU has no separate fail-safe bit per code.
- **Drive modes.** Tables marked Drive Mode 1–4 follow the SI-Drive mode the ECU receives over CAN (1 Default,
  2 Sport, 3 Intelligent, 4 Sport Sharp; the names of 2–4 are inferred from the older platform). The manual ROMs
  carry maps for every mode, but the manual car probably stays in mode 1 (inferred), so edit mode 1 there.
- **Reading and writing the ECU:** nothing in this repository does either, and I haven't tested a tool for it.
