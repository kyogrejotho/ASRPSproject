clear all; clc; 

Rrail = 0.014; % Negative feeder resistance
% wear_factor = 0.8;
% Rline = (18.8/(Dcontact*wear_factor+Dmessenger)+Rrail); %Resistance from TSS to train ohm/km
Rline = 0.051; % Positive feeder resistance
R = Rrail+Rline;

Pcat = 650e3;
Vcat = 550;
TPSSx1 = 0; % Distance Substation1
TPSSx2 = 3; % Distance Substation2 
pk = 2; % Train position



[Vdrop,ITPSS1,ITPSS2] = bilateral(Pcat,Vcat,pk,TPSSx1,TPSSx2,R);
TPSSloss(ITPSS1)

function [PTPSSloss, VdropTPSS] = TPSSloss(ITPSS)
VratedTR = 750;
PratedTR = 0.35e6;
Vsc_percent = 8; % Short circuit voltage percentage
Rf_TPSS = 228e-3; % Substation converter resistance

IratedTR = PratedTR/(sqrt(3)*VratedTR); % Transformer rated current calculation
ZTR = Vsc_percent * VratedTR/(100*IratedTR); % Short-circuit Impedance TR

TR_loss = ITPSS^2*ZTR; % Loss in rectifier
Conv_loss = ITPSS^2*Rf_TPSS; % Loss in Transformer
PTPSSloss = TR_loss+Conv_loss; % Total loss in TPSS
VdropTPSS = sqrt(Conv_loss*(Rf_TPSS)) % Voltage drop in rectifier 
end

function [Vdrop] = unilateral(Pcat,Vcat,pk,TPSSx1,R)
%To calculate the Voltage drop, The location of train(pk) and location of
%substation(TPSSx) is needed
Itrain = Pcat/Vcat; %Train current 
x1 = pk - TPSSx; % Distance between train and substation

Vdrop = R*x1*Itrain;

end

function [Vdrop,ITPSS1,ITPSS2] = bilateral(Pcat,Vcat,pk,TPSSx1,TPSSx2,R)
%To calculate the Voltage drop, The location of train(pk) and location of
%substation(TPSSx) is needed
Itrain = Pcat/Vcat %Train current
x1 = pk - TPSSx1;% Distance between train and previous substation
L = abs(TPSSx2-TPSSx1); % Distance between 2 substation
ITPSS1 = ((L-x1)/L)*Itrain % Current that supply to train from the 1st substation
ITPSS2 = (x1/L)*Itrain % Current that supply to train from the 2nd substation
Vdrop = R*((x1*(L-x1))/L)*Itrain 

end