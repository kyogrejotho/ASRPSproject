clc; close all; clear all;

global eff Vcat;

eff = 0.9;

Pref = -350
Vcat = 950
[Pcat,~,Pnosup,Prhe] = train003(Pref)

function [Pcat,Icat] = train001(Pref)
    % no control
    global eff Vcat;
    if Pref >= 0
        Pcat = Pref/eff;
        Icat = Pcat/Vcat;
    else
        Pcat = eff*Pref;
        Icat = Pcat/Vcat;
    end
end

function [Pcat,Icat,Pnosup] = train002(Pref)
    % over current
    global eff Vcat;
    if Pref >= 0
        Pcat = Pref*kOC()/eff;
        Icat = Pcat/Vcat;
        Pnosup = Pref*(1-kOC());
    else
        Pcat = eff*Pref;
        Icat = Pcat/Vcat;
        Pnosup = 0;
    end
end

function [Pcat,Icat,Pnosup,Prhe] = train003(Pref)
    % over current & over voltage 
    global eff Vcat;
    if Pref >= 0
        Pcat = Pref*kOC()/eff;
        Icat = Pcat/Vcat;
        Pnosup = Pref*(1-kOC());
        Prhe = 0;
    else
        Pcat = eff*Pref*kOV();
        Icat = Pcat/Vcat;
        Pnosup = 0;
        Prhe = eff*Pref*(1-kOV());
    end
end

function k = kOC()
    global Vcat
    V1_OC = 550;
    V2_OC = 600;
    k = (Vcat-V1_OC)/(V2_OC-V1_OC);
    if k > 1
        k = 1;
    elseif k < 0
        k = 0;
    end
end

function k = kOV()
    global Vcat
    V3_OV = 850;
    V4_OV = 900;
    k = (V4_OV-Vcat)/(V4_OV-V3_OV);
    if k > 1
        k = 1;
    elseif k < 0
        k = 0;
    end
end