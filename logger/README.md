# Logger definitions

Files for **RomRaider Logger**, to log your car over the OBD port with a J2534 cable (Tactrix OpenPort 2.0 or
similar). They cover every ROM this repo supports: WRX and WRX S4, Levorg 2.0 and 1.6, Forester XT, Legacy / Outback
and Ascent.

## Which file do I use?

| Your car | Your ROM | Use |
|---|---|---|
| Any model except the Ascent | stock or tuned, no logging patch | `FA20DIT_Logger.xml` |
| Any model except the Ascent | with the [logging patch](../tools/logpatch/) | `FA20DIT_Logger_LogPatch.xml` |
| Ascent | stock or tuned, no logging patch | `FA24DIT_Logger.xml` |
| Ascent | with the logging patch | `FA24DIT_Logger_LogPatch.xml` |
| Any model, Ascent included | any, **no patch needed** | `DIT_Logger_SUBUDS.xml`, with a RomRaider build that has the SUBUDS protocol ([below](#logging-without-the-patch-subuds)) |

The `..._LogPatch_only.xml` files hold only the extra logging-patch parameters, if you want to add them to a logger
file of your own.

In RomRaider, load the file under Settings → Logger Definition Location, and pick the protocol (SSM, OBD or SUBUDS)
under Settings → Logger Protocol. RomRaider logs one protocol at a time.

## What you can log

### On a stock ROM (SSM and OBD)

* **SSM** (the default): 46 parameters. Besides the basics (rpm, load, boost, timing, temperatures, A/F), these
  include DAM, the A/F sensor reading, injector pulse width, fan, purge and alternator duty, EGR valve position and the
  cam-timing solenoid currents.
* **DTC tab**: about 155 trouble codes, each shown as pending (failed this drive) or stored. A few codes can't be read
  this way, so a scan tool is still the complete check.
* **OBD**: 32 standard OBD-II parameters. This is the only stock way to see **actual fuel rail pressure**, and it also
  gives the commanded A/F and oil temperature. OBD updates more slowly than SSM.

What a stock ROM can't give you over SSM or OBD: feedback and fine knock correction, target boost, target torque,
combustion mode and target rail pressure. For those, use either the logging patch or SUBUDS.

### With the logging patch

The [logging patch](../tools/logpatch/) is a small edit to your ROM (stock or tuned) that makes those hidden values
readable over normal SSM. It adds 24 parameters (L01–L24):

* **Torque:** target torque, throttle torque request
* **Timing and knock:** base timing, feedback knock correction, fine learning knock correction, knock correction
  advance, total knock correction
* **Fuel:** combustion mode, actual and target rail pressure, closed-loop target, A/F correction and learning,
  injector pulse width
* **Boost:** target boost, boost pressure, wastegate duty and its feedback
* **Throttle and cams:** throttle-model values, throttle target, intake and exhaust cam targets

Nothing else in the ROM changes, and the patch fixes the checksum for you.

### Ascent differences

The Ascent's ECU works the same way, so most of the above carries over. The differences:

* **Wastegate duty is left out** of the stock file. The Ascent has an electric wastegate, and that slot shows a WRX
  value nothing in the Ascent uses.
* **Trouble codes** are the Ascent's own: most match the WRX, a handful are different or Ascent-only.
* **Logging patch:** the two WRX wastegate parameters (L13, L14) are dropped. Target boost and boost pressure are the
  Ascent's own, and eight parameters are added for the electric wastegate:

  | ID | Parameter | Unit |
  |---|---|---|
  | L25 | Wastegate motor duty (positive opens, negative closes) | % |
  | L26 | Wastegate position | % open |
  | L27 | Wastegate position command | % open |
  | L28 | Boost error (target minus actual; positive = under target) | psi, kPa |
  | L29 | Target boost from the table, before temperature and altitude corrections | psi, kPa |
  | L30 | Wastegate control mode (0 open at low rpm, 1 feed-forward only, 2 closed loop, 3 closed, 4 engine off, 5 fixed position, 6 sweep) | mode |
  | L31 | Wastegate position sensor voltage | V |
  | L32 | Wastegate feed-forward position | % open |

  0 % open means the wastegate is shut on its seat. Where 100 % falls is my best estimate, so the raw value is
  offered too.

## Logging without the patch (SUBUDS)

**SUBUDS** is a new logger protocol I added to RomRaider. It reads values straight from the ECU's memory, so a
**stock ROM** gives you everything the logging patch adds, with no reflash. It only uses diagnostic requests the ECU
allows without any unlock, and it only reads: it changes nothing in the ROM or in how the engine runs.

**You need:**

* A RomRaider build with SUBUDS. Stock RomRaider doesn't have it yet; Windows and Linux test builds are on my
  [RomRaider fork's subuds-test-1 release](https://github.com/Jengacat/RomRaider/releases/tag/subuds-test-1)
  (source: the [`Subaru-UDS-Logging` branch](https://github.com/Jengacat/RomRaider/tree/Subaru-UDS-Logging)).
* `DIT_Logger_SUBUDS.xml`: one file for every supported car, the Ascent included.
* The same J2534 cable as for SSM.

**To use it:** load the file, choose **SUBUDS** as the logger protocol, and connect. RomRaider identifies your ECU
first and shows only the parameters that exist on it:

* 2.0 and 1.6 cars: the 46 stock parameters plus the 24 logging-patch ones (70);
* Ascent: its 45 stock parameters plus its 30 logging-patch ones (75).

The names and units match the other files, so a log from SUBUDS reads the same as one from SSM.

The memory location of each value differs from ROM to ROM. I checked every one in an emulator running each ROM's
own code: it had to return the same value the ECU's normal SSM read does, on all 103 ROMs. If your ECU isn't one of
the supported calibrations, it still connects, but no parameters show up; nothing is guessed.

SUBUDS logs only sensors and internal values. For trouble codes and OBD parameters, use the regular files.

## Status and feedback

None of these files has been run on a car yet. Every file is loaded with RomRaider's own code and every conversion
is checked, but real-world confirmation is still needed. If a value sits at a constant or reads nonsense, please
[report it](../../../issues/new?template=bug_report.yml), with your car, ROM and file. On a patched ROM, first check
that the L parameters move. If you try SUBUDS, please [let me know](../../../issues/new/choose) how it went.

Long-term fuel trim is 0.39 % per count. Older logger files elsewhere show double the real value.
