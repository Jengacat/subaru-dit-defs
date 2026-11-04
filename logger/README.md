# Logger definitions

For RomRaider Logger over CAN (Tactrix OpenPort 2.0 or another J2534 interface).

| File | Use |
|---|---|
| `FA20DIT_Logger.xml` | Stock ROMs (all supported). SSM: 46 parameters plus trouble codes for the DTC tab. OBD: 32 standard OBD-II parameters. |
| `FA20DIT_Logger_LogPatch.xml` | ROMs with the [logging patch](../tools/logpatch/): everything in the stock file plus L01–L24. Valid for every supported ROM (the patch uses the same slots in each). |
| `FA20DIT_Logger_LogPatch_only.xml` | Only the logging-patch parameters, to merge into your own logger file. |

## What a stock ROM gives you

RomRaider logs one protocol at a time; pick it under Settings → Logger Protocol.

* **SSM (the default):** 46 parameters (J01–J46), including the ECU's own A/F sensor lambda, injector pulse width,
  fan, purge and alternator duty, EGR valve position and the AVCS solenoid currents.
* **DTC tab (SSM):** 156 trouble codes, each shown as pending (failed this drive) or stored. The ECU keeps the
  rest where SSM can't reach them, so a scan tool is still the complete check.
* **OBD:** 32 standard OBD-II parameters. This is the only way to see **actual fuel rail pressure** (PID 0x23) on a
  stock ROM, and it also gives the commanded lambda (PID 0x44) and oil temperature. OBD polling is slower than SSM.

Not reachable on a stock ROM with RomRaider: feedback/fine knock correction, target boost, target torque, combustion
mode and the rail-pressure target. The [logging patch](../tools/logpatch/) adds them over SSM. (The ECU does report
the rail target in OBD PID 0x6D, but that reply is longer than RomRaider can read, so it isn't in the file.)

Long-term fuel trim is 0.39 % per count (older logger files showed double the real value).

## Status

None of this has been run against a car yet. The files are parsed and every conversion evaluated with RomRaider's own
logger code. If a parameter sits at a constant or reads nonsense on your car, please
[report it](../../../issues/new?template=bug_report.yml). On a patched ROM, check that the L parameters show live,
changing values.
