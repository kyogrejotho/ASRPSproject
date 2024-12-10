clear all; clc;
%% Case1

Pcat_train1 = 650e3; % This is known, is split between L and R (in slides, 307 and 343)
Vcat_train1 = 550;
Pcat_train2 = 350e3;
Vcat_train2 = 582;

Vcat_TPSS1 = 622;
Vcat_TPSS2 = 590;
Vcat_TPSS3 = 630;

pk_train1 = 2;
pk_train2 = 4.6;

TPSSx1 = 0; % Distance Substation1
TPSSx2 = 3; % Distance Substation2 
TPSSx3 = 6; % Distance Substation3

[P_TPSS1,P_TPSS1_loss,P_TPSS1_net,I_TPSS1] = TPSS_power(Vcat_TPSS1)
[P_TPSS2,P_TPSS2_loss,P_TPSS2_net,I_TPSS2] = TPSS_power(Vcat_TPSS2)
[P_TPSS3,P_TPSS3_loss,P_TPSS3_net,I_TPSS3] = TPSS_power(Vcat_TPSS3)
[P_TPSS1_train1,P_TPSS2_train1] = Train_demand(I_TPSS1,Vcat_train1,Pcat_train1)
I_train1_TPSS2 = P_TPSS2_train1/Vcat_train1;
I_train2_TPSS2 = I_TPSS2-I_train1_TPSS2;
[P_TPSS2_train2,P_TPSS3_train2] = Train_demand(I_train2_TPSS2,Vcat_train2,Pcat_train2)

DC_loss_TPSS1 = P_TPSS1_net - P_TPSS1_train1
DC_loss_TPSS2 = P_TPSS2_net - (P_TPSS2_train1+P_TPSS2_train2)
DC_loss_TPSS3 = P_TPSS3_net - P_TPSS3_train2
DC_loss_total = DC_loss_TPSS1 + DC_loss_TPSS2 + DC_loss_TPSS3

% P_DC_loss12 = DC_loss(I_TPSS1,I_train1_TPSS2,pk_train1,TPSSx1,TPSSx2)
% P_DC_loss23 = DC_loss(I_train2_TPSS2,I_TPSS3,pk_train2,TPSSx1,TPSSx2)

%% RUN Test case
clear all; clc;

% Data arrays
arr_Vcat_TPSS1 = [622;872;645;850]; % Input Vcat at Substation 1
arr_Vcat_TPSS2 = [590;800;614;800]; % Input Vcat at Substation 2
arr_Vcat_TPSS3 = [630;747;641;740]; % Input Vcat at Substation 3

arr_Pcat_train1 = [650e3;-650e3;524e3;-585e3]; % Input Pcat at train 1
arr_Vcat_train1 = [550;872;586;850]; % Input Vcat at train 1
arr_Pcat_train2 = [350e3;564e3;377e3;526e3]; % Input Pcat at train 2
arr_Vcat_train2 = [582;746;598;737]; % Input Vcat at train 2

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
    [arr_P_TPSS1_train1(i), arr_P_TPSS2_train1(i)] = Train_demand(arr_I_TPSS1(i), arr_Vcat_train1(i), arr_Pcat_train1(i));
    arr_I_train1_TPSS2(i) = arr_P_TPSS2_train1(i) / arr_Vcat_train1(i);
    arr_I_train2_TPSS2(i) = arr_I_TPSS2(i) - arr_I_train1_TPSS2(i);
    [arr_P_TPSS2_train2(i), arr_P_TPSS3_train2(i)] = Train_demand(arr_I_train2_TPSS2(i), arr_Vcat_train2(i), arr_Pcat_train2(i));

    arr_DC_loss_TPSS1(i) = arr_P_TPSS1_net(i) - arr_P_TPSS1_train1(i);
    arr_DC_loss_TPSS2(i) = arr_P_TPSS2_net(i) - (arr_P_TPSS2_train1(i) + arr_P_TPSS2_train2(i));
    arr_DC_loss_TPSS3(i) = arr_P_TPSS3_net(i) - arr_P_TPSS3_train2(i);
    arr_DC_loss_total(i) = arr_DC_loss_TPSS1(i) + arr_DC_loss_TPSS2(i) + arr_DC_loss_TPSS3(i);
end

