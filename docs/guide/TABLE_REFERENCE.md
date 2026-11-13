Every Beginner (level 1) and Intermediate (level 2) table, in the definition's folder order, with its plain-English summary. Units are the definition's defaults (load g/rev, torque ft-lb, boost psi). Level 3–5 tables are in the definition itself; raise RomRaider's user level to see them.

## Fueling / Injectors & Rail Pressure

| Table | Level | What it does |
| --- | --- | --- |
| **Injector Scaling** | Beginner | Injector size constant, shown as the injector flow (g/s) the ECU assumes at the 0.3 MPa reference of Injector Flow Compensation. Cranking pulses, latency, minimum pulse and the throttle-rate transient fuel are in microseconds and do not follow it. |
| **Injector Latency** | Beginner | Fixed time added to every injection pulse, by rail pressure; probably the injector opening delay. |
| **Injector Flow Compensation (Injectors 1/3)** | Beginner | Multiplier on the fuel quantity of injectors 1 and 3 by rail pressure: more pressure means more flow, so less pulse. Keep equal to Injector Flow Compensation (Injectors 2/4). |
| **Injector Flow Compensation (Injectors 2/4)** | Beginner | Same as Injector Flow Compensation (Injectors 1/3) but for injectors 2 and 4 (rail pressure plus Injector 2/4 Rail Pressure Offset). |
| **Injector Minimum Pulse Width** | Intermediate | Shortest pulse the ECU will command; any shorter computed pulse is raised to this. Adjust for injectors with a different minimum controllable pulse. |
| **Target Rail Pressure** | Beginner | Main fuel rail pressure target in normal warm running, by load and rpm. Higher pressure = better atomisation and more injector flow at the cost of pump load. Replaced by Target Rail Pressure (Pedal Released) with the pedal released. |
| **Target Rail Pressure (Pedal Released)** | Intermediate | Rail pressure target used instead of Target Rail Pressure while the accelerator is fully released (cranking or running), by coolant. |

## Fueling / Open Loop & Enrichment Targets

| Table | Level | What it does |
| --- | --- | --- |
| **Primary Open Loop Fueling** | Beginner | Base open-loop (power enrichment) AFR target by rpm and load, used once the exhaust temperature estimate is high enough. The ECU uses the richer of this and the Primary Open Loop Fueling (TGV ..., AVCS ...) group: to lean, edit both; to richen, either. Also see Open Loop Fueling Floor (Outside Closed Loop). |
| **Primary Open Loop Fueling (TGV Closed, AVCS Inactive)** | Beginner | Open-loop AFR target for TGVs closed with AVCS not in active control, part of a blend by TGV position and AVCS state, used above Open Loop Delay Load Threshold after a delay. The ECU uses the richer of the two systems, so leaning needs both. |
| **Primary Open Loop Fueling (TGV Closed, AVCS Active)** | Beginner | Open-loop AFR target for TGVs closed with AVCS in active control, part of a blend by TGV position and AVCS state, used above Open Loop Delay Load Threshold after a delay. The ECU uses the richer of the two systems, so leaning needs both. |
| **Primary Open Loop Fueling (TGV Open, AVCS Inactive)** | Beginner | Open-loop AFR target for TGVs open with AVCS not in active control, part of a blend by TGV position and AVCS state, used above Open Loop Delay Load Threshold after a delay. The ECU uses the richer of the two systems, so leaning needs both. |
| **Primary Open Loop Fueling (TGV Open, AVCS Active)** | Beginner | Open-loop AFR target for TGVs open with AVCS in active control, part of a blend by TGV position and AVCS state, used above Open Loop Delay Load Threshold after a delay. The ECU uses the richer of the two systems, so leaning needs both. |
| **Open Loop Fueling Floor (Outside Closed Loop)** | Beginner | Minimum enrichment whenever the engine is out of closed loop for any reason: the mixture is at least this rich. Check it as well as Primary Open Loop Fueling when leaning the open-loop target. |
| **Open Loop Delay Load Threshold** | Intermediate | Load, by rpm, above which the Primary Open Loop Fueling (TGV..., AVCS...) group takes effect after a delay; below it that group is off. |
| **Primary Open Loop Fueling Additive** | Intermediate | Extra open-loop enrichment added to Primary Open Loop Fueling, scaled by its DAM multiplier: full at DAM 0, none at DAM 1. Probably the classic knock-dependent extra fuel. Edit with Primary Open Loop Fueling Additive (TGV/AVCS Group). |
| **Primary Open Loop Fueling Additive DAM Multiplier** | Intermediate | Scales Primary Open Loop Fueling Additive by the Dynamic Advance Multiplier (DAM), so the extra fuel is added as knock history lowers DAM. Edit with the (TGV/AVCS Group) copy. |
| **Primary Open Loop Fueling Additive (TGV/AVCS Group)** | Intermediate | Knock-dependent extra enrichment for the TGV/AVCS open-loop group, scaled by its DAM multiplier (full at DAM 0, none at DAM 1). |
| **Primary Open Loop Fueling Additive DAM Multiplier (TGV/AVCS Group)** | Intermediate | Scales Primary Open Loop Fueling Additive (TGV/AVCS Group) by DAM (128 = x1.0). |

