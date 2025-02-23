clear
clc
tic
% Parameters
len = 400;
N = 20;            % Number of sections
dz = len / N;
L = 2.5e-7 * dz;   % Inductance per section
C = 1e-10 * dz;    % Capacitance per section
R = 0;             % Resistance per section
Rs = 0;            % Source resistance
Rl = 100;          % Load resistance
Vs = 30;           % Source voltage

% Initial conditions
y0 = zeros(2 * N, 1);
tspan = 0:1e-11:20e-6;  % Simulate from 0 to 20µs
opts = odeset('Refine', 1);
% Solve using ode45
[t, y] = ode23(@(t,y) fline(t, y, N, L, C, R, Rs, Rl, Vs), tspan-1, y0);

% Plot voltage at the load (VN)
figure(1);
plot(t*1e6, y(:, 2*N));  % Convert time to microseconds
xlabel('Time (\mus)');
ylabel('Voltage at Load (V)');
title('Transmission Line Voltage at Load');
grid on
toc
function df = fline_noR(t, y, N, L, C, R, Rs, Vs)
    df = zeros(2*N, 1);
    In = y(1:2:end);     % Currents (I1, I2, ..., IN)
    Vn = y(2:2:end);     % Voltages (V1, V2, ..., VN)
    
    inv_L = 1 / L;
    inv_C = 1 / C;
    R_total_source = Rs + R;
    
    % Source end (n=1)
    df(1) = inv_L * (Vs - R_total_source*In(1) - Vn(1));
    df(2) = inv_C * (In(1) - In(2));
    
    % Interior nodes (n=2 to N-1)
    for n = 2:N-1
        df(2*n-1) = inv_L * (Vn(n-1) - Vn(n) - R*In(n));
        df(2*n)   = inv_C * (In(n) - In(n+1));
    end
    
    % Load end (n=N)
    df(2*N-1) = inv_L * (Vn(N-1) - Vn(N) - R*In(N));
    df(2*N)    = inv_C * (In(N) - Vn(N)/Rl);
end