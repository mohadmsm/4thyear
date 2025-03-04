clear
clc
R = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           
G = 0;            
l = 150e-6;        % Length of the transmission line 
f_max = 100e9;    % Maximum frequency (100 GHz)
%f = linspace(0, f_max, 100); 
w = 2*pi*f_max;        
s = 1i*w; 
vs_sine = @(s) w./(s.^2 + w^2);% Laplace transform of sin(wt)
% Transfer function (exact solution)
vo = @(s) 1 ./ (cosh(l .* sqrt((R + L.*s) .* (G + C.*s))));
vo_step = @(s) 10./s.* vo(s);
vo_sine = @(s) vs_sine(s).*vo(s);
time =10e-12;
[y_step,t] = niltcv(vo_step,time);
[y_sine,t] = niltcv(vo_sine,time);
% Plot the frequency response
%plot(f / 1e9, 20*log10(abs(vo(s)))); %20*log10 for scaling  
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

