# FA24DIT (2022+ WRX) CAN

`FA24DIT_CAN.dbc`: the 2022+ WRX ECU's own frames (0x040, 0x041, 0x081, 0x146, 0x240, 0x241, 0x342,
0x345-0x347) and the received frames it decodes (vehicle and wheel speeds and the VDC torque request, 0x139-0x13B;
an idle-speed request, 0x048; climate, 0x2D2; electrical load, 0x118; the meter, 0x390), with the node names ECM,
VDC, TCM, HVAC, BCM and METER. Read from the 2023 ROM (LHBKC40M); the 2024 ROM uses the same frame tables, and the
2022 ROM's differ only by one frame (0x3A2) that is not in this file. Each signal's comment says whether its
meaning and scale are read from the code or inferred. Raw signals have no scale because the ECU never converts them.

Not in the DBC yet: the SI-Drive mode the ECU receives. It reads it from 0x3A4 byte 2, bits 0-2 (3 = mode 1
Default, 1 = 2 Sport, 2 = 3 Intelligent, 4 = 4 Sport Sharp, 5 = mode 7; anything else falls back to a calibration
value), and it can be set by calibration to use 0x393 byte 3 bits 5-7 instead. Mode names 2-4 are inferred from the
older platform.

The Ascent and Legacy / Outback XT (FA24DIT on the older SH72544R ECU) have their own dictionary:
`FA20DIT_FA24_CAN.*`.

Listening on the bus is safe; transmitting on a running car's CAN bus is not.
