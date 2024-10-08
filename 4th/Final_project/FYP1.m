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

Vs = 30;%  % Input voltage (V)
% Compute inductance and capacitance
C = 1 / (v * Zc); 
L = Zc/v;  

NDZ = 50;  % Number of spatial steps

dz = L_total / NDZ;  % Spatial step delta z
dt = 1e-11;  % Time step delta t 


t_max = 20e-6;  % Maximum simulation time (20 as in the paper)
t_steps = round(t_max / dt);  % Number of time steps

% allocate voltage and current arrays
V = zeros(NDZ+1, t_steps);
V(1,:)=Vs*ones(1,t_steps);
I = zeros(NDZ, t_steps);

   
% FDTD Loop for Time Stepping
for n = 1:t_steps-1
    V(1,n+1) = V(1,n);
    for k = 1:NDZ
    if k>1
            V(k,n+1) = V(k,n) + dt/(dz *C)* (I(k-1,n) - I(k,n));  % Update voltag
        
        dV_k = V(k-1,n) - V(k,n);  % Voltage difference between points
        I(k-1,n+1) = I(k-1,n) + dt/(dz *L) * dV_k; 
    end
    end
 
    V(NDZ,n+1) =V(NDZ,n)+dt*(I(NDZ-1,n)/(C*dz)-V(NDZ,n)/(RL*C*dz));
end
% Plot the results for the voltage at the load
figure(1)
plot((0:t_steps-1)*dt/1e-6, V(NDZ,:));
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title('FDTD Simulation of Transmission Line');
grid on;
