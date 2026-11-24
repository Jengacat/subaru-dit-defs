# Tools

| Tool | What it does |
|---|---|
| `checksum.py` | Verify or fix the ROM checksum, for 2 MB (2015–2018), 2.5 MB (2019–2021) and 4032 KB (2022+ WRX) ROMs. Python 3, no extra packages. |
| `checksum.ps1` | The same in PowerShell, for Windows without Python (Windows PowerShell 5.1 or later). |
| `ef_view.py`, `ef_view.ps1` | 2022+ WRX only: the 3 MB copy of a ROM that EcuFlash can open, and merging the edited copy back (checksum fixed). |
| [`logpatch/`](logpatch/) | The logging patch: adds 24 loggable parameters to a ROM (Python or PowerShell 5.1). |

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

**2022+ WRX (RH850).** The tool picks this rule by the file size (4,128,768 bytes): the 16-bit sum of all
little-endian words of the whole file must be 0x5AA5, and `fix` rewrites the word at file offset 0x3EFF7E (address
0x3FFF7E). That word is the one that differs between otherwise identical builds; that it is the one the ECU expects
to change is inferred. A 4 MB file (boot block in front) is refused: remove its first 65,536 bytes.

## EcuFlash view copies (2022+ WRX)

```
python3 ef_view.py view  stock.bin  stock_view.bin
python3 ef_view.py merge stock.bin  stock_view.bin  edited.bin
```

`view` writes the first 3 MB, which EcuFlash opens with the `FA24DIT` definitions (FastECU needs no copy). `merge` puts the edited copy
back in front of the rest of the original, fixes the checksum and lists the changed ranges; it refuses a copy that
wasn't made from that image. `ef_view.ps1` does the same on Windows (PowerShell 5.1 or later).
