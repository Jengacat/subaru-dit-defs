# FA24DIT (Ascent) CAN

Built from each ROM's own CAN code, run in an emulator. The Ascent uses a different set of frame IDs from the FA20DIT (WRX, Levorg, Forester), so the FA20DIT dictionary does not apply. Field names ending in a frame ID were matched to a WRX signal through the ECU variable they feed or come from (inferred); the others are raw fields. Received frames: only the first byte and the low nibble of the second are mapped (the decoder copies those to RAM unconditionally); the payloads are not mapped yet. Bit numbers: byte, then bit 0 = LSB.

| ROM | Year | Network variant | ID table |
|---|---|---|---|
| LT8D800A | 2019 | 4 | 0x277F0C |
| LT8F300C | 2020 | 4 | 0x277F08 |
| LT8H300D | 2021 | 4 | 0x2781DC |

## Frames

| ID | Direction | DLC | ROMs |
|---|---|---|---|
| 0x040 | send | 8 | all |
| 0x041 | send | 8 | all |
| 0x048 | receive | 8 | all |
| 0x049 | receive | 8 | all |
| 0x118 | receive | 8 | all |
| 0x139 | receive | 8 | all |
| 0x13A | receive | 8 | all |
| 0x13B | receive | 8 | all |
| 0x146 | send | 8 | all |
| 0x174 | receive | 8 | LT8F300C, LT8D800A |
| 0x221 | receive | 8 | all |
| 0x240 | send | 8 | all |
| 0x241 | send | 8 | all |
| 0x2D2 | receive | 8 | all |
| 0x33A | receive | 8 | all |
| 0x345 | send | 8 | all |
| 0x346 | send | 8 | all |
| 0x347 | send | 8 | all |
| 0x34A | receive | 8 | all |
| 0x390 | receive | 8 | all |
| 0x393 | receive | 8 | all |
| 0x3AC | receive | 8 | all |
| 0x660 | receive | 8 | all |
| 0x68D | receive | 8 | LT8H300D |
| 0x6FC | send | 8 | all |
| 0x771 | send | 8 | all |
| 0x772 | send | 8 | all |
| 0x773 | send | 8 | all |
| 0x774 | send | 8 | all |
| 0x775 | send | 8 | all |
| 0x7DF | receive (diagnostic) | 8 | all |
| 0x7E0 | receive (diagnostic) | 8 | all |
| 0x7E8 | send (diagnostic) | 8 | all |

## Received fields

