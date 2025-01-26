clc;
clear all;

eff = 0.9;
%% Put test case here
[Pcat51,Pnosupp51,Prhe51,Pacc51] = Train_offboard(650,0.9,745,0.5); % Testing only, for charging
%% Functions
function [Pcat] = Train_simple_fxn(Pref,eff, Vcat)
    Pcat = Pref/eff
    Icat = Pcat/Vcat
end

function [Pcat,Pnosupp,Prhe] =  Train_protection(Pref,eff,Vcat)

    v1 = 550; % hardcoded for now
    v2 = 600;
    v3 = 850;
    v4 = 900;
    
    k = getKp(Pref, Vcat, v1,v2,v3,v4);

    if Pref >= 0
        Pcat = k*Pref/eff; % k is the slope of the OCP line
        Pnosupp = Pref-(Pcat*eff);
        Prhe = 0; % no Prhe if OCP
    elseif Pref < 0 
        Pcat = k*Pref*eff;
        Prhe = (Pref*eff) - Pcat;
        Pnosupp = 0; % no Pnosupp if OCV
    end
end

function [Pcat, Pnosupp, Prhe, Pacc, Ptrain,SoCfinal] = Train_batt(Pref, eff, Vcat,SoC)
    SoC1 = 0.05;
    SoC2 = 0.1;
    SoC3 = 0.9; % For Pablo's case, use 0.95
    SoC4 = 0.95; % For Pablo's case, use 1.00

    v1 = 550; % hardcoded for now
    v2 = 600;
    v3 = 850;
    v4 = 900;

    dt = 1/3600; % [s]
    
    Pmax = 300; % [kW]
    Emax = 20; % [kWh]
    eff_b = 0.9; % battery efficiency, same as for caternary?

    k = getKp(Pref, Vcat, v1,v2,v3,v4);
    k_soc = getKc(Pref, SoC, SoC1, SoC2, SoC3, SoC4);
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

function [Pcat, Pnosupp, Prhe] = Train_substation(Pref, eff, Vcat)
    Ptf = 350; % [kW] or 0.35 MW
    V0 = 750; % [V]
    Vn = 700; % [V]
    Vcc = 0.08; % 8%
    Pconv = 175; % [kW] or 0.175 MW
    Vdead = 10; % [V]
    Rf = 228e-3; % [Ohms]

    v1 = 550; % hardcoded for now
    v2 = 600;
    v3 = 850;
    v4 = 900;
    
    k = getKp(Pref, Vcat, v1,v2,v3,v4);

    if Pref >= 0
        Pcat = k*Pref/eff; % k is the slope of the OCP line
        Pnosupp = Pref-(Pcat*eff);
        Prhe = 0; % no Prhe if traction/OCP
        Icat = Pcat/Vcat
        Loss_cat = Icat * Rf; % [kW]
    elseif Pref < 0 
        k;
        Pcat = k*Pref*eff;
        Prhe = (Pref*eff) - Pcat;
        Pnosupp = 0; % no Pnosupp if braking/OVP
    end
end

function [Pcat, Pnosupp, Prhe, Pacc] = Train_offboard(Pref, eff, Vcat, SoC)
    
    SoC1 = 0.05;
    SoC2 = 0.1;
    SoC3 = 0.9; % For Pablo's case, use 0.95
    SoC4 = 0.95; % For Pablo's case, use 1.00

    Vreg = 750;
    dV1 = 10; % [V]
    dV2 = 10; % [V]
    dV3 = 10; % [V]
    
    dt = 1/3600; % [hours in a second]
    
    Pmax = 200; % [kW]
    Emax = 50; % [kWh]
    eff_b = 0.9; % battery efficiency, same as for caternary?

    v1 = 550; % hardcoded for now
    v2 = 600;
    v3 = 850;
    v4 = 900;
    
    k = getKp(Pref, Vcat, v1,v2,v3,v4);
    k_soc = getKc(Pref, SoC, SoC1, SoC2, SoC3, SoC4);
    [k_off,bool_chrg] = getKoff(Vcat,Vreg,dV1,dV2,dV3) % temporary, need to know logic for chrg/dchrg
    if ~bool_chrg
        Ptrain = Pref/eff; % @ after converter, removed k
        Pacc_available = k_soc*k_off*Pmax*eff_b %Pmax only equal to Pacc_available if SoC2 < soc 
        %Pacc = min(Pacc_available,Pref/(eff*eff_b)); % used to be second arg Ptrain
        Pacc = min(Pacc_available,Ptrain);
        Pacc2 = min((Pref/eff^2),Pmax*k_soc);
        %Pcat = (Pref/eff - Pacc*eff_b)*k; % Pcat = Ptrain-Pacc before
        Pcat = (Ptrain-Pacc)*k; 
        Pnosupp = Pref-Pacc*(eff)-(Pcat*eff); % Pref-(Ptrain*eff);
        Prhe = 0; % no Prhe if traction
        SoCfinal = (Emax*SoC - Pacc2*dt)/Emax; % new soc calculation [kWh * {0-1} - kW*t]/kWh
    elseif bool_chrg
        Ptrain = Pref*eff % no k yet since we have not hit cat yet
        Pacc_available = -1*k_off*k_soc*Pmax/eff_b %Pmax only equal to Pacc_available if soc < SoC3
        Pacc = max(Pacc_available, Ptrain); % these are negative values, the max value is smaller in magnitude
        Pacc2 = max((Pref*(eff^2)),-Pmax*k_soc);
        Pcat = max(Ptrain-Pacc, k*Ptrain); % Ptrain was originally Pcat in slides, seems wrong
        Prhe = Ptrain -Pacc - Pcat;
        Pnosupp = 0; % no Pnosupp if OCV
        SoCfinal = (Emax*SoC - Pacc2*dt)/Emax; % new soc calculations
    end
end

function isNum = checkNum(numInput)
    testNum = str2double(numInput);
    if isnan(testNum)
        isNum = 0;
        uiwait(warnndlg('Invalid input! Please numerical values only for voltage or power'));
    else
        isNum = 1;
    end
end

function k = getKp(Pref,Vcat,ocpMin, ocpMax, ovpMin, ovpMax)
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

function [k_off,bool_chrg] = getKoff (Vcat, Vreg, dV1, dV2, dV3)
    if Vcat < Vreg % Discharge when grid voltage down
        if Vcat > Vreg-dV2 % Deadband
            k_off = 0;
        else
            k_off = (Vcat-(Vreg-dV1-dV2))/(dV1); % Vcat - lower limit, at the slope
        end
        bool_chrg = 0;
    elseif Vcat > Vreg % Charge when grid voltage up
        if Vcat < Vreg+dV2 %deadband
            k_off = 0;
        else 
            k_off = (Vcat-(Vreg+dV2))/(dV3); % upper limit - Vcat
        end
        bool_chrg = 1;
    end
    k_off = clip(k_off, 0, 1);
end

