clear all
clc
N = 10;       % Number of sections in the transmission line
y0 = zeros(2 * N, 1);
y0(2) = 5;  % Initial voltage at the first node

% Time span for the simulation
tspan = [0 10];  

% Solve using ode45
[t, y] = ode45(@fline, tspan, y0);

% Plot voltage at the end of the transmission line (VN)
figure;
plot(t, y(:, 2 * N));
xlabel('Time (s)');
ylabel('Voltage at Load (V)');
title('Voltage at Load over Time');