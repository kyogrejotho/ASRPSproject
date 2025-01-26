clear all; clc;

Pcat_train1 = 650e3; % This is known, is split between L and R (in slides, 307 and 343)
Vcat_train1 = 750;%550;
Pcat_train2 = 350e3;
Vcat_train2 = 750;%582;

Vcat_TPSS1 = 750;%622;
Vcat_TPSS2 = 750;%590;
Vcat_TPSS3 = 750;%630;

pk_train1 = 2;
pk_train2 = 4.6;

TPSSx1 = 0; % Distance Substation1
TPSSx2 = 3; % Distance Substation2 
TPSSx3 = 6; % Distance Substation3

% Check the slide lesson 2 DC rail page 19
Vcat_TPSS1 = 765;
SoC = 0.5;
[P_TPSS,P_TPSS_loss,P_TPSS_net,I_TPSS] = TPSS_power(Vcat_TPSS1)

Vcat_TPSS = [750,750,750];
soc_TPSS = [0.5,0.5,0.5];
pk_TPSS = [TPSSx1,TPSSx2,TPSSx3];
Vcat_train = [750,750];
soc_train = [0.5,0.5];
pk_train = [pk_train1,pk_train2];
Pref_train = [Pcat_train1,Pcat_train2];

min(abs((pk_TPSS-pk_train(2)*ones(1,length(pk_TPSS)))))
pk_TPSS(min(((pk_TPSS-pk_train(1)*ones(1,length(pk_TPSS))))))


function [Vcat_TPSS,Vcat_train] = iter(Vcat_TPSS,soc_TPSS,pk_TPSS,Vcat_train,soc_train,pk_train,Pref_train)
    Rrail = 0.014; % Negative feeder resistance
    Rline = 0.051; % Positive feeder resistance
    Rkm = Rrail+Rline; % [Ohm/km]
    Vcat_TPSS(max((pk_TPSS-pk_train(1)*ones(length(pk_TPSS)))))
    %Distance1 = abs(pk - x_TPSS_L);
    %Distance2 = abs(x_TPSS_R - pk);
    %R1 = Rkm * Distance1;
    %R2 = Rkm * Distance2;
end

function [P_TPSS,P_TPSS_loss,P_TPSS_net,I_TPSS] = TPSS_power(Vcat)
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


function k = getKp(Vcat,V1,V2,V3,V4,dV1,dV3)
    if Vcat <= V1 % Fully discharge
        k = 1;
    elseif Vcat <= V2 && Vcat > V1 % Vcat near the blocking state partially discharge
        k = 1-(Vcat-V1)/(dV1);
    elseif Vcat >= V3 && Vcat < V4 % Vcat near the blocking state partially charge
        k = 1-(V4-Vcat)/(dV3);
    elseif Vcat >= V4 % Fully charge
        k = 1;
    else % Blocking state
        k = 0;
    end
    % k = clip(k,0,1); % limit this like a sat block
end

function k_soc = getKc (soc, dchrg_socMin, dchrg_socMax, chrg_socMin,chrg_socMax)
    if soc <= dchrg_socMin % Stop discharging
        k_soc = 0;
    elseif soc > dchrg_socMin && soc <= dchrg_socMax % Discharging mode
        k_soc = (soc-dchrg_socMin)/(dchrg_socMax-dchrg_socMin);
    elseif soc >= chrg_socMin && soc < chrg_socMax % Charging mode
        k_soc = (chrg_socMax-soc)/(chrg_socMax-chrg_socMin);
    elseif soc >= chrg_socMax % Stop charging
        k_soc = 0;
    else % If SoC in the middle, can fully charge or discharge
        k_soc = 1;
    end
    % k_soc = clip(k_soc,0,1);
end

function [Pcat,Icat,Pnosupp,Prhe,Pacc,soc_new] = train005(Pref,Vcat,soc)
    % over current & over voltage /w accumulator rev1
    global dt;
    eff_conv = 0.9;
    eff_inv = 0.9;
    Emax = 20 * 1e3; % Wh max energy in accumulator
    Pmax = 300 * 1e3; % W max power from/to accumulator
    % traction & discharge
    if Pref >= 0
        Ptrain_demand = Pref / eff_inv; % power that the train demand (before inverter @ Pcat node)
        Pacc_avail = Pmax * ksoc(soc,Pref) * eff_conv; % max power from accumulator after converter (@ Pcat node)
        Pacc = min(Ptrain_demand, Pacc_avail); % after converter (@ Pcat node)
        soc_new = (Emax*soc - dt*Pacc/eff_conv)/Emax; % new soc calculation
        if (soc_new - 0) < 0 % if the new SOC is below 0%, don't use battery
            soc_new = soc;
            Pacc = 0;
        end

        Pcat = (Ptrain_demand - Pacc) * kcat(Vcat,Pref); % the rest of ref power is from catenary (@ Pcat node)
        Icat = Pcat/Vcat;
        Pnosupp = Ptrain_demand - (Pcat + Pacc)*eff_inv; % the rest of power is not supplied
        Prhe = 0;
    % braking
    else
        Ptrain_demand = Pref * eff_inv; % power that the train generate during breaking (after inverter @ Pcat node)
        Pacc_avail = -Pmax * ksoc(soc,Pref) / eff_conv;
        Pacc = max(Ptrain_demand, Pacc_avail); % to batt, after inverter, before converter (@ Pcat node)
        soc_new = (Emax*soc - dt*Pacc*eff_conv)/Emax; % new soc calculation
        if (soc_new - 100) > 0 % if the new soc is above 100%, don't use battery
            soc_new = soc;
            Pacc = 0;
        end

        Pcat = (Ptrain_demand - Pacc) * kcat(Vcat,Pref); % the rest of ref power to catenary (@ Pcat node)
        Icat = Pcat/Vcat;
        Pnosupp = 0;
        Prhe = Ptrain_demand - (Pcat + Pacc); % (@ Pcat node)
    end
end

function k = kcat(Vcat,Pref) % over current & under voltage control
    V1_OC = 550; % min catenary voltage, 0 Pcat (traction) below this
    V2_OC = 600; % start of over current control, linear scaling to V1_OC
    V3_OV = 850; % start of over voltage control, linear scaling to V4_OV
    V4_OV = 900; % max catenary voltage, 0 Pcat (braking) above this
    if Pref >= 0
        k = (Vcat-V1_OC)/(V2_OC-V1_OC); % over current
    else
        k = (V4_OV-Vcat)/(V4_OV-V3_OV); % under voltage
    end
    clip(k,0,1);
end

function k = ksoc(soc,Pref) % accumulator discharging control
    soc1_discharge = 5 * 1e-2; % min accumulator soc, 0 Pacc (traction) below this
    soc2_discharge = 10 * 1e-2; % start of discharging control, linear scaling to soc1_discharge
    soc3_charge = 90 * 1e-2; % start of over voltage control, linear scaling to soc4_charge
    soc4_charge = 95 * 1e-2; % max accumulator soc, 0 Pcat (braking) above this
    if Pref >= 0
        k = (soc - soc1_discharge)/(soc2_discharge - soc1_discharge); % discharging
    else
        k = (soc4_charge - soc)/(soc4_charge - soc3_charge); % charging
    end
    clip(k,0,1);
end