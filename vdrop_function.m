clear all; clc; 

Rrail = 0.014;
% wear_factor = 0.8;
% Rline = (18.8/(Dcontact*wear_factor+Dmessenger)+Rrail); %Resistance from TSS to train ohm/km
Rline = 0.051;
R = Rrail+Rline;
R_TPSS = 228e-3;

Pcat = 650e3;
Vcat = 550;
TPSSx1 = 0;
TPSSx2 = 3;
pk = 2;

bilateral(Pcat,Vcat,pk,TPSSx1,TPSSx2,R);


% function [PTPSSloss] = TPSSloss()
% 
% 
% 
% end

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