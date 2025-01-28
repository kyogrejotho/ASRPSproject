---- ASRPS ----
JES DAVID ADRIEL RAMIREZ BUARON - UO299578
PATTARACHAI ROCHANANAK - UO304836
NICHOLAS PUTRA RIHANDOKO - UO299590
-----------------------------------------------------------
models of the train is in the "Train_simple.m" file
it has 3 train models:
    1) simple (Train_simple_fxn)
    2) squeeze control ("Train_protection" function)
    3) squeeze control /w accumulator ("Train_batt" function)
For the squeeze control w/ accumulator, the following are the SoC limits
    SoC1 = 0.05;
    SoC2 = 0.1;     
    SoC3 = 0.9;     
    SoC4 = 0.95;    
Power and Energy units are in [kW] and [kWh]
POSITIVE(+) POWER means power DRAWN FROM DC LINE
-----------------------------------------------------------
models of the TPSS is in the "TPSS_model.m" file
it has 3 TPSS model:
    1) non-reversible ("TPSS_power" function)
    2) reversible ("TPSS_reverse_power" function)
    3) /w offboard accumulator ("TPSS_acc_power" function)
The same SoC limits apply here.
The value of Rr for Reversible TPSS approximate from the power flow on the slide (Case 6) (Rr = 0.3)
The power of the off board accumulator will change linearly from 0 to -Pmax during 760 to 770V (charging) 
and from 0 to Pmax during 730V to 740V (discharging) 
RUN THIS FILE SEPARATELY FROM Train_simple.m 
Power and Energy units are in [kW] and [kWh]
POSITIVE (+) POWER means power INJECTED TO DC LINE
in "TPSS_model.m", calculate DC loss on catenary+rail
for single train in unilateral and bilateral feeding topology
can be calculated using the "train_demand" function (bilateral)