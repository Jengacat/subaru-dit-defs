# FA20DIT CAN dictionary

Every CAN frame the FA20DIT engine ECU (Hitachi SH72543R: 2015-2018 WRX, 2014-2018 Levorg, 2016-2018 Forester XT / tS) receives and sends, for **31 complete ROMs**. 500 kbit/s, 11-bit IDs.

## How this was made

* The meanings, scaling and confidence come from a full map of one ROM (LF75404S, 2015 USDM WRX 6MT), made by reading its receive decoder, transmit packer and the code that uses each value.
* Each ROM was then **run in an emulator**: its own network selector picks its ID table, its own receive decoder is fed every bit of every frame, and its own transmit packer is fed every bit of every value it reads. Which RAM bit each frame bit lands in (or comes from) was recorded and compared with LF75404S through a RAM address map. So the bit layout for every ROM below is what that ROM's code does, not an assumption that it matches LF75404S.
* **Confidence:** *read* = taken from the code; *inferred* = interpretation of what the code does; *unknown* / *meaning unknown* = the bits are decoded or sent, but what they mean is not established.
* Addresses quoted in the meanings (FFF8xxxx RAM, 0x0xxxxx code, cal 0x0xxxxx) are **LF75404S's**. The RAM address of each signal in every ROM is in `FA20DIT_CAN_RAM.csv`.
* Byte 0 = first data byte, bit 0 = least significant bit. Multi-byte values are little-endian (low byte first) unless marked BE. physical = raw x scale + offset.

## Conventions on this bus (all ROMs)

* The ECU polls its receive mailboxes every 10 ms; a frame shorter than its expected length is ignored.
* Rolling counters are only checked for being frozen (same value for 2 s = invalid), never for sequence. A frame missing for 0.5 s is "lost" and its sender's U-code group applies fallbacks.
* The only checksum: 0x161 byte 7 = sum of bytes 0-6 (mod 256).
* Transmit starts 190 ms after CAN start and stops on bus-off or UDS 0x28 (communication control).
* **TCM frames 0x148 / 0x149 / 0x368 are decoded only on ROMs coded AT/CVT.** On the manual-transmission coding the decoder throws them away every pass and uses fixed fallbacks (no TCM U-code is set). The bit layout below is what the decoder uses when the coding allows it.

## ROM groups

ROMs in one group have the same IDs and use exactly the same bits.

| Group | ROM | Year | Market | Model | Transmission | ID table |
|---|---|---|---|---|---|---|
| A | LF75200T | 2015 | Canada | WRX | AT/CVT | 0x1E71D4 |
| A | LF75300F | 2015 | JDM | WRX S4 | AT/CVT | 0x1F946C |
| A | LF75300H | 2016 | USDM | WRX | MT | 0x1F946C |
| A | LF75300L | 2015 | not confirmed | WRX | AT/CVT | 0x1F946C |
| A | LF75300S | 2015 | USDM | WRX | MT | 0x1F946C |
| A | LF75301K | 2016 | Singapore | WRX | MT | 0x1F946C |
| A | LF75301P | 2015 | Middle East | WRX | MT | 0x1F946C |
| A | LF75401D | 2014 | JDM | Levorg 2.0 | CVT (model) | 0x1F946C |
| A | LF75404S | 2015 | USDM | WRX | MT | 0x1F946C |
| B | LF78001H | 2016 | ADM | Forester tS | AT/CVT | 0x1F7580 |
| B | LF78002H | 2017 | ADM | Forester XT | CVT (model) | 0x1F75BC |
| C | LF78103B | 2017 | USDM | Forester XT | AT/CVT | 0x1F7898 |
| D | LF79002P | 2017 | USDM | WRX | MT | 0x1F77DC |
| D | LF79100N | 2017 | not confirmed | WRX | AT/CVT | 0x1F7818 |
| D | LF79100P | 2017 | USDM | WRX | MT | 0x1F7818 |
| E | LF79100K | not stated | JDM | Levorg 2.0 STI | CVT (model) | 0x1F7418 |
| E | LF79100S | 2017 | ADM | Levorg 2.0GT-S | CVT (model) | 0x1F7418 |
| E | LF79200T | not stated | JDM | Levorg | CVT (model) | 0x1F7418 |
| E | LF79202U | not stated | JDM | Levorg | CVT (model) | 0x1F7418 |
| E | LF79300T | not stated | JDM | Levorg | CVT (model) | 0x1F7418 |
| F | LF9C000C | 2017 | EDM | Forester XT | AT/CVT | 0x1F75B8 |
| G | LF9C001K | 2018 | JDM | WRX S4 | AT/CVT | 0x1F72B8 |
| H | LF9C001P | 2018 | USDM | WRX | MT | 0x1F76B8 |
| H | LF9C100P | 2018 | USDM | WRX | MT | 0x1F76B8 |
| I | LV9N000C | 2015 | USDM | Forester XT | AT/CVT | 0x1CB3CC |
| I | LV9N100A | 2014 | JDM | Levorg 2.0GT-S | CVT (model) | 0x1CB8AC |
| I | LV9N100B | 2015 | JDM | WRX S4 | AT/CVT | 0x1CB8AC |
| I | LV9N100F | 2015 | ADM | WRX | MT | 0x1CB8AC |
| I | LV9N101C | 2015 | USDM | WRX | AT/CVT | 0x1CB8AC |
| I | LV9N101F | 2015 | not confirmed | WRX | MT | 0x1CB8AC |
| I | LV9N101I | 2015 | GCC | WRX | MT | 0x1CB8AC |

What differs between groups (everything else is identical in all groups):

