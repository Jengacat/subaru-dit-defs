# Tools

| Tool | What it does |
|---|---|
| `checksum.py` | Verify or fix the ROM checksum. Python 3, no extra packages. |
| `checksum.ps1` | The same in PowerShell, for Windows without Python (Windows PowerShell 5.1 or later). |
| [`logpatch/`](logpatch/) | The logging patch: adds 24 loggable parameters to a ROM. |

## Checksum

The ECU requires the 16-bit sum of all big-endian words from 0x6000 to the end of flash to equal 0x5AA5; the word at
0x1FFFFE is the correction word. `fix` rewrites only that word; `verify` also checks the validity markers.

```
python3 checksum.py fix  edited.bin  edited_fixed.bin
python3 checksum.py verify  edited_fixed.bin
```

```
powershell -ExecutionPolicy Bypass -File checksum.ps1 fix  edited.bin  edited_fixed.bin
powershell -ExecutionPolicy Bypass -File checksum.ps1 verify  edited_fixed.bin
```

Without an output file, `fix` overwrites the input. Every line of `verify` must say OK before you flash.
