% FDTD Simulation with Terminal Constraints
clear; clc;

% Parameters
L_total = 150e-6;    % Total line length (m)
R = 1200;            % Per-unit-length resistance (Ω/m)
L = 250e-9;          % Per-unit-length inductance (H/m)
C = 1e-10;           % Per-unit-length capacitance (F/m)
Rs = 10;             % Source resistance (Ω)
R_L = 500;            % Load resistance (Ω) [Added]
NDZ = 50;            % Spatial steps
dz = L_total / NDZ;  % Spatial step (Δz)
v = 1/sqrt(L*C);     % Phase velocity (m/s)
dt = dz / v;         % Magic time step (Δt = Δz/v)
t_max = 10e-12;      % Simulation time
t_steps = round(t_max / dt); % Time steps

% Initialize staggered grids
V = zeros(NDZ+1, t_steps);   % Voltages at integer time steps
I = zeros(NDZ, t_steps);     % Currents at half-integer steps (I(:,n) = I^{n-1/2})

% Source voltage (1V step input)
Vs = ones(1, t_steps);

% FDTD Loop
for n = 1:t_steps-1
    % Update left boundary (z=0) using Eq. (10a)
    V(1, n+1) = (Rs*(C*dz)/(2*dt) + 0.5)^(-1) * ...
        ((Rs*(C*dz)/(2*dt) - 0.5)*V(1,n) - Rs*I(1,n) + 0.5*(Vs(n+1) + Vs(n)));
    
    % Update interior voltages (k=2 to NDZ) using Eq. (10b)
    for k = 2:NDZ
        V(k, n+1) = V(k, n) - (dt/(dz*C)) * (I(k, n) - I(k-1, n));
    end
    
    % Update right boundary (z=L) using Eq. (10c)
    V(NDZ+1, n+1) = (R_L*(C*dz)/(2*dt) + 0.5)^(-1) * ...
        ((R_L*(C*dz)/(2*dt) - 0.5)*V(NDZ+1, n) + R_L*I(NDZ, n));
    
    % Update currents using Eq. (10d) (staggered in time)
    for k = 1:NDZ
        I(k, n+1) = I(k, n) - (dt/(L*dz)) * (V(k+1, n+1) - V(k, n+1)) - (R*dt/L)*I(k, n);
    end
end

% Plot voltage at load (z=L)
figure;
plot((0:t_steps-1)*dt / 1e-12, V(NDZ+1, :));
xlabel('Time (ps)');
ylabel('Load Voltage (V)');
title('FDTD Simulation with Terminal Constraints');
grid on;