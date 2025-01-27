clc;
clear all;


%% Put test case here individually
eff = 0.9; % efficiency of onborad converter/rectifier/inverter
%[Pcat51, Pnosupp51, Prhe51, Pacc51] = Train_offboard(650, 0.9, 745, 0.5); % Testing only, for charging
%% In Table From
arr_labels = ["Pref", "Vcat", "SOCinit", "Pcat", "Prhe","Pnosupp", "Pacc","Ptrain", "SOCfinal"]; % NOT USED NOW
arr_Pref = [350;200;350;200;350;350;200;350;350;150;650;350;200;650;350;200;200;-350;-650;-350;-650;-150;-200;-650;-150;-650;-300;-650;-150;-650;-200;-600;-1000;-650];
arr_Vcat = [550;550;550;550;550;600;600;600;600;600;575;575;575;575;575;575;575; 900; 900; 900; 900; 900; 850; 850; 850; 850; 850; 875; 875; 875; 875; 890;  875; 890];
arr_SOC_init = [0.5;0.5;0.075;0.075;0.05;0.05;0.5;0.5;0.075;0.09;0.5;0.5;0.5;0.075;0.075;0.075;0.05;1;0.5;0.5;0.975;0.975;1;0.975;0.975;0.5;0.5;0.975;0.975;0.5;0.5;1;0.5;0.975];
%Pre-allocate arrays
arr_Pcat = ones(length(arr_Pref),1);
arr_Pnosupp = ones(length(arr_Pref),1);
arr_Prhe = ones(length(arr_Pref),1);
arr_Pacc = ones(length(arr_Pref),1);
arr_SoC_final = ones(length(arr_Pref),1);
arr_Ptrain = ones(length(arr_Pref),1);

for i = 1:length(arr_Pref)
    [iter_Pcat,iter_Pnosupp,iter_Prhe,iter_Pacc,iter_Ptrain,iter_SoCfinal] = Train_batt(arr_Pref(i),eff,arr_Vcat(i),arr_SOC_init(i)); % add new SoC
    arr_Pcat(i) = iter_Pcat;
    arr_Pnosupp(i) = iter_Pnosupp;
    arr_Prhe(i) = iter_Prhe;
    arr_Pacc(i) = iter_Pacc;
    arr_Ptrain(i) = iter_Ptrain;
    arr_SoC_final(i) = iter_SoCfinal;
end
results = table(arr_Pref, arr_Vcat,arr_SOC_init, arr_Pcat, arr_Prhe, arr_Pnosupp, arr_Pacc, arr_Ptrain, arr_SoC_final);
results.Properties.VariableNames = ["Pref", "Vcat", "SOCinit", "Pcat", "Prhe","Pnosupp", "Pacc","Ptrain", "SOCfinal"];
writetable(results,'trainWithBattery.csv')
%% FUNCTIONS

% Simple Train
function [Pcat] = Train_simple_fxn(Pref, eff, Vcat)
    Pcat = Pref/eff % power from/to catenary
    Icat = Pcat*1e3/Vcat % current from/to catenary
end

% Train /w squeeze control
function [Pcat,Pnosupp,Prhe] =  Train_protection(Pref, eff, Vcat)

    v1 = 550; % min Vcat for overcurrent protection (ocpMin)
    v2 = 600; % max Vcat for overcurrent protection (ocpMax) 
    v3 = 850; % min Vcat for overvoltage protection (ovpMin)
    v4 = 900; % max Vcat for overvoltage protection (ovpMax)
    
    k = getKp(Pref, Vcat, v1,v2,v3,v4); % Pcat modifier

    if Pref >= 0
        Pcat = k*Pref/eff; % k is the slope of the OCP line
        Pnosupp = Pref - (Pcat*eff);
        Prhe = 0; % no Prhe if OCP
    elseif Pref < 0 
        Pcat = k*Pref*eff; % k is the slope of the OVP line
        Prhe = (Pref*eff) - Pcat;
        Pnosupp = 0; % no Pnosupp if OVP
    end
end

