clc;
clear;
eff = 0.9;
%Pref = '755'; % in kW
%Vcat = '390'; % in V
%withOCP = false; 
% prompt = {'Enter reference power in kW:','Enter catenary voltage in V:', 'Consider Overcurrent Protection? Y/N'};
% dlgtitle = 'Train Parameters';
% fieldsize = [1 45; 1 45;1 45];
% definput = {'755','390','N'};
% vpAns = inputdlg(prompt,dlgtitle,fieldsize,definput);
% strPref = vpAns{1}; % can get rid of this, refer to ans array in fxn calls
% strVcat = vpAns{2};
% strOCP = vpAns{3};
% 
% if checkNum(strPref)
%     Pref = str2double(strPref);
% end
% 
% if checkNum(strVcat)
%     Vcat = str2double(strVcat);
% end
% 
% if checkOCP(strOCP)
%     prompt = {'Enter minimum voltage in V','Enter maximum voltage in V:'};
%     dlgtitle = 'Set Voltage Limits';
%     fieldsize = [1 45; 1 45];
%     definput = {'550','600'};
%     vMinMaxAns = inputdlg(prompt,dlgtitle,fieldsize,definput);
% 
%     Train_protection(Pref,eff,Vcat)
% 
% end

eff = 0.9; % 0 - 1
%ex1 = Train_simple_fxn (500,eff,700)
% [Psupp1,Pnosupp1] = Train_protection(650,eff,650)
% [Psupp2,Pnosupp2] = Train_protection(650,eff,575)
% [Psupp3,Pnosupp3] = Train_protection(650,eff,560)
% [Psupp4,Pnosupp4] = Train_protection(650,eff,400)
% [Psupp5,Pnosupp5] = Train_protection(650,eff,550)
% [Psupp6,Pnosupp6] = Train_protection(650,eff,600)
% [Psupp7,Pnosupp7] = Train_protection(-650,eff,600)

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

    v1 = 550; % hardcoded for now
    v2 = 600;

    Pcat = Pref/eff;
    if Vcat > v2 % limit Psupply to Pcatenary
        Psupp = Pcat;
        Pnosupp = Pref-(Psupp*eff); % usual computation;
    elseif Vcat < v1 % if larger, limit Psupply to 0
         Psupp = 0;
         Pnosupp = Pref-(Psupp*eff);
    elseif Pcat < 0 % if negative, we are in traction and we have no supply power, Psupp = Pref*eff
        Psupp = Pref*eff;
        Pnosupp = 0;
    else
        Psupp = (Pcat/(v2-v1))*(Vcat-v1);
        Pnosupp = Pref-(Psupp*eff);
    end
end

function withOCP = checkOCP(strOCP)
    if strlength(strOCP) > 1
        withOCP = 0;
        uiwait(warndlg('Input too long!'));
    elseif strcmpi('y',strOCP)
        withOCP = 1;
    elseif strcmpi('n',strOCP)
        withOCP = 1
    else
        withOCP = 0;
        uiwait(warnndlg('Invalid input! Please input only Y or N'));
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