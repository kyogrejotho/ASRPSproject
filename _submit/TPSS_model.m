clear all; clc;
%% Case1 This is just single case, Go to another section for the conventional testcase

Pcat_train1 = 650; % [kW] This is known, is split between L and R (in slides, 307 and 343)
Vcat_train1 = 550; % [V] Voltage Catenery at Train1
Pcat_train2 = 350; % [kW] Power of Train2
Vcat_train2 = 582; % [V] Voltage Catenery at Train2

Vcat_TPSS1 = 622; % Voltage Catenery at TPSS1 [V]
Vcat_TPSS2 = 590; % Voltage Catenery at TPSS2 [V]
Vcat_TPSS3 = 630; % Voltage Catenery at TPSS3 [V]

pk_train1 = 2; % Point kilometer train1
pk_train2 = 4.6; % Point kilometer train2

TPSSx1 = 0; % Distance Substation1
TPSSx2 = 3; % Distance Substation2 
TPSSx3 = 6; % Distance Substation3

[P_TPSS1,P_TPSS1_loss,P_TPSS1_net,I_TPSS1] = TPSS_power(Vcat_TPSS1) % Information of Power,Current from TPSS1
[P_TPSS2,P_TPSS2_loss,P_TPSS2_net,I_TPSS2] = TPSS_power(Vcat_TPSS2) % Information of Power,Current from TPSS2
[P_TPSS3,P_TPSS3_loss,P_TPSS3_net,I_TPSS3] = TPSS_power(Vcat_TPSS3) % Information of Power,Current from TPSS3
[P_TPSS1_train1,P_TPSS2_train1] = Train_demand(I_TPSS1,Vcat_train1,Pcat_train1) % Power that train demand from the nearby TPSS
I_train1_TPSS2 = P_TPSS2_train1/Vcat_train1; % Current from train1 to TPSS2
I_train2_TPSS2 = I_TPSS2-I_train1_TPSS2; % Current from train2 to TPSS2
[P_TPSS2_train2,P_TPSS3_train2] = Train_demand(I_train2_TPSS2,Vcat_train2,Pcat_train2) % Power that train demand from the nearby TPSS

DC_loss_TPSS1 = P_TPSS1_net - P_TPSS1_train1 % Loss in catenery from TPSS1 to train 1
DC_loss_TPSS2 = P_TPSS2_net - (P_TPSS2_train1+P_TPSS2_train2) % Loss in catenery from TPSS2 to train 1 and train2
DC_loss_TPSS3 = P_TPSS3_net - P_TPSS3_train2 % Loss in catenery from TPSS3 to train 2
DC_loss_total = DC_loss_TPSS1 + DC_loss_TPSS2 + DC_loss_TPSS3 %Total loss on catenery

% P_DC_loss12 = DC_loss(I_TPSS1,I_train1_TPSS2,pk_train1,TPSSx1,TPSSx2)
% P_DC_loss23 = DC_loss(I_train2_TPSS2,I_TPSS3,pk_train2,TPSSx1,TPSSx2)

%% RUN Test case Coventional Case 1 2 3 4
clear all; clc;

% Data arrays
arr_Vcat_TPSS1 = [622;872;645;850;735]; % Input Vcat at Substation 1 [V]
arr_Vcat_TPSS2 = [590;800;614;800;755]; % Input Vcat at Substation 2 [V]
arr_Vcat_TPSS3 = [630;747;641;740;755]; % Input Vcat at Substation 3 [V]

arr_Pcat_train1 = [650;-650;524;-585;650]; % Input Pcat at train 1 [kW]
arr_Vcat_train1 = [550;872;586;850;550]; % Input Vcat at train 1 [V]
arr_Pcat_train2 = [350;564;377;526;350]; % Input Pcat at train 2 [kW]
arr_Vcat_train2 = [582;746;598;737;582]; % Input Vcat at train 2 [kW]

