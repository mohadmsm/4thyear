clear all
clc
% a lossless , two-conductor line with Vs(t)=30,
% Rs = 0 R, VL(t) = 0, and RL = 100 R. The line is of 
% length L = 400 m and has TJ = 2 x 10' m/s and ZC = 50 R
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L_total = 400;  % Total length of the line (m)
Zc = 50;  % Characteristic impedance (Ohms)
v = 2e8;  % Speed of propagation (m/s)
Rs = 0;  % Source resistance (Ohms)
RL = 100;  % Load resistance (Ohms)
Vs = 30;  % Input voltage (V)
% Compute inductance and capacitance
C = 1 / (v * Zc); 
L = Zc/v;  
%C = 40.6280e-12;  
%L = 1.10418e-6;  
NDZ = 200;  % Number of spatial steps
NDT= 2000; %not used 
dz = L_total / NDZ;  % Spatial step delta z
dt = dz / v;  % Time step delta t (magic time step)
t_max = 20e-6;  % Maximum simulation time (20 as in the paper)
t_steps = round(t_max / dt);  % Number of time steps
% allocate voltage and current arrays
V = zeros(NDZ+1, t_steps);
I = zeros(NDZ, t_steps);
% FDTD Loop for Time Stepping
for n = 1:t_steps-1
    V(1,n+1) = ((dz/dt * Rs * C + 1)^(-1)) * ((dz/dt * Rs * C - 1) * V(1,n) ...
                - 2 * Rs * I(1,n) + (Vs + Vs));
    for k = 1:NDZ
        if k>1
            V(k,n+1) = V(k,n) - dt/dz *C^-1* (I(k,n) + I(k-1,n));  % Update voltag
        end
        dV_k = V(k+1,n+1) + V(k,n+1);  % Voltage difference between points
        I(k,n+1) = I(k,n) - dt/dz *L^-1 * dV_k; 

    end
 
    V(NDZ+1,n+1) = ((dz/dt * RL * C + 1)^(-1)) * ((dz/dt * RL * C - 1) * V(NDZ+1,n) ...
                   + 2 * RL * I(NDZ,n) + V(NDZ+1,n));
end
% Plot the results for the voltage at the load
figure;
plot(0:t_steps-1, V);
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title('FDTD Simulation of Transmission Line');
grid on;
