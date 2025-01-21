clear all
clc
N = 2; % Number of sections in the transmission line
l = 400 ; % line length 
dz = l/N ; % section length
L = 2.5e-7 ;  % Inductance
C = 1e-10;    % Capacitance
G = 0;
R = 0 * dz;       % Resistance per section *dz
Rs = 0;       % Source resistance
Rl = 100;     % Load resistance
Vs  = 30;      % Source voltage (could be a function of time)
y0 = zeros(2 * N, 1);
tspan = [0 20e-6];
t1 = 0:1e-11:20e-6;
M = 2;
Vo = @(s) Vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
[poles,residues] =  R_Approximation(M);
Vot = - (1 ./ t1) .*sum(real(Vo(poles./t1).*residues));
% Solve using ode45
L = L *dz;
C = C *dz;
[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, Rl, Vs), t1, y0);

% Plot voltage at the end of the transmission line (VN)
figure(1);
plot(t, y(:,N*2));  % Plot voltage at the load (VN)
hold on
plot(t1,Vot);
hold off
xlabel('Time (us)');
ylabel('Voltage at Load (V)');
title('Voltage at Load over Time');
legend('NILT0 (Red)', 'RLC Ladder (Blue)', 'FontSize', 12, 'Location', 'Best')
grid on
xlim([0 tspan(2)]);

