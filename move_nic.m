clear; clc;
dpk = 10; %m track path length
pkmax = 75100; %m end of track
pk = 0:dpk:pkmax; %m track array
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
% speed profile in km/h
speed_profile = [0      *ones(1,numel(pk(pk<50))),...
                50      *ones(1,numel(pk(pk<=2000)) - numel(pk(pk<=50))),...
                180     *ones(1,numel(pk(pk<=14600)) - numel(pk(pk<=2000))),...
                300     *ones(1,numel(pk(pk<=51700)) - numel(pk(pk<=14600))),...
                280     *ones(1,numel(pk(pk<=59750)) - numel(pk(pk<=51700))),...
                200     *ones(1,numel(pk(pk<=69100)) - numel(pk(pk<=59750))),...
                110     *ones(1,numel(pk(pk<=73100)) - numel(pk(pk<=69100))),...
                50      *ones(1,numel(pk(pk<=75050)) - numel(pk(pk<=73100))),...
                0       *ones(1,numel(pk(pk>=75050)))];
% tunnnel profile (isTunnel)
tunnel_profile = [ones(1,numel(pk(pk<5250))),...
                 zeros(1,numel(pk(pk>=5250)))];

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
%



train_speed = zeros(1,numel(pk));
mode = zeros(1,numel(pk));
last_speed = 0;
for x = 2:numel(pk)
    brake_horizon = ceil(2000/dpk);
    if x < numel(pk)-brake_horizon-1
        if speed_profile(x+brake_horizon) < speed_profile(x)
            brake_ref = speed_profile(x+brake_horizon);
        else 
            brake_ref = speed_profile(x);
        end
    else
        brake_ref = speed_profile(end);
    end
    %brake_ref
    [~,speed] = train_traction(train_speed(x-1),speed_profile(x),brake_ref,tunnel_profile(x),curve_profile(x),slope_profile(x),dpk);
    train_speed(x) = speed;
end
figure(1);
plot(pk/1000,speed_profile,pk/1000,train_speed); grid on;

%
train_speed_rev = zeros(1,numel(pk));
mode = zeros(1,numel(pk));
last_speed = 0;
for x = 2:numel(pk)
    brake_horizon = ceil(2000/dpk);
    if x < numel(pk)-brake_horizon-1
        if speed_profile(x+brake_horizon) < speed_profile(x)
            brake_ref = speed_profile(x+brake_horizon);
        else 
            brake_ref = speed_profile(x);
        end
    else
        brake_ref = speed_profile(end);
    end
    %brake_ref
    [~,speed] = train_traction(traitrain_speed_revn_speed(x-1),speed_profile(x),brake_ref,tunnel_profile(x),curve_profile(x),slope_profile(x),dpk);
    train_speed_rev(x) = speed;
end
figure(1);
plot(pk/1000,speed_profile,pk/1000,train_speed); grid on;
%}

function [Pref,speed] = train_traction(last_speed,speed_ref,brake_ref,isTunnel,curve_rad,slope,dx)
    eff_motor = 0.85;
    regen_min_speed = 30; %km/h
    M_train = 650*1e3; %kg train mass
    rotM_coef = 0.05; % rotating mass coefficient
    Meqv_train = (1 + rotM_coef)*M_train; %kg equivalent total mass of train;
    Favail = calc_Favail(last_speed);
    Fdrag = calc_Fdrag(last_speed,isTunnel,M_train);
    Fcurve = calc_Fcurve(curve_rad,M_train);
    Fgrad = calc_Fgrad(slope,M_train);
    Fext = Fdrag + Fcurve + Fgrad;
    % acceleration logic
    if speed_ref <= brake_ref
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
        if last_speed > brake_ref
            if last_speed > regen_min_speed
                Fbrake = 0;
                Fmotor = -Favail;
            else
                Fbrake = -0.5*Meqv_train^2;
                Fmotor = 0;
            end
        else
            Fbrake = 0;
            Fmotor = clip(-Fext,-Favail,Favail);
            if Fmotor < 0 && (last_speed < regen_min_speed)
                Fbrake = Fmotor;
                Fmotor = 0;
            end
        end
    end
    accel = (Fmotor + Fbrake + Fext)/Meqv_train - 1e-9;
    % v = u + a*dt
    % v^2 = u^2 + 2*a*s
    dt = (sqrt(2*dx*accel + (last_speed/3.6)^2) - (last_speed/3.6))/accel;
    speed = last_speed + accel*dt*3.6;
    Pref = Fmotor*(last_speed/3.6)/eff_motor;
end

function Favail = calc_Favail(speed)
    Pmax_motor = 10000;%8800; %kW
    speed_base_motor = 180; %km/h
    if speed < speed_base_motor %km/h, base speed
        %Favail = 2*(-(170-99)/160*speed+170)*1000
        Favail = (Pmax_motor/speed_base_motor)*3600;
    else
        Favail = (Pmax_motor/speed)*3600;
    end
end

function Fdrag = calc_Fdrag(speed,isTunnel,M_train)
% drag resistance per mass (N/kg), including rolling resistance
    if isTunnel
        tunnel_coef = 1.7; % tunnel coefficient for air/drag resistance
    else
        tunnel_coef = 1; % drag coefficient at open air
    end
    Fdrag = -9.81*(0.93899+0.00162*tunnel_coef*(speed/3.6)^2)*(M_train/1000);
end

function Fcurve = calc_Fcurve(curve_rad,M_train)
% curve resistance per mass (N/kg)
    if curve_rad == 0
        Fcurve = 0;
    elseif curve_rad < 0
        Fcurve = -10*65/(curve_rad-65)*M_train;
    else
        Fcurve = -10*65/(curve_rad-55)*M_train;
    end
end

function Fgrad = calc_Fgrad(slope,M_train)
% normalized gradient force (N/kg)
    Fgrad = -(9.81*slope)*M_train; 
end
%}