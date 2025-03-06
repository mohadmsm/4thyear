clear
clc
R = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           
G = 0;            
l = 150e-6;        % Length of the transmission line 
f_max = 100e9;    % Maximum frequency (100 GHz)
w = 2*pi*f_max;        
s = 1i*w; 
vs_sine = @(s) w./(s.^2 + w^2);% Laplace transform of sin(wt)
% Transfer function (exact solution)
vo = @(s) 1 ./ (cosh(l .* sqrt((R + L.*s) .* (G + C.*s))));
vo_sine = @(s) vs_sine(s).*vo(s);
time =10e-12;
[y_sine,t] = niltcv(vo_sine,time);
% Plot the frequency response
plot(t, y_sine)
xlabel('time (s)');
ylabel('Vo');
grid on;
%%
clear
clc
R = 1200;          % Ω/m
L = 250e-9;        % H/m
C = 1e-10;         % F/m
G = 0;             % S/m
l = 150e-6;        % m  (line length)

f_max = 100e10;    % 100 GHz
w = 2*pi*f_max;    
s = 1i*w;

% Transfer function of the line
vo = @(s) 1 ./ cosh( l .* sqrt( (R + L.*s) .* (G + C.*s) ) );

%Define the trapezoidal pulse in the Laplace domain

Tr = 1e-12;  % 1 ps rise/fall
Tp = 5e-12;  % 5 ps high
Amp = 1;     % 1 V amplitude

% Laplace transform of the trapezoid
Vpulse = @(s) (Amp./(Tr*s.^2)).*(1 - exp(-Tr.*s))- (Amp./(Tr.*s.^2)).*(exp(-(Tr+Tp).*s) - exp(-(2*Tr+Tp).*s));

vo_pulse = @(s) Vpulse(s) .* vo(s);

% Choose a simulation time that covers the entire 7 ps pulse
Tsim = 20e-12; 

% Compute inverse Laplace transform numerically
[y_pulse, t] = niltcv(vo_pulse, Tsim);

plot(t, y_pulse)
xlabel('Time (s)')
ylabel('Vo (V)')
title('Transmission Line Response to 1 V Trapezoidal Pulse')
grid on
%%
clear
clc

R  = 1200;       % ohms per meter
L  = 250e-9;     % H per meter
C  = 1e-10;      % F per meter
G  = 0;          % S per meter
l  = 150e-6;     % line length in meters

Z0_approx = 0;

% Source resistor (not matched to Z0)
Rs = 0;   % ohms

%-------------------------------
% Sine wave parameters
%-------------------------------
f = 100e9;              % 100 GHz
omega = 2*pi*f;
A = 1;                  % amplitude (1 V)
Vs_sine = @(s) A*(omega./(s.^2 + omega^2));  % Laplace transform of sin(omega*t)

%-------------------------------
% Define propagation constant
%-------------------------------
gamma = @(s) sqrt((R + L.*s).*(G + C.*s));

H_mismatch_source = @(s) (Z0_approx ./ (Rs + Z0_approx)) .* exp(-gamma(s)*l);

% Overall output in Laplace domain
Vo_sine = @(s) Vs_sine(s) .* H_mismatch_source(s);

%-------------------------------
% Inverse Laplace to get time-domain
%-------------------------------
Tmax = 50e-12;   % ~50 ps to see several cycles (period ~10 ps)
[y_out, t] = niltcv(Vo_sine, Tmax);

%-------------------------------
% Plot the result
%-------------------------------
figure
plot(t, y_out, 'LineWidth',1.2)
grid on
xlabel('Time (s)')
ylabel('V_{out} (V)')
title('Line Response to 100 GHz Sine (R_s=10 \Omega, Matched Load)')

