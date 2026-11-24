# Extras

| Folder | Contents |
|---|---|
| [`can/`](can/) | The FA20DIT CAN dictionary ([README](can/README.md)): every frame the ECU receives and sends, for 31 ROMs (2014–2018 WRX, WRX S4, Levorg, Forester XT/tS). `FA20DIT_CAN.dbc` covers all of them, for passive logging with a CAN interface and a DBC-aware tool; `FA20DIT_CAN_RAM.csv` gives each signal's RAM address in each ROM; `FA20DIT_CAN.json` is the same data for scripts. |
| [`can/`](can/) `FA24_Early_CAN.*` | The Ascent's (FA24 Early) CAN dictionary, a first pass ([notes](can/FA24_Early_CAN.md)). |
| [`can/`](can/) `FA24DIT_CAN.dbc` | 2022+ WRX (RH850): the frames the ECU sends and the received frames it decodes, as a DBC ([notes](can/FA24DIT_CAN.md)). |

Listening on the bus is safe; transmitting on a running car's CAN bus is not.
