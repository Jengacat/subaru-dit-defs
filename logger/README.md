# Logger definitions

For RomRaider Logger over CAN (Tactrix OpenPort 2.0 or another J2534 interface).

| File | Use |
|---|---|
| `FA20DIT_Logger.xml` | Stock ROMs (all supported). SSM: 46 parameters plus trouble codes for the DTC tab. OBD: 32 standard OBD-II parameters. |
| `FA20DIT_Logger_LogPatch.xml` | ROMs with the [logging patch](../tools/logpatch/): everything in the stock file plus L01–L24. Valid for every supported ROM (the patch uses the same slots in each). |
| `FA20DIT_Logger_LogPatch_only.xml` | Only the logging-patch parameters, to merge into your own logger file. |
| `FA24DIT_Logger.xml`, `FA24DIT_Logger_LogPatch.xml`, `FA24DIT_Logger_LogPatch_only.xml` | The same three for the Ascent (FA24DIT). See [Ascent](#ascent) below. |
| `FA20DIT_Logger_SUBUDS.xml`, `FA24DIT_Logger_SUBUDS.xml` | **Stock ROMs, no patch:** every parameter above, read straight from RAM with the SUBUDS protocol. Needs a RomRaider build with SUBUDS. See [Logging without the patch](#logging-without-the-patch-subuds). |

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

## Logging without the patch (SUBUDS)

**SUBUDS** is a RomRaider logger protocol I wrote that reads values straight from the ECU's RAM, so a stock ROM gives
you everything the logging patch adds without a reflash. It uses standard diagnostic services the ECU allows without
any security unlock: it opens the extended diagnostic session (0x10 0x03), tells the ECU which RAM addresses to
collect (0x2C, define by memory address) and then reads them all in one request per logging pass (0x22).

**What you need:**

* A RomRaider build with the SUBUDS protocol. Stock RomRaider 1.1.0 doesn't have it. It's on the
  `Subaru-UDS-Logging` branch of [my RomRaider fork](https://github.com/Jengacat/RomRaider/tree/Subaru-UDS-Logging);
  Windows and Linux builds are on the fork's
  [subuds-test-1 release](https://github.com/Jengacat/RomRaider/releases/tag/subuds-test-1).
* A J2534 cable (Tactrix OpenPort 2.0 or similar), as for SSM over CAN.
* `FA20DIT_Logger_SUBUDS.xml` (WRX, WRX S4, Levorg, Forester XT, Legacy / Outback and the Levorg 1.6), or
  `FA24DIT_Logger_SUBUDS.xml` (Ascent).

**How to use it:** load the SUBUDS file as the logger definition, choose **SUBUDS** under Settings → Logger
Protocol, and connect. RomRaider reads the ECU ID first and picks that ROM's RAM addresses; the parameters then
work like any other.

**What's in the files:**

| File | Parameters | ROMs |
|---|---|---|
| `FA20DIT_Logger_SUBUDS.xml` | 70: the 46 stock parameters (J01–J46) and the 24 logging-patch ones (L01–L24) | all 100 supported 2.0 and 1.6 ROMs, 24 RAM layouts |
| `FA24DIT_Logger_SUBUDS.xml` | 75: 45 stock (wastegate duty J10 left out, as in the Ascent SSM file) and 30 logging-patch ones (L01–L12, L15–L32) | the three Ascent ROMs |

The names, conversions and IDs match the SSM files, so a log from either protocol reads the same.

**How I checked it:** RAM addresses differ between ROMs, so every address was checked in an emulator running each ROM's own
code. The byte the SUBUDS read returns had to match the byte the ECU's own SSM read returns for the same parameter,
on the stock and on the patched ROM: 103 ROMs, no mismatch. RomRaider's own definition parser resolves every
parameter for every ECU ID in the files, and an ECU ID that isn't in the file gets no addresses (nothing is guessed).

**Limits:**

* **Not yet run on a car.** If you try it, please [open an issue](../../../issues/new/choose) and say how it went
  (cable, ROM, whether values move).
* RAM only. The protocol doesn't read flash and doesn't unlock security.
* One protocol at a time, as with SSM and OBD: the DTC tab and OBD parameters need their own files.
* An ECU your file doesn't list (an unsupported calibration) connects, but its parameters stay unavailable.

## Status

None of this has been run against a car yet. The files are parsed and every conversion evaluated with RomRaider's own
logger code. If a parameter sits at a constant or reads nonsense on your car, please
[report it](../../../issues/new?template=bug_report.yml). On a patched ROM, check that the L parameters show live,
changing values.