* **B** (LF78001H, LF78002H): has 0x142, 0x162, 0x6FC; no 0x15A, 0x188, 0x362; also uses 0x361 value_361_b5_6, 0x361 value_361_b7; does not use 0x141 charging_flag_AA6Bb7.
* **C** (LF78103B): has 0x162, 0x6FC; no 0x15A, 0x188; also uses 0x361 value_361_b5_6, 0x361 value_361_b7, 0x362 battery_soc_low_nibble; does not use 0x141 charging_flag_AA6Bb7.
* **D** (LF79002P, LF79100N, LF79100P): has 0x6FC; no 0x15A; also uses 0x362 battery_soc_low_nibble.
* **E** (LF79100K, LF79100S, LF79200T, LF79202U, LF79300T): also uses 0x362 battery_soc_low_nibble.
* **F** (LF9C000C): has 0x142, 0x162; no 0x15A, 0x188, 0x362; also uses 0x361 value_361_b5_6, 0x361 value_361_b7, 0x161 rx_161_b5_7_7, 0x368 rx_368_b0_7_7, 0x3D1 rx_3d1_b7_2_6; does not use 0x141 charging_flag_AA6Bb7.
* **G** (LF9C001K): also uses 0x362 battery_soc_low_nibble, 0x0D1 rx_0d1_b3_2_2, 0x161 rx_161_b5_7_7, 0x188 rx_188_b6_6_6, 0x368 rx_368_b0_7_7, 0x3D1 rx_3d1_b7_2_6.
* **H** (LF9C001P, LF9C100P): has 0x6FC; no 0x15A; also uses 0x362 battery_soc_low_nibble, 0x0D1 rx_0d1_b3_2_2, 0x161 rx_161_b5_7_7, 0x188 rx_188_b6_6_6, 0x368 rx_368_b0_7_7, 0x3D1 rx_3d1_b7_2_6.
* **I** (LV9N000C, LV9N100A, LV9N100B, LV9N100F, LV9N101C, LV9N101F, LV9N101I): does not use 0x148 tcm148_b7_bit4, 0x148 tcm148_b7_bit5, 0x152 bcm152_b6_bit2, 0x361 flag_88E13b1, 0x361 flag_88E13b2.

## Messages

| ID | Direction | Sender | Period | DLC | ROM groups |
|---|---|---|---|---|---|
| 0x0D0 | ECU receives | VDC | timeout 30 ms | 8 | all |
| 0x0D1 | ECU receives | VDC | timeout 30 ms | 4 | all |
| 0x0D2 | ECU receives | VDC | timeout 30 ms | 8 | all |
| 0x0D3 | ECU receives | VDC | timeout 30 ms | 7 | all |
| 0x0D4 | ECU receives | VDC | timeout 30 ms | 8 | all |
| 0x140 | ECU sends | ECM | 10 ms | 8 | all |
| 0x141 | ECU sends | ECM | 10 ms | 8 | all |
| 0x142 | ECU sends | ECM | 50 ms | 8 | B, F |
| 0x144 | ECU sends | ECM | 20 ms | 8 | all |
| 0x148 | ECU receives | TCM | timeout 20 ms | 8 | all |
| 0x149 | ECU receives | TCM | timeout 20 ms | 8 | all |
| 0x152 | ECU receives | BCM | timeout 30 ms | 8 | all |
| 0x15A | ECU receives | unknown | timeout 30 ms | 8 | A, E, G, I |
| 0x161 | ECU receives | unknown driver-assist/cruise unit | timeout 60 ms | 8 | all |
| 0x162 | ECU receives | unknown sender |  | 8 | B, C, F |
| 0x188 | ECU receives | unknown | timeout 40 ms | 8 | A, D, E, G, H, I |
| 0x280 | ECU receives | unknown, A/C-related | timeout 30 ms | 8 | all |
| 0x282 | ECU receives | combination meter | timeout 60 ms | 8 | all |
| 0x360 | ECU sends | ECM | 50 ms | 8 | all |
| 0x361 | ECU sends | ECM | 50 ms | 8 | all |
| 0x362 | ECU sends | ECM | 50 ms | 8 | A, C, D, E, G, H, I |
| 0x368 | ECU receives | TCM | timeout 60 ms | 8 | all |
| 0x370 | ECU receives | unknown | timeout 60 ms | 8 | all |
| 0x372 | ECU receives | unknown | timeout 110 ms | 8 | all |
| 0x3D1 | ECU receives | combination meter group | timeout 30 ms | 8 | all |
| 0x660 | ECU receives | BCM group | timeout 510 ms | 8 | all |
| 0x6FC | ECU sends | ECM | 100 ms | 8 | B, C, D, H |
| 0x771 | ECU sends | ECM |  | 8 | all |
| 0x772 | ECU sends | ECM |  | 8 | all |
| 0x773 | ECU sends | ECM |  | 8 | all |
| 0x774 | ECU sends | ECM |  | 8 | all |
| 0x775 | ECU sends | ECM |  | 8 | all |
| 0x7DF | ECU receives |  |  | 8 | all |
| 0x7E0 | ECU receives |  |  | 8 | all |

### 0x0D0 (received, from VDC)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 6 | all | vdc0d0_b6 | signed x 1 | -> 0x11637C (gated by cal 0x364F3 b6) -> FFF8A8D1 / B406 / B452; meaning not determined | inferred | all |
| 7 | all | vdc0d0_b7 | signed x 1 | as byte 6 | inferred | all |

### 0x0D1 (received, from VDC)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | vehicle_speed | km/h x 0.05625 | -> 0x118D9C -> FFF8B4C2 -> 0x06C21C -> FFF88BE8 (ECU vehicle speed, x17.78) and FFF99835 (km/h); fallback 10 km/h on VDC fault | read | all |
| 2 | all | brake_pressure | raw | brake override 0x181B38 (FFF8AC94), 0x0DE0E0, 0x0EE338, 0x111AB8 | inferred | all |
| 3 | 2 | rx_0d1_b3_2_2 | raw | Used only by the ROMs listed; meaning not determined. | read (meaning unknown) | G, H |