% Pre-allocating arrays
n = length(arr_Vcat_TPSS1);
arr_P_TPSS1 = zeros(n,1);
arr_P_TPSS1_loss = zeros(n,1);
arr_P_TPSS1_net = zeros(n,1);
arr_I_TPSS1 = zeros(n,1);
arr_P_TPSS2 = zeros(n,1);
arr_P_TPSS2_loss = zeros(n,1);
arr_P_TPSS2_net = zeros(n,1);
arr_I_TPSS2 = zeros(n,1);
arr_P_TPSS3 = zeros(n,1);
arr_P_TPSS3_loss = zeros(n,1);
arr_P_TPSS3_net = zeros(n,1);
arr_I_TPSS3 = zeros(n,1);
arr_P_TPSS1_train1 = zeros(n,1);
arr_P_TPSS2_train1 = zeros(n,1);
arr_I_train1_TPSS2 = zeros(n,1);
arr_I_train2_TPSS2 = zeros(n,1);
arr_P_TPSS2_train2 = zeros(n,1);
arr_P_TPSS3_train2 = zeros(n,1);
arr_DC_loss_TPSS1 = zeros(n,1);
arr_DC_loss_TPSS2 = zeros(n,1);
arr_DC_loss_TPSS3 = zeros(n,1);
arr_DC_loss_total = zeros(n,1);

% Loop to compute values
for i = 1:n
    [arr_P_TPSS1(i), arr_P_TPSS1_loss(i), arr_P_TPSS1_net(i), arr_I_TPSS1(i)] = TPSS_power(arr_Vcat_TPSS1(i));
    [arr_P_TPSS2(i), arr_P_TPSS2_loss(i), arr_P_TPSS2_net(i), arr_I_TPSS2(i)] = TPSS_power(arr_Vcat_TPSS2(i));
    [arr_P_TPSS3(i), arr_P_TPSS3_loss(i), arr_P_TPSS3_net(i), arr_I_TPSS3(i)] = TPSS_power(arr_Vcat_TPSS3(i));
    [arr_P_TPSS1_train1(i), arr_P_TPSS2_train1(i)] = Train_demand(arr_I_TPSS1(i), arr_Vcat_train1(i), arr_Pcat_train1(i)); % Power that train demand from the nearby TPSS
    arr_I_train1_TPSS2(i) = arr_P_TPSS2_train1(i) / arr_Vcat_train1(i); % Current from train1 to TPSS2
    arr_I_train2_TPSS2(i) = arr_I_TPSS2(i) - arr_I_train1_TPSS2(i);
    [arr_P_TPSS2_train2(i), arr_P_TPSS3_train2(i)] = Train_demand(arr_I_train2_TPSS2(i), arr_Vcat_train2(i), arr_Pcat_train2(i)); % Power that train demand from the nearby TPSS

    arr_DC_loss_TPSS1(i) = arr_P_TPSS1_net(i) - arr_P_TPSS1_train1(i);
    arr_DC_loss_TPSS2(i) = arr_P_TPSS2_net(i) - (arr_P_TPSS2_train1(i) + arr_P_TPSS2_train2(i));
    arr_DC_loss_TPSS3(i) = arr_P_TPSS3_net(i) - arr_P_TPSS3_train2(i);
    arr_DC_loss_total(i) = arr_DC_loss_TPSS1(i) + arr_DC_loss_TPSS2(i) + arr_DC_loss_TPSS3(i);
end

% Create table
results = table(arr_Vcat_TPSS1, arr_Vcat_TPSS2, arr_Vcat_TPSS3, ...
                arr_Pcat_train1, arr_Vcat_train1, arr_Pcat_train2, arr_Vcat_train2, ...
                arr_P_TPSS1, arr_P_TPSS2, arr_P_TPSS3, ...
                arr_P_TPSS1_loss, arr_P_TPSS2_loss, arr_P_TPSS3_loss, arr_DC_loss_total);

% Assign variable names to the table
results.Properties.VariableNames = ["Vcat_TPSS1", "Vcat_TPSS2", "Vcat_TPSS3", "Pcat_train1", "Vcat_train1", ...
                                    "Pcat_train2", "Vcat_train2", "P_TPSS1", "P_TPSS2", "P_TPSS3", ...
                                    "P_TPSS1_loss", "P_TPSS2_loss", "P_TPSS3_loss", "DC_loss_total"];

% Display the table
disp(results);
writetable(results,'TPSS_Conventional.csv')

%% RUN Test case Reversible TPSS case 5 6
clear all; clc;

