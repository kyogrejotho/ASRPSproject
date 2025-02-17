arr_labels = ["Pref", "Vcat", "SOCinit", "Pcat", "Pnosupp", "Prhe", "Pacc", "SOCfinal"]; % NOT USED NOW
arr_Pref = [350; -350; 0; 350; 350; 350; 350; -350; -350; -350; -350];
arr_Vcat = [650; 800; 700; 600; 550; 575; 500; 850; 900; 870; 950];
arr_SOC_init = [0.025; 0.05; 0.075; 0.1; 0.5; 0.9; 0.925; 0.95; 0.975];

arr_Pcat = ones(length(arr_Pref),length(arr_SOC_init));
arr_Pnosupp = ones(length(arr_Pref),length(arr_SOC_init));
arr_Prhe = ones(length(arr_Pref),length(arr_SOC_init));
arr_Pacc = ones(length(arr_Pref),length(arr_SOC_init));
arr_SOC_final = ones(length(arr_Pref),length(arr_SOC_init));

%{
test_case
for j = 1:length(arr_SOC_init)
    for i = 1:length(arr_Pref)
        Vcat = arr_Vcat(i);
        [iter_Pcat,~,iter_Pnosupp,iter_Prhe,iter_Pacc,iter_SOC_final] = train004(arr_Pref(i),arr_SOC_init(j));
        arr_Pcat(i,j) = iter_Pcat;
        arr_Pnosupp(i,j) = iter_Pnosupp;
        arr_Prhe(i,j) = iter_Prhe;
        arr_Pacc(i,j) = iter_Pacc;
        arr_SOC_final(i,j) = iter_SOC_final;
    end
    result = table(arr_Pref, arr_Vcat, arr_SOC_init(j)*ones(length(arr_Pref),1), arr_Pcat(:,j), arr_Pnosupp(:,j), arr_Prhe(:,j), arr_Pacc(:,j), arr_SOC_final(:,j));
    result.Properties.VariableNames = arr_labels
end
%}

%Results of Train_batt from Jes
%{
for i = 1:length(arr_Pref)
    [iter_Pcat,iter_Pnosupp,iter_Prhe,iter_Pacc,iter_Ptrain,iter_SoCfinal] = Train_batt(arr_Pref(i),eff,arr_Vcat(i),arr_SOC_init(i)); % add new SoC
    arr_Pcat(i) = iter_Pcat;
    arr_Pnosupp(i) = iter_Pnosupp;
    arr_Prhe(i) = iter_Prhe;
    arr_Pacc(i) = iter_Pacc;
    %sarr_Ptrain(i) = iter_Ptrain;
    arr_SoC_final(i) = iter_SoCfinal;
end
results = table(arr_Pref, arr_Vcat,arr_SoC_init, arr_Pcat, arr_Prhe, arr_Pnosupp, arr_Pacc, arr_Ptrain, arr_SoC_final);
%}

%% MORE TEST CASES FROM JES, TEST CASE DUMP

% arr_labels = ["Pref","Vcat", "Pcat", "Prhe", "Pnosupp"]; % NOT USED NOW
% arr_Pref = [350; -350; 0; 350; 350; 350; 350; -350; -350; -350; -350];
% arr_Vcat = [650; 800; 700; 600; 550; 575; 500; 850; 900; 870; 950];
% arr_Pcat = ones(11,1);
% arr_Prhe = ones(11,1);
% arr_Pnosupp = ones(11,1);
% 
% arr_SoC = [0; 0.03; 0.05; 0.07; 0.10; 0.50; 0.9; 0.93; 0.95; 0.97; 1];
% arr_SoCfinal = ones(11,1); % store updated SoC
% arr_Pacc = ones(11,1);
% arr_Ptrain = ones(11,1);

% arr_labels = ["Pref", "Vcat", "SOCinit", "Pcat", "Pnosupp", "Prhe", "Pacc", "SOCfinal"]; % NOT USED NOW
% arr_Pref = [350; -350; 0; 350; 350; 350; 350; -350; -350; -350; -350; 200;-250];
% arr_Vcat = [650; 800; 700; 600; 550; 575; 500; 850; 900; 870; 950;800;700];
% arr_SOC_init = [0.025; 0.05; 0.075; 0.1; 0.5; 0.9; 0.925; 0.95; 0.975];

