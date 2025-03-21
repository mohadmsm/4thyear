function [y,t]=FDTD(R,L,C,length,Rs,t_max,N)
NDZ = N;  % Number of spatial steps
dz = length / NDZ;  % Spatial step delta z
dt = 1e-16;  % Time step delta t or Magic time step (dt = dz/v) for a lossles case
t_steps = round(t_max / dt);  % Number of time steps
% allocate voltage and current arrays
time = (0:t_steps-1)*dt;
V = zeros(NDZ+1, t_steps);
I = zeros(NDZ, t_steps);
%f = 100e9;
% 1.Step input (1V source)
Vs = 1 * ones(1, t_steps); 
% 2. Sine wave (100 GHz)
%Vs = sin(2*pi*f* time);
% 3. Trapezoidal pulse (custom function)
for ii=1:length(time)
    Vs(ii) = trapezoidalPulse(time(ii));
end 
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
y = V(NDZ,:);
t = time;
end