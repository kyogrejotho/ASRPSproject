prompt = {'Enter catenary power in kW:','Enter catenary voltage in V:'};
dlgtitle = 'Train Parameters';
fieldsize = [1 45; 1 45];
definput = {'772','570'};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput)
eff = 0.9; % 0 - 1

function [Pcat,Icat] = Train_simple_fxn(Pref,eff, Vcat)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
threshold = 570;
if Vcat < threshold
    Pcat = 0;
else
    Pcat = Pref/eff; 
    Icat = Pcat/Vcat;
end

end