## Fueling / Closed Loop & Fuel Trims

| Table | Level | What it does |
| --- | --- | --- |
| **Closed Loop Target (TGVs Open, EGR Off)** | Beginner | Closed-loop lambda target with the TGVs open and little or no EGR. Picked by TGV state and estimated EGR flow, then limited by the Closed Loop Target Lean Limit tables. Targets richer than lambda 0.80 drop the ECU into open loop (Closed Loop Minimum Target). |
| **Closed Loop Target (TGVs Closed, EGR Active)** | Intermediate | Closed-loop lambda target with the TGVs closed and EGR flowing. Picked by TGV state and estimated EGR flow, then limited by the Closed Loop Target Lean Limit tables. Targets richer than lambda 0.80 drop the ECU into open loop (Closed Loop Minimum Target). |
| **Closed Loop Target (TGVs Closed, EGR Off)** | Intermediate | Closed-loop lambda target with the TGVs closed and EGR closed or nearly closed. Picked by TGV state and estimated EGR flow, then limited by the Closed Loop Target Lean Limit tables. Targets richer than lambda 0.80 drop the ECU into open loop (Closed Loop Minimum Target). |
| **Closed Loop Target (TGVs Open, EGR Active)** | Intermediate | Closed-loop lambda target with the TGVs open and EGR flowing. Picked by TGV state and estimated EGR flow, then limited by the Closed Loop Target Lean Limit tables. Targets richer than lambda 0.80 drop the ECU into open loop (Closed Loop Minimum Target). |

## Fueling / Transient Fueling

| Table | Level | What it does |
| --- | --- | --- |
| **Transient Fuel Throttle-Rate Gain** | Intermediate | Acceleration/deceleration fuel on throttle movement, by coolant: larger = more fuel when the throttle opens and less when it closes. The table the manual car uses, every pass while running. Keep the three Transient Fuel Throttle-Rate Gain tables consistent. |
| **Transient Fuel Throttle-Rate Gain (AT/CVT)** | Intermediate | AT/CVT version of Transient Fuel Throttle-Rate Gain; only used with an automatic/CVT coding, no effect on a manual car. |
| **Transient Fuel Throttle-Rate RPM Multiplier** | Intermediate | Scales the throttle-movement transient fuel by rpm (256 = x1.0). Raise it for more tip-in fuel at that rpm. Not active for the first second with the pedal released or at steady idle at standstill. |
| **Transient Fuel Film Target** | Intermediate | Fuel film mass target (mg) by load and rpm; when it rises, the difference is added to the following injections and then decays, compensating fuel film build-up (inferred). The values are fuel mass, but the load axis is fuel-based and scales with Injector Scaling: after changing Injector Scaling, multiply the load axis by new raw / 2918 to keep the same real loads. |
| **Standstill Tip-In Enrichment** | Intermediate | Extra fuel when pulling away from standstill, by coolant; the largest active enrichment wins. Probably a cold drive-away aid. Triggered below 5 km/h as the pedal is first pressed. |
| **Standstill Tip-In Enrichment Hold Time** | Intermediate | How long Standstill Tip-In Enrichment is held at full amount before it decays, by coolant. |
| **Standstill Tip-In Enrichment Decay** | Intermediate | How fast Standstill Tip-In Enrichment fades after the hold time, by coolant; larger = faster fade. |

## Fueling / Cranking & Start

| Table | Level | What it does |
| --- | --- | --- |
| **Cranking Fuel (First Attempt)** | Intermediate | Main cranking fuel pulse by coolant, for a normal first cranking attempt. Raise for more fuel while cranking. Raw units: change it proportionally. |

## Fueling / Decel Fuel Cut