### 0x0D2 (received, from VDC)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | vdc_torque_request | Nm x 0.1 -1000 | -> 0x116264 -> FFF8B470 (applied only while FFF8A89F b2 = byte4 bit1 and value > 10000 and FFF886AB b5); fallback 10000 (0 Nm) | inferred | all |
| 2-3 | LE u16 | vdc_torque_limit | Nm x 0.1 -1000 | -> 0x117778 -> FFF8B47C/B464/B466 (torque module 0x0BE694, monitors 0x189DF0/0x1A8D6C); fallback 0x3700 (+408 Nm) | inferred | all |
| 4 | 0 | vdc0d2_b4_bit0 | raw | 0x117778 select, 0x11B594 -> FFF8A89F b3 | read | all |
| 4 | 1 | vdc0d2_b4_bit1 | raw | torque-request enable (0x11B814 -> FFF8A89F b2) | read | all |
| 4 | 2 | vdc0d2_b4_bit2 | raw | 0x1191D4 -> FFF8A89F b1 | read | all |
| 5 | 0 | vdc0d2_b5_bit0 | raw | 0x115438 (SI-Drive arbitration), 0x0BE694 | read | all |

### 0x0D3 (received, from VDC)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 1 | 0-2 | vdc0d3_b1 | raw | b0/b1 -> 0x11BBB4 -> FFF8A898, FFF8A8A1 b7 | read | all |
| 2 | 0-3 | vdc0d3_b2_lo | raw | 0x1191D4, 0x11A0C4 (FFF8A8A2 b7), 0x11FA38 | read | all |
| 2 | 7 | vdc0d3_b2_bit7 | raw | brake override validity 0x181978 | read | all |
| 3 | 1 | vdc0d3_b3_bit1 | raw | 0x113894 (FFF8A8D1 path) | read | all |
| 3 | 2 | vdc0d3_b3_bit2 | raw | speed/VDC status: 0x06EDDC, cruise speed 0x16C2D0 | read | all |
| 3 | 3 | vdc0d3_b3_bit3 | raw | 0x115438 SI-Drive, brake override 0x181978 | read | all |
| 3 | 7 | vdc0d3_b3_bit7 | raw | 0x11BD48 -> FFF8A89F b0; FFF9BA24..26 delay line (0x0B5758) | read | all |
| 6 | all | vdc0d3_counter | raw | rolling counter; U0416 if unchanged 200 passes | read | all |

### 0x0D4 (received, from VDC)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | wheel_speed_1 | km/h x 0.05625 | -> FFF8B4C0 | inferred | all |
| 2-3 | LE u16 | wheel_speed_2 | km/h x 0.05625 | -> FFF8B4C4 | inferred | all |
| 4-5 | LE u16 | wheel_speed_3 | km/h x 0.05625 | -> FFF8B4C6 | inferred | all |
| 6-7 | LE u16 | wheel_speed_4 | km/h x 0.05625 | -> FFF8B4C8 | inferred | all |

### 0x140 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | all | accel_pedal_raw | % x 0.392157 | Accelerator pedal, channel-1 position through Accelerator Pedal Scaling (0..65535) high byte; fallback cal 0x573C4 on pedal fault | read/inferred | all |
| 1 | 0-3 | rolling_counter | count | 4-bit rolling counter 0..15, +1 per 10 ms (= per frame); 0..7 in variants 0 | read | all |
| 1 | 4 | mil_request | flag | MIL requested: FFF99809 b3 (DTC confirmed, MIL on) OR FFF88E69 b1 (flashing-MIL DTC) | read/inferred | all |
| 1 | 5 | etc_fault | flag | Copy of FFF8A2B8 b7: electronic-throttle fault with motor drive off (Phase 13 TE) | read/inferred | all |
| 1 | 6 | ac_compressor_on | flag | A/C compressor output engaged (A/C module 0x121B90) | inferred | all |
| 1 | 7 | clutch_switch_latched | flag | MT only: FFF88E62 b1 (pin PA14, active low) latched while MT coding FFF88ADA b7, released after cal 0x5780F passes; clutch pedal switch (inferred) | inferred | all |
| 2-3 | LE, 14 bits from bit 0 | engine_speed | rpm x 1 | Engine speed, 1 rpm/bit (CD54 = rpm x 5.12), 14 bits | read | all |
| 3 | 6 | pedal_released | flag | Accelerator fully released (0x09FF9A, Phase 11 A) | read | all |
| 3 | 7 | dtc_setting_off | flag | Set by UDS 0x85 ControlDTCSetting 0x02 (off) in session 2/3 (0x0B54AC); cleared at reset/0x0B7730 | read | all |
| 4 | all | cruise_virtual_pedal | % x 0.392157 | Cruise module pedal-equivalent request (B9AC, written by 0x168864); 0 when not cruising | inferred | all |
| 5 | all | accel_pedal_effective | % x 0.392157 | Pedal used by the torque request: FFF88A5E, or max(pedal, B9AC) while cruise (FFF88E12 b1) | read | all |
| 6 | all | throttle_opening | % x 0.392157 | Throttle opening: 888A4 = FFF88A3A x 25600 / cal 0x35AFE (43515); 255 ~ 100 % (scale inferred) | inferred | all |
| 7 | 0 | throttle_closed | flag | Throttle byte FFF8CD77 <= cal 0x3550C (3), +cal 0x3550D (2) hysteresis: throttle (nearly) closed | read | all |
| 7 | 1 | status_89AB6 | flag | FFF89AB6 != 0; 89AB6 set/cleared by a serial handshake in 0x090E8A/0x09203A (not decoded) | unknown | all |
| 7 | 2 | pin_PA2 | flag | Raw discrete input A29A b4 = pin PA2 (active low) masked by cal 0x5693A (=0) | read (meaning unknown) | all |
| 7 | 5 | accessory_load_flag | flag | FFF8A8A0 b0, or (coding FFF811DC != 0x5A) input FFF88BC6 b4 (pin PA4); the flag that enables Idle Air Adder (CAN 0x280 Stage) | read/inferred | all |