%table(arr_Pref, arr_Vcat,arr_SOC_init,arr_Pcat,arr_Pnosupp, arr_Prhe, arr_Pacc);
arr_labels = ["Pref", "Vcat", "SOCinit", "Pcat", "Pnosupp", "Prhe", "Pacc","Ptrain","SOCfinal"];
% arr_Pref = [350;200;350;200;350;350;200;350;350;150;650;350;200;650;350;200;200;-350;-650;-350;-650;-150;-200;-650;-150;-650;-300;-650;-150;-650;-200;-600;-1000;-650];
% arr_Vcat = [550;550;550;550;550;600;600;600;600;600;575;575;575;575;575;575;575; 900; 900; 900; 900; 900; 850; 850; 850; 850; 850; 875; 875; 875; 875; 890;  875; 890];
% arr_SOC_init = [0.5;0.5;0.075;0.075;0.05;0.05;0.5;0.5;0.075;0.09;0.5;0.5;0.5;0.075;0.075;0.075;0.05;1;0.5;0.5;0.975;0.975;1;0.975;0.975;0.5;0.5;0.975;0.975;0.5;0.5;1;0.5;0.975];
arr_Pref = [];
arr_Vcat = [];
arr_SOC_init = [];

arr_Pcat = ones(length(arr_Pref),1);
arr_Ptrain = ones(length(arr_Pref),1);
arr_Pnosupp = ones(length(arr_Pref),1);
arr_Prhe = ones(length(arr_Pref),1);
arr_Pacc = ones(length(arr_Pref),1);
arr_SOC_final = ones(length(arr_Pref),1);

% length(arr_Pref)
% length(arr_Vcat)
% length(arr_SOC_init)
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
% [Pcat1,Pnosupp1] = Train_protection(650,eff,650)
% [Pcat2,Pnosupp2] = Train_protection(650,eff,575)
% [Pcat3,Pnosupp3] = Train_protection(650,eff,560)
% [Pcat4,Pnosupp4] = Train_protection(650,eff,400)
% [Pcat5,Pnosupp5] = Train_protection(650,eff,550)
% [Pcat6,Pnosupp6] = Train_protection(650,eff,600)
% [Pcat7,Pnosupp7] = Train_protection(-650,eff,600)

% [Pcat01,Pnosupp01,Prhe01] = Train_protection(350,eff,650)
% [Pcat02,Pnosupp02,Prhe02] = Train_protection(-350,eff,800)
% [Pcat03,Pnosupp03,Prhe03] = Train_protection(0,eff,700)
% [Pcat04,Pnosupp04,Prhe04] = Train_protection(350,eff,600)
% [Pcat05,Pnosupp05,Prhe05] = Train_protection(350,eff,550)
% [Pcat06,Pnosupp06,Prhe06] = Train_protection(350,eff,575)
% [Pcat07,Pnosupp07,Prhe07] = Train_protection(350,eff,500)
% [Pcat08,Pnosupp08,Prhe08] = Train_protection(350,eff,850)
% [Pcat09,Pnosupp09,Prhe09] = Train_protection(-350,eff,900)
% [Pcat10,Pnosupp10,Prhe10] = Train_protection(-350,eff,870)
% [Pcat11,Pnosupp11,Prhe11] = Train_protection(-350,eff,950)

% [Pcat1,Pnosupp1] = Train_protection(350,eff,650)
% [Pcat2,Pnosupp2] = Train_protection(-350,eff,800)
% [Pcat3,Pnosupp3] = Train_protection(0,eff,700)
% [Pcat4,Pnosupp4] = Train_protection(350,eff,600)
% [Pcat5,Pnosupp5] = Train_protection(350,eff,550)
% [Pcat6,Pnosupp6] = Train_protection(350,eff,575)
% [Pcat7,Pnosupp7] = Train_protection(350,eff,500)

%For results of Train_protection function
% for i = 1:length(arr_Pref)
%     [iter_Pcat,iter_Pnosupp,iter_Prhe] = Train_protection(arr_Pref(i),eff,arr_Vcat(i));
%     arr_Pcat(i) = iter_Pcat;
%     arr_Pnosupp(i) = iter_Pnosupp;
%     arr_Prhe(i) = iter_Prhe;
% end
% results = table(arr_Pref, arr_Vcat, arr_Pcat, arr_Prhe, arr_Pnosupp);
% results.Properties.VariableNames = arr_labels;

 %[Pcat1,Pnosupp1,Prhe1,Pacc1,Ptrain1] = Train_batt(694.8,0.9,570,0.5); % Testing only, for discharging
 % [Pcat2,Pnosupp2,Prhe2,Pacc2,Ptrain2] = Train_batt(-650,0.9,870,0.5); % Testing only, for charging
 % [Pcat3,Pnosupp3,Prhe3,Pacc3,Ptrain3] = Train_batt(200,0.9,575,0.5); % bug fix due to this
 % [Pcat4,Pnosupp4,Prhe4,Pacc4,Ptrain4] = Train_batt(650,0.9,570,0.5);
 % [Pcat4,Pnosupp4,Prhe4,Pacc4,Ptrain4] = Train_batt(300,0.9,575,0.5);
 % [Pcat6,Pnosupp6,Prhe6,Pacc6,Ptrain6] = Train_batt(200,0.9,500,0.5);