% Data arrays
arr_Vcat_TPSS1 = [793;765]; % Input Vcat at Substation 1 [V]
arr_Vcat_TPSS2 = [766;799]; % Input Vcat at Substation 2 [V]
arr_Vcat_TPSS3 = [716;799]; % Input Vcat at Substation 3 [V]

arr_Pcat_train1 = [-585;-585;]; % Input Pcat at train 1 [kW]
arr_Vcat_train1 = [806;800]; % Input Vcat at train 1 [V]
arr_Pcat_train2 = [526;-585]; % Input Pcat at train 2 [kW]
arr_Vcat_train2 = [703;790]; % Input Vcat at train 2 [V]

% Pre-allocating arrays
n = length(arr_Vcat_TPSS1);
arr_P_TPSS1 = zeros(n,1);
arr_P_TPSS1_loss = zeros(n,1);
arr_P_TPSS1_net = zeros(n,1);
arr_I_TPSS1 = zeros(n,1);
arr_P_TPSS2 = zeros(n,1);
arr_P_TPSS2_loss = zeros(n,1);
arr_P_TPSS2_net = zeros(n,1);
arr_I_TPSS2 = zeros(n,1);
arr_P_TPSS3 = zeros(n,1);
arr_P_TPSS3_loss = zeros(n,1);
arr_P_TPSS3_net = zeros(n,1);
arr_I_TPSS3 = zeros(n,1);
arr_P_TPSS1_train1 = zeros(n,1);
arr_P_TPSS2_train1 = zeros(n,1);
arr_I_train1_TPSS2 = zeros(n,1);
arr_I_train2_TPSS2 = zeros(n,1);
arr_P_TPSS2_train2 = zeros(n,1);
arr_P_TPSS3_train2 = zeros(n,1);
arr_DC_loss_TPSS1 = zeros(n,1);
arr_DC_loss_TPSS2 = zeros(n,1);
arr_DC_loss_TPSS3 = zeros(n,1);
arr_DC_loss_total = zeros(n,1);

% Loop to compute values
for i = 1:n
    [arr_P_TPSS1(i), arr_P_TPSS1_loss(i), arr_P_TPSS1_net(i), arr_I_TPSS1(i)] = TPSS_reverse_power(arr_Vcat_TPSS1(i));
    [arr_P_TPSS2(i), arr_P_TPSS2_loss(i), arr_P_TPSS2_net(i), arr_I_TPSS2(i)] = TPSS_reverse_power(arr_Vcat_TPSS2(i));
    [arr_P_TPSS3(i), arr_P_TPSS3_loss(i), arr_P_TPSS3_net(i), arr_I_TPSS3(i)] = TPSS_reverse_power(arr_Vcat_TPSS3(i));
    [arr_P_TPSS1_train1(i), arr_P_TPSS2_train1(i)] = Train_demand(arr_I_TPSS1(i), arr_Vcat_train1(i), arr_Pcat_train1(i)); % Power that train demand from the nearby TPSS
    arr_I_train1_TPSS2(i) = arr_P_TPSS2_train1(i) / arr_Vcat_train1(i); % Current from train1 to TPSS2
    arr_I_train2_TPSS2(i) = arr_I_TPSS2(i) - arr_I_train1_TPSS2(i);
    [arr_P_TPSS2_train2(i), arr_P_TPSS3_train2(i)] = Train_demand(arr_I_train2_TPSS2(i), arr_Vcat_train2(i), arr_Pcat_train2(i)); % Power that train demand from the nearby TPSS

    arr_DC_loss_TPSS1(i) = arr_P_TPSS1_net(i) - arr_P_TPSS1_train1(i);
    arr_DC_loss_TPSS2(i) = arr_P_TPSS2_net(i) - (arr_P_TPSS2_train1(i) + arr_P_TPSS2_train2(i));
    arr_DC_loss_TPSS3(i) = arr_P_TPSS3_net(i) - arr_P_TPSS3_train2(i);
    arr_DC_loss_total(i) = arr_DC_loss_TPSS1(i) + arr_DC_loss_TPSS2(i) + arr_DC_loss_TPSS3(i);
end

