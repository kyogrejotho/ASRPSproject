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