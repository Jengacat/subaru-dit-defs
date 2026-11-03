# Logging patch

`make_logpatch.py` points 41 unused entries of the ECU's SSM parameter table at RAM values worth logging, adding 24
parameters (L01–L24): target and throttle torque, base timing, FBKC / FLKC / KCA / total knock correction, combustion
mode, rail pressure actual and target, target boost, boost pressure, wastegate duty and feedback, closed-loop target,
A/F correction and learning, throttle-model values, the throttle target, cam targets and injector pulse.

```
python3 make_logpatch.py specs/logpatch_<calibration ID>.json your_rom.bin your_rom_logpatch.bin
python3 make_logpatch.py --verify specs/logpatch_<calibration ID>.json your_rom.bin your_rom_logpatch.bin
```

It works on a stock or tuned ROM, as long as the calibration ID matches the spec. Only the 41 table entries and the
checksum correction word change, and the checksum is fixed for you. The tool refuses to patch if:

- the ROM is not 2 MB, or its calibration ID doesn't match the spec;
- the ROM's checksum is already bad (fix it first with `../checksum.py`);
- any slot to patch is already in use.

Log with [`FA20DIT_Logger_LogPatch.xml`](../../logger/). `specs/` holds one spec per supported ROM; the slots are the
same in all of them. Not yet confirmed on a running ECU.