% Create table
results = table(arr_Vcat_TPSS1, arr_Vcat_TPSS2, arr_Vcat_TPSS3, ...
                arr_Pcat_train1, arr_Vcat_train1, arr_Pcat_train2, arr_Vcat_train2, ...
                arr_P_TPSS1, arr_P_TPSS2, arr_P_TPSS3, ...
                arr_P_TPSS1_loss, arr_P_TPSS2_loss, arr_P_TPSS3_loss, arr_DC_loss_total);

% Assign variable names to the table
results.Properties.VariableNames = ["Vcat_TPSS1[V]", "Vcat_TPSS2[V]", "Vcat_TPSS3[V]", "Pcat_train1[kW]", "Vcat_train1[kW]", ...
                                    "Pcat_train2[kW]", "Vcat_train2[V]", "P_TPSS1[kW]", "P_TPSS2[kW]", "P_TPSS3[kW]", ...
                                    "P_TPSS1_loss[kW]", "P_TPSS2_loss[kW]", "P_TPSS3_loss[kW]", "DC_loss_total[kW]"];

% Display the table
disp(results);
writetable(results,'TPSS_Reversible.csv')

%% RUN Test case Non-rev Accumulator TPSS case 7 8
clear all; clc;

% Data arrays
arr_Vcat_TPSS1 = [651;760;651;793;793;765;765;765;735;735;735]; % Input Vcat at Substation 1 [V]
arr_soc_TPSS1 = [0.5;0.5;0.01;0.01;0.5;0.5;0.925;0.95;0.5;0.075;0.05];
arr_Vcat_TPSS2 = [683;766;683;766;766;766;766;766;766;766;766]; % Input Vcat at Substation 2 [V]
arr_soc_TPSS2 = [0.5;0.5;0.01;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5];
arr_Vcat_TPSS3 = [690;733;690;716;716;716;716;716;716;716;716]; % Input Vcat at Substation 3 [V]
arr_soc_TPSS3 = [0.5;0.5;0.01;0.5;0.01;0.01;0.01;0.01;0.01;0.01;0.01];

arr_Pcat_train1 = [722;-585;722;722;-585;-585;-585;-585;-585;-585;-585]; % Input Pcat at train 1 [kW]
arr_Vcat_train1 = [610;794;610;610;806;806;806;806;806;806;806]; % Input Vcat at train 1 [V]
arr_Pcat_train2 = [388;526;526;530;526;526;526;526;526;526;526]; % Input Pcat at train 2 [kW]
arr_Vcat_train2 = [642;710;642;682;703;703;703;703;703;703;703]; % Input Vcat at train 2 [V]

% Pre-allocating arrays
n = length(arr_Vcat_TPSS1);
arr_P_TPSS1 = zeros(n,1);
arr_P_TPSS1_loss = zeros(n,1);
arr_P_TPSS1_net = zeros(n,1);
arr_I_TPSS1 = zeros(n,1);
arr_P_TPSS2 = zeros(n,1);
arr_P_TPSS2_loss = zeros(n,1);
arr_P_TPSS2_net = zeros(n,1);
arr_I_TPSS2 = zeros(n,1);
arr_P_TPSS3 = zeros(n,1);
arr_P_TPSS3_loss = zeros(n,1);
arr_P_TPSS3_net = zeros(n,1);
arr_I_TPSS3 = zeros(n,1);
arr_P_TPSS1_train1 = zeros(n,1);
arr_P_TPSS2_train1 = zeros(n,1);
arr_I_train1_TPSS2 = zeros(n,1);
arr_I_train2_TPSS2 = zeros(n,1);
arr_P_TPSS2_train2 = zeros(n,1);
arr_P_TPSS3_train2 = zeros(n,1);
arr_DC_loss_TPSS1 = zeros(n,1);
arr_DC_loss_TPSS2 = zeros(n,1);
arr_DC_loss_TPSS3 = zeros(n,1);
arr_DC_loss_total = zeros(n,1);
arr_Pacc_batt_TPSS1 = zeros(n,1);
arr_Pacc_batt_TPSS2 = zeros(n,1);
arr_Pacc_batt_TPSS3 = zeros(n,1);
arr_SoC_TPSS1 = zeros(n,1);
arr_SoC_TPSS2 = zeros(n,1);
arr_SoC_TPSS3 = zeros(n,1);

