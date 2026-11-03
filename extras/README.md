# Extras

| Folder | Contents |
|---|---|
| [`can/`](can/) | `FA20DIT_LF75404S.dbc`: the ECU's CAN messages (received and broadcast), for passive logging with a CAN interface and a DBC-aware tool. Decoded from the 2015 ROM; the 2017 and 2018 ROMs differ in a few signals. |

Listening on the bus is safe; transmitting on a running car's CAN bus is not.
