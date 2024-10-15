clear all
clc
N = 100; % Number of sections in the transmission line
l = 400 ; % line length 
dz = l/N ; % section length
L = 2.5e-7 * dz;   % Inductance
C = 1e-10 * dz;    % Capacitance
R = 0 * dz;       % Resistance per section *dz
Rs = 0;       % Source resistance
Rl = 100;     % Load resistance
Vs  = 30;      % Source voltage (could be a function of time)
y0 = zeros(2 * N, 1);
tspan = [0 20e-6];  
% Solve using ode45
[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, Rl, Vs), tspan, y0);
% Plot voltage at the end of the transmission line (VN)
figure(1);
plot(t, y(:,N*2));  % Plot voltage at the load (VN)
xlabel('Time (us)');
ylabel('Voltage at Load (V)');
title('Voltage at Load over Time');
grid on

