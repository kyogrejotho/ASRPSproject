clc;
clear;
% Pref = '755'; % in kW
% Vcat = '390'; % in V
% prompt = {'Enter catenary power in kW:','Enter catenary voltage in V:'};
% dlgtitle = 'Train Parameters';
% fieldsize = [1 45; 1 45];
% definput = {Pref,Vcat};
% answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
eff = 0.9; % 0 - 1
%ex1 = Train_simple_fxn (500,eff,700)
[Psupp1,Pnosupp1] = Train_protection(650,eff,650)
[Psupp2,Pnosupp2] = Train_protection(650,eff,575)
[Psupp3,Pnosupp3] = Train_protection(650,eff,560)
[Psupp4,Pnosupp4] = Train_protection(650,eff,400)
[Psupp5,Pnosupp5] = Train_protection(650,eff,550)
[Psupp6,Pnosupp6] = Train_protection(650,eff,600)
[Psupp7,Pnosupp7] = Train_protection(-650,eff,600)

function [Pcat] = Train_simple_fxn(Pref,eff, Vcat)
%   Detailed explanation goes here
% threshold = 570;
% if Vcat < threshold
%     Pcat = 0;
% else
    Pcat = Pref/eff
    Icat = Pcat/Vcat
%end
end

function [Psupp,Pnosupp] =  Train_protection(Pref,eff,Vcat)

    v1 = 550;
    v2 = 600;

    Pcat = Pref/eff;
    Psupp = (Pcat/(v2-v1))*(Vcat-v1);
    Pnosupp = Pref-(Psupp*eff);
    if Vcat > v2 % limit Psupply to Pcatenary
        Psupp = Pcat;
        Pnosupp = Pref-(Psupp*eff); % usual computation;
    elseif Vcat < v1 % if larger, limit Psupply to 0
         Psupp = 0;
         Pnosupp = Pref-(Psupp*eff);
    elseif Pcat < 0 % if negative, we are in traction and we have no supply power, Psupp = Pref*eff
        Psupp = Pref*eff;
        Pnosupp = 0;
    end
end

