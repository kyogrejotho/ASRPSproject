clc; close all; clear all;

%% Test Case
test_case

global Vcat dt;
dt = 60;
%
test_case
for j = 1:length(arr_SOC_init)
    for i = 1:length(arr_Pref)
        Vcat = arr_Vcat(i);
        [iter_Pcat,~,iter_Pnosupp,iter_Prhe,iter_Pacc,iter_SOC_final] = train004(arr_Pref(i),arr_SOC_init(j));
        arr_Pcat(i,j) = iter_Pcat;
        arr_Pnosupp(i,j) = iter_Pnosupp;
        arr_Prhe(i,j) = iter_Prhe;
        arr_Pacc(i,j) = iter_Pacc;
        arr_SOC_final(i,j) = iter_SOC_final;
    end
    % output test case, one initial SOC per table
    result = table(arr_Pref, arr_Vcat, arr_SOC_init(j)*ones(length(arr_Pref),1), arr_Pcat(:,j), arr_Pnosupp(:,j), arr_Prhe(:,j), arr_Pacc(:,j), arr_SOC_final(:,j));
    result.Properties.VariableNames = arr_labels
end
%}

%{
Pref = 350;
Vcat = 650;
soc = 0 * 1e-2;
% over current & over voltage
[Pcat,~,Pnosup,Prhe] = train003(Pref)
% over current & over voltage /w accumulator
[Pcat,~,Pnosup,Prhe,soc] = train004(Pref,soc)
%}

function [Pcat,Icat] = train001(Pref)
    % no control
    global Vcat;
    eff = 0.9;
    if Pref >= 0
        Pcat = Pref/eff;
        Icat = Pcat/Vcat;
    else
        Pcat = eff*Pref;
        Icat = Pcat/Vcat;
    end
end

function [Pcat,Icat,Pnosup] = train002(Pref)
    % over current
    global Vcat;
    eff = 0.9;
    if Pref >= 0
        Pcat = Pref*kOC()/eff;
        Icat = Pcat/Vcat;
        Pnosup = Pref*(1-kOC());
    else
        Pcat = eff*Pref;
        Icat = Pcat/Vcat;
        Pnosup = 0;
    end
end

function [Pcat,Icat,Pnosup,Prhe] = train003(Pref)
    % over current & over voltage
    global Vcat;
    eff = 0.9;
    if Pref >= 0
        Pcat = Pref*kOC()/eff;
        Icat = Pcat/Vcat;
        Pnosup = Pref*(1-kOC());
        Prhe = 0;
    else
        Pcat = eff*Pref*kOV();
        Icat = Pcat/Vcat;
        Pnosup = 0;
        Prhe = eff*Pref*(1-kOV());
    end
end

function [Pcat,Icat,Pnosup,Prhe,Pacc2,soc] = train004(Pref,soc)
    % over current & over voltage /w accumulator
    global Vcat dt;
    eff = 0.9;
    Emax = 20 * 1e3; % Wh max energy in accumulator
    Pmax = 300 * 1e3; % Wh max power from/to accumulator
    % traction & discharge
    if Pref >= 0
        Pacc2 = min((Pref/(eff^2))*ksoc_discharge(soc),Pmax); % from batt, before converter
        Pacc1 = Pacc2*eff; % after converter (@ Pcat node)
        Pcat = (Pref/eff - Pacc1)*kOC(); % the rest of ref power from catenary (@ Pcat node)
        Pnosup = Pref - (Pcat + Pacc1)*eff; % the rest of power is not supplied (@ Pref node)
        Prhe = 0;

        Icat = Pcat/Vcat;
        soc = (Emax*soc - Pacc2*dt)/Emax; % new soc calculation
    % braking
    else
        Pacc2 = max((Pref*(eff^2))*ksoc_charge(soc),-Pmax); % to batt, after converter
        Pacc1 = Pacc2/eff; % before converter (@ Pcat node)
        Pcat = ((eff*Pref) - Pacc1)*kOV(); % the rest of ref power to catenary (@ Pcat node)
        Pnosup = 0;
        Prhe = Pref*eff - (Pcat + Pacc1); % (@ Pcat node)

        Icat = Pcat/Vcat;
        soc = (Emax*soc - Pacc2*dt)/Emax; % new soc calculation
    end
end

function k = kOC() % over current control
    global Vcat
    V1_OC = 550; % min catenary voltage, 0 Pcat (traction) below this
    V2_OC = 600; % start of over current control, linear scaling to V1_OC
    k = (Vcat-V1_OC)/(V2_OC-V1_OC);
    if k > 1
        k = 1;
    elseif k < 0
        k = 0;
    end
end

function k = kOV() % over voltage control
    global Vcat
    V3_OV = 850; % start of over voltage control, linear scaling to V4_OV
    V4_OV = 900; % max catenary voltage, 0 Pcat (braking) above this
    k = (V4_OV-Vcat)/(V4_OV-V3_OV);
    if k > 1
        k = 1;
    elseif k < 0
        k = 0;
    end
end

function k = ksoc_discharge(soc) % accumulator discharging control
    soc1_discharge = 5 * 1e-2; % min accumulator soc, 0 Pacc (traction) below this
    soc2_discharge = 10 * 1e-2; % start of discharging control, linear scaling to soc1_discharge
    k = (soc-soc1_discharge)/(soc2_discharge-soc1_discharge);
    if k > 1
        k = 1;
    elseif k < 0
        k = 0;
    end
end

function k = ksoc_charge(soc) % accumulator charging control
    soc3_charge = 90 * 1e-2; % start of over voltage control, linear scaling to soc4_charge
    soc4_charge = 95 * 1e-2; % max accumulator soc, 0 Pcat (braking) above this
    k = (soc4_charge-soc)/(soc4_charge-soc3_charge);
    if k > 1
        k = 1;
    elseif k < 0
        k = 0;
    end
end