### 0x141 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE, 15 bits from bit 0 | torque_request | Nm x 0.1 -1000 | Driver torque request after the external limit (AEA6) x AEA0 (=1.0 stock): 10000 + 10 x Nm; with the pedal released: 10000 - 10 x friction (B46C) | read/inferred | all |
| 1 | 7 | ac_flag_A9A3b1 | flag | A/C module 0x121B90 output bit (not decoded) | unknown | all |
| 2-3 | LE, 15 bits from bit 0 | torque_actual | Nm x 0.1 -1000 | Estimated engine torque: DAM-weighted torque-from-load (B490/B4A2) through 05D3D8/05D3E4, minus losses AF62 and an idle term; 10000 + 10 x Nm, floor 0 | inferred | all |
| 4-5 | LE, 14 bits from bit 0 | engine_speed_filtered | rpm x 1 | Filtered engine speed (CE9C, weight B73E); with an AT it tracks the TCM speed FFF8924E (0x149); 0 when FFF88A28 b1 clear or engine not rotating | inferred | all |
| 5 | 7 | pedal_flag_88C64b4 | flag | Copy of FFF88C64 b4 (pedal module 0x09F282, not decoded) | unknown | all |
| 6 | 0-2 | gear_mt | gear x 1 | Gear 1..6 as binary; 7 when neutral (FFF88ADA b6); hold otherwise; 0 when not MT | read | all |
| 6 | 3 | flag_88E0Eb0 | flag | From 88A27 b0, 88ADA b3, 89010 b0, module voltage 88A7E, coolant 88A44, A82E b7 | unknown | all |
| 6 | 4 | crank_or_low_voltage | flag | 0 only when 88A27 b0 and 88ADA b3 clear, module voltage FFF88A7E > 0x6666 and a start timer (cal 0x35B06) expired | inferred | all |
| 6 | 5 | below_rev_limit | flag | rpm < AED4 + cal 0x3552C and (rpm < A62E x 128 + cal 0x3552E or A63D b0 clear) | inferred | all |
| 6 | 6 | torque_flag_A63Db0 | flag | Torque module 0x0BE694 status bit | unknown | all |
| 7 | 0-2 | drive_mode_applied | code x 1 | SI-Drive mode applied (A8C3): mode1 (default) -> b1b0=11, mode2 (Sport) -> b0, mode3 (Intelligent) -> b1, mode4 (Sport Sharp) -> b2; positions inferred from the stock maps (Phase 22) | read | all |
| 7 | 3 | flag_A64Cb1 | flag | copy | unknown | all |
| 7 | 4 | drive_mode_flag_A643 | flag | FFF8A643 in {1,2,3} | read (meaning unknown) | all |
| 7 | 5 | drive_mode_req_4 | flag | Last accepted requested mode A8C2 == 4 | read | all |
| 7 | 6 | charging_flag_AA6Bb7 | flag | Charging-control module 0x13741C status bit (sent while cal 0x57584 b4 = 0) | unknown | A, D, E, G, H, I |
| 7 | 7 | booster_sensor_fault | flag | Brake-booster pressure sensor FFF88D0C out of range low/high (0x071B82, cal 0x57585 b5) | read/inferred | all |

### 0x142 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE, 15 bits from bit 0 | value_142 | raw | 16-bit ECU value FFF8B4B2 (low 15 bits, low byte first). 0x142 is sent instead of 0x362 by ROMs on the alternate network table. | read (meaning unknown) | B, F |
| 1 | 7 | flag_142_A9A2b6 | flag | FFF8A9A2 b6 (the byte whose b7 is the A/C compressor flag in 0x140). | read (meaning unknown) | B, F |
| 2 | all | value_142_b2 | raw | ECU value FFF8A8E7. | read (meaning unknown) | B, F |

### 0x144 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 2 | cruise_switch_flag | flag | Cruise switch decoder 0x08DF14 bit | unknown | all |
| 0 | 3-5 | cruise_switch_code | code x 1 | Cruise lever switches FFF88EC9 b0/b1/b3/b2 one-hot-ish: b3 = b0 or b3 alone, b4 = b1 or b3 alone, b5 = b2 alone (held otherwise) | read/inferred | all |
| 0 | 6 | cruise_meter_flag_b5 | flag | Cruise module 0x16557C (0x16EC9C), meter-related cruise state | inferred | all |
| 0 | 7 | cruise_meter_flag_b6 | flag | Cruise module 0x16557C (0x16EE1C) | inferred | all |
| 1 | 1 | drive_cycle_done | flag | Set once counters 89D3A >= 600, 89D3C >= 300, 89D3E >= 30 (OBD driving-cycle criteria, inferred) | inferred | all |
| 1 | 3 | torque_monitor_AC77b0 | flag | 0x17B0E8/0x17B268 | unknown | all |
| 1 | 4-7 | cruise_switch_taps | bits x 1 | Cruise: b4 raise-switch tap, b5 raise edge, b6 lower-switch tap, b7 lower edge (Phase 18 C) | inferred | all |
| 2 | all | max_available_torque | Nm x 1.6 | (T_CAN - friction) x 0.625: T_CAN = Engine Torque from Load (CAN, DAM 1.0/0) blended by DAM; 255 = saturated | read/inferred | all |
| 3 | all | start_counter | count | Backup-RAM 8-bit wrap counter, +1 on each rising edge of FFF8AB8C b0 (engine-start event, 0x1739C8) in normal mode (AC78 = 0) | inferred | all |
| 4 | all | warmup_counter | count | Same for FFF8AB8D b0 (coolant-based event, 0x1739F4): warm-up cycle counter (inferred) | inferred | all |
| 5 | all | coding_byte | raw | Bit-permuted copy of cal 0x58B7A (0x0A) -> 0x24 constant on this ROM | read | all |
| 6 | 0 | cruise_standby | flag | Cruise ready/standby (0x16F194) | inferred | all |
| 6 | 1 | cruise_active | flag | Cruise controlling (max(pedal torque, cruise torque) used) | read | all |
| 6 | 2 | cruise_override | flag | Driver torque above cruise torque (0x16D1B4) | inferred | all |
| 6 | 3 | pin_PA15 | flag | Discrete pin PA15 (A298.2) | read (meaning unknown) | all |
| 6 | 4 | can_fault_latch | flag | Latched (until reset) when 88DD4 b4/b5/b6 (0x161 group U-codes) or A8A4 b3/b5 | read/inferred | all |
| 6 | 5 | cruise_unavailable | flag | 0 only when meter flags 811E1 b4 and b2 set and no fault (88BB2 b0, 88E13 b4/b0, A8A4 b1) | inferred | all |
| 6 | 6 | vdc_flag_inverted | flag | Inverted output of 0x11B5A4 (inputs incl. VDC request 888B6, MAP, coolant) | unknown | all |
| 6 | 7 | mt_coding | flag | Manual-transmission coding (1 on this car) | read | all |
| 7 | 0 | drive_mode_state | flag | Drive-mode state machine A8C0 in {2,3,4,5} | read | all |
| 7 | 1-3 | drive_mode_requested | code x 1 | Requested/accepted mode A8C2: bit1 = A8C2 in {1,2}, bit2 = in {1,3}, bit3 = (A8C2 == 4) | read | all |
| 7 | 5 | network_variant0_flag | flag | FFF88E0C b3: set only when the ECU runs network variant 0, so always 0 on these cars (all select variant 1). | read | all |
| 7 | 6 | cal_57ABC_b2 | flag | Copy of cal 0x57ABC b2 (0 -> always 0) | read | all |

