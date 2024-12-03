clear all; clc;

Vcat = 750;


[P_TPSS1,P_TPSS1_loss,I_TPSS1] = TPSS_power(622)
[P_TPSS2,P_TPSS2_loss,I_TPSS2] = TPSS_power(590)
[P_TPSS3,P_TPSS3_loss,I_TPSS3] = TPSS_power(630)

function [P_TPSS P_TPSS_loss I_TPSS] = TPSS_power(Vcat,pk)
Rrail = 0.014; % Negative feeder resistance
Rline = 0.051; % Positive feeder resistance
R = Rrail+Rline;

Rf_TPSS = 228e-3; % Substation converter resistance
Vcat_nominal = 750;
if (Vcat < Vcat_nominal)
    P_TPSS_loss = ((Vcat_nominal-Vcat)^2)/Rf_TPSS;
    I_TPSS = (Vcat_nominal-Vcat)/Rf_TPSS;
    P_TPSS = I_TPSS*Vcat_nominal;
else
    P_TPSS_loss = 0;
end
end