| Table | Level | What it does |
| --- | --- | --- |
| **Decel Fuel Cut Delay** | Intermediate | Delay between the closed-pedal decel fuel cut condition being met and cylinders starting to be cut, by coolant and rpm. |
| **Decel Fuel Cut Resume RPM Adder (Coolant)** | Intermediate | Added to the idle target to set the rpm at which the decel fuel cut ends (and, 200 rpm higher, where it starts), by coolant. Raising it probably ends the cut at a higher rpm. |
| **Decel Fuel Cut Resume RPM Adder (Low Speed)** | Intermediate | Extra resume-rpm adder for the decel fuel cut below 15 km/h, by coolant. Raising it probably ends the cut at a higher rpm. |
| **Decel Fuel Cut Staging Time (Gear 1, A/C Off)** | Intermediate | Decel fuel cut staging for gear 1 (and 0) with the A/C off (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 1, A/C On)** | Intermediate | Decel fuel cut staging for gear 1 (and 0) with the A/C engaged (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 2, A/C Off)** | Intermediate | Decel fuel cut staging for gear 2 with the A/C off (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 2, A/C On)** | Intermediate | Decel fuel cut staging for gear 2 with the A/C engaged (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 3, A/C Off)** | Intermediate | Decel fuel cut staging for gear 3 with the A/C off (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 3, A/C On)** | Intermediate | Decel fuel cut staging for gear 3 with the A/C engaged (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 4, A/C Off)** | Intermediate | Decel fuel cut staging for gear 4 with the A/C off (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 4, A/C On)** | Intermediate | Decel fuel cut staging for gear 4 with the A/C engaged (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 5, A/C Off)** | Intermediate | Decel fuel cut staging for gear 5 with the A/C off (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 5, A/C On)** | Intermediate | Decel fuel cut staging for gear 5 with the A/C engaged (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 6, A/C Off)** | Intermediate | Decel fuel cut staging for gear 6 (and above) with the A/C off (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Gear 6, A/C On)** | Intermediate | Decel fuel cut staging for gear 6 (and above) with the A/C engaged (inferred): for each rpm band, the times after the cut starts at which 1, 2, 3 and all 4 cylinders are cut. Lower = faster, harsher cut. Values should rise along each row. Manual coding. |
| **Decel Fuel Cut Staging Time (Neutral)** | Intermediate | Decel fuel cut staging used with the neutral switch on, by vehicle speed: all cylinders are cut at once after this time, instead of the gear tables. |

## Ignition Timing / Base Timing

| Table | Level | What it does |
| --- | --- | --- |
| **Base Timing (EGR Off, TGV Open)** | Beginner | Base (upper-limit) ignition timing map for pedal pressed, EGR off and TGVs open, which covers wide-open throttle and high rpm. The ECU fires the lower of this map and Primary Ignition plus knock correction advance and fine learning. |
| **Base Timing (EGR Off, TGV Closed)** | Beginner | Base (upper-limit) ignition timing map used while the pedal is pressed, EGR is off (or only a few percent) and the TGVs are closed (typically cold or light-load running). The ECU fires the lower of this map and Primary Ignition plus knock correction advance and fine learning, so raising cells adds timing only where this map is the lower one. |
| **Base Timing (EGR Active, TGV Open)** | Beginner | Base (upper-limit) ignition timing map used while the pedal is pressed, EGR is active and the TGVs are open (part-throttle cruising). The ECU fires the lower of this map and Primary Ignition plus EGR advance, knock correction advance and fine learning, so raising cells adds timing only where this map is the lower one. One of four base maps selected by EGR and TGV state. |
| **Base Timing (EGR Active, TGV Closed)** | Beginner | Base (upper-limit) ignition timing map used while the pedal is pressed, EGR is active and the TGVs are closed. The ECU fires the lower of this map and Primary Ignition plus knock correction advance and fine learning (then feedback knock correction and retards apply), so raising cells adds timing only where this map is the lower one. One of four base maps selected by EGR and TGV state; that the switching module is EGR is inferred. |

## Ignition Timing / Timing Compensations

| Table | Level | What it does |
| --- | --- | --- |
| **Base Timing IAT Compensation** | Intermediate | Timing added (negative = retard) for hot intake air, by intake air temperature, scaled by Base Timing IAT Compensation Multiplier. Applied once the engine is running above about 800 rpm and feeds into base timing. |
| **Base Timing IAT Compensation Multiplier** | Intermediate | Scales Base Timing IAT Compensation by rpm and load: 0 = no intake-temperature timing correction, 1.0 = the full amount. |
| **Base Timing Coolant Compensation (TGV Open)** | Intermediate | Timing added to base timing on a cold engine, by coolant temperature, for the TGV-open side; scaled by Base Timing Coolant Compensation Weight (TGV Open) and blended with the TGV Closed table by how far the TGVs are open. Active above about 800 rpm. |
| **Base Timing Coolant Compensation (TGV Closed)** | Intermediate | Timing added to base timing on a cold engine, by coolant temperature, for the TGV-closed side, blended with the TGV Open table by how far the TGVs are open. Active above about 800 rpm. Keep consistent with Base Timing Coolant Compensation (TGV Open). |
| **Base Timing Coolant Compensation Weight (TGV Open)** | Intermediate | Percentage (by rpm and load) of Base Timing Coolant Compensation (TGV Open) actually applied. Lower values reduce the cold-engine timing correction in that area. |

## Ignition Timing / Knock Control

