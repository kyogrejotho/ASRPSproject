%% Train without protection
Pref = 0; % power reference on wheels
eff = 0.5;% eff
Pcat = 0; % power in catenary, want this as output
Icat = 0; % current in catenary, also want this as output
Vcat = 200; % voltage in catenary

Pcat = Pref/eff; 
Icat = Pcat/Vcat; 

% check for negative

