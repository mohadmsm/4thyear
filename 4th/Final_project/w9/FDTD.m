function [y,t]=FDTD(R,L,C,length,t_max)
Rs = 0;
NDZ = 100;  % Number of spatial steps
dz = length / NDZ;  % Spatial step delta z
dt = 1e-17;  % Time step delta t 
t_steps = round(t_max / dt);  % Number of time steps
% allocate voltage and current arrays
time = (0:t_steps-1)*dt;
V = zeros(NDZ+1, t_steps);
I = zeros(NDZ, t_steps);
% 1.Step input (1V source)
Vs = 1 * ones(1, t_steps); 
% 2. Sine wave (100 GHz)
%freq = 100e9; % Frequency in Hz
%Vs = sin(2*pi*freq * time);
% 3. Trapezoidal pulse (custom function)
%for i=1:length(time)
    %Vs(i) = trapezoidalPulse(time(i));
%end 
% FDTD Loop for Time Stepping
for n = 1:t_steps-1
    V(1, n+1) = (Rs*C/2* dz/dt + 0.5)^-1* ((Rs *C/2 *dz/dt - 0.5) * V(1, n) - Rs * I(1, n) + 0.5 * (Vs(n+1) + Vs(n)));
    for k = 1:NDZ
    if k>1
        V(k,n+1) = V(k,n) + dt/(dz *C)* (I(k-1,n) - I(k,n));  % Update voltag        
        dV_k = V(k-1,n) - V(k,n);  % Voltage difference between points 
        I(k-1,n+1) = I(k-1,n) + dt/(dz *L) * (dV_k-R*dz*I(k-1,n));
    end
    end
    V(NDZ,n+1) =V(NDZ,n)+dt*(I(NDZ-1,n)/(C*dz));
end
y = V(NDZ,:);
t = time/1e-12;
end