| Table | Level | What it does |
| --- | --- | --- |
| **Knock Correction Advance Max A (TGV Open)** | Beginner | First part of the knock correction advance (timing added as DAM rises), by rpm and load, for TGVs open; blended with the TGV Closed table and scaled by KCA DAM Curve A. It is added to the Primary Ignition request, not to the Base Timing map: the ECU fires the lower of Base Timing and Primary + knock advance + fine learning, so raising it adds timing only where that sum is still below Base Timing. |
| **Knock Correction Advance Max A (TGV Closed)** | Beginner | First part of the knock correction advance (timing added as DAM rises), by rpm and load, for TGVs closed; blended with the TGV Open table and scaled by KCA DAM Curve A. It is added to the Primary Ignition request, not to the Base Timing map: the ECU fires the lower of Base Timing and Primary + knock advance + fine learning, so raising it adds timing only where that sum is still below Base Timing. |
| **Knock Correction Advance Max B (TGV Open)** | Beginner | Second part of the knock correction advance, by rpm and load, for TGVs open. The total available advance is Max A plus Max B; it raises the Primary Ignition side of the timing limit and can never push fired timing above the Base Timing map. |
| **Knock Correction Advance Max B (TGV Closed)** | Beginner | Second part of the knock correction advance, by rpm and load, for TGVs closed. Like part A it raises the Primary Ignition side of the timing limit and can never push fired timing above the Base Timing map. |
| **KCA DAM Curve A** | Intermediate | How much of Knock Correction Advance Max A is applied at each DAM value (0 = none, 1.0 = all). The resulting advance raises the Primary Ignition side of the timing limit, so it reaches the spark only where Primary + advance is below Base Timing. |
| **KCA DAM Curve B** | Intermediate | How much of Knock Correction Advance Max B is applied at each DAM value. Like part A it acts on the Primary Ignition side of the timing limit, never above Base Timing; keep the axis increasing. |
| **FBKC Maximum Retard** | Intermediate | Largest amount of timing feedback knock correction can pull. The live knock retard never goes below minus this value, and it applies to all cylinders at once. Raising it allows more protective retard. |
| **FBKC Retard Step (Knock, State 0x0E)** | Intermediate | Timing pulled by feedback knock correction for each knock event detected above Knock Threshold, in the main knock case. Applied once per combustion event, to all cylinders (there is no per-cylinder knock retard). |
| **FBKC Retard Step (Knock, State 7)** | Intermediate | Timing pulled by feedback knock correction for each knock event detected above Knock Threshold, in the second main-knock case (an extra internal condition is set). Applied once per combustion event. |
| **FBKC Recovery Step** | Intermediate | Timing given back by feedback knock correction per combustion event in the non-knock states other than normal knock-free running: when rpm is outside the FBKC window (for example below FBKC Window RPM Minimum), in the closed-pedal / low-load state, and in a few other special states. Inside the window, after knock stops the correction is held for 100 knock-free events and then recovered by FBKC Recovery Step (State 0x0F), not by this value. |
| **FBKC Recovery Step (State 0x0F)** | Intermediate | Timing given back by feedback knock correction per combustion event after a long knock-free stretch (about 100 events since the last knock). Larger values recover faster. |
| **FBKC Window RPM Maximum** | Intermediate | Upper rpm limit for feedback knock correction. Above it the current knock retard is held: no new retard and no recovery. Raise this if you raise the rev limit. |
| **FBKC Window RPM Minimum** | Intermediate | Lower rpm limit for feedback knock correction: below it no new knock retard is taken, and any existing knock retard is given back by FBKC Recovery Step each combustion event. |
| **DAM Step Gain (FLKC Cell)** | Intermediate | How strongly each fine-knock-learning step moves DAM, per FLKC learning cell (index = 5 x rpm range + load range, 0-34; index 0 is the lowest rpm and load cell). Larger values make DAM move faster when the ECU learns knock in that cell; 0 means that cell never moves DAM. Purpose is inferred. |

## Boost Control / Boost Targets

| Table | Level | What it does |
| --- | --- | --- |
| **Target Boost** | Beginner | Boost target in absolute pressure, by rpm and the ECU's target torque (the driver's request after the torque limits). Corrected for barometric pressure and intake temperature, then the wastegate control chases it. Raise with Boost Limit. |
| **Boost Limit** | Beginner | Boost ceiling by rpm that the torque/throttle model uses as its full-load manifold pressure: the model's target MAP is (torque request / full-load reference torque) x this, and it also scales the throttle-area input. It is not an overboost cut (see Overboost Limit). Raise it together with Target Boost so the model's full-load pressure matches the boost you run. |

## Boost Control / Wastegate Duty