% [Pcat7,Pnosupp7,Prhe7,Pacc7,Ptrain7] = Train_batt(350,0.9,650,0.04);
% [Pcat8,Pnosupp8,Prhe8,Pacc8,Ptrain8] = Train_batt(300,0.9,650,0.08);
% [Pcat9,Pnosupp9,Prhe9,Pacc9,Ptrain9] = Train_batt(200,0.9,850,0.5);
%[Pcat91,Pnosupp92,Prhe92,Pacc92,Ptrain92,SOCfinal92] = Train_batt(-400,0.9,890,0.94);

% Testing only, for discharging
% [Pcat3,Pnosupp3,Prhe3,Pacc3,Ptrain3] = Train_batt(-300,0.9,875,0.5); % Testing only, for charging
% For charging
% [Pcat11,Pnosupp11,Prhe11,Pacc11,Ptrain11] = Train_batt(-350,0.9,750,0.85);
% [Pcat12,Pnosupp12,Prhe12,Pacc12,Ptrain12] = Train_batt(-200,0.9,650,0.92);
% [Pcat13,Pnosupp13,Prhe13,Pacc13,Ptrain13] = Train_batt(-50,0.9,850,0.98);
% [Pcat14,Pnosupp14,Prhe14,Pacc14,Ptrain14] = Train_batt(-500,0.9,870,0.8);
% [Pcat15,Pnosupp15,Prhe15,Pacc15,Ptrain15] = Train_batt(-50,0.9,860,0.93);
% [Pcat16,Pnosupp16,Prhe16,Pacc16,Ptrain16] = Train_batt(-300,0.9,870,0.96);
% [Pcat17,Pnosupp17,Prhe17,Pacc17,Ptrain17] = Train_batt(-500,0.9,900,0.1);
% [Pcat18,Pnosupp18,Prhe18,Pacc18,Ptrain18] = Train_batt(-50,0.9,950,0.92);
% [Pcat19,Pnosupp19,Prhe19,Pacc19,Ptrain19] = Train_batt(-300,0.9,950,0.95);
%[Pcat191,Pnosupp191,Prhe191,Pacc191,Ptrain191] = Train_batt(-1000,0.9,875,0.5);
% [Pcat192,Pnosupp192,Prhe192,Pacc192,Ptrain192] = Train_batt(-600,0.9,890,1);
% Test substation
%[Pcat41,Pnosupp41,Prhe41] = Train_substation(-650,0.9,735);

% Results of Train_batt 2
% for i = 1:length(arr_Pref)
%     [iter_Pcat,iter_Pnosupp,iter_Prhe,iter_Pacc,iter_Ptrain,iter_SoCfinal] = Train_batt(arr_Pref(i),eff,arr_Vcat(i),arr_SOC_init(i));
%     arr_Pcat(i) = iter_Pcat;
%     arr_Pnosupp(i) = iter_Pnosupp;
%     arr_Pacc(i) = iter_Pacc;
%     % iter_Pacc
%     % iter_Pnosupp
%     % iter_Pcat
%     % iter_Prhe
%     arr_Prhe(i) = iter_Prhe;
%     arr_Ptrain(i) = iter_Ptrain;
%     arr_SOC_final(i) = iter_SOCfinal;
% end
% results = table(arr_Pref, arr_Vcat,arr_SOC_init,arr_Pcat,arr_Pnosupp, arr_Prhe, arr_Pacc,arr_Ptrain,arr_SOC_final);
% results.Properties.VariableNames = arr_labels;
% arr_Pcat;
% Test offboard accumulation
%[Pcat51,Pnosupp51,Prhe51,Pacc51] = Train_offboard(650,0.9,745,0.5); % Testing only, for charging

% Results of Train_batt
% for j = 1: length(arr_SOC_init)
%     for i = 1:length(arr_Pref)
%         [iter_Pcat,iter_Pnosupp,iter_Prhe,iter_Pacc,iter_Ptrain,iter_SoCfinal] = Train_batt(arr_Pref(i),eff,arr_Vcat(i),arr_SOC_init(j)); % add new SoC
%         arr_Pcat(i,j) = iter_Pcat;
%         arr_Pnosupp(i,j) = iter_Pnosupp;
%         arr_Prhe(i,j) = iter_Prhe;
%         arr_Pacc(i,j) = iter_Pacc;
%         arr_Ptrain(i,j) = iter_Ptrain;
%         arr_SOC_final(i,j) = iter_SoCfinal;
%         i;
%         length(arr_Pref);
%         j;
%     end
%         result = table(arr_Pref, arr_Vcat, arr_SOC_init(j)*ones(length(arr_Pref),1), arr_Pcat(:,j), arr_Pnosupp(:,j), arr_Prhe(:,j), arr_Pacc(:,j), arr_SOC_final(:,j));
%         result.Properties.VariableNames = arr_labels
% end