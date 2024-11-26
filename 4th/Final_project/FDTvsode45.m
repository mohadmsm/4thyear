clear all
clc
% a lossless , two-conductor line with Vs(t)=30,
% Rs = 0 R, VL(t) = 0, and RL = 100 R. The line is of 
% length L = 400 m and has TJ = 2 x 10' m/s and ZC = 50 R 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L_total = 400; 
Zc = 50;  
v = 2e8; 
Rs = 0;  
RL = 100; 
Vs = 30;
C = 1 / (v * Zc); 
L = Zc/v;  
NDZ = 200;  
dz = L_total / NDZ;  
dt = 1e-11;  
t_max = 20e-6;  
t_steps = round(t_max / dt);  % Number of time steps
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
N=200;
dz = 400/N;
R = 0;
t1 = 0:1e-11:20e-6;
L = L *dz;
C = C *dz;
y0 = zeros(2 * N, 1);
[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, RL, Vs), t1, y0);

% Plot the results for the voltage at the load
figure(1)
plot((0:t_steps-1)*dt/1e-6, V(NDZ,:));
hold on
plot(t.*1e6, y(:,N*2));
hold off
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title('FDTD Simulation of Transmission Line Vs ODE45');
grid on;