| Table | Level | What it does |
| --- | --- | --- |
| **Wastegate Duty Initial** | Beginner | Base (feed-forward) wastegate duty by rpm and target torque, before boost feedback is added. Higher duty = more boost. It is scaled by the wastegate duty baro and IAT compensations and the total is capped by Wastegate Duty Maximum. Faults force 0 % duty. |
| **Wastegate Duty Maximum** | Beginner | Ceiling on wastegate duty (Initial plus feedback) by rpm and target torque, scaled by the same baro and IAT compensations. Also stops the boost integral from growing once duty reaches it. Raise it if feedback runs out of authority. |

## Boost Control / Boost Feedback & Compensations

| Table | Level | What it does |
| --- | --- | --- |
| **Target Boost IAT Compensation** | Beginner | Multiplier on Target Boost and Boost Limit by intake air temperature (1.0 = no change). |
| **Target Boost Baro Compensation** | Beginner | Multiplier on Target Boost (and Boost Limit) by rpm and barometric pressure (1.0 = no change). |
| **Wastegate Duty IAT Compensation** | Intermediate | Multiplier on Wastegate Duty Initial and Maximum by intake air temperature (1.0 = no change). |
| **Wastegate Duty Baro Compensation** | Intermediate | Multiplier on Wastegate Duty Initial and Maximum by rpm and barometric pressure (1.0 = no change). Edit together with Wastegate Duty IAT Compensation, which it is combined with. |
| **Boost Proportional** | Intermediate | Proportional wastegate duty added by boost error (target minus actual; positive = under target), scaled by Boost Proportional IAT Gain. Larger values react harder to error. Zero while boost feedback is inactive. |
| **Boost Integral Step (Positive Error)** | Intermediate | How fast the boost integral adds duty when boost is under target, by boost error; added every 20 ms, scaled by Boost Integral Positive IAT Gain. Only grows above Boost Integral Positive Error Deadband and while duty is below Wastegate Duty Maximum; capped by Boost Integral Maximum. |
| **Boost Integral Step (Negative Error)** | Intermediate | How fast the boost integral removes duty when boost is over target, by boost error; applied every 20 ms while duty is at least 5 %, scaled by Boost Integral Negative IAT Gain. Floored at Boost Integral Minimum. |

## Torque & Throttle / Requested Torque

