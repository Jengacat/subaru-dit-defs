# Definitions

Table definitions for the supported FA20DIT and FB16DIT ROMs (see the [supported ROMs](../README.md#supported-roms)
lists).

| Folder | For | Files |
|---|---|---|
| [`romraider/`](romraider/) | RomRaider | `FA20DIT_RomRaider.xml` covers every supported 2.0 ROM, `FB16DIT_RomRaider.xml` every supported Levorg 1.6 ROM. |
| [`ecuflash/`](ecuflash/) | EcuFlash | Imperial and Metric sets: a base file per engine plus one file per ROM, named by calibration ID. Also `read_subaruhitachish72544.xml`, a read template for the 2.5 MB (2019+) ECUs (untested; see the [main README](../README.md#reading-your-ecu)). |

Both carry the same tables, scalings and descriptions. Each table has a plain-English summary first and the detail
after it, and tables are grouped by purpose in tuning order. The descriptions say what the ECU does with a table, not
what a particular car's calibration holds: stock values differ between markets, models and the two engines.

EcuFlash corrects this ECU's checksum on save for 2 MB ROMs; RomRaider can't until
[pull request #248](https://github.com/RomRaider/RomRaider/pull/248) is merged and released. Until then, run
[`tools/checksum.py`](../tools/) or `tools/checksum.ps1` on every ROM edited in RomRaider, and on every 2.5 MB ROM,
before flashing.

## Notes on individual ROMs

*2019 Levorg STI (LF9F000R):* this is the first 2019+ ROM (Hitachi SH72544R, 2.5 MB). The calibration is almost the
same as the 2018 WRX S4's, but the code and layout are new, so check it carefully. Logging (SSM, OBD, the logging
patch) and the CAN dictionary cover it too. Four of its trouble codes sit where other ROMs have P0244, P0451, P0452
and P0453, so in the logger's DTC tab those four names also give its code. EcuFlash can't correct its checksum: use
the checksum tool. Writing a 2.5 MB ECU isn't supported by any open tool yet; see
[Reading your ECU](../README.md#reading-your-ecu).

*Malaysian Forester XT (LF9C000a):* the ID really ends in a lowercase "a". The code and table layout are the same
as LF9C000C's; only a few calibration bytes differ.

*Levorg 2.0 (2014–2017):* six of the seven Levorg ROMs run the same code as a
WRX ROM in this table; LV9N301A / LV9N302A are a build of their own, ported and checked like the others.

*Outdated:* LV9N000C is an early calibration that Subaru superseded (its tune is 99.7% the same as LV9N101C's). It
is still fully supported. When you open it, RomRaider shows its "ECU Revision is Obsolete" notice ("A newer version of
this ECU revision exists"), with a link to RomRaider's general ECU revision list rather than to this repo. The notice
can be switched off with its "Always display this message" box or in RomRaider's settings ("Warn me when opening out
of date image revision"). The EcuFlash definition does not carry this flag.

*Levorg 1.6 (FB16DIT, 2014–2020):* the 1.6's ECU runs the same software as the 2.0's. For each 1.6 ROM I paired every
function with the 2.0 ROM of the same software version; 98–99.9 % are identical instruction for instruction, so each
table is found by the same instruction that reads it in the 2.0. Where the code differs I read it. The five 2015 ROMs
(LF76…) are a software build I have no 2.0 ROM of; they sit between two 2.0 builds and needed the most hand work.
In the 2014–2017 ROMs the knock background function is a shorter version: it has four extra rows, Knock Background
Clear Step (Event 1–4). The 2019 and 2020 ROMs are 2.5 MB: EcuFlash can't correct their checksum (use the checksum
tool), and no open tool writes those ECUs yet. Model years and markets are as the ROMs were supplied. The
descriptions were written on the 2.0 and have not all been re-read against the 1.6.

*2017 Australian Forester XT (LF78002H):* the same software version as the Forester tS (LF78001H), and nearly the same
code (its ID shares the LF780 prefix, but the two are separate builds, so neither definition fits the other ROM). Its
definition was moved from LF78001H instruction for instruction, with the 2017 USDM Forester XT (LF78103B) as a second
reference.

*User levels differ between ROMs:* a table that a ROM's own calibration switches off is at the Debug level in that
ROM and at Advanced in a ROM that uses it.

*Partial ports:* LF78001H, LF78002H and the LV9N ROMs have fewer tables than the WRX ROMs; tables I could not place with
confidence are left out rather than guessed.

## Credits

- **reokov**: the seven Levorg 2.0 ROMs and sixteen of the nineteen Levorg 1.6 ROMs, the ECU ID and model-revision information,
  the EcuFlash SH72544R read-template tip for 2.5 MB ECUs, and the suggestion to list the supported ROMs per model.
- **Hafiez STi**: the Malaysian Forester XT ROM (LF9C000a).
- The RomRaider forum, where several of the ROMs were posted.
