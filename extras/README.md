# Extras

| Folder | Contents |
|---|---|
| [`can/`](can/) | The FA20DIT CAN dictionary ([README](can/README.md)): every frame the ECU receives and sends, for 31 ROMs (2014–2018 WRX, WRX S4, Levorg, Forester XT/tS). `FA20DIT_CAN.dbc` covers all of them, for passive logging with a CAN interface and a DBC-aware tool; `FA20DIT_CAN_RAM.csv` gives each signal's RAM address in each ROM; `FA20DIT_CAN.json` is the same data for scripts. |

Listening on the bus is safe; transmitting on a running car's CAN bus is not.