### 0x148 (received, from TCM)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 0-3 | tcm148_b0_lo_code | raw | -> 0x1174EC -> FFF8A8DC (code map 0000->8, 0001->0, 0010->1, 0011->2, 0100->3, 1010->4, 1011->5, 1100->6, 1110->7, else hold); range/position-like (inferred) | read | all |
| 0 | 4-7 | tcm148_b0_hi_code | raw | -> 0x114304 -> FFF8A8B9 (0..8, latched on fresh frame) -> 0x083052 | read | all |
| 1 | 0-3 | tcm148_counter | raw | rolling counter, frozen-counter check 0x0683EE / U0402 0x078A92 | read | all |
| 1 | 4-6 | tcm148_b1_flags | raw | -> 0x1197E4 -> FFF8A8A1 b6 | read | all |
| 2-3 | LE, 14 bits from bit 0 | tcm148_word | raw | consumers 0x094218, 0x0EE338 (idle) | read | all |
| 6 | 0-3 | tcm148_b6_lo | raw | -> 0x117B18 -> FFF8A8E5 -> 0x116378 -> FFF8A8D0 (0x0C589C, 0x0EE338) and 0x121B90 | read | all |
| 6 | 4-7 | tcm148_gear | gear code x 1 | -> 0x1166F0 -> FFF8A8D5 (1..6, 0xD, 0xE, 0; others hold) -> FFF8A899 (0x08254C gear path, ignition 0x0DE0E0, cruise) | inferred | all |
| 7 | 0 | tcm148_b7_bit0 | raw |  | read | all |
| 7 | 1 | tcm148_b7_bit1 | raw |  | read | all |
| 7 | 2 | tcm148_b7_bit2 | raw |  | read | all |
| 7 | 4 | tcm148_b7_bit4 | raw |  | read | A, B, C, D, E, F, G, H |
| 7 | 5 | tcm148_b7_bit5 | raw |  | read | A, B, C, D, E, F, G, H |

### 0x149 (received, from TCM)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | all | tcm149_b0 | raw | consumers 0x13741C, 0x165AC4 (cruise) | read | all |
| 1 | 0-3 | tcm149_b1_lo | raw | b4-6 -> 0x10F464 -> FFF8A88F (0/2/4 blend request; read by torque, ignition, idle, boost) | read | all |
| 1 | 4 | tcm149_b1_bit4 | raw |  | read | all |
| 1 | 5 | tcm149_b1_bit5 | raw |  | read | all |
| 1 | 6 | tcm149_b1_bit6 | raw | no reader found | read | all |
| 1 | 7 | tcm149_b1_bit7 | raw | -> 0x0BE694 | read | all |
| 2 | all | tcm149_idle_target | rpm x 8 | minimum idle target in 0x0F222C (B240 = max(B22C, x*1024/25)) | inferred | all |
| 4 | all | tcm149_torque_limit | Nm x 2 | used by 0x117778 only when FFF88B80 b2 is set, which no variant-1 frame sets; fallback cal 0x572D0 = 0x55 | inferred | all |
| 5 | all | tcm149_b5 | raw | -> 0x0EE338 | read | all |
| 6-7 | LE, 14 bits from bit 0 | tcm149_word | raw | -> 0x13B308 | read | all |
| 7 | 7 | tcm149_b7_bit7 | raw |  | read | all |

### 0x152 (received, from BCM)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 1 | 0 | bcm152_b1_bit0 | raw | 0x11AC8C -> FFF8A8A0 b4 | read | all |
| 1 | 1 | bcm152_b1_bit1 | raw | 0x11AD44 -> FFF8A8A0 b3 | read | all |
| 1 | 2 | bcm152_b1_bit2 | raw | 0x11BEDC | read | all |
| 1 | 3 | bcm152_b1_bit3 | raw | 0x11B138 -> FFF8A8A0 b2; 0x11BEDC -> A8A0 b1 | read | all |
| 1 | 4-7 | bcm152_counter | raw | frozen-counter check 0x0687A8 | read | all |
| 6 | 0 | bcm152_b6_bit0 | raw | SI-Drive enable term in 0x11A8B0 | read | all |
| 6 | 2 | bcm152_b6_bit2 | raw |  | read | A, B, C, D, E, F, G, H |
| 6 | 3 | bcm152_b6_bit3 | raw |  | read | all |
| 6 | 4 | bcm152_b6_bit4 | raw |  | read | all |
| 6 | 5 | bcm152_b6_bit5 | raw | 0x11BDD4 -> FFF8A8A3 b3 | read | all |
| 6 | 6-7 | bcm152_b6_hi | raw | 0x11BD6C -> FFF8A8A3 b4 | read | all |
| 7 | 1 | bcm152_b7_bit1 | raw |  | read | all |
| 7 | 2 | bcm152_b7_bit2 | raw | idle air adder B1C4 (cal 0x25A72) in 0x0ECAE0 | read | all |
| 7 | 3 | bcm152_b7_bit3 | raw | idle air adder B1B6 (cal 0x25A62) in 0x0ECAE0 | read | all |
| 7 | 4 | bcm152_b7_bit4 | raw |  | read | all |
| 7 | 5 | bcm152_b7_bit5 | raw |  | read | all |
| 7 | 6 | bcm152_b7_bit6 | raw |  | read | all |
| 7 | 7 | bcm152_b7_bit7 | raw |  | read | all |

