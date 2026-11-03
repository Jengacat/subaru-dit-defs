# FA20DIT Tuning Guide

A tuning guide for the FA20DIT ECU, written for tuners using these definitions. It assumes you already know
how to tune a car; it explains what is specific to this ECU and how to tune it, in workflow order.

Units follow the definitions: load in g/rev, torque in ft-lb, boost in psi gauge, rail pressure in psi, temperatures
in °F. Screenshots are from the RomRaider definition on the 2015 WRX 6MT ROM (LF75404S).

**Nothing here has been validated on a running engine yet.** Treat stock values and behaviour as the starting point
and confirm with logs.

## Part I – Before you tune

- [1. How this ECU makes power decisions](C01.md)
- [2. Logging and setup](C02.md)

## Part II – Tuning workflows

- [3. Injectors, fuel pressure and E85 without a flex sensor](C03.md)
- [4. MAF scaling, intakes, MAP sensor, throttle body and IAT](C04.md)
- [5. Making power](C05.md)
- [6. Fueling: open loop, closed loop, trims](C06.md)
- [7. Timing and knock](C07.md)
- [8. Cam timing (AVCS)](C08.md)
- [9. Rev limiter, speed limiter, overboost and protection](C09.md)
- [10. Drivability](C10.md)
- [11. Hard limits and gotchas](C11.md)

## Part III – How it works

- [12. Combustion modes, stratified start and catalyst heating](C12.md)
- [13. Torque and throttle model](C13.md)
- [14. Boost control loop](C14.md)
- [15. The fueling chain](C15.md)
- [16. Knock control](C16.md)
- [17. Idle control](C17.md)
- [18. Limit states and cuts](C18.md)
- [19. CAN: SI-Drive, VDC and cruise](C19.md)

## Appendices

- [A02. Logger parameter reference](A02.md)
- [A03. Injector and rail pressure details](A03.md)
- [A04. Sensor inputs and air-measurement details](A04.md)
- [A06. Closed loop, learning and open-loop gating](A06.md)
- [A07. Timing and knock control detail](A07.md)
- [A08. Cam control details](A08.md)
- [A09. Limiter values by image](A09.md)
- [A10. Drivability details](A10.md)
- [A12. Start and catalyst-heating tables](A12.md)
- [A13. Torque and throttle model tables](A13.md)
- [A14. Boost control tables](A14.md)
- [A15. Fueling chain arithmetic](A15.md)
- [A17. Idle control tables](A17.md)
- [A18. Limit state and cut details](A18.md)
- [A19. CAN signal reference](A19.md)

## Table reference

- [Every Beginner and Intermediate table, with a plain-English summary](TABLE_REFERENCE.md)
