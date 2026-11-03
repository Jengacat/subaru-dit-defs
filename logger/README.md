# Logger definitions

For RomRaider Logger over SSM.

| File | Use |
|---|---|
| `FA20DIT_Logger.xml` | Stock ROMs. Built and checked for LF75404S, LF75300H, LF79002P and LF9C100P. |
| `FA20DIT_Logger_LogPatch.xml` | ROMs with the [logging patch](../tools/logpatch/): the stock parameters plus L01–L24. Valid for all eight supported ROMs (the patch uses the same slots in each). |
| `FA20DIT_Logger_LogPatch_only.xml` | Only the logging-patch parameters, to merge into your own logger file. |

On a stock ROM, several of the most useful values (feedback knock correction, rail pressure, target boost,
combustion mode, target torque) can't be read over SSM; the logging patch adds them. Long-term fuel trim is 0.39 %
per count (older logger files showed double the real value).

The patched-ROM parameters have not yet been confirmed on a running ECU; after flashing a patched ROM, check that they
show live, changing values.