### 0x15A (received, from unknown)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 0-3 | m15a_counter | raw | frozen check 0x07B208 -> FFF88DD4 b7 | read | A, E, G, I |
| 2 | 0 | can_restart_req | raw | CAN restart (start-state 5); many readers (0x06A064, 0x06A166, fuel, ignition) | read | A, E, G, I |
| 2 | 2 | m15a_b2_bit2 | raw |  | read | A, E, G, I |
| 6 | 0-3 | engine_stop_code | raw | 0x115E08: FFF8A8C5 = 10 when nibble = 1010b -> 0x0827B2 (A6E7 = 3 mode) | read | A, E, G, I |
| 7 | 0-2 | m15a_b7 | raw | no reader found | read | A, E, G, I |

### 0x161 (received, from unknown driver-assist/cruise unit)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | m161_torque | Nm x 0.1 -1000 | -> 0x10E640 -> FFF8B3F8 (x*8-64000, floor 16000 = 0 Nm) -> cruise 0x16557C/0x1663AC, 0x18AFC4 | inferred | all |
| 2 | all | m161_b2 | raw | cruise flags (0x1196E0, 0x119624, 0x119CCC, 0x119CDC, 0x119DE4, 0x119EF8) | read | all |
| 3 | all | m161_b3 | raw | 0x118234 -> FFF8A8EE, 0x119624/0x1196E0 -> FFF8A8A4 b1/b2 | read | all |
| 5 | 2 | m161_b5_bit2 | raw |  | read | all |
| 5 | 4-6 | m161_counter | raw |  | read | all |
| 5 | 7 | rx_161_b5_7_7 | raw | Used only by the ROMs listed; meaning not determined. | read (meaning unknown) | F, G, H |
| 6 | 0-2 | m161_switch_code | raw | 0x10F504 -> FFF8A895 = CAN cruise switch code (used when FFF811E1 b4 and cal 0x36584 = 1) | read | all |
| 6 | 3 | m161_b6_bit3 | raw |  | read | all |
| 7 | all | m161_checksum | raw |  | read | all |

### 0x162 (received, from unknown sender)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 6 | 0-2 | rolling_counter_162 | count | Rolling counter (frozen check only). 0x162 is received instead of 0x188 by ROMs on the alternate network table; no other bit of it is decoded. | read | B, C, F |

### 0x188 (received, from unknown)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 2 | 1-3 | m188_counter | raw | frozen-counter check 0x068D2E -> FFF8A8A8 b6 | read | A, D, E, G, H, I |
| 4 | 0-2 | m188_code | raw | -> 0x1106D0 -> FFF8A89D (b0 + 2*b1 + 4*b2, 0 if b1 and b2) -> 0x11A060: FFF8A8A1 b3 = (code 5 for cal 0x35A94 = 70 passes) | read | A, D, E, G, H, I |
| 6 | 6 | rx_188_b6_6_6 | raw | Used only by the ROMs listed; meaning not determined. | read (meaning unknown) | G, H |

### 0x280 (received, from unknown, A/C-related)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 0 | ac280_b0_bit0 | raw | -> 0x1195AC (with FFF8A297 b2) -> FFF88B8B b0 = A/C request input of 0x080088 / 0x121B90 (inferred) | inferred | all |
| 0 | 1-3 | ac280_b0_code | raw | -> 0x114760 -> FFF8A8BF (0..7) -> idle 0x0EE338, 0x13741C; 0x11B090 -> FFF8A8A0 b0 | read | all |
| 1 | 0-3 | ac280_counter | raw | frozen-counter check 0x068556 | read | all |
| 1 | 7 | ac280_b1_bit7 | raw | -> 0x111AB8 | read | all |
| 2 | 7 | ac280_b2_bit7 | raw | FFF88B8E is read by 0x0EE338, 0x0F7618, 0x1CFD2E (bit not separated) | read | all |
| 3 | all | ac280_b3 | raw | radiator fan duty table input 05C998 (0x0F70B4, fan module 0x0F7618, off in stock) | read | all |
| 4 | 0-4 | ac280_b4_lo | raw | -> 0x116994 -> FFF8A8D9 (no reader) | read | all |
| 4 | 5-7 | ac280_b4_hi | raw | -> 0x10E8C4 -> FFF8A889 -> 0x10E9C0 -> FFF8A88A (0..6) -> idle 0x0EE338 / 0x10EA40 | read | all |
| 5 | all | ac280_b5 | % x 1 | FFF8A8C6 = cal 0x3555C (121) x / 100, cap 128 (0x115F80) -> idle, torque 0x0BE694, 0x080088 | inferred | all |
| 6 | 0 | ac280_b6_bit0 | raw | forces FFF8A8C6 = cal 0x35A85; set to 1 on frame loss | read | all |

### 0x282 (received, from combination meter)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE, 10 bits from bit 0 | meter_word | raw | -> 0x1108B8 -> FFF8B43C (0x06C336, SSM) | read | all |
| 1 | 3 | meter_b1_bit3 | raw |  | read | all |
| 1 | 4-7 | meter_counter | raw |  | read | all |
| 3 | all | meter_b3 | raw | fan table select 05C9BC/05C9B0 (cal 0x342EC = 148), torque 0x0BE694, 0x09621E, 0x0F7618 | read | all |
| 5 | 3 | si_drive_b3 | raw | SI-Drive: 0x115D10 -> FFF8A8C4 -> FFF8A8C1 | read | all |
| 5 | 4 | m282_b5_bit4 | raw | 0x11C330 -> FFF8A8A5 b3 | read | all |
| 5 | 5 | m282_b5_bit5 | raw | 0x11C330 | read | all |
| 5 | 6 | si_drive_b6 | raw |  | read | all |
| 5 | 7 | si_drive_b7 | raw |  | read | all |
| 6 | 4-7 | meter_code | raw | 0x10F344 -> FFF8A88C (0..15, market/units code, cruise tables) | read | all |
| 7 | 0 | cruise_option | raw | 0x119B54 -> FFF811E1 b4 after cal 0x35BEA = 10 passes | read | all |
| 7 | 1 | m282_b7_bit1 | raw | 0x119A20 -> FFF811E1 b2/b3 | read | all |
| 7 | 4 | m282_b7_bit4 | raw | 0x115E30 -> FFF811E3 = 0xA5 (clear) / 0x5A (set) after 10 passes | read | all |
| 7 | 7 | m282_b7_bit7 | raw | 0x11C4C8 -> FFF811DF b2/b5 (speed scale select) | read | all |

