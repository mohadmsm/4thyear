clear
clc
% Define Parameters for 1D Transmission Line (use 1,1 elements from L and C)
L_11 = 1.10418e-6;  % Inductance (H/m) from L(1,1)
C_11 = 40.6280e-12;  % Capacitance (F/m) from C(1,1)
Zc = sqrt(L_11 / C_11);  % Characteristic impedance (Ohms)
v = 1 / sqrt(L_11 * C_11);  % Wave speed (m/s)
L_total = 0.254;  % Total length of the line (m)

% Source and Load Resistances
Rs = 50;  % Source resistance (Ohms)
RL = 50;  % Load resistance (Ohms)
Vs = 30;  % Input voltage (V)

% Discretization
NDZ = 200;  % Number of spatial steps
dz = L_total / NDZ;  % Spatial step size (m)
dt = dz / v;  % Time step (s)
t_max = 20e-6;  % Maximum simulation time (s)
t_steps = round(t_max / dt);  % Number of time steps

% Time vector
time = (0:t_steps-1) * dt;  % Time vector (s)

% Preallocate voltage and current arrays
V = zeros(NDZ+1, t_steps);  % Voltage array [spatial steps, time steps]
I = zeros(NDZ, t_steps);  % Current array [spatial steps, time steps]

% Set initial conditions
V(1,1) = Vs;  % Apply initial voltage at the source

% FDTD Loop for Time Stepping
for n = 1:t_steps-1
    % Update current using voltage
    for k = 1:NDZ
        dV = V(k+1,n) - V(k,n);  % Voltage difference between spatial steps
        I(k,n+1) = I(k,n) - dt / dz * dV / L_11;  % Update current
    end
    
    % Update voltage using current
    for k = 2:NDZ
        dI = I(k,n+1) - I(k-1,n+1);  % Current difference between spatial steps
        V(k,n+1) = V(k,n) - dt / dz * dI / C_11;  % Update voltage
    end
    
    % Apply boundary conditions
    V(1,n+1) = (Vs - Rs * I(1,n+1)) / (1 + Rs / Zc);  % Source boundary condition
    V(end,n+1) = (RL * I(NDZ,n+1)) / (RL + Zc);  % Load boundary condition
end

% Plot the results for the voltage at the load
figure;
plot(time * 1e6, V(end,:), 'k-', 'LineWidth', 1.5);  % Plot voltage at the load
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title('1D FDTD Simulation of Transmission Line (Using L(1,1) and C(1,1))');
grid on;
