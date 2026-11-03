# Definitions

Table definitions for the supported FA20DIT ROMs (see the [supported ROMs](../README.md#supported-roms) table).

| Folder | For | Files |
|---|---|---|
| [`romraider/`](romraider/) | RomRaider | One file covering every supported ROM. |
| [`ecuflash/`](ecuflash/) | EcuFlash | One file per ROM, named by calibration ID. |

Both carry the same tables, scalings and descriptions. Each table has a plain-English summary first and the detail
after it, and tables are grouped by purpose in tuning order.

EcuFlash may correct this ECU's checksum (not yet confirmed); RomRaider can't until
[pull request #248](https://github.com/RomRaider/RomRaider/pull/248) is merged and released. Until then, run [`tools/checksum.py`](../tools/) or
`tools/checksum.ps1` on every edited ROM before flashing.
