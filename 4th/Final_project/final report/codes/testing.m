clear
clc
tic
L_total = 400;  % Total length of the line (m)
Zc = 50;  % Characteristic impedance (Ohms)
v = 2e8;  % Speed of propagation (m/s)
Rs = 0;  % Source resistance (Ohms)
RL = 1;  % Load resistance (Ohms)
Vs = 30;  % Input voltage (V)
R = 0.1;  % Resistance per section (Ohms) - Added parameter

% Compute inductance and capacitance
C = 1 / (v * Zc); 
L = Zc / v;  
NDZ = 20;  % Number of spatial steps
dz = L_total / NDZ;  % Spatial step delta z
dt = 1e-11;  % Time step delta t 
t_max = 20e-6;  % Maximum simulation time (20e-6 seconds)
t_steps = round(t_max / dt);  % Number of time steps

% Allocate voltage and current arrays
V = zeros(NDZ+1, t_steps);
V(1,:) = Vs * ones(1, t_steps);  % Initial source voltage
I = zeros(NDZ, t_steps);   

% FDTD Loop for Time Stepping
for n = 1:t_steps-1
    V(1, n+1) = V(1, n);  % Update source voltage (fixed)
    for k = 1:NDZ
        if k > 1
            % Update voltage at position k
            V(k, n+1) = V(k, n) + (dt / (dz * C)) * (I(k-1, n) - I(k, n));
            % Voltage difference for current update
            dV_k = V(k-1, n) - V(k, n);
            % Update current with resistance R per section
            I(k-1, n+1) = I(k-1, n) * (1 - (dt * R) / (L * dz)) ...
                         + (dt / (dz * L)) * dV_k;
        end
    end
    % Boundary condition at the load (assuming open circuit)
    V(NDZ, n+1) = V(NDZ, n) + dt * (I(NDZ-1, n) / (C * dz));
end

% Plot the voltage at the load
figure(1)
plot((0:t_steps-1) * dt / 1e-6, V(NDZ, :));
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title('FDTD Simulation of Transmission Line with Resistance');
grid on;
toc