%%
% RLC ladder
clear 
clc
len=150e-6;
N = 200; % Number of sections in the transmission line
dz=len/N;
L = 250e-9*dz;   % Inductance
C = 1e-10*dz;    % Capacitance
R = 1200*dz;       % Resistance per section
Rs = 10;       % Source resistance
Vs  = 1;     % Source voltage 
Vs_sine = @(t) sin(2*pi*100e9*t);% input sin with 0.1THz 
y0 = zeros(2 * N, 1);
tspan = 0:1e-15:10e-12;  
% Solve using ode45
[t, y_step] = ode45(@(t, y) fline_noR(t, y, N, L, C, R, Rs, Vs), tspan, y0);
[t, y_sine] = ode45(@(t, y) fline_noR(t, y, N, L, C, R, Rs, Vs_sine), tspan, y0);

% Plot voltage at the end of the transmission line (VN)
figure(1);
%plot(t, y_step(:,N*2));  % Plot voltage at the load (VN)
plot(t, y_sine(:,N*2));
xlabel('Time (s)');
ylabel('Voltage (V)');
title('RLC with unit step input and R_s=10');
grid on 
%%
%RLC input as pulse 
clear 
clc
len=150e-6;
N = 200; % Number of sections in the transmission line
dz=len/N;
L = 250e-9*dz;   % Inductance
C = 1e-10*dz;    % Capacitance
R = 1200*dz;       % Resistance per section
Rs = 10;       % Source resistance
vs_pulse = @(t) trapezoidalPulse(t);
y0 = zeros(2 * N, 1);
tspan = linspace(0,10e-12,10e4);  
% Solve using ode45
[t, y_pulse] = ode45(@(t, y) fline_noR(t, y, N, L, C, R, Rs, vs_pulse), tspan, y0);
% Plot voltage at the end of the transmission line (VN)
figure(1);
plot(t, y_pulse(:,N*2));
xlabel('Time (s)');
ylabel('Voltage (V)');
title('RLC with Trapezoidal Pulse input with R_s=10');
grid on 
%%
clear
clc
L_total = 150e-6;  % Total length of the line (m)
R = 1200;
l = 250e-9;
c = 1e-10;
Zc = sqrt((R+l)/(c));  % Characteristic impedance (Ohms)
v = 2e8;  % Speed of propagation (m/s)
% Compute inductance and capacitance
C = 1 / (v * Zc); 
L = Zc/v;
NDZ = 100;  % Number of spatial steps
dz = L_total / NDZ;  % Spatial step delta z
dt = 1e-17;  % Time step delta t 
t_max = 10e-12;
t_steps = round(t_max / dt);  % Number of time steps
% allocate voltage and current arrays
V = zeros(NDZ+1, t_steps);
time = (0:t_steps-1)*dt;
%Vs = sin(2*pi*100e9.*time);
%Vs = 1;
%V(1,:)=Vs.*ones(1,t_steps);
V(1,1) = trapezoidalPulse(time(1));
I = zeros(NDZ, t_steps);   
% FDTD Loop for Time Stepping
for n = 1:t_steps-1
    %V(1,n+1) = V(1,n);
    %V(1, n+1) = sin(2*pi*100e9 * time(n+1));
    V(1,n+1) = trapezoidalPulse(time(n+1));
    for k = 1:NDZ
    if k>1
        V(k,n+1) = V(k,n) + dt/(dz *C)* (I(k-1,n) - I(k,n));  % Update voltag        
        dV_k = V(k-1,n) - V(k,n);  % Voltage difference between points
        I(k-1,n+1) = I(k-1,n) + dt/(dz *L) * dV_k; 
    end
    end
    V(NDZ,n+1) =V(NDZ,n)+dt*(I(NDZ-1,n)/(C*dz));
end
y_FDTD = V(NDZ,:);
% Plot the results for the voltage at the load
figure(1)
plot((0:t_steps-1)*dt/1e-12, V(NDZ,:));
xlabel('Time (ps)');
ylabel('V Load (Volts)');
%title('FDTD Simulation of Transmission Line with unit step input');
%title('FDTD Simulation of Transmission Line with 100 GHz Sine Wave Input');
title('FDTD Simulation of Transmission Line with Trapezoidal Pulse Input');
grid on;