% Loop to compute values
for i = 1:n % Below this we bring information from the substation function and calculation for the power flow
    [arr_P_TPSS1(i), arr_P_TPSS1_loss(i), arr_P_TPSS1_net(i), arr_I_TPSS1(i), arr_Pacc_batt_TPSS1(i), arr_SoC_TPSS1(i)] = TPSS_acc_power(arr_Vcat_TPSS1(i),arr_soc_TPSS1(i));
    [arr_P_TPSS2(i), arr_P_TPSS2_loss(i), arr_P_TPSS2_net(i), arr_I_TPSS2(i), arr_Pacc_batt_TPSS2(i), arr_SoC_TPSS2(i)] = TPSS_acc_power(arr_Vcat_TPSS2(i),arr_soc_TPSS2(i));
    [arr_P_TPSS3(i), arr_P_TPSS3_loss(i), arr_P_TPSS3_net(i), arr_I_TPSS3(i), arr_Pacc_batt_TPSS3(i), arr_SoC_TPSS3(i)] = TPSS_acc_power(arr_Vcat_TPSS3(i),arr_soc_TPSS3(i));
    [arr_P_TPSS1_train1(i), arr_P_TPSS2_train1(i)] = Train_demand(arr_I_TPSS1(i), arr_Vcat_train1(i), arr_Pcat_train1(i)); % Power that train demand from the nearby TPSS
    arr_I_train1_TPSS2(i) = arr_P_TPSS2_train1(i) / arr_Vcat_train1(i); % Current from train1 to TPSS2
    arr_I_train2_TPSS2(i) = arr_I_TPSS2(i) - arr_I_train1_TPSS2(i);
    [arr_P_TPSS2_train2(i), arr_P_TPSS3_train2(i)] = Train_demand(arr_I_train2_TPSS2(i), arr_Vcat_train2(i), arr_Pcat_train2(i)); % Power that train demand from the nearby TPSS

    arr_DC_loss_TPSS1(i) = arr_P_TPSS1_net(i) - arr_P_TPSS1_train1(i);
    arr_DC_loss_TPSS2(i) = arr_P_TPSS2_net(i) - (arr_P_TPSS2_train1(i) + arr_P_TPSS2_train2(i));
    arr_DC_loss_TPSS3(i) = arr_P_TPSS3_net(i) - arr_P_TPSS3_train2(i);
    arr_DC_loss_total(i) = arr_DC_loss_TPSS1(i) + arr_DC_loss_TPSS2(i) + arr_DC_loss_TPSS3(i);
end

% Create table
results = table(arr_Vcat_TPSS1, arr_Vcat_TPSS2, arr_Vcat_TPSS3, ...
                arr_Pcat_train1, arr_Vcat_train1, arr_Pcat_train2, arr_Vcat_train2, ...
                arr_P_TPSS1, arr_P_TPSS2, arr_P_TPSS3, ...
                arr_Pacc_batt_TPSS1, arr_Pacc_batt_TPSS2, arr_Pacc_batt_TPSS3, ...
                arr_P_TPSS1_loss, arr_P_TPSS2_loss, arr_P_TPSS3_loss, arr_DC_loss_total,...
                arr_SoC_TPSS1, arr_SoC_TPSS2, arr_SoC_TPSS3);

% Assign variable names to the table
results.Properties.VariableNames = ["Vcat_TPSS1[V]", "Vcat_TPSS2[V]", "Vcat_TPSS3[V]", "Pcat_train1[kW]", "Vcat_train1[V]", ...
                                    "Pcat_train2[kW]", "Vcat_train2[V]", "P_TPSS1[kW]", "P_TPSS2[kW]", "P_TPSS3[kW]", ...
                                    "Pbatt_TPSS1[kW]", "Pbatt_TPSS2[kW]", "Pbatt_TPSS3[kW]", ...
                                    "P_TPSS1_loss[kW]", "P_TPSS2_loss[kW]", "P_TPSS3_loss[kW]", "DC_loss_total[kW]","SoCfinal1","SoCfinal2","SoCfinal3"];

% Display the table
disp(results);
writetable(results,'TPSS_Nonreverse_WITH_ACC.csv')

%% Non-Revesible TPSS + Acc
clear all; clc;
% Check the slide lesson 2 DC rail page 19
Vcat_TPSS1 = 735; % Change this to test substation !!!!!
SoC = 93;
TPSS_acc_power(Vcat_TPSS1,SoC)