### 0x360 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | fuel_flow | unit not settled x 0.001 | 1000 x cal 0x35B32 (49917) x C230 x rpm_raw x 2.6375e-11/60 x cal 0x35B34/32768, C230 = sum of the 8 injector pulse words x 0.8 / 4; 0 when engine not rotating; clamp 65535 | read/inferred | all |
| 2 | all | oil_temp | degC x 1 -40 | Engine oil temperature (88A9D = degC+50); 40 (0 degC) when FFF88E2B b5 (oil sensor fault) | read | all |
| 3 | all | coolant_temp | degC x 1 -40 | Coolant temperature (Coolant Temp Sensor Scaling, degC+50); 0xFF when FFF88E28 b1 (sensor fault) | read | all |
| 4 | all | map | kPa abs x 2 | Manifold pressure, 2 kPa/bit, first-order filtered (cal 0x3650A); 7 when FFF88E28 b3 (MAP fault); init 0x33 | read/inferred | all |
| 5 | 0 | flag_888A7b1 | flag | Output of 0x11A9D8 (pedal, speed, drive mode, rpm inputs) | unknown | all |
| 5 | 1-3 | drive_mode_req_bits | code x 1 | b1/b2 = A8C2 code (as 0x144), b3 = A8C0 in {2..5} | read | all |
| 5 | 4 | cruise_lamp_main | flag | Cruise indicator (state 0xA0 standby, blink timer cal 0x409BC) | inferred | all |
| 5 | 5 | cruise_lamp_set | flag | Cruise SET indicator (controlling, cal 0x409CC) | inferred | all |
| 5 | 6 | engine_warm_latch | flag | Latched once FFF88A44 > cal 0x35BDA | read/inferred | all |
| 5 | 7 | flag_ACECb4 | flag | Module 0x19818C | unknown | all |
| 6 | 0 | flag_88E14b0 | flag | 1 with MT coding, else coolant FFF8CD65 < cal 0x35518 (0) | read | all |
| 6 | 1 | elec_load_flag | flag | 0 when A290 b5 clear and load word B458 (CAN 0x370) below cal 0x35AA0 (hyst 0x35AA2) | inferred | all |
| 6 | 2 | flag_88E14b4 | flag | 0x11C440(coolant, MT coding, AC78, 88EA2 b3, 88B8C b7) | unknown | all |
| 6 | 3 | flag_8889Eb5 | flag | 0x11B4A8(engine state 906B, coolant at start 88A46, coolant) | unknown | all |
| 6 | 4 | rad_fan_1 | flag | Radiator fan stage >= 1 output (cal 0x57584 b3 = 0) | read | all |
| 6 | 5 | rad_fan_2 | flag | Radiator fan stage 2 output (port PF6) | read | all |
| 6 | 6 | ac_switch_PA8 | flag | Discrete pin PA8 (A/C-load switch, Phase 16) | read | all |
| 6 | 7 | ac_request | flag | A/C request (pin PH4 or CAN) | read | all |
| 7 | all | cruise_set_speed | km/h or mph x 1 | Cruise set speed B9FC (km/h x 128) rounded; x1000/1609 (mph) when A8A7 b0 (mph meter); 0 when main switch off | read | all |

### 0x361 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 0-2 | gear_calc | gear x 1 | Gear 1..6 binary from 0x114230 (20 ms gear logic; shift-indicator gear, inferred) | inferred | all |
| 0 | 3 | flag_88E13b1 | flag | 0 on this ROM (cal 0x57585 b3 = 0 holds init) | read | A, B, C, D, E, F, G, H |
| 0 | 4 | maint_flag_811E0 | flag | Backup-RAM flag from 0x11BB08 (counters 1148C/1148E, A8D1); maintenance-type reminder (guess) | unknown | all |
| 0 | 5 | flag_88E13b2 | flag | 0 on this ROM (cal 0x57585 b3 = 0) | read | A, B, C, D, E, F, G, H |
| 1 | 0-3 | coding_bits | raw | From cal 0x58B7A -> 0b0001 on this ROM | read | all |
| 1 | 5-7 | mil_code | code x 1 | 88E69 b1/b2 -> 4 (flash phase on), 1 (lamp off / flash off phase), 0 (steady on); init 1 | read/inferred | all |
| 2 | all | booster_pressure_raw | ADC raw x 256 | Brake-booster pressure sensor A/D high byte (Phase 18 D) | read/inferred | all |
| 3 | all | baro | kPa abs x 0.4 +13.2 | Barometric pressure (88A36, kPa x 256 inferred), clamp 0..255 | read/inferred | all |
| 4 | 0-3 | rolling_counter | count | 0..cal 0x35B00 (15), +1 per 50 ms | read | all |
| 4 | 4 | flag_89053b3 | flag | 0x082800 (engine-state code input, Phase 11 C) | unknown | all |
| 4 | 5 | engine_not_rotating | flag | Engine not rotating (Phase 14) | read | all |
| 4 | 6 | flag_89053b5 | flag | 0x082674 | unknown | all |
| 4 | 7 | cruise_flag_A8B2b0 | flag | Cruise standby branch (0x16DB98) | inferred | all |
| 5-6 | LE u16 | value_361_b5_6 | raw | 16-bit ECU value FFF8B454, low byte first. Sent only when cal 0x57584 b4 is set (the Forester ROMs on the alternate table); otherwise bytes 5-7 are 0. | read (meaning unknown) | B, C, F |
| 7 | all | value_361_b7 | raw | ECU value FFF8A8E0; same option as bytes 5-6. | read (meaning unknown) | B, C, F |

