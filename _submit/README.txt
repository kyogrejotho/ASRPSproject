---- ASRPS ----
JES DAVID ADRIEL RAMIREZ BUARON
PATTARACHAI ROCHANANAK
NICHOLAS PUTRA RIHANDOKO
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
POSITIF POWER means power DRAWN FROM DC LINE
-----------------------------------------------------------
models of the TPSS is in the "TPSS_model.m" file
it has 3 TPSS model:
    1) non-reversible ("TPSS_power" function)
    2) reversible ("TPSS_reverse_power" function)
    3) /w offboard accumulator ("TPSS_acc_power" function)
The same SoC limits apply here.
RUN THIS FILE SEPARATELY FROM Train_simple.m 
Power and Energy units are in [kW] and [kWh]
POSITIF POWER means power INJECTED TO DC LINE
in "TPSS_model.m", calculate DC loss on catenary+rail
for single train in unilateral and bilateral feeding topology
can be calculated using the "train_demand" function (bilateral) and "DC_loss" function