function [P_TPSS, P_TPSS_loss, P_TPSS_net, I_TPSS, Pacc_cat, SoCfinal] = TPSS_acc_power(Vcat_TPSS,SoC)
    Vcat_nominal = 750; % THIS IS NOMINAL VOLTAGE DO NOT CHANGE THIS
    Rf_TPSS = 228e-3; % Substation converter resistance

    SoC1 = 0.05;    % min SoC for Pacc offboard discharging protection
    SoC2 = 0.1;     % max SoC for Pacc offboard discharging protection
    SoC3 = 0.9;     % min SoC for Pacc offboard charging protection
    SoC4 = 0.95;    % max SoC for Pacc offboard charging protection

    dV1 = 10;
    dV2 = 10;
    dV3 = 10;

    V1 = Vcat_nominal-dV2-dV1;  % min Vcat for Pacc offboard discharge
    V2 = Vcat_nominal-dV2;      % max Vcat for Pacc offboard discharge
    V3 = Vcat_nominal+dV2;      % min Vcat for Pacc offboard charge
    V4 = Vcat_nominal+dV2+dV3;  % max Vcat for Pacc offboard charge

    Pmax = 200; % [kW] max power of offboard battery/accumulator (charging and discharging)
    Emax = 50; % [kWh] offboard battery/accumluator's capacity]

    dt = 1/3600; % [s]

    eff = 0.9; % efficiency of offboard converter/rectifier/inverter

    k = getKp(Vcat_TPSS, V1, V2, V3, V4, dV1, dV3); % Pacc modifier based on Vcat
    k_soc = getKc(SoC, SoC1, SoC2, SoC3, SoC4);     % Pacc modifier based on SoC


    if (Vcat_TPSS <= V2) % Vcat lower than blocking state voltage go to discharging mode

        I_TPSS = (Vcat_nominal-Vcat_TPSS)/Rf_TPSS; % Current that goes from substation
        P_TPSS_loss = ((Vcat_nominal-Vcat_TPSS)^2)*1e-3/Rf_TPSS; % Loss in the substation
        P_TPSS_req = I_TPSS*Vcat_nominal*1e-3;  % The full power that substation need to provide (DEMAND)
        P_batt_req = P_TPSS_req*k_soc*k; % This is value that demand on battery 
        Pacc_cat = min(P_batt_req,Pmax*eff); % If the demand less than the full capacity of battery use the just as demand
        % If the demand larger than the capacity of battery just provide
        % the maximum
        P_TPSS = P_TPSS_req - Pacc_cat; % The power that more than battery can provide, substation will provide it.
        Pacc_batt = Pacc_cat/eff;

        P_TPSS_net = P_TPSS_req - P_TPSS_loss; % The real that DC get from TPSS pass through converter
        SoCfinal = (Emax*SoC - Pacc_batt*dt)/Emax; % new soc calculation [kWh * {0-1} - kW*t]/kWh
    elseif (Vcat_TPSS >= V3) % Vcat higher than blocking state voltage go to charging mode

        P_TPSS_loss = 0; % During charging process there is no power reverse to the substation

        P_TPSS = 0; % During charging process there is no power reverse to the substation
        Pacc_batt = -Pmax*eff*k_soc*k; % The amount that battery be able to receive
        Pacc_cat = Pacc_batt/eff; % The power before goes to converter
        I_TPSS = Pacc_batt/Vcat_TPSS; % Current to charge the battery

        P_TPSS_net = P_TPSS - P_TPSS_loss;
        SoCfinal = (Emax*SoC - Pacc_batt*dt)/Emax; % new soc calculation [kWh * {0-1} - kW*t]/kWh
    else % Vcat in the blocking state
        Pacc_batt = 0;
        Pacc_cat = 0;
        I_TPSS = 0;
        P_TPSS = 0;
        P_TPSS_loss = 0;
        P_TPSS_net = 0; 
    end
end