% Train /w onboard accumulator & squeeze control
function [Pcat, Pnosupp, Prhe, Pacc, Ptrain, SoCfinal] = Train_batt(Pref, eff, Vcat, SoC)
    SoC1 = 0.05;    % min SoC for Pacc onboard discharging protection
    SoC2 = 0.1;     % max SoC for Pacc onboard discharging protection
    SoC3 = 0.9;     % min SoC for Pacc onboard charging protection
    SoC4 = 0.95;    % max SoC for Pacc onboard charging protection

    v1 = 550;       % min Vcat for overcurrent protection (ocpMin)
    v2 = 600;       % max Vcat for overcurrent protection (ocpMax) 
    v3 = 850;       % min Vcat for overvoltage protection (ovpMin)
    v4 = 900;       % max Vcat for overvoltage protection (ovpMax)

    dt = 1/3600; % [s]
    
    Pmax = 300; % [kW] max power of battery/accumulator (charging and discharging)
    Emax = 20; % [kWh] battery/accumluator's capacity
    eff_b = 0.9; % battery converter's efficiency, same as for other onborad converter/rectifier/inverter

    k = getKp(Pref, Vcat, v1,v2,v3,v4); % Pcat modifier
    k_soc = getKc(Pref, SoC, SoC1, SoC2, SoC3, SoC4); % Pacc modifier
    
    % Here, Ptrain is the "potential" Pcat
    if Pref >= 0 % Traction
        Ptrain = Pref/eff; % @ after converter, removed k
        Pacc_available = k_soc*Pmax*eff_b; %Pmax only equal to Pacc_available if SoC2 < soc 
        %Pacc = min(Pacc_available,Pref/(eff*eff_b)); % used to be second arg Ptrain
        Pacc = min(Pacc_available,Ptrain);
        Pacc2 = min((Pref/eff^2),Pmax*k_soc);
        %Pcat = (Pref/eff - Pacc*eff_b)*k; % Pcat = Ptrain-Pacc before
        Pcat = (Ptrain-Pacc)*k; 
        Pnosupp = Pref-Pacc*(eff)-(Pcat*eff); % Pref-(Ptrain*eff);
        Prhe = 0; % no Prhe if traction
        Ptrain = Pacc + Pcat;
        SoCfinal = (Emax*SoC - Pacc2*dt)/Emax; % new soc calculation [kWh * {0-1} - kW*t]/kWh
    elseif Pref < 0 % Braking
        Ptrain = Pref*eff; % no k yet since we have not hit cat yet
        Pacc_available = -1*k_soc*Pmax/eff_b; %Pmax only equal to Pacc_available if soc < SoC3
        Pacc = max(Pacc_available, Ptrain); % these are negative values, the max value is smaller in magnitude
        Pacc2 = max((Pref*(eff^2)),-Pmax*k_soc);
        Pcat = max(Ptrain-Pacc, k*Ptrain); % Ptrain was originally Pcat in slides, seems wrong
        Prhe = Ptrain -Pacc - Pcat;
        Pnosupp = 0; % no Pnosupp if OCV
        Ptrain = Pacc + Pcat + Prhe;
        SoCfinal = (Emax*SoC - Pacc2*dt)/Emax; % new soc calculations
    end
end

function k = getKp (Pref, Vcat, ocpMin, ocpMax, ovpMin, ovpMax)
    if Pref >= 0 % OCP only happens during positive power/taking power from catenary
        k = (Vcat-ocpMin)/(ocpMax-ocpMin);
    elseif Pref < 0 % OVP only happens during negative power/injecting power to catenary
        k = (ovpMax-Vcat)/(ovpMax-ovpMin);
    end
    k = clip(k,0,1); % limit this like a sat block
end

function k_soc = getKc (Pref, soc, dchrg_socMin, dchrg_socMax, chrg_socMin,chrg_socMax)
    if Pref >=0 % Battery will discharge, train is in traction mode
        k_soc = (soc-dchrg_socMin)/(dchrg_socMax-dchrg_socMin);
    elseif Pref < 0 % Charge the accumulator/battery only when train is braking
        k_soc = (chrg_socMax-soc)/(chrg_socMax-chrg_socMin);
    end
    k_soc = clip(k_soc,0,1);
end
