# EcuFlash definitions

One definition per ROM, named by calibration ID (`FA20DIT_<calibration ID>_EcuFlash.xml`). Use the file that matches
the ID EcuFlash shows when it reads your ECU.

**Install:** copy the file into your EcuFlash metadata folder (for example `rommetadata\subaru\`) and restart EcuFlash.
Each file is standalone; no base definition is needed.

Table folders are numbered in tuning order (`01.02 Fueling - …`). Higher user levels show more tables, as in RomRaider.

The definitions set the SH72543R memory model with no checksum module, so **EcuFlash will not fix the checksum**. Run
the [checksum tool](../../tools/) on the saved ROM before flashing. Writing with EcuFlash has not been tested on this
ECU yet.