%% Non-Revesible TPSS
function [P_TPSS, P_TPSS_loss, P_TPSS_net, I_TPSS] = TPSS_power(Vcat)
    Rf_TPSS = 228e-3; % Substation converter resistance
    Vcat_nominal = 750;
    if (Vcat < Vcat_nominal) % If the V catenery less than the nominal value, substation need to inject current 
        P_TPSS_loss = ((Vcat_nominal-Vcat)^2)*1e-3/Rf_TPSS;
        I_TPSS = (Vcat_nominal-Vcat)/Rf_TPSS;
        P_TPSS = I_TPSS*Vcat_nominal*1e-3;
        P_TPSS_net = P_TPSS - P_TPSS_loss;
    else % Substation is blocked
        I_TPSS = 0;
        P_TPSS = 0;
        P_TPSS_loss = 0;
        P_TPSS_net = 0;
    end
end

%% Reversible TPSS
function [P_TPSS, P_TPSS_loss, P_TPSS_net, I_TPSS] = TPSS_reverse_power(Vcat)
    Rf_TPSS = 228e-3; % Substation converter resistance
    % Rr_TPSS = 2*Rf_TPSS;
    % Rr_TPSS = 0.3;
    Rr_TPSS = Rf_TPSS;
    Vcat_nominal = 750;

    Vr = 10; % volts above the Vcat_nominal to start grid injection

    if (Vcat < Vcat_nominal) % If the V catenery lower than the nominal value substation need to inject power
        P_TPSS_loss = ((Vcat_nominal-Vcat)^2)*1e-3/Rf_TPSS;
        I_TPSS = (Vcat_nominal-Vcat)/Rf_TPSS;
        P_TPSS = I_TPSS*Vcat_nominal*1e-3;
        P_TPSS_net = P_TPSS - P_TPSS_loss;
    elseif (Vcat > Vcat_nominal+Vr) % If the V catenery higher than nominal in need reverse back!!
        P_TPSS_loss = ((Vcat_nominal+Vr-Vcat)^2)*1e-3/Rr_TPSS;
        I_TPSS = ((Vcat_nominal+Vr-Vcat)/Rr_TPSS);
        P_TPSS = I_TPSS*Vcat_nominal*1e-3;
        P_TPSS_net = P_TPSS - P_TPSS_loss;
    else % Substation is blocked
        I_TPSS = 0;
        P_TPSS = 0;
        P_TPSS_loss = 0;
        P_TPSS_net = 0;
    end
end

function k = getKp(Vcat, V1, V2, V3, V4, dV1, dV3)
    if Vcat <= V1 % Fully discharge
        k = 1
    elseif Vcat <= V2 && Vcat > V1 % Vcat near the blocking state partially discharge
        k = 1-(Vcat-V1)/(dV1)
    elseif Vcat >= V3 && Vcat < V4 % Vcat near the blocking state partially charge
        k = 1-(V4-Vcat)/(dV3)
    elseif Vcat >= V4 % Fully charge
        k = 1
    else % Blocking state
        k = 0
    end
    % k = clip(k,0,1); % limit this like a sat block
end

function k_soc = getKc(soc, dchrg_socMin, dchrg_socMax, chrg_socMin, chrg_socMax)
    if soc <= dchrg_socMin % Stop discharging
        k_soc = 0
    elseif soc > dchrg_socMin && soc <= dchrg_socMax % Discharging mode
        k_soc = (soc-dchrg_socMin)/(dchrg_socMax-dchrg_socMin)
    elseif soc >= chrg_socMin && soc < chrg_socMax % Charging mode
        k_soc = (chrg_socMax-soc)/(chrg_socMax-chrg_socMin)
    elseif soc >= chrg_socMax % Stop charging
        k_soc = 0
    else % If SoC in the middle, can fully charge or discharge
        k_soc = 1 
    end
    % k_soc = clip(k_soc,0,1);
end

%% OTHER FUNCTIONS
% This function the purpose to define how much the power from train get
% from TPSS nearby, for an example, train1 is between TPSS1 and TPSS2, This
% function will calculate Power from TPSS1(Left) to Train1 
function [Pcat_train_TPSS_L, Pcat_train_TPSS_R] = Train_demand(I_TPSS_L, Vcat_train, Pcat_train)
    Pcat_train_TPSS_L = Vcat_train*I_TPSS_L*1e-3;
    Pcat_train_TPSS_R = Pcat_train - Pcat_train_TPSS_L;
end

