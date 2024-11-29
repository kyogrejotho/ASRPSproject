clear; close; clc;
dpk = 10; %m track path length
pkmax = 75100; %m end of track
pk = 0:dpk:pkmax; %m track array

% speed profile in km/h
speed_profile = [0      *ones(1,numel(pk(pk<dpk))),...
                50      *ones(1,numel(pk(pk<=2000)) - numel(pk(pk<=dpk))),...
                180     *ones(1,numel(pk(pk<=14600)) - numel(pk(pk<=2000))),...
                300     *ones(1,numel(pk(pk<=51700)) - numel(pk(pk<=14600))),...
                280     *ones(1,numel(pk(pk<=59750)) - numel(pk(pk<=51700))),...
                200     *ones(1,numel(pk(pk<=69100)) - numel(pk(pk<=59750))),...
                110     *ones(1,numel(pk(pk<=73100)) - numel(pk(pk<=69100))),...
                50      *ones(1,numel(pk(pk<=(pkmax-dpk))) - numel(pk(pk<=73100))),...
                0       *ones(1,numel(pk(pk>=(pkmax-dpk))))];
speed_profile_reverse = fliplr(speed_profile);
%figure(1);
%plot(pk/1000,speed_profile,fliplr(pk/1000),speed_profile_reverse); grid on;

% track curvature radius in meters
curve_profile = [0      *ones(1,numel(pk(pk<3350))),...
                5570    *ones(1,numel(pk(pk<=4650)) - numel(pk(pk<=3350))),...
                0       *ones(1,numel(pk(pk<=9500)) - numel(pk(pk<=4650))),...
                2069    *ones(1,numel(pk(pk<=11200)) - numel(pk(pk<=9500))),...
                5411    *ones(1,numel(pk(pk<=18200)) - numel(pk(pk<=11200))),...
                0       *ones(1,numel(pk(pk<=40650)) - numel(pk(pk<=18200))),...
                5730    *ones(1,numel(pk(pk<=44750)) - numel(pk(pk<=40650))),...
                0       *ones(1,numel(pk(pk<=51700)) - numel(pk(pk<=44750))),...
                4982    *ones(1,numel(pk(pk<=59750)) - numel(pk(pk<=51700))),...
                2626    *ones(1,numel(pk(pk<=65200)) - numel(pk(pk<=59750))),...
                0       *ones(1,numel(pk(pk<=69100)) - numel(pk(pk<=65200))),...
                1003    *ones(1,numel(pk(pk<=70650)) - numel(pk(pk<=69100))),...
                0       *ones(1,numel(pk(pk<=72950)) - numel(pk(pk<=70650))),...
                732     *ones(1,numel(pk(pk<=74050)) - numel(pk(pk<=72950))),...
                0       *ones(1,numel(pk(pk>=74050)))];
curve_profile_reverse = fliplr(curve_profile);
%figure(2);
%plot(pk/1000,curve_profile,fliplr(pk/1000),curve_profile_reverse); grid on;

% tunnnel profile (isTunnel)
tunnel_profile = [ones(1,numel(pk(pk<5250))),...
                 zeros(1,numel(pk(pk>=5250)))];
tunnel_profile_reverse = fliplr(tunnel_profile);
%figure(3);
%plot(pk/1000,tunnel_profile,fliplr(pk/1000),tunnel_profile_reverse); grid on;

% slope profile in per.unit values
slope_profile = [-15000*1e-6*ones(1,numel(pk(pk<8500))),...
                118*1e-6    *ones(1,numel(pk(pk<=14400)) - numel(pk(pk<=8500))),...
                2161*1e-6   *ones(1,numel(pk(pk<=43250)) - numel(pk(pk<=14400))),...
                -5592*1e-6  *ones(1,numel(pk(pk<=54250)) - numel(pk(pk<=43250))),...
                3551*1e-6   *ones(1,numel(pk(pk<=63750)) - numel(pk(pk<=54250))),...
                -45*1e-6    *ones(1,numel(pk(pk<=66400)) - numel(pk(pk<=63750))),...
                -9759*1e-6  *ones(1,numel(pk(pk<=70000)) - numel(pk(pk<=66400))),...
                17629*1e-6  *ones(1,numel(pk(pk<=73300)) - numel(pk(pk<=70000))),...
                6670*1e-6   *ones(1,numel(pk(pk>=73300)))];
slope_profile_reverse = -1*fliplr(slope_profile);
%figure(4);
%plot(pk/1000,slope_profile,fliplr(pk/1000),slope_profile_reverse); grid on;


train_speed = zeros(1,numel(pk));
brake_weight = 0.05;
brake_horizon_init = ceil(2000/dpk); % start braking from 2km (2000m) from change of speed profile
brake_horizon = brake_horizon_init;
%
for x = 2:numel(pk)
    if x < numel(pk)-brake_horizon_init-1
        brake_speed_ref = speed_profile(x+brake_horizon);
    else
        brake_speed_ref = 0;
    end
    if brake_speed_ref < train_speed(x-1)
        % v^2 = u^2 + 2*a*s
        Fbrake_ref = brake_weight*(brake_speed_ref^2 - train_speed(x-1)^2)/(2*brake_horizon*dpk);
        if brake_horizon > 2
            brake_horizon = brake_horizon-1;
        else
            brake_horizon = brake_horizon_init;
        end
    else 
        Fbrake_ref = 0;
        brake_horizon = brake_horizon_init;
    end
    [~,speed] = train_traction(train_speed(x-1),speed_profile(x),Fbrake_ref,tunnel_profile(x),curve_profile(x),slope_profile(x),dpk);
    train_speed(x) = speed;
