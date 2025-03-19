%FDTD
clear
clc
L_total = 150e-6;  % Total length of the line (m)
R = 1200;
L = 250e-9;
C = 1e-10;
Rs = 10;
NDZ = 50;  % Number of spatial steps
dz = L_total / NDZ;  % Spatial step delta z
v = 1/sqrt(L*C); % Phase velocity (m/s)
%dt = dz/v;   % Magic time step (dt = dz/v)
dt = 1e-16;  % Time step delta t 
t_max = 10e-12;
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
     V(1, n+1) = (Rs*C/2*dz/dt+0.5)^-1*((Rs *C/2 *dz/dt-0.5)*V(1,n)-Rs*I(1,n)+0.5*(Vs(n+1)+Vs(n)));
    for k = 1:NDZ
    if k>1
        V(k,n+1) = V(k,n) + dt/(dz *C)* (I(k-1,n) - I(k,n));  % Update voltag            
        I(k-1,n+1) = I(k-1,n)-(dt/(L*dz))*(V(k,n+1)-V(k-1,n+1))-(R*dt/L)*I(k-1,n);% Update current
    end
    end
    V(NDZ,n+1) =V(NDZ,n)+dt*(I(NDZ-1,n)/(C*dz));
end
y_FDTD = V(NDZ,:);
% Plot the results for the voltage at the load
figure(1)
plot(time/1e-12, V(NDZ,:));
xlabel('Time (ps)');
ylabel('V Load (Volts)');
title('FDTD Simulation of Transmission Line with unit step input');
%title('FDTD Simulation of Transmission Line with 100 GHz Sine Wave Input');
%title('FDTD Simulation of Transmission Line with Trapezoidal Pulse Input');
grid on