% Create table
results = table(arr_Vcat_TPSS1, arr_Vcat_TPSS2, arr_Vcat_TPSS3, ...
                arr_Pcat_train1/1000, arr_Vcat_train1, arr_Pcat_train2/1000, arr_Vcat_train2, ...
                arr_P_TPSS1/1000, arr_P_TPSS2/1000, arr_P_TPSS3/1000, ...
                arr_P_TPSS1_loss/1000, arr_P_TPSS2_loss/1000, arr_P_TPSS3_loss/1000, arr_DC_loss_total/1000);

% Assign variable names to the table
results.Properties.VariableNames = ["Vcat_TPSS1", "Vcat_TPSS2", "Vcat_TPSS3", "Pcat_train1", "Vcat_train1", ...
                                    "Pcat_train2", "Vcat_train2", "P_TPSS1", "P_TPSS2", "P_TPSS3", ...
                                    "P_TPSS1_loss", "P_TPSS2_loss", "P_TPSS3_loss", "DC_loss_total"];

% Display the table
disp(results);

%% Revesible TPSS
clear all; clc;
% Check the slide lesson 2 DC rail page 19
Vcat_TPSS1 = 765;
SoC = 0.5;
TPSS_acc_power(Vcat_TPSS1,SoC)


function [P_TPSS P_TPSS_loss P_TPSS_net I_TPSS] = TPSS_acc_power(Vcat_TPSS,SoC)
Vcat_nominal = 750;

SoC1 = 0.05;
SoC2 = 0.1;
SoC3 = 0.9; % For Pablo's case, use 0.95
SoC4 = 0.95; % For Pablo's case, use 1.00

dV1 = 10;
dV2 = 10;
dV3 = 10;

V1 = Vcat_nominal-dV2-dV1;
V2 = Vcat_nominal-dV2;
V3 = Vcat_nominal+dV2;
V4 = Vcat_nominal+dV2+dV3;

Pmax = 200e3;
Emax = 50e3;

eff = 0.9;

k = getKp(Vcat_TPSS,V1,V2,V3,V4,dV1,dV3);
k_soc = getKc(SoC, SoC1, SoC2, SoC3, SoC4);


if(Vcat_TPSS <= V2) % Vcat lower than blocking state voltage go to discharging mode
Pacc1 = Pmax*k
Pacc2 = k_soc*Pacc1*eff

elseif(Vcat_TPSS >= V3) % Vcat higher than blocking state voltage go to charging mode
Pacc1 = -1*Pmax*k
Pacc2 = k_soc*Pacc1/eff
else % Vcat in the blocking state
Pacc1 = 0
Pacc2 = 0
end

end


%% function
function [P_TPSS P_TPSS_loss P_TPSS_net I_TPSS] = TPSS_power(Vcat)

Rf_TPSS = 228e-3; % Substation converter resistance
Vcat_nominal = 750;
if (Vcat < Vcat_nominal)
    P_TPSS_loss = ((Vcat_nominal-Vcat)^2)/Rf_TPSS;
    I_TPSS = (Vcat_nominal-Vcat)/Rf_TPSS;
    P_TPSS = I_TPSS*Vcat_nominal;
    P_TPSS_net = P_TPSS - P_TPSS_loss;
else % Substation is blocked
    I_TPSS = 0;
    P_TPSS = 0;
    P_TPSS_loss = 0;
    P_TPSS_net = 0; 
end
end


function [Pcat_train_TPSS_L,Pcat_train_TPSS_R] = Train_demand(I_TPSS,Vcat_train,Pcat_train)
Pcat_train_TPSS_L = Vcat_train*I_TPSS;
Pcat_train_TPSS_R = Pcat_train - Pcat_train_TPSS_L;
end

function P_DC_loss_total = DC_loss(I_TPSS_L,I_TPSS_R,pk,x_TPSS_L,x_TPSS_R)
Rrail = 0.014; % Negative feeder resistance
Rline = 0.051; % Positive feeder resistance
Rkm = Rrail+Rline; % [Ohm/km]

Distance1 = abs(pk - x_TPSS_L);
Distance2 = abs(x_TPSS_R - pk);
R1 = Rkm * Distance1;
R2 = Rkm * Distance2;

P_DC_loss_L = (I_TPSS_L^2)*R1;
P_DC_loss_R = (I_TPSS_R^2)*R2;

P_DC_loss_total = P_DC_loss_L + P_DC_loss_R;

end

function k = getKp(Vcat,V1,V2,V3,V4,dV1,dV3)
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

function k_soc = getKc (soc, dchrg_socMin, dchrg_socMax, chrg_socMin,chrg_socMax)
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