end
figure(1);
plot(pk/1000,speed_profile,pk/1000,train_speed); grid on;

%}
train_speed_reverse = zeros(1,numel(pk));
for x = 2:numel(pk)
    if x < numel(pk)-brake_horizon_init-1
        brake_speed_ref = speed_profile_reverse(x+brake_horizon);
    else
        brake_speed_ref = 0;
    end
    if brake_speed_ref < train_speed_reverse(x-1)
        % v^2 = u^2 + 2*a*s
        Fbrake_ref = brake_weight*(brake_speed_ref^2 - train_speed_reverse(x-1)^2)/(2*brake_horizon*dpk);
        if brake_horizon > 2
            brake_horizon = brake_horizon-1;
        else
            brake_horizon = brake_horizon_init;
        end
    else 
        Fbrake_ref = 0;
        brake_horizon = brake_horizon_init;
    end
    [~,speed] = train_traction(train_speed_reverse(x-1),speed_profile_reverse(x),Fbrake_ref,tunnel_profile_reverse(x),curve_profile_reverse(x),slope_profile_reverse(x),dpk);
    train_speed_reverse(x) = speed;
end
figure(2);
plot(pk/1000,speed_profile,pk/1000,fliplr(train_speed_reverse)); grid on;
%}

function [Pref,speed] = train_traction(last_speed,speed_ref,Fbrake_ref,isTunnel,curve_rad,slope,dx)
    eff_motor = 0.9;
    regen_min_speed = 30; %km/h
    M_train = 650*1e3; %kg train mass
    rotM_coef = 0.05; % rotating mass coefficient
    Meqv_train = (1 + rotM_coef)*M_train; %kg equivalent total mass of train;
    Favail = calc_Favail(last_speed);
    Fdrag = calc_Fdrag(last_speed,isTunnel,M_train);
    Fcurve = calc_Fcurve(last_speed,curve_rad,M_train);
    Fgrad = calc_Fgrad(slope,M_train);
    Fext = Fdrag + Fcurve + Fgrad;
    % acceleration logic
    if Fbrake_ref == 0
        if last_speed < speed_ref
            Fbrake = 0;
            Fmotor = Favail;
        else
            Fbrake = 0;
            Fmotor = clip(-Fext,-Favail,Favail);
            if Fmotor < 0 && (last_speed < regen_min_speed)
                Fbrake = Fmotor;
                Fmotor = 0;
            end
        end
    else
    % braking logic (preparation to reduce speed)
        Fbrake_req = Fbrake_ref*Meqv_train - Fgrad;
        if last_speed > regen_min_speed
            Fmotor = max(Fbrake_req,-Favail);
            Fbrake = Fbrake_req - Fmotor;
        else
            Fbrake = Fbrake_req;
            Fmotor = 0;
        end
    end
    accel = (Fmotor + Fbrake + Fext)/Meqv_train + 1e-9;
    % v = u + a*dt
    % v^2 = u^2 + 2*a*s
    dt = (sqrt(2*dx*accel + (last_speed/3.6)^2) - (last_speed/3.6))/accel;
    speed = last_speed + accel*dt*3.6;
    Pref = Fmotor*(last_speed/3.6)/eff_motor;
end

function Favail = calc_Favail(speed)
    %Fmax_motor = 340000; %N
    Pmax_motor = 8800; %kW
    speed_base_motor = 180; %km/h
    if speed < speed_base_motor %km/h, base speed
        Favail = (Pmax_motor/speed_base_motor)*3600;
        %Favail = Fmax_motor;
    else
        Favail = (Pmax_motor/speed)*3600;
        %Favail = Fmax_motor*speed_base_motor/speed;
    end
end

function Fdrag = calc_Fdrag(speed,isTunnel,M_train)
% drag resistance per mass (N/kg), including rolling resistance
    if isTunnel
        tunnel_coef = 1.7; % tunnel coefficient for air/drag resistance
    else
        tunnel_coef = 1; % drag coefficient at open air
    end
    if speed == 0
        Fdrag = 0;
    else
        Fdrag = -9.81*(0.93899+0.00162*tunnel_coef*(speed/3.6)^2)*(M_train/1000);
    end
end

function Fcurve = calc_Fcurve(speed,curve_rad,M_train)
% curve resistance per mass (N/kg)
    if curve_rad == 0 || speed == 0
        Fcurve = 0;
    elseif curve_rad < 350
        Fcurve = -10*(650/(curve_rad-65))*(M_train/1000);
    else
        Fcurve = -10*(650/(curve_rad-55))*(M_train/1000);
    end
end

function Fgrad = calc_Fgrad(slope,M_train)
% normalized gradient force (N/kg)
    Fgrad = -(9.81*slope)*M_train; 
end
%}