### 0x362 (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | battery_current | A x 0.004 -125 | (raw - 1875000)/4 of LIN battery-sensor word FFF89074 (I = raw/1000 - 2000 A, from the SOC integrator 0x139798), clamp -125..+125 A; 0xFFFF invalid | read/inferred | A, C, D, E, G, H, I |
| 2 | all | lin_value_907A | raw | LIN battery-sensor 9-bit value, clamp 250, 0xFF invalid (init 120) | unknown | A, C, D, E, G, H, I |
| 3 | all | battery_soc | % x 0.5 | Battery state of charge (B72C = % x 10, 0x139798) | read/inferred | A, C, D, E, G, H, I |
| 4 | all | lin_value_89084 | raw x 8 | LIN battery-sensor value; 0xFF invalid | unknown | A, C, D, E, G, H, I |
| 5 | all | lin_value_89258 | raw x 8 | LIN battery-sensor value; 0xFF invalid | unknown | A, C, D, E, G, H, I |
| 6 | all | lin_value_928E | raw x 64 | LIN battery-sensor value; 0xFF invalid | unknown | A, C, D, E, G, H, I |
| 7 | 0 | lin_fault_flag | flag | 89245 b2 or b1 (LIN status) while cal 0x57584 b4 = 0 | inferred | A, C, D, E, G, H, I |
| 7 | 1 | lin_status_89245b0 | flag | 0x096740 (LIN status) | unknown | A, C, D, E, G, H, I |
| 7 | 2 | lin_flag_88E0Eb2 | flag | Set/cleared by the LIN receiver 0x097B06/0x097C12 | unknown | A, C, D, E, G, H, I |
| 7 | 4-7 | battery_soc_low_nibble | raw | Low 4 bits of the battery state-of-charge byte (the value in byte 3). Packed by the 2017-2018 and Levorg ROMs; LF75404S leaves bits 4-7 at 0. | read | C, D, E, G, H |

### 0x368 (received, from TCM)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 7 | rx_368_b0_7_7 | raw | Used only by the ROMs listed; meaning not determined. | read (meaning unknown) | F, G, H |
| 1 | 4 | tcm368_b1_bit4 | raw |  | read | all |
| 1 | 5 | tcm368_b1_bit5 | raw |  | read | all |
| 1 | 6 | tcm368_b1_bit6 | raw | -> 0x10F434 -> FFF8A88E (0..3) -> cruise 0x165AC4/0x167988 | read | all |
| 1 | 7 | tcm368_b1_bit7 | raw | -> FFF8A88E | read | all |
| 3 | all | tcm368_b3 | raw | no reader found | read | all |

### 0x370 (received, from unknown)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE u16 | m370_word | raw | -> 0x114AD0 -> FFF8B458 (zero when byte3 bit0) = idle air adder (electrical load, inferred) in 0x0ECAE0, 0x0801B8, 0x111AB8 | inferred | all |
| 3 | 0 | m370_b3_bit0 | raw | invalid flag for the word (inferred) | inferred | all |
| 3 | 1 | m370_b3_bit1 | raw |  | read | all |
| 5 | 0-3 | m370_counter | raw |  | read | all |

### 0x372 (received, from unknown)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 1 | 4-7 | m372_counter | raw |  | read | all |
| 2 | 5-7 | m372_code | raw | 0x1137D0 (40 ms) -> 0x118EAC -> FFF8A890..A892, FFF8A8A6 b1-b4 -> 0x128B18 | read | all |

### 0x3D1 (received, from combination meter group)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | LE, 13 bits from bit 0 | ambient_temp_raw | raw | 0x1FFF = startup/invalid, 0x1FFE = frame lost; filtered FFF8924A (0x071DC6) checked by P0072/P0073 (0x071E14: <3523 -> P0073, >4873 -> P0072) | inferred | all |
| 7 | 2-6 | rx_3d1_b7_2_6 | raw | Used only by the ROMs listed; meaning not determined. | read (meaning unknown) | F, G, H |

### 0x660 (received, from BCM group)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0-1 | BE u16 | m660_w0 | raw | no reader found | read | all |
| 2-3 | BE u16 | m660_w1 | raw | 0xFFFF = invalid; -> 0x1101B0 -> FFF81494 (DTC record stamp, 0x0A09C6) | inferred | all |
| 5-7 | BE u24 | m660_dist | raw | 0xFFFFFF = invalid; last valid FFF8900C -> 0x110108 -> FFF8C228 (monotonic, DTC record stamp) | inferred | all |

### 0x6FC (sent)

| Byte | Bits | Name | Scale | Meaning | Confidence | Groups |
|---|---|---|---|---|---|---|
| 0 | 0-3 | lin_battery_b0 | raw | LIN battery-sensor block, low nibble of FFF893A6. 0x6FC is sent every 100 ms by ROMs whose table has it in mailbox 15 (they do not receive 0x15A). | read (meaning unknown) | B, C, D, H |
| 1 | all | lin_battery_b1 | raw | LIN battery-sensor value FFF893A9. | read (meaning unknown) | B, C, D, H |
| 2 | all | lin_battery_b2 | raw | LIN battery-sensor value FFF893AA. | read (meaning unknown) | B, C, D, H |
| 3 | all | lin_battery_b3 | raw | LIN battery-sensor value FFF893AB. | read (meaning unknown) | B, C, D, H |
| 4 | all | lin_battery_b4 | raw | ECU value FFF899AF (LIN battery-sensor processing). | read (meaning unknown) | B, C, D, H |
| 5 | 0-4 | lin_battery_b5 | raw | LIN battery-sensor value FFF893A7, bits 0-4. | read (meaning unknown) | B, C, D, H |
| 6 | all | lin_battery_b6 | raw | LIN battery-sensor value FFF893A8. | read (meaning unknown) | B, C, D, H |

## Open

* Meanings marked unknown (VDC/BCM status bits, the 0x142 / 0x6FC / LIN values, the 2018-only receive bits). Most need a capture from a car, not more ROM work.
* Which wheel is which in 0x0D4; the ambient-temperature scale in 0x3D1; the fuel-flow unit in 0x360.
* Senders of 0x161, 0x15A, 0x162, 0x188, 0x280, 0x370, 0x372.