| Table | Level | What it does |
| --- | --- | --- |
| **Requested Torque (Drive Mode 1, Default)** | Beginner | Drive mode 1: the default set (used when no SI-Drive request is received; the only set on cars without SI-Drive). Main driver demand map for drive mode 1 (the default and fallback): torque requested from rpm and pedal; sets how much torque (and so throttle and boost) a given pedal gives. Edit together with Requested Torque (Drive Mode 1, Default, Monitor) or expect a throttle plausibility fault. |
| **Requested Torque (Drive Mode 1, Default, Monitor)** | Beginner | Safety-monitor copy of Requested Torque (Drive Mode 1, Default), probably read by the electronic throttle torque monitor. Keep it identical to the main table: change both together or expect a throttle/torque plausibility fault. |
| **Requested Torque (Drive Mode 2, Sport)** | Beginner | Drive mode 2: SI-Drive Sport (S). Main driver demand map for drive mode 2: torque requested from rpm and pedal; sets how much torque (and so throttle and boost) a given pedal gives. Edit together with Requested Torque (Drive Mode 2, Sport, Monitor) or expect a throttle plausibility fault. |
| **Requested Torque (Drive Mode 2, Sport, Monitor)** | Beginner | Safety-monitor copy of Requested Torque (Drive Mode 2, Sport), probably read by the electronic throttle torque monitor. Keep it identical to the main table: change both together or expect a throttle/torque plausibility fault. |
| **Requested Torque (Drive Mode 3, Intelligent)** | Beginner | Drive mode 3: SI-Drive Intelligent (I). Main driver demand map for drive mode 3: torque requested from rpm and pedal; sets how much torque (and so throttle and boost) a given pedal gives. Edit together with Requested Torque (Drive Mode 3, Intelligent, Monitor) or expect a throttle plausibility fault. |
| **Requested Torque (Drive Mode 3, Intelligent, Monitor)** | Beginner | Safety-monitor copy of Requested Torque (Drive Mode 3, Intelligent), probably read by the electronic throttle torque monitor. Keep it identical to the main table: change both together or expect a throttle/torque plausibility fault. |
| **Requested Torque (Drive Mode 4, Sport Sharp)** | Intermediate | Drive mode 4: SI-Drive Sport Sharp (S#). Main driver demand map for drive mode 4: torque requested from rpm and pedal. Edit together with Requested Torque (Drive Mode 4, Sport Sharp, Monitor) or expect a throttle plausibility fault. |
| **Requested Torque (Drive Mode 4, Sport Sharp, Monitor)** | Intermediate | Safety-monitor copy of Requested Torque (Drive Mode 4, Sport Sharp), probably read by the electronic throttle torque monitor. Keep it identical to the main table: change both together or expect a throttle/torque plausibility fault. |

## Torque & Throttle / Torque Limits & Engine Protection

| Table | Level | What it does |
| --- | --- | --- |
| **Rev Limit RPM** | Beginner | The rev limit: above it the ECU cuts fuel to all four cylinders on every firing and closes the throttle; spark is not cut or retarded. To move the limit, set this, Rev Limit Full Cut RPM, Rev Limit Full Cut Reset RPM, Rev Limit Stage 1 RPM and Rev Limit Stage 2 RPM (Stage 1 Hold) to the new rpm and Rev Limit Reset RPM about 100 lower. |
| **Rev Limit Reset RPM** | Beginner | End of the rev-limit state: the throttle cap stays until rpm falls to this and boost is below Rev Limit Reset Maximum MAP, while fuel already returns at Rev Limit Full Cut Reset RPM. Keep it about 100 rpm below Rev Limit RPM. |
| **Rev Limit Full Cut RPM** | Beginner | At or above this rpm, once the rev limit has started, every injector is cut on every firing (a hard fuel cut). Keep it equal to Rev Limit RPM; set higher, the range between them gets only the throttle cap, probably a softer limit. |
| **Rev Limit Full Cut Reset RPM** | Beginner | Fuel returns once rpm falls to this and boost is below Rev Limit Reset Maximum MAP. |
| **Rev Limit Stage 1 RPM** | Beginner | Set it to your rev limit with the other Rev Limit rpm values. |
| **Rev Limit Stage 2 RPM (Stage 1 Hold)** | Beginner | Stage 1 of the throttle cap holds above this rpm. Set it to your rev limit. |
| **Rev Limit Reset Maximum MAP** | Beginner | The rev-limit fuel cut and state cannot end while manifold pressure is at or above this, even below their reset rpm. Raise it if you want the cut to release on rpm alone at high boost. |
| **Maximum Torque (IAT)** | Beginner | Maximum target torque by rpm and intake air temperature. The ECU uses the lowest of this, Maximum Torque (DAM) and other limits, and the result drives the boost target. |
| **Maximum Torque (DAM)** | Beginner | Maximum target torque by DAM (knock learning) and rpm, in the same lowest-wins limit as Maximum Torque (IAT). Losing DAM lowers the torque target and so the boost target. |
| **Overboost Limit** | Beginner | Overboost limit by rpm, compensated for baro and intake temperature like the boost target. Boost 26.7 kPa over it for 2 s sets the overboost flag, and 33 kPa over it starts the overboost cut (throttle cap, then a full fuel cut once the flag is set). Raise it when raising boost targets. Note: the boost-control pressure reading stops at about 269 kPa absolute, so an Overboost Limit above about 236 kPa absolute (269 minus the 33 kPa cut margin) can never trigger the overboost cut. |
| **Rev/Boost Limit Torque (Base)** | Intermediate | Throttle-side torque cap by rpm used only during the rev or overboost cut when neither stage applies. It does not limit torque in normal driving, so raising it gives no extra power. |
| **Rev/Boost Limit Torque (Stage 1)** | Intermediate | Throttle-side torque cap while the rev limiter is cutting fuel, or during an overboost cut above 256 kPa absolute: the throttle closes toward it. |
| **Rev/Boost Limit Torque Stage 1 MAP** | Intermediate | During a rev or overboost cut, manifold pressure above which the stage 1 throttle cap is used. It does not start a cut by itself. |
| **Rev/Boost Limit Torque Stage 1 Reset MAP** | Intermediate | Stage 1 throttle cap stays on while manifold pressure is above this. |
| **Rev/Boost Limit Torque Stage 2 Hold MAP** | Intermediate | Stage 2 throttle cap stays on while manifold pressure is above this. |
| **Overboost Margin** | Intermediate | How far above Overboost Limit boost must be before overboost time is counted toward the overboost flag, which makes the overboost cut a full fuel cut. |
| **Overboost Delay** | Intermediate | How long boost must stay above Overboost Limit plus Overboost Margin before the overboost flag sets and the overboost cut becomes a full fuel cut. |
| **Vehicle Speed Limit** | Intermediate | Vehicle speed limiter. It needs this speed, Vehicle Speed Limit Minimum RPM and Vehicle Speed Limit Full Cut Speed to act, and then cuts fuel to all cylinders without closing the throttle. |
| **Vehicle Speed Limit Minimum RPM** | Intermediate | The speed limiter only starts at or above this engine speed. |
| **Vehicle Speed Limit Full Cut Speed** | Intermediate | Speed at which the active speed limiter cuts fuel to all cylinders; without it the limiter does nothing. |
| **Vehicle Speed Limit Offset** | Intermediate | Subtracted from Vehicle Speed Limit to give the speed where the limiter state starts; it is not a release hysteresis. |
| **Fail-Safe Rev Limit (Rail Pressure Fault)** | Intermediate | Rev limit used only while a fuel-rail pressure fault is active: above it fuel to all cylinders is cut. |
| **Fail-Safe Rev Limit (Injector Driver Fault)** | Intermediate | Rev limit used only while an injector-driver fault has put the fuel system in its low-pressure fail-safe: above it fuel to all cylinders is cut. |

## Torque & Throttle / Throttle Control & Throttle Model

| Table | Level | What it does |
| --- | --- | --- |
| **Throttle Opening Map Reference Torque** | Intermediate | Torque by rpm that counts as 100 % in the Throttle Opening from Target Torque maps: at or above it they give wide-open throttle. Raise it together with Full-Load Reference Brake Torque for a higher-torque tune. Edit together with Throttle Opening Map Reference Torque (Monitor). |
| **Throttle Opening Map Reference Torque (Monitor)** | Intermediate | Throttle-monitor copy of Throttle Opening Map Reference Torque. Keep identical to the main table, or expect the monitor to disagree with the main path (plausibility fault inferred). |
| **Throttle Opening from Target Torque (TGV Closed)** | Beginner | This is where part-throttle feel is set: the commanded throttle opening is essentially this map (by rpm and target torque) plus the idle air. Used with the TGVs closed and no EGR (blended by TGV position and EGR amount). Edit together with Throttle Opening from Target Torque (TGV Closed, Monitor). |
| **Throttle Opening from Target Torque (TGV Closed, Monitor)** | Beginner | Throttle-monitor copy of Throttle Opening from Target Torque (TGV Closed). Make the same edit here as on the main table, or expect a plausibility fault (inferred). |
| **Throttle Opening from Target Torque (TGV Open)** | Beginner | This is where part-throttle feel is set: the commanded throttle opening is essentially this map (by rpm and target torque) plus the idle air. Used with the TGVs open and no EGR; probably the table a warm car mostly uses at part load. Edit together with Throttle Opening from Target Torque (TGV Open, Monitor). |
| **Throttle Opening from Target Torque (TGV Open, Monitor)** | Beginner | Throttle-monitor copy of Throttle Opening from Target Torque (TGV Open). Make the same edit here as on the main table, or expect a plausibility fault (inferred). |
| **Throttle Opening from Target Torque (TGV Closed, EGR)** | Beginner | This is where part-throttle feel is set: the commanded throttle opening is essentially this map (by rpm and target torque) plus the idle air. Used with the TGVs closed and EGR active (blended by TGV position and EGR amount). Edit together with Throttle Opening from Target Torque (TGV Closed, EGR, Monitor). |
| **Throttle Opening from Target Torque (TGV Closed, EGR, Monitor)** | Beginner | Throttle-monitor copy of Throttle Opening from Target Torque (TGV Closed, EGR). Make the same edit here as on the main table, or expect a plausibility fault (inferred). |
| **Throttle Opening from Target Torque (TGV Open, EGR)** | Beginner | This is where part-throttle feel is set: the commanded throttle opening is essentially this map (by rpm and target torque) plus the idle air. Used with the TGVs open and EGR active (blended by TGV position and EGR amount). Edit together with Throttle Opening from Target Torque (TGV Open, EGR, Monitor). |
| **Throttle Opening from Target Torque (TGV Open, EGR, Monitor)** | Beginner | Throttle-monitor copy of Throttle Opening from Target Torque (TGV Open, EGR). Make the same edit here as on the main table, or expect a plausibility fault (inferred). |

## AVCS (Cam Timing) / Intake Targets

| Table | Level | What it does |
| --- | --- | --- |
| **Intake Cam Target 1A (TGV Open, Normal, Altitude)** | Intermediate | Intake cam advance target (degrees from the fully retarded rest position) by rpm and load for normal driving with the TGVs open, used at altitude (blended in by AVCS Barometric Blend; near sea level the 1B table is used instead). Higher = earlier intake valve timing. The normal vs high-pedal split is inferred from the switching conditions. |
| **Intake Cam Target 1B (TGV Open, Normal, Sea Level)** | Intermediate | Main intake cam advance target (degrees from rest) by rpm and load for normal driving with the TGVs open near sea level: above light part throttle, above about 5200 rpm, or cold. Higher = earlier intake timing. At light part throttle the TGVs close and Intake Cam Target 3B is used instead. Normal vs high-pedal split is inferred. |
| **Intake Cam Target 2A (TGV Open, High Pedal, Altitude)** | Intermediate | Intake cam advance target (degrees from rest) by rpm and load used when the pedal is near wide open (about 90 % or more), TGVs open, at altitude. Higher = earlier intake timing. The high-pedal meaning is inferred from the switching conditions. |
| **Intake Cam Target 2B (TGV Open, High Pedal, Sea Level)** | Intermediate | Intake cam advance target (degrees from rest) by rpm and load used when the pedal is near wide open (about 90 % or more), TGVs open, near sea level. This, not 1B, sets wide-open-throttle intake timing near sea level. Higher = earlier intake timing. The high-pedal meaning is inferred from the switching conditions. |
| **Intake Cam Target 3A (TGV Closed, Altitude)** | Intermediate | Intake cam advance target (degrees from rest) by rpm and load used while the TGVs are closed (light part throttle), at altitude. Higher = earlier intake timing. Near sea level Intake Cam Target 3B is used instead. |
| **Intake Cam Target 3B (TGV Closed, Sea Level)** | Intermediate | Intake cam advance target (degrees from rest) by rpm and load used while the TGVs are closed (light part throttle, cruising) near sea level. Higher = earlier intake timing. This is the table that sets light-load intake timing on most cars. |

## AVCS (Cam Timing) / Exhaust Targets

| Table | Level | What it does |
| --- | --- | --- |
| **Exhaust Cam Target 1A (TGV Open, Normal, Altitude)** | Intermediate | Exhaust cam retard target (degrees from the fully advanced rest position) by rpm and load for normal driving with the TGVs open, at altitude (near sea level 1B is used). Higher = later exhaust closing and more overlap. The normal vs high-pedal split is inferred. |
| **Exhaust Cam Target 1B (TGV Open, Normal, Sea Level)** | Intermediate | Main exhaust cam retard target (degrees from rest) by rpm and load for normal driving with the TGVs open near sea level. Higher = later exhaust closing and more valve overlap. At light part throttle the TGVs close and Exhaust Cam Target 3B is used instead. Normal vs high-pedal split is inferred. |
| **Exhaust Cam Target 2A (TGV Open, High Pedal, Altitude)** | Intermediate | Exhaust cam retard target (degrees from rest) by rpm and load used when the pedal is near wide open (about 90 % or more), TGVs open, at altitude. Higher = more overlap. The high-pedal meaning is inferred from the switching conditions. |
| **Exhaust Cam Target 2B (TGV Open, High Pedal, Sea Level)** | Intermediate | Exhaust cam retard target (degrees from rest) by rpm and load used when the pedal is near wide open (about 90 % or more), TGVs open, near sea level. Higher = more overlap. High-pedal meaning inferred. |
| **Exhaust Cam Target 3A (TGV Closed, Altitude)** | Intermediate | Exhaust cam retard target (degrees from rest) by rpm and load while the TGVs are closed (light part throttle), at altitude. Higher = more overlap. Near sea level Exhaust Cam Target 3B is used instead. |
| **Exhaust Cam Target 3B (TGV Closed, Sea Level)** | Intermediate | Exhaust cam retard target (degrees from rest) by rpm and load while the TGVs are closed (light part throttle, cruising) near sea level. Higher = later exhaust closing and more overlap (internal EGR). |

## Idle / Idle Speed Targets

| Table | Level | What it does |
| --- | --- | --- |
| **Idle Speed Target (Warm Idle, Mode 5)** | Intermediate | Main idle speed target by coolant in normal running; this is the table to edit to change idle speed on a manual car. Automatic/CVT cars use Mode 6 instead. |
| **Idle Speed Target (Warm Idle, AT/CVT, Mode 6)** | Intermediate | Warm idle speed target by coolant for automatic/CVT cars only; a manual car never uses this table. |
| **Idle Speed Target (Post-Start, Modes 1/2)** | Intermediate | Idle speed target by coolant right after a start (below 75 degC coolant) until the car moves or the engine warms to 50 degC, and while the engine is stopped. Raise for a higher fast-idle after cold starts. |
| **Idle Speed Target (Warm Start, Mode 3)** | Intermediate | Idle speed target by coolant after a hot restart (coolant at or above 75 degC at start), until the car moves. Raise for a higher idle right after hot starts. |
| **Idle Speed Target (Warm-Up Drive-Off, Mode 7)** | Intermediate | Idle speed target by coolant once the car has driven off after a cold start but the engine is still warming up (until coolant is above about 75 degC); then idle returns to Mode 5. Used on manual cars. |
| **Idle Speed Target (Warm-Up Drive-Off, AT/CVT, Mode 8)** | Intermediate | Automatic/CVT version of Idle Speed Target (Warm-Up Drive-Off, Mode 7): idle speed by coolant once the car has moved off before the engine is warm. Never used on a manual car. |
| **Idle Speed Target (In Drive, AT/CVT)** | Intermediate | Idle speed target by coolant while an automatic/CVT car idles in Drive with the brake on (pedal released, slow). Never used on a manual car (inferred). |
