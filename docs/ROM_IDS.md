# Known calibration IDs

The calibration IDs known for Subaru DIT engine ECUs, as collected by reokov (issue #2), sorted by how each relates
to the ROMs this repo has definitions for. 338 IDs are listed; 22 supported ROMs were not on his list.

**A definition is published only for ROMs I have a complete read of.** The first five characters of an ID group
related ROMs, but they are not a software version: within a group the code can differ, and several groups (LV9N3…, LF9D0…, LF791…, LF9F0…) hold both 2.0 (FA20DIT)
and 1.6 (FB16DIT) ROMs. A 1.6 calibration can run exactly the code of a 2.0 ROM and the other way round, so the
engine can't be told from the code: I read it from each ROM's calibration. The other direction has held so far: no two groups share code. Every
pair of ROMs I have with identical code has the same first five characters. ROMs of one build differ only in their
calibration data (and the ID and checksum); a different build of the same family can still be close (the 2019–2020
Levorg 1.6 builds differ from each other in 3 to 18 of about 8,300 functions), but its tables can move.

Of the groups where I have more than one complete ROM, most run exactly the same code in every ROM; these do not:

* **LF780…:** LF78001H and LF78002H are separate builds (each has its own definition); the other six LF780 ROMs run
  LF78002H's code.
* **LF790…:** LF79001R is a separate build from the other seven, which run LF79002P's code.
* **LF791…:** LF79110N and LF79120P are separate builds from the other eight, which run LF79100P's code.
* **LF9D0…:** five builds: LF9D000d is a Levorg 1.6 (FB16DIT) build, and LF9D012h, LF9D030g, LF9D040h and LF9D050h
  are four different 2.0 (FA20DIT) builds.
* **LV9N0…:** three builds: LV9N000C, LV9N002E (13 of about 7,600 functions differ from LV9N000C) and LV9N002I.
* **LV9N1…:** LV9N101C differs from the other five.
* **LV9N3…:** four builds: two 2.0 builds (LV9N301A and the eight that run its code; LV9N300E and the five that run
  its code) and two different 1.6 builds (LV9N303J, LV9N340J).

Using a definition on a ROM with other code corrupts the calibration. If your ROM is in the second or third list
below, [send it](../README.md#submitting-a-rom): it can probably be added quickly.

## Supported (214 of the listed IDs, 236 in all)

LF75100D, LF75200A, LF75200S, LF75200T, LF75300D, LF75300E, LF75300F, LF75300G, LF75300H, LF75300J, LF75300K, LF75300L, LF75300M, LF75300S, LF75300T, LF75301A, LF75301J, LF75301K, LF75301L, LF75301P, LF75400K, LF75400N, LF75400S, LF75401D, LF75401E, LF75401F, LF75401G, LF75401J, LF75401K, LF75401L, LF75401M, LF75401N, LF75401P, LF75402A, LF75402H, LF75402S, LF75402T, LF75403A, LF75403G, LF75403S, LF75403T, LF75404H, LF75404S, LF75500A, LF75500G, LF75500T, LF75600H, LF75600S, LF76000C, LF76100R (1.6), LF76200Q (1.6), LF76200R (1.6), LF76301Q (1.6), LF76301R (1.6), LF76400Q (1.6), LF76400R (1.6), LF76401R (1.6), LF76402R (1.6), LF76500Q (1.6), LF76500R (1.6), LF76600R (1.6), LF78000D, LF78000F, LF78001C, LF78001E, LF78001F, LF78001G, LF78001H, LF78001Z, LF78002C, LF78002D, LF78002E, LF78002G, LF78002H, LF78002J, LF78002Z, LF78003A, LF780Z2E, LF78101B, LF78102B, LF78103B, LF78104B, LF78106B, LF78200B, LF79001K, LF79001L, LF79001M, LF79001R, LF79002N, LF79002P, LF79002Q, LF79002S, LF79100K, LF79100L, LF79100M, LF79100N, LF79100P, LF79100Q, LF79100R, LF79100S, LF79101K, LF79101L, LF79101M, LF79101P, LF79101T (1.6), LF79101U (1.6), LF79102N, LF79103P, LF79110N, LF79120P, LF79200T (1.6), LF79200U (1.6), LF79201U (1.6), LF79202U (1.6), LF79300T (1.6), LF79300U (1.6), LF79400U (1.6), LF9B002G (1.6), LF9B003U (1.6), LF9B100G (1.6), LF9B200U (1.6), LF9C000A, LF9C000B, LF9C000C, LF9C000E, LF9C000F, LF9C000L, LF9C000Q, LF9C000R, LF9C000Y, LF9C000Z, LF9C000a, LF9C000b, LF9C001D, LF9C001K, LF9C001N, LF9C001P, LF9C002B, LF9C002N, LF9C100M, LF9C100P, LF9C100R, LF9C100X, LF9C101P, LF9C102P, LF9C200B, LF9C200N, LF9C300P, LF9D000d (1.6), LF9D000f, LF9D000i, LF9D000j, LF9D000k, LF9D000m, LF9D000n, LF9D001e (1.6), LF9D010g, LF9D010h, LF9D011g, LF9D012h, LF9D030g, LF9D040h, LF9D050h, LF9D100e (1.6), LF9D200d (1.6), LF9F000P (1.6), LF9F000Q (1.6), LF9F000R, LF9F000U, LF9F000V, LF9F000W, LF9F000Y, LF9F000Z, LF9F100P (1.6), LF9F100Q (1.6), LF9F200P (1.6), LF9G001T, LF9G002S, LF9G002T, LF9G003T, LF9J000C, LF9J000D, LF9J001E, LF9K000D, LF9K000E, LF9L000E, LG7D430B (2.4), LG7D501B (2.4), LG7F300F (2.4), LG7F301F (2.4), LT8D700A (2.4), LT8D800A (2.4), LT8F200C (2.4), LT8F300C (2.4), LT8H300D (2.4), LV3C001T (1.6), LV3C100T (1.6), LV9N000A, LV9N000C, LV9N001E, LV9N002E, LV9N002I, LV9N100A, LV9N100B, LV9N100F, LV9N101C, LV9N101F, LV9N101G, LV9N101H, LV9N101I, LV9N300E, LV9N300F, LV9N300H, LV9N300I, LV9N300L, LV9N301A, LV9N301B, LV9N301E, LV9N301F, LV9N301J (1.6), LV9N301K, LV9N302A, LV9N302B, LV9N302E, LV9N302F, LV9N302G, LV9N302H, LV9N302I, LV9N302J (1.6), LV9N302L, LV9N303J (1.6), LV9N303K, LV9N340J (1.6), LV9N600M, LV9N601M, LV9N601N

(1.6) = Levorg 1.6 (FB16DIT); (2.4) = Ascent / Legacy XT (FA24DIT engine on the older ECU: the FA24 Early files); the rest are 2.0 (FA20DIT). Not on the list: LF75401M, LF75403A, LF75500T, LF76500R, LF78002D, LF79103P, LF9C002N, LF9C100M, LF9C100X, LF9C102P, LF9C200N, LF9D011g, LF9F100Q, LG7F301F, LT8D800A, LT8F200C, LT8H300D, LV3C100T, LV9N302G, LV9N302I, LV9N302L, LV9N303K.

## RH850 ECU: 2022+ WRX, 2023+ Ascent and Legacy / Outback XT

WRX, supported (24): LHBHB10B, LHBHD00B (2022, 6MT); LHBH740C (2022, CVT); LHBHC01C (2022–2023, CVT); LHBKC40M,
LHBKC30M (2023, 6MT); LHBP400b (2024, 6MT); LHBP301c (2024, CVT); LHBT210V (2026, CVT; the full ID is LHBT210VB0G);
and, year unknown: LHBH720D, LHBKC20P, LHBP300d, LHBT130h (6MT); LHBH740A, LHBH800A, LHBHA00A, LHBHB00A, LHBKC20R,
LHBKC20L, LHBP100e, LHBP100a, LHBT120a, LHBT120g, LHBT110a (CVT).

Ascent and Legacy / Outback XT, supported (11, all CVT): LHBK240Y (2023 Ascent); LHBK240G (2023 Legacy / Outback XT);
LHBKG01H, LHBKG00H, LHBKG01G (2024 Outback XT); LHBR200G, LHBR300G (2025 Legacy / Outback XT); and, year unknown,
model from the calibration: LHBP201A (Ascent), LHBK230H (Legacy / Outback XT), LHBK240Z and LHBK231Z (Ascent,
unconfirmed).

See the [2022+ WRX guide](WRX_2022plus.md), which applies to all of them. These are a different ECU generation
(Renesas RH850) from everything else on this page, and none of them was on the list above. The first four
characters don't identify the car: the LHBK… builds include 2023 WRX, Ascent and Legacy / Outback XT ROMs, and
LHBP201A is an Ascent calibration on 2024 WRX code. Within one family several builds exist, so as with the older
ECUs a definition fits only ROMs that run the same code.

## Same first five characters as a supported ROM, not supported yet (9)

These share the first five characters of the ID with a supported ROM. Where all my ROMs of the group run the same code
(one build), an unread ROM is likely to as well, but it is not certain until I see it; where the group already has
more than one build, any unread ROM could be a new one. *Engine* is that of my ROMs in the group; *Builds* is how many different code builds those ROMs contain ("1 ROM" when I
have only one). (partial) = I have
an incomplete read, not enough for a definition. (read) = I have a complete read and the definition is in progress.

| Group | Engine | Builds | Supported ROMs | Listed, not supported yet |
|---|---|---|---|---|
| LF751… | 2.0 | 1 ROM | LF75100D |  |
| LF752… | 2.0 | 1 | LF75200A, LF75200S, LF75200T |  |
| LF753… | 2.0 | 1 | LF75300D, LF75300E, LF75300F, LF75300G, LF75300H, LF75300J, LF75300K, LF75300L, LF75300M, LF75300S, LF75300T, LF75301A, LF75301J, LF75301K, LF75301L, LF75301P |  |
| LF754… | 2.0 | 1 | LF75400K, LF75400N, LF75400S, LF75401D, LF75401E, LF75401F, LF75401G, LF75401J, LF75401K, LF75401L, LF75401M, LF75401N, LF75401P, LF75402A, LF75402H, LF75402S, LF75402T, LF75403A, LF75403G, LF75403S, LF75403T, LF75404H, LF75404S |  |
| LF755… | 2.0 | 1 | LF75500A, LF75500G, LF75500T |  |
| LF756… | 2.0 | 1 | LF75600H, LF75600S |  |
| LF760… | 2.0 | 1 ROM | LF76000C |  |
| LF761… | 1.6 | 1 ROM | LF76100R (1.6) |  |
| LF762… | 1.6 | 1 | LF76200Q (1.6), LF76200R (1.6) |  |
| LF763… | 1.6 | 1 | LF76301Q (1.6), LF76301R (1.6) |  |
| LF764… | 1.6 | 1 | LF76400Q (1.6), LF76400R (1.6), LF76401R (1.6), LF76402R (1.6) |  |
| LF765… | 1.6 | 1 | LF76500Q (1.6), LF76500R (1.6) |  |
| LF766… | 1.6 | 1 ROM | LF76600R (1.6) |  |
| LF780… | 2.0 | 2 | LF78000D, LF78000F, LF78001C, LF78001E, LF78001F, LF78001G, LF78001H, LF78001Z, LF78002C, LF78002D, LF78002E, LF78002G, LF78002H, LF78002J, LF78002Z, LF78003A, LF780Z2E |  |
| LF781… | 2.0 | 1 | LF78101B, LF78102B, LF78103B, LF78104B, LF78106B |  |
| LF782… | 2.0 | 1 ROM | LF78200B |  |
| LF790… | 2.0 | 2 | LF79001K, LF79001L, LF79001M, LF79001R, LF79002N, LF79002P, LF79002Q, LF79002S | |
| LF791… | 2.0 and 1.6 | 3 | LF79100K, LF79100L, LF79100M, LF79100N, LF79100P, LF79100Q, LF79100R, LF79100S, LF79101K, LF79101L, LF79101M, LF79101P, LF79101T (1.6), LF79101U (1.6), LF79102N, LF79103P, LF79110N, LF79120P | LF79130P (read) |
| LF792… | 1.6 | 1 | LF79200T (1.6), LF79200U (1.6), LF79201U (1.6), LF79202U (1.6) |  |
| LF793… | 1.6 | 1 | LF79300T (1.6), LF79300U (1.6) |  |
| LF794… | 1.6 | 1 ROM | LF79400U (1.6) |  |
| LF9B0… | 1.6 | 1 | LF9B002G (1.6), LF9B003U (1.6) |  |
| LF9B1… | 1.6 | 1 ROM | LF9B100G (1.6) |  |
| LF9B2… | 1.6 | 1 ROM | LF9B200U (1.6) |  |
| LF9C0… | 2.0 | 1 | LF9C000A, LF9C000B, LF9C000C, LF9C000E, LF9C000F, LF9C000L, LF9C000Q, LF9C000R, LF9C000Y, LF9C000Z, LF9C000a, LF9C000b, LF9C001D, LF9C001K, LF9C001N, LF9C001P, LF9C002B, LF9C002N |  |
| LF9C1… | 2.0 | 1 | LF9C100M, LF9C100P, LF9C100R, LF9C100X, LF9C101P, LF9C102P |  |
| LF9C2… | 2.0 | 1 | LF9C200B, LF9C200N |  |
| LF9C3… | 2.0 | 1 ROM | LF9C300P |  |
| LF9D0… | 2.0 and 1.6 | 5 | LF9D000d (1.6), LF9D000f, LF9D000i, LF9D000j, LF9D000k, LF9D000m, LF9D000n, LF9D001e (1.6), LF9D010g, LF9D010h, LF9D011g, LF9D012h, LF9D030g, LF9D040h, LF9D050h | |
| LF9D1… | 1.6 | 1 ROM | LF9D100e (1.6) |  |
| LF9D2… | 1.6 | 1 ROM | LF9D200d (1.6) |  |
| LF9F0… | 2.0 and 1.6 | 1 | LF9F000P (1.6), LF9F000Q (1.6), LF9F000R, LF9F000U, LF9F000V, LF9F000W, LF9F000Y, LF9F000Z |  |
| LF9F1… | 1.6 | 1 | LF9F100P (1.6), LF9F100Q (1.6) |  |
| LF9F2… | 1.6 | 1 ROM | LF9F200P (1.6) |  |
| LF9G0… | 2.0 | 1 | LF9G001T, LF9G002S, LF9G002T, LF9G003T |  |
| LF9J0… | 2.0 | 1 | LF9J000C, LF9J000D, LF9J001E |  |
| LF9K0… | 2.0 | 1 | LF9K000D, LF9K000E |  |
| LF9L0… | 2.0 | 1 ROM | LF9L000E |  |
| LG7F3… | 2.4 | 1 | LG7F300F (2.4), LG7F301F (2.4) | |
| LV3C0… | 1.6 | 1 ROM | LV3C001T (1.6) |  |
| LV3C1… | 1.6 | 1 ROM | LV3C100T (1.6) |  |
| LV9N0… | 2.0 | 3 | LV9N000A, LV9N000C, LV9N001E, LV9N002E, LV9N002I | LV9N001D, LV9N002D, LV9N002F (partial) |
| LV9N1… | 2.0 | 2 | LV9N100A, LV9N100B, LV9N100F, LV9N101C, LV9N101F, LV9N101G, LV9N101H, LV9N101I | LV9N100D, LV9N100E, LV9N100J, LV9N101D (partial), LV9N101E |
| LV9N3… | 2.0 and 1.6 | 4 | LV9N300E, LV9N300F, LV9N300H, LV9N300I, LV9N300L, LV9N301A, LV9N301B, LV9N301E, LV9N301F, LV9N301J (1.6), LV9N301K, LV9N302A, LV9N302B, LV9N302E, LV9N302F, LV9N302G, LV9N302H, LV9N302I, LV9N302J (1.6), LV9N302L, LV9N303J (1.6), LV9N303K, LV9N340J (1.6) | |
| LV9N6… | 2.0 | 1 | LV9N600M, LV9N601M, LV9N601N |  |

## Same family (first four characters), a group I have no ROM of (23)

These need a read and a port, like the supported ROMs of their family; (read) marks the ones I have a complete read of, with the port in progress. *My ROMs* gives the engine of the ROMs I have
from that family, which says nothing certain about these.

| Group | My ROMs of the family | IDs |
|---|---|---|
| LF9C4… | 2.0 | LF9C400P (read) |
| LG7D9… | 2.4 | LG7D900B (read), LG7D901B (read), LG7D902B (read) |
| LG7F6… | 2.4 | LG7F600F (read), LG7F601F (read), LG7F602F (read) |
| LT8D5… | 2.4 | LT8D510A (read) |
| LT8D6… | 2.4 | LT8D600A (read) |
| LT8DA… | 2.4 | LT8DA00A (read) |
| LT8DB… | 2.4 | LT8DB00A (read), LT8DB01A (read), LT8DB02A (read) |
| LT8F1… | 2.4 | LT8F101C (read) |
| LT8F6… | 2.4 | LT8F600C (read), LT8F601C (read), LT8F602C (read) |
| LT8H1… | 2.4 | LT8H100D (read) |
| LT8H6… | 2.4 | LT8H601D (read), LT8H602D (read) |
| LV9N2… | 2.0 and 1.6 | LV9N200J, LV9N201J, LV9N202J |

## Other families (92)

No supported ROM shares these prefixes. The AF5G, AF56, LF6A and LF61 ROMs I have seen (2013–2015 Forester XT) are
from an older 1.5 MB ECU (SH705x) with different software, not covered here. I have complete reads of the ones marked (read), with the ports in progress; I have not seen a ROM of the others.

| Family | IDs |
|---|---|
| AE8M | AE8M800A, AE8M900A, AE8MB00A, AE8MF00A, AE8MK00A, AE8ML00A |
| AEEB | AEEB000A |
| AEEC | AEEC800A, AEEC900A |
| AF56 | AF56601B, AF56D00B, AF56D01B, AF56E01B, AF56E02B, AF56E03B |
| AF5F | AF5F100A |
| AF5G | AF5G000A, AF5G100A, AF5G200A, AF5G200C, AF5G200D, AF5G300H, AF5G5Z3A, AF5G800A, AF5G800C, AF5G800D, AF5G800E, AF5G800G, AF5G800H, AF5G801A |
| AF6A | AF6A500C, AF6A500D, AF6A500G, AF6A600A, AF6A600C, AF6A600D, AF6A601A, AF6A601C, AF6A601D, AF6A601E, AF6A601G, AF6A601H |
| AV9D | AV9D100E (read) |
| DB4V | DB4V000D |
| LF61 | LF61600B, LF61800B, LF61801B, LF61802B, LF61803B |
| LF6A | LF6A100C, LF6A200A, LF6A400C, LF6A400D, LF6A400E, LF6A400H, LF6A400I, LF6A400J, LF6A401A, LF6A402A, LF6A4Z0D, LF6A500C, LF6A500D, LF6A500F, LF6A500G, LF6A500I, LF6A600A, LF6A600D, LF6A600I, LF6A600J, LF6A601A, LF6A601C, LF6A601D, LF6A601E, LF6A601G, LF6A601H |
| LF73 | LF73100A (read) |
| LF77 | LF77000C (read), LF77000D (read), LF77000Q (read) |
| LF7B | LF7B100B, LF7B100C, LF7B201B, LF7B201C |
| LG7G | LG7G500G (read), LG7G500H (read), LG7G501G (read), LG7G501H (read), LG7G502G (read), LG7G502H (read) |
| LT8J | LT8J501F (read), LT8J502F (read) |
| LV9H | LV9H000D (read) |
