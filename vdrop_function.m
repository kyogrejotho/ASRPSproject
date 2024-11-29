clear all; clc; 

Rrail = 0.014;
% wear_factor = 0.8;
% Rline = (18.8/(Dcontact*wear_factor+Dmessenger)+Rrail); %Resistance from TSS to train ohm/km
Rline = 0.051;
R = Rrail+Rline;

Pcat = 650e3;
Vcat = 550;
TPSSx1 = 0; % Distance Substation1
TPSSx2 = 3; % Distance Substation2 
pk = 2; % Train position



[Vdrop,ITPSS1,ITPSS2] = bilateral(Pcat,Vcat,pk,TPSSx1,TPSSx2,R);
TPSSloss(ITPSS1)

function PTPSSloss = TPSSloss(ITPSS)
VratedTR = 750;
PratedTR = 0.35e6;
Vsc_percent = 8; % Short circuit voltage percentage
Rf_TPSS = 228e-3; % Substation converter resistance

IratedTR = PratedTR/(sqrt(3)*VratedTR);
ZTR = Vsc_percent * VratedTR/(100*IratedTR); % Short-circuit Impedance TR

PTPSSloss = (ITPSS^2*ZTR)+(ITPSS^2*Rf_TPSS); % Total loss in TPSS

end

function [Vdrop] = unilateral(Pcat,Vcat,pk,TPSSx1,R)


Itrain = Pcat/Vcat; %train current
x1 = pk - TPSSx;

Vdrop = R*x1*Itrain;

end

function [Vdrop,ITPSS1,ITPSS2] = bilateral(Pcat,Vcat,pk,TPSSx1,TPSSx2,R)

Itrain = Pcat/Vcat %train current
x1 = pk - TPSSx1;
L = abs(TPSSx2-TPSSx1);
ITPSS1 = ((L-x1)/L)*Itrain
ITPSS2 = (x1/L)*Itrain
Vdrop = R*((x1*(L-x1))/L)*Itrain

end