| ID | Byte.bit | Bits | Name | RAM (LT8H300D) | Meaning |
|---|---|---|---|---|---|
| 0x048 | 0.0 | 8 | rx_048_b0_0_7 | FFF8AA80 | RAM FFF8AA80 on LT8H300D; no WRX signal on that variable. |
| 0x048 | 1.0 | 4 | rx_048_b1_0_3 | FFF8AA81 | RAM FFF8AA81 on LT8H300D; no WRX signal on that variable. |
| 0x049 | 0.0 | 8 | rx_049_b0_0_7 | FFF8AA82 | RAM FFF8AA82 on LT8H300D; no WRX signal on that variable. |
| 0x049 | 1.0 | 4 | rx_049_b1_0_3 | FFF8AA83 | RAM FFF8AA83 on LT8H300D; no WRX signal on that variable. |
| 0x118 | 0.0 | 8 | rx_118_b0_0_7 | FFF8AA92 | RAM FFF8AA92 on LT8H300D; no WRX signal on that variable. |
| 0x118 | 1.0 | 4 | rx_118_b1_0_3 | FFF8AA93 | RAM FFF8AA93 on LT8H300D; no WRX signal on that variable. |
| 0x139 | 0.0 | 8 | rx_139_b0_0_7 | FFF8AA7A | RAM FFF8AA7A on LT8H300D; no WRX signal on that variable. |
| 0x139 | 1.0 | 4 | rx_139_b1_0_3 | FFF8AA7B | RAM FFF8AA7B on LT8H300D; no WRX signal on that variable. |
| 0x13A | 0.0 | 8 | rx_13a_b0_0_7 | FFF8AA7C | RAM FFF8AA7C on LT8H300D; no WRX signal on that variable. |
| 0x13A | 1.0 | 4 | rx_13a_b1_0_3 | FFF8AA7D | RAM FFF8AA7D on LT8H300D; no WRX signal on that variable. |
| 0x13B | 0.0 | 8 | rx_13b_b0_0_7 | FFF8AA7E | RAM FFF8AA7E on LT8H300D; no WRX signal on that variable. |
| 0x13B | 1.0 | 4 | rx_13b_b1_0_3 | FFF8AA7F | RAM FFF8AA7F on LT8H300D; no WRX signal on that variable. |
| 0x221 | 0.0 | 8 | rx_221_b0_0_7 | FFF8AA88 | RAM FFF8AA88 on LT8H300D; no WRX signal on that variable. |
| 0x221 | 1.0 | 4 | rx_221_b1_0_3 | FFF8AA89 | RAM FFF8AA89 on LT8H300D; no WRX signal on that variable. |
| 0x2D2 | 0.0 | 8 | rx_2d2_b0_0_7 | FFF8AA8A | RAM FFF8AA8A on LT8H300D; no WRX signal on that variable. |
| 0x2D2 | 1.0 | 4 | rx_2d2_b1_0_3 | FFF8AA8B | RAM FFF8AA8B on LT8H300D; no WRX signal on that variable. |
| 0x33A | 0.0 | 8 | rx_33a_b0_0_7 | FFF8AA94 | RAM FFF8AA94 on LT8H300D; no WRX signal on that variable. |
| 0x33A | 1.0 | 4 | rx_33a_b1_0_3 | FFF8AA95 | RAM FFF8AA95 on LT8H300D; no WRX signal on that variable. |
| 0x34A | 0.0 | 8 | rx_34a_b0_0_7 | FFF8AA84 | RAM FFF8AA84 on LT8H300D; no WRX signal on that variable. |
| 0x34A | 1.0 | 4 | rx_34a_b1_0_3 | FFF8AA85 | RAM FFF8AA85 on LT8H300D; no WRX signal on that variable. |
| 0x390 | 0.0 | 8 | rx_390_b0_0_7 | FFF8AA8C | RAM FFF8AA8C on LT8H300D; no WRX signal on that variable. |
| 0x390 | 1.0 | 4 | rx_390_b1_0_3 | FFF8AA8D | RAM FFF8AA8D on LT8H300D; no WRX signal on that variable. |
| 0x390 | 1.4 | 1 | rx_390_b1_4_4 | FFF8AA56 | RAM FFF8AA56 on LT8H300D; no WRX signal on that variable. |
| 0x393 | 0.0 | 8 | rx_393_b0_0_7 | FFF8AA8E | RAM FFF8AA8E on LT8H300D; no WRX signal on that variable. |
| 0x393 | 1.0 | 4 | rx_393_b1_0_3 | FFF8AA8F | RAM FFF8AA8F on LT8H300D; no WRX signal on that variable. |
| 0x3AC | 0.0 | 8 | rx_3ac_b0_0_7 | FFF8AA86 | RAM FFF8AA86 on LT8H300D; no WRX signal on that variable. |
| 0x3AC | 1.0 | 4 | rx_3ac_b1_0_3 | FFF8AA87 | RAM FFF8AA87 on LT8H300D; no WRX signal on that variable. |
| 0x3AC | 1.4 | 1 | rx_3ac_b1_4_4 | FFF8AA55 | RAM FFF8AA55 on LT8H300D; no WRX signal on that variable. |
| 0x68D | 0.0 | 8 | rx_68d_b0_0_7 | FFF8AFE3 | RAM FFF8AFE3 on LT8H300D; no WRX signal on that variable. |
| 0x68D | 1.0 | 4 | rx_68d_b1_0_3 | FFF8AFE4 | RAM FFF8AFE4 on LT8H300D; no WRX signal on that variable. |

## Sent fields

| ID | Byte.bit | Bits | Name | RAM (LT8H300D) | Meaning |
|---|---|---|---|---|---|
| 0x040 | 0.0 | 6 | tx_040_b0_0_5 | FFF8C01A | RAM FFF8C01A on LT8H300D; no WRX signal on that variable. |
| 0x040 | 0.6 | 1 | tx_040_b0_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x040 | 0.7 | 1 | tx_040_b0_7_7 | FFF899C0 | RAM FFF899C0 on LT8H300D (FFF8929A on the WRX); no WRX signal on that variable. |
| 0x040 | 1.0 | 4 | tx_040_b1_0_3 | FFF8C01F | RAM FFF8C01F on LT8H300D; no WRX signal on that variable. |
| 0x040 | 1.4 | 1 | tx_040_b1_4_4 | FFF8C046 | RAM FFF8C046 on LT8H300D; no WRX signal on that variable. |
| 0x040 | 1.7 | 1 | tx_040_b1_7_7 | FFF99A80 | RAM FFF99A80 on LT8H300D (FFF99A80 on the WRX); no WRX signal on that variable. |
| 0x040 | 2.0 | 8 | tx_040_b2_0_7 | FFF8CD75 | RAM FFF8CD75 on LT8H300D; no WRX signal on that variable. |
| 0x040 | 3.0 | 6 | engine_speed_040 | FFF8CD74 | Same ECU variable as the 2021 WRX's 0x140 engine_speed (RAM FFF8CD74 on LT8H300D, FFF8C162 on the WRX, neighbour). Engine speed, 1 rpm/bit (CD54 = rpm x 5.12), 14 bits |
| 0x040 | 3.6 | 1 | tx_040_b3_6_6 | FFF8B9C1 | RAM FFF8B9C1 on LT8H300D; the 2021 WRX's 0x140 pin_PA2 comes from the same byte (FFF8AE41 on the WRX), not checked bit by bit. |
| 0x040 | 3.7 | 1 | tx_040_b3_7_7 | FFF899C0 | RAM FFF899C0 on LT8H300D (FFF8929A on the WRX); no WRX signal on that variable. |
| 0x040 | 4.0 | 8 | tx_040_b4_0_7 | FFF8C06F | RAM FFF8C06F on LT8H300D; no WRX signal on that variable. |
| 0x040 | 5.0 | 8 | tx_040_b5_0_7 | FFF8C01A | RAM FFF8C01A on LT8H300D; no WRX signal on that variable. |
| 0x040 | 6.0 | 8 | tx_040_b6_0_7 | FFF8C086 | RAM FFF8C086 on LT8H300D; no WRX signal on that variable. |
| 0x040 | 7.6 | 1 | tx_040_b7_6_6 | FFF89B48 | RAM FFF89B48 on LT8H300D; the 2021 WRX's 0x140 pedal_released comes from the same byte (FFF89424 on the WRX), not checked bit by bit. |
| 0x040 | 7.7 | 1 | tx_040_b7_7_7 | FFF8C035 | RAM FFF8C035 on LT8H300D; the 2021 WRX's 0x141 pedal_flag_88C64b4 comes from the same byte (FFF8B49D on the WRX), not checked bit by bit. |
| 0x041 | 0.0 | 1 | tx_041_b0_0_0 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x041 | 0.1 | 1 | tx_041_b0_1_1 | FFF8C14A | RAM FFF8C14A on LT8H300D; the 2021 WRX's 0x140 ac_compressor_on comes from the same byte (FFF8B5A6 on the WRX), not checked bit by bit. |
| 0x041 | 0.2 | 2 | tx_041_b0_2_3 | FFF89CEC | RAM FFF89CEC on LT8H300D; the 2021 WRX's 0x141 drive_mode_flag_A643 comes from the same byte (FFF895D0 on the WRX), not checked bit by bit. |
| 0x041 | 0.4 | 1 | tx_041_b0_4_4 | FFF9244D | RAM FFF9244D on LT8H300D; no WRX signal on that variable. |
| 0x041 | 0.5 | 1 | tx_041_b0_5_5 | FFF89783 | RAM FFF89783 on LT8H300D; the 2021 WRX's 0x141 crank_or_low_voltage comes from the same byte (FFF8905F on the WRX), not checked bit by bit. |
| 0x041 | 0.6 | 1 | tx_041_b0_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x041 | 0.7 | 1 | tx_041_b0_7_7 | FFF89786 | RAM FFF89786 on LT8H300D; the 2021 WRX's 0x141 below_rev_limit comes from the same byte (FFF89062 on the WRX), not checked bit by bit. |
| 0x041 | 1.0 | 4 | tx_041_b1_0_3 | FFF8C020 | RAM FFF8C020 on LT8H300D; no WRX signal on that variable. |
| 0x041 | 2.0 | 8 | tx_041_b2_0_7 | FFF8CD9F | RAM FFF8CD9F on LT8H300D; no WRX signal on that variable. |
| 0x041 | 3.0 | 7 | tx_041_b3_0_6 | FFF8CD9E | RAM FFF8CD9E on LT8H300D; no WRX signal on that variable. |
| 0x041 | 3.7 | 1 | tx_041_b3_7_7 | FFF89786 | RAM FFF89786 on LT8H300D; the 2021 WRX's 0x141 below_rev_limit comes from the same byte (FFF89062 on the WRX), not checked bit by bit. |
| 0x041 | 4.0 | 8 | tx_041_b4_0_7 | FFF8CD41 | RAM FFF8CD41 on LT8H300D; no WRX signal on that variable. |
| 0x041 | 5.0 | 7 | tx_041_b5_0_6 | FFF8CD40 | RAM FFF8CD40 on LT8H300D; no WRX signal on that variable. |
| 0x041 | 5.7 | 1 | tx_041_b5_7_7 | FFF89D06 | RAM FFF89D06 on LT8H300D (FFF895EA on the WRX); no WRX signal on that variable. |
| 0x041 | 6.0 | 8 | tx_041_b6_0_7 | FFF8C028 | RAM FFF8C028 on LT8H300D; no WRX signal on that variable. |
| 0x041 | 7.0 | 1 | tx_041_b7_0_0 | FFF8C14B | RAM FFF8C14B on LT8H300D; the 2021 WRX's 0x141 ac_flag_A9A3b1 comes from the same byte (FFF8B5A7 on the WRX), not checked bit by bit. |
| 0x041 | 7.1 | 1 | tx_041_b7_1_1 | FFF8C14A | RAM FFF8C14A on LT8H300D; the 2021 WRX's 0x140 ac_compressor_on comes from the same byte (FFF8B5A6 on the WRX), not checked bit by bit. |
| 0x041 | 7.2 | 2 | tx_041_b7_2_3 | FFF89CEC | RAM FFF89CEC on LT8H300D; the 2021 WRX's 0x141 drive_mode_flag_A643 comes from the same byte (FFF895D0 on the WRX), not checked bit by bit. |
| 0x041 | 7.4 | 1 | tx_041_b7_4_4 | FFF9244D | RAM FFF9244D on LT8H300D; no WRX signal on that variable. |
| 0x041 | 7.5 | 1 | tx_041_b7_5_5 | FFF89783 | RAM FFF89783 on LT8H300D; the 2021 WRX's 0x141 crank_or_low_voltage comes from the same byte (FFF8905F on the WRX), not checked bit by bit. |
| 0x146 | 0.0 | 2 | tx_146_b0_0_1 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x146 | 0.2 | 1 | tx_146_b0_2_2 | FFF89CEC | RAM FFF89CEC on LT8H300D; the 2021 WRX's 0x141 drive_mode_flag_A643 comes from the same byte (FFF895D0 on the WRX), not checked bit by bit. |
| 0x146 | 0.3 | 3 | tx_146_b0_3_5 | FFF8C038 | RAM FFF8C038 on LT8H300D; the 2021 WRX's 0x144 cruise_switch_code comes from the same byte (FFF8B4A0 on the WRX), not checked bit by bit. |
| 0x146 | 0.6 | 1 | tx_146_b0_6_6 | FFF8C03E | RAM FFF8C03E on LT8H300D; no WRX signal on that variable. |
| 0x146 | 0.7 | 1 | tx_146_b0_7_7 | FFF89CEF | RAM FFF89CEF on LT8H300D; the 2021 WRX's 0x140 mil_request comes from the same byte (FFF895D3 on the WRX), not checked bit by bit. |
| 0x146 | 1.0 | 4 | tx_146_b1_0_3 | FFF8C021 | RAM FFF8C021 on LT8H300D; no WRX signal on that variable. |
| 0x146 | 1.4 | 3 | tx_146_b1_4_6 | FFF8C05B | RAM FFF8C05B on LT8H300D; no WRX signal on that variable. |
| 0x146 | 1.7 | 1 | tx_146_b1_7_7 | FFF89CEF | RAM FFF89CEF on LT8H300D; the 2021 WRX's 0x140 mil_request comes from the same byte (FFF895D3 on the WRX), not checked bit by bit. |
| 0x146 | 2.0 | 8 | tx_146_b2_0_7 | FFF8D1F5 | RAM FFF8D1F5 on LT8H300D (FFF8C4E7 on the WRX); no WRX signal on that variable. |
| 0x146 | 3.0 | 6 | engine_speed_filtered_146 | FFF8D1F4 | Same ECU variable as the 2021 WRX's 0x141 engine_speed_filtered (RAM FFF8D1F4 on LT8H300D, FFF8C4E6 on the WRX, vote). Filtered engine speed (CE9C, weight B73E); with an AT it tracks the TCM speed FFF8924E (0x149); 0 when FFF88A28 b1 clear or engine not rotating |
| 0x146 | 3.6 | 1 | tx_146_b3_6_6 | FFF8C03E | RAM FFF8C03E on LT8H300D; no WRX signal on that variable. |
| 0x146 | 3.7 | 1 | tx_146_b3_7_7 | FFF9244E | RAM FFF9244E on LT8H300D; no WRX signal on that variable. |
| 0x146 | 4.0 | 8 | tx_146_b4_0_7 | FFF8C081 | RAM FFF8C081 on LT8H300D; no WRX signal on that variable. |
| 0x146 | 5.0 | 1 | tx_146_b5_0_0 | FFF89CF0 | RAM FFF89CF0 on LT8H300D; the 2021 WRX's 0x140 throttle_closed comes from the same byte (FFF895D4 on the WRX), not checked bit by bit. |
| 0x146 | 5.1 | 1 | tx_146_b5_1_1 | FFF89CEE | RAM FFF89CEE on LT8H300D; the 2021 WRX's 0x144 cruise_standby comes from the same byte (FFF895D2 on the WRX), not checked bit by bit. |
| 0x146 | 5.2 | 1 | tx_146_b5_2_2 | FFF89CEC | RAM FFF89CEC on LT8H300D; the 2021 WRX's 0x141 drive_mode_flag_A643 comes from the same byte (FFF895D0 on the WRX), not checked bit by bit. |
| 0x146 | 5.3 | 3 | tx_146_b5_3_5 | FFF8C038 | RAM FFF8C038 on LT8H300D; the 2021 WRX's 0x144 cruise_switch_code comes from the same byte (FFF8B4A0 on the WRX), not checked bit by bit. |
| 0x146 | 5.6 | 1 | tx_146_b5_6_6 | FFF9244E | RAM FFF9244E on LT8H300D; no WRX signal on that variable. |
| 0x240 | 0.0 | 1 | tx_240_b0_0_0 | FFF81052 | RAM FFF81052 on LT8H300D (FFF81164 on the WRX); no WRX signal on that variable. |
| 0x240 | 0.1 | 1 | tx_240_b0_1_1 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x240 | 0.2 | 1 | tx_240_b0_2_2 | FFF89F27 | RAM FFF89F27 on LT8H300D; the 2021 WRX's 0x361 flag_89053b3 comes from the same byte (FFF89813 on the WRX), not checked bit by bit. |
| 0x240 | 0.3 | 3 | tx_240_b0_3_5 | FFF81051 | RAM FFF81051 on LT8H300D; the 2021 WRX's 0x144 warmup_counter comes from the same byte (FFF81163 on the WRX), not checked bit by bit. |
| 0x240 | 0.6 | 1 | tx_240_b0_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x240 | 0.7 | 1 | tx_240_b0_7_7 | FFF89AAE | RAM FFF89AAE on LT8H300D; the 2021 WRX's 0x360 ac_request comes from the same byte (FFF89386 on the WRX), not checked bit by bit. |
| 0x240 | 1.0 | 4 | tx_240_b1_0_3 | FFF8C022 | RAM FFF8C022 on LT8H300D; no WRX signal on that variable. |
| 0x240 | 3.0 | 1 | tx_240_b3_0_0 | FFF89F27 | RAM FFF89F27 on LT8H300D; the 2021 WRX's 0x361 flag_89053b3 comes from the same byte (FFF89813 on the WRX), not checked bit by bit. |
| 0x240 | 3.1 | 1 | tx_240_b3_1_1 | FFF89912 | RAM FFF89912 on LT8H300D; the 2021 WRX's 0x361 engine_not_rotating comes from the same byte (FFF891ED on the WRX), not checked bit by bit. |
| 0x240 | 3.2 | 1 | tx_240_b3_2_2 | FFF89F27 | RAM FFF89F27 on LT8H300D; the 2021 WRX's 0x361 flag_89053b3 comes from the same byte (FFF89813 on the WRX), not checked bit by bit. |
| 0x240 | 3.3 | 1 | tx_240_b3_3_3 | FFF89CF0 | RAM FFF89CF0 on LT8H300D; the 2021 WRX's 0x140 throttle_closed comes from the same byte (FFF895D4 on the WRX), not checked bit by bit. |
| 0x240 | 3.4 | 1 | tx_240_b3_4_4 | FFF89782 | RAM FFF89782 on LT8H300D; the 2021 WRX's 0x360 flag_8889Eb5 comes from the same byte (FFF8905E on the WRX), not checked bit by bit. |
| 0x240 | 3.5 | 2 | tx_240_b3_5_6 | FFF8C03F | RAM FFF8C03F on LT8H300D; no WRX signal on that variable. |
| 0x240 | 3.7 | 1 | tx_240_b3_7_7 | FFF89AAE | RAM FFF89AAE on LT8H300D; the 2021 WRX's 0x360 ac_request comes from the same byte (FFF89386 on the WRX), not checked bit by bit. |
| 0x240 | 4.0 | 3 | tx_240_b4_0_2 | FFF81052 | RAM FFF81052 on LT8H300D (FFF81164 on the WRX); no WRX signal on that variable. |
| 0x240 | 4.3 | 3 | tx_240_b4_3_5 | FFF81051 | RAM FFF81051 on LT8H300D; the 2021 WRX's 0x144 warmup_counter comes from the same byte (FFF81163 on the WRX), not checked bit by bit. |
| 0x240 | 4.6 | 2 | tx_240_b4_6_7 | FFF8C578 | RAM FFF8C578 on LT8H300D; no WRX signal on that variable. |
| 0x240 | 5.0 | 3 | tx_240_b5_0_2 | FFF89CEE | RAM FFF89CEE on LT8H300D; the 2021 WRX's 0x144 cruise_standby comes from the same byte (FFF895D2 on the WRX), not checked bit by bit. |
| 0x240 | 5.3 | 1 | tx_240_b5_3_3 | FFF89CEF | RAM FFF89CEF on LT8H300D; the 2021 WRX's 0x140 mil_request comes from the same byte (FFF895D3 on the WRX), not checked bit by bit. |
| 0x240 | 5.4 | 2 | tx_240_b5_4_5 | FFF89CED | RAM FFF89CED on LT8H300D; the 2021 WRX's 0x144 cruise_switch_taps comes from the same byte (FFF895D1 on the WRX), not checked bit by bit. |
| 0x240 | 5.6 | 1 | tx_240_b5_6_6 | FFF8B31D | RAM FFF8B31D on LT8H300D; the 2021 WRX's 0x144 drive_cycle_done comes from the same byte (FFF8A869 on the WRX), not checked bit by bit. |
| 0x240 | 5.7 | 1 | tx_240_b5_7_7 | FFF8C4E8 | RAM FFF8C4E8 on LT8H300D; the 2021 WRX's 0x144 torque_monitor_AC77b0 comes from the same byte (FFF8B8DD on the WRX), not checked bit by bit. |
| 0x240 | 6.0 | 3 | tx_240_b6_0_2 | FFF8C037 | RAM FFF8C037 on LT8H300D; the 2021 WRX's 0x141 drive_mode_applied comes from the same byte (FFF8B49F on the WRX), not checked bit by bit. |
| 0x240 | 6.3 | 1 | tx_240_b6_3_3 | FFF89D0A | RAM FFF89D0A on LT8H300D; the 2021 WRX's 0x140 accessory_load_flag comes from the same byte (FFF895EE on the WRX), not checked bit by bit. |
| 0x240 | 6.6 | 1 | tx_240_b6_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x240 | 7.5 | 1 | tx_240_b7_5_5 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x241 | 0.0 | 2 | tx_241_b0_0_1 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x241 | 0.2 | 1 | tx_241_b0_2_2 | FFF8C023 | RAM FFF8C023 on LT8H300D; no WRX signal on that variable. |
| 0x241 | 0.3 | 2 | tx_241_b0_3_4 | FFF8C03D | RAM FFF8C03D on LT8H300D; no WRX signal on that variable. |
| 0x241 | 0.5 | 1 | tx_241_b0_5_5 | FFF89CEA | RAM FFF89CEA on LT8H300D; the 2021 WRX's 0x141 flag_88E0Eb0 comes from the same byte (FFF895CE on the WRX), not checked bit by bit. |
| 0x241 | 0.6 | 2 | tx_241_b0_6_7 | FFF89785 | RAM FFF89785 on LT8H300D; the 2021 WRX's 0x360 cruise_lamp_main comes from the same byte (FFF89061 on the WRX), not checked bit by bit. |
| 0x241 | 1.0 | 4 | tx_241_b1_0_3 | FFF8C023 | RAM FFF8C023 on LT8H300D; no WRX signal on that variable. |
| 0x241 | 2.0 | 8 | tx_241_b2_0_7 | FFF8CD77 | RAM FFF8CD77 on LT8H300D; no WRX signal on that variable. |
| 0x241 | 3.0 | 8 | tx_241_b3_0_7 | FFF8CD76 | RAM FFF8CD76 on LT8H300D; no WRX signal on that variable. |
| 0x241 | 4.3 | 3 | tx_241_b4_3_5 | FFF8C03D | RAM FFF8C03D on LT8H300D; no WRX signal on that variable. |
| 0x241 | 4.6 | 2 | tx_241_b4_6_7 | FFF89CEF | RAM FFF89CEF on LT8H300D; the 2021 WRX's 0x140 mil_request comes from the same byte (FFF895D3 on the WRX), not checked bit by bit. |
| 0x241 | 5.0 | 1 | tx_241_b5_0_0 | FFF81054 | RAM FFF81054 on LT8H300D; the 2021 WRX's 0x361 maint_flag_811E0 comes from the same byte (FFF81166 on the WRX), not checked bit by bit. |
| 0x241 | 5.1 | 1 | tx_241_b5_1_1 | FFF8C279 | RAM FFF8C279 on LT8H300D; the 2021 WRX's 0x141 charging_flag_AA6Bb7 comes from the same byte (FFF8B699 on the WRX), not checked bit by bit. |
| 0x241 | 5.5 | 1 | tx_241_b5_5_5 | FFF89CEA | RAM FFF89CEA on LT8H300D; the 2021 WRX's 0x141 flag_88E0Eb0 comes from the same byte (FFF895CE on the WRX), not checked bit by bit. |
| 0x241 | 5.6 | 1 | tx_241_b5_6_6 | FFF8978B | RAM FFF8978B on LT8H300D; the 2021 WRX's 0x140 status_89AB6 comes from the same byte (FFF89067 on the WRX), not checked bit by bit. |
| 0x241 | 6.0 | 5 | tx_241_b6_0_4 | FFF8C03B | RAM FFF8C03B on LT8H300D; no WRX signal on that variable. |
| 0x241 | 6.6 | 2 | tx_241_b6_6_7 | FFF89785 | RAM FFF89785 on LT8H300D; the 2021 WRX's 0x360 cruise_lamp_main comes from the same byte (FFF89061 on the WRX), not checked bit by bit. |
| 0x241 | 7.0 | 8 | tx_241_b7_0_7 | FFF8C389 | RAM FFF8C389 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 0.0 | 3 | tx_345_b0_0_2 | FFF8C024 | RAM FFF8C024 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 0.3 | 1 | tx_345_b0_3_3 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x345 | 0.4 | 2 | tx_345_b0_4_5 | FFF8C043 | RAM FFF8C043 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 0.6 | 1 | tx_345_b0_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x345 | 0.7 | 1 | tx_345_b0_7_7 | FFF899C0 | RAM FFF899C0 on LT8H300D (FFF8929A on the WRX); no WRX signal on that variable. |
| 0x345 | 1.0 | 4 | tx_345_b1_0_3 | FFF8C024 | RAM FFF8C024 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 1.4 | 2 | tx_345_b1_4_5 | FFF8C043 | RAM FFF8C043 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 2.0 | 7 | coding_byte_345 | FFF8C039 | Same ECU variable as the 2021 WRX's 0x144 coding_byte (RAM FFF8C039 on LT8H300D, FFF8B4A1 on the WRX, vote). Bit-permuted copy of cal 0x58B7A (0x0A) -> 0x24 constant on this ROM |
| 0x345 | 2.7 | 1 | tx_345_b2_7_7 | FFF899C0 | RAM FFF899C0 on LT8H300D (FFF8929A on the WRX); no WRX signal on that variable. |
| 0x345 | 3.0 | 8 | tx_345_b3_0_7 | FFF8C07B | RAM FFF8C07B on LT8H300D; no WRX signal on that variable. |
| 0x345 | 4.0 | 8 | tx_345_b4_0_7 | FFF8C08B | RAM FFF8C08B on LT8H300D; no WRX signal on that variable. |
| 0x345 | 5.0 | 8 | tx_345_b5_0_7 | FFF8C069 | RAM FFF8C069 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 6.0 | 8 | tx_345_b6_0_7 | FFF8C064 | RAM FFF8C064 on LT8H300D; no WRX signal on that variable. |
| 0x345 | 7.0 | 8 | tx_345_b7_0_7 | FFF8C08D | RAM FFF8C08D on LT8H300D; no WRX signal on that variable. |
| 0x346 | 0.0 | 1 | tx_346_b0_0_0 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x346 | 0.1 | 2 | tx_346_b0_1_2 | FFF8C025 | RAM FFF8C025 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 0.3 | 1 | tx_346_b0_3_3 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x346 | 0.4 | 1 | tx_346_b0_4_4 | FFF89CEA | RAM FFF89CEA on LT8H300D; the 2021 WRX's 0x141 flag_88E0Eb0 comes from the same byte (FFF895CE on the WRX), not checked bit by bit. |
| 0x346 | 0.5 | 1 | tx_346_b0_5_5 | FFF8A12C | RAM FFF8A12C on LT8H300D; the 2021 WRX's 0x362 lin_status_89245b0 comes from the same byte (FFF89A0D on the WRX), not checked bit by bit. |
| 0x346 | 0.6 | 1 | tx_346_b0_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x346 | 0.7 | 1 | tx_346_b0_7_7 | FFF8AB48 | RAM FFF8AB48 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 1.0 | 4 | tx_346_b1_0_3 | FFF8C025 | RAM FFF8C025 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 1.4 | 1 | tx_346_b1_4_4 | FFF89CEA | RAM FFF89CEA on LT8H300D; the 2021 WRX's 0x141 flag_88E0Eb0 comes from the same byte (FFF895CE on the WRX), not checked bit by bit. |
| 0x346 | 1.5 | 1 | tx_346_b1_5_5 | FFF8A12C | RAM FFF8A12C on LT8H300D; the 2021 WRX's 0x362 lin_status_89245b0 comes from the same byte (FFF89A0D on the WRX), not checked bit by bit. |
| 0x346 | 1.6 | 1 | tx_346_b1_6_6 | FFF89CEA | RAM FFF89CEA on LT8H300D; the 2021 WRX's 0x141 flag_88E0Eb0 comes from the same byte (FFF895CE on the WRX), not checked bit by bit. |
| 0x346 | 1.7 | 1 | tx_346_b1_7_7 | FFF8AB48 | RAM FFF8AB48 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 2.0 | 8 | tx_346_b2_0_7 | FFF8CD93 | RAM FFF8CD93 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 3.0 | 8 | tx_346_b3_0_7 | FFF8CD92 | RAM FFF8CD92 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 4.0 | 8 | tx_346_b4_0_7 | FFF8C079 | RAM FFF8C079 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 5.0 | 8 | tx_346_b5_0_7 | FFF8C075 | RAM FFF8C075 on LT8H300D; no WRX signal on that variable. |
| 0x346 | 6.0 | 8 | tx_346_b6_0_7 | FFF8C08C | RAM FFF8C08C on LT8H300D; no WRX signal on that variable. |
| 0x346 | 7.0 | 8 | tx_346_b7_0_7 | FFF8C08E | RAM FFF8C08E on LT8H300D; no WRX signal on that variable. |
| 0x347 | 0.0 | 1 | tx_347_b0_0_0 | FFF8C026 | RAM FFF8C026 on LT8H300D; no WRX signal on that variable. |
| 0x347 | 0.1 | 1 | tx_347_b0_1_1 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x347 | 0.2 | 1 | tx_347_b0_2_2 | FFF8C026 | RAM FFF8C026 on LT8H300D; no WRX signal on that variable. |
| 0x347 | 0.3 | 1 | tx_347_b0_3_3 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x347 | 0.4 | 2 | tx_347_b0_4_5 | FFF8C074 | RAM FFF8C074 on LT8H300D; no WRX signal on that variable. |
| 0x347 | 0.6 | 1 | tx_347_b0_6_6 | FFF89CE8 | RAM FFF89CE8 on LT8H300D; the 2021 WRX's 0x144 cruise_meter_flag_b6 comes from the same byte (FFF895CC on the WRX), not checked bit by bit. |
| 0x347 | 0.7 | 1 | tx_347_b0_7_7 | FFF8C074 | RAM FFF8C074 on LT8H300D; no WRX signal on that variable. |
| 0x347 | 1.0 | 4 | tx_347_b1_0_3 | FFF8C026 | RAM FFF8C026 on LT8H300D; no WRX signal on that variable. |
| 0x347 | 1.4 | 4 | tx_347_b1_4_7 | FFF8C074 | RAM FFF8C074 on LT8H300D; no WRX signal on that variable. |
| 0x6FC | 0.0 | 4 | lin_battery_b0_6fc | FFF8A29E | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b0 (RAM FFF8A29E on LT8H300D, FFF89B6E on the WRX, vote). LIN battery-sensor block, low nibble of FFF893A6. 0x6FC is sent every 100 ms by ROMs whose table has it in mailbox 15 (they do not receive 0x15A). |
| 0x6FC | 1.0 | 8 | lin_battery_b1_6fc | FFF8A2A1 | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b1 (RAM FFF8A2A1 on LT8H300D, FFF89B71 on the WRX, vote). LIN battery-sensor value FFF893A9. |
| 0x6FC | 2.0 | 8 | lin_battery_b2_6fc | FFF8A2A2 | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b2 (RAM FFF8A2A2 on LT8H300D, FFF89B72 on the WRX, vote). LIN battery-sensor value FFF893AA. |
| 0x6FC | 3.0 | 8 | lin_battery_b3_6fc | FFF8A2A3 | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b3 (RAM FFF8A2A3 on LT8H300D, FFF89B73 on the WRX, vote). LIN battery-sensor value FFF893AB. |
| 0x6FC | 4.0 | 8 | lin_battery_b4_6fc | FFF8A8A7 | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b4 (RAM FFF8A8A7 on LT8H300D, FFF8A177 on the WRX, vote). ECU value FFF899AF (LIN battery-sensor processing). |
| 0x6FC | 5.0 | 5 | lin_battery_b5_6fc | FFF8A29F | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b5 (RAM FFF8A29F on LT8H300D, FFF89B6F on the WRX, vote). LIN battery-sensor value FFF893A7, bits 0-4. |
| 0x6FC | 6.0 | 8 | lin_battery_b6_6fc | FFF8A2A0 | Same ECU variable as the 2021 WRX's 0x6FC lin_battery_b6 (RAM FFF8A2A0 on LT8H300D, FFF89B70 on the WRX, vote). LIN battery-sensor value FFF893A8. |
