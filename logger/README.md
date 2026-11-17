# Logger definitions

For RomRaider Logger over CAN (Tactrix OpenPort 2.0 or another J2534 interface).

| File | Use |
|---|---|
| `FA20DIT_Logger.xml` | Stock ROMs (all supported). SSM: 46 parameters plus trouble codes for the DTC tab. OBD: 32 standard OBD-II parameters. |
| `FA20DIT_Logger_LogPatch.xml` | ROMs with the [logging patch](../tools/logpatch/): everything in the stock file plus L01–L24. Valid for every supported ROM (the patch uses the same slots in each). |
| `FA20DIT_Logger_LogPatch_only.xml` | Only the logging-patch parameters, to merge into your own logger file. |
| `FA24DIT_Logger.xml`, `FA24DIT_Logger_LogPatch.xml`, `FA24DIT_Logger_LogPatch_only.xml` | The same three for the Ascent (FA24DIT). See [Ascent](#ascent) below. |

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

## Ascent

The Ascent's ECU answers SSM the same way as the WRX's, so the stock parameters carry over, with three differences:

* **Wastegate duty (J10) is left out.** The Ascent drives an electric wastegate. Its SSM slot still shows the WRX
  wastegate duty, which nothing in the Ascent uses.
* **DTC tab:** 155 codes. 148 positions hold the same code as on the WRX; at four of them the Ascent has another code
  (P226B, P24B9, P24BA, P24BB, as on the 2019+ WRX), four positions are empty and three Ascent codes are added
  (P0140, P2008, P2011). P0125 is only on the 2021 ROM.
* **Logging patch (`FA24DIT_Logger_LogPatch.xml`):** L01–L24 except L13 and L14 (WRX wastegate duty and feedback).
  Target Boost (L11) and Boost Control Pressure (L12) are the electric wastegate control's own target and measured
  pressure. New on the Ascent:

  | ID | Parameter | Unit |
  |---|---|---|
  | L25 | Wastegate Motor Duty (positive opens, negative closes) | % |
  | L26 | Wastegate Position | % open (0 % = seated) |
  | L27 | Wastegate Position Command | % open |
  | L28 | Boost Error (target minus actual; positive = below target) | psi, kPa |
  | L29 | Target Boost (Table), before the IAT and rpm/baro multipliers and the cap | psi, kPa abs |
  | L30 | Wastegate Control Mode: 0 open (low rpm), 1 feed-forward only, 2 closed loop, 3 closed, 4 engine not running (inferred), 5 fixed position, 6 sweep | mode |
  | L31 | Wastegate Position Sensor Voltage | V |
  | L32 | Wastegate Position Feed-Forward | % open |

  The % open scale takes 32768 as fully open. That full-open point is my inference; the raw value is offered too.

OBD is unchanged: the Ascent answers the same OBD-II parameters.

## Coming: logging without the patch

A new RomRaider logger protocol, **SUBUDS**, will read the L parameters (and more) on a stock ROM, without the logging
patch. [My fork of RomRaider](https://github.com/Jengacat/RomRaider/tree/Subaru-UDS-Logging) already has it; the logger
file for it will be added here with a test build. See the
[main README](../README.md#in-progress-logging-without-a-patch-subaru-uds-in-romraider).

## Status

None of this has been run against a car yet. The files are parsed and every conversion evaluated with RomRaider's own
logger code. If a parameter sits at a constant or reads nonsense on your car, please
[report it](../../../issues/new?template=bug_report.yml). On a patched ROM, check that the L parameters show live,
changing values.
