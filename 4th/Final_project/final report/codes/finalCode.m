clear
clc
tic
L_total = 400;  % Total length of the line (m)
Zc = 50;  % Characteristic impedance (Ohms)
v = 2e8;  % Speed of propagation (m/s)
Rs = 0;  % Source resistance (Ohms)
RL = 100;  % Load resistance (Ohms)
Vs = 30;%  % Input voltage (V)
% Compute inductance and capacitance
C = 1 / (v * Zc); 
L = Zc/v;  
NDZ = 200;  % Number of spatial steps
dz = L_total / NDZ;  % Spatial step delta z
dt = 5e-12;  % Time step delta t 
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
    V(NDZ,n+1) =V(NDZ,n)+dt*(I(NDZ-1,n)/(C*dz));
end
y_FDTD = V(NDZ,:);
toc
vo = @(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0 + 2.5e-7.*s).^(1/2)));
[y1,t1]=niltcv(vo,20e-6,'pp1');
RMSE = sqrt(sum(abs(y_FDTD-y1).^2)/length(y1));
abs(RMSE)

%{
len=400;
N = 100; % Number of sections in the transmission line
dz=len/N;
L = 2.5e-7*dz;   % Inductance
C = 1e-10*dz;    % Capacitance
R = 0;       % Resistance per section
Rs = 0;       % Source resistance
Rl = 100;     % Load resistance
Vs  = 30;      % Source voltage (could be a function of time)
y0 = zeros(2 * N, 1);
tspan = 0:1e-10:20e-6;  
% Solve using ode45
[t, y] = ode45(@(t, y) fline_noR(t, y, N, L, C, R, Rs, Vs), tspan, y0);
y_RLC= y(:,N*2)';
plot(t1,y_FDTD,t,y_RLC,t1,y1,'black')
xlabel('Time (s)');
ylabel('Vo (Volts)');
grid on
legend('FDTD','RLC','Exact');
title('FDTD Vs RLC Vs Exact Simulation of Transmission Line');
xlim([0 20e-6]);

% Plot the results for the voltage at the load

figure(1)
plot((0:t_steps-1)*dt/1e-6, V(NDZ,:));
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title('FDTD Simulation of Transmission Line');
%
grid on;
toc
%}
%%
clear 
clc
tic
len=400;
N = 400; % Number of sections in the transmission line
dz=len/N;
L = 2.5e-7*dz;   % Inductance
C = 1e-10*dz;    % Capacitance
R = 0.1*dz;       % Resistance per section
Rs = 0;       % Source resistance
Rl = 100;     % Load resistance
Vs  = 30;      % Source voltage (could be a function of time)
y0 = zeros(2 * N, 1);
tspan = 0:1e-10:20e-6;  
% Solve using ode45
[t, y] = ode45(@(t, y) fline_noR(t, y, N, L, C, R, Rs, Vs), tspan, y0);
% Plot voltage at the end of the transmission line (VN)
toc
vo = @(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0 + 2.5e-7.*s).^(1/2)));
[y1,t1]=niltcv(vo,20e-6,'pp1');
yr= y(:,N*2)';
RMSE = sqrt(sum(abs(yr-y1).^2)/length(y1));
RMSE
%}
%{
figure(1);
plot(t, y(:,N*2));  % Plot voltage at the load (VN)
xlabel('Time (s)');
ylabel('Voltage (V)');
title('RLC over Time');
xlim([0 20e-6]);
grid on 
toc
%}
%%
clear
clc
l = 400;
R = 0;
L = 2.5e-7;  
C = 1e-10; 
G=0;
vs=30;
vo = @(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(vo,20e-6,'pp1');
plot(t,y);
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Exact solution');
xlim([0 20e-6]);
grid on 
%%
clear
clc
A = [-2 1 0 0; 1 -2 1 0; 0 1 -2 1; 0 0 1 -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
t=0:0.01:2;
sys = ss(A,B,transpose(C),0); 
[y_values, t] = step(sys, t); 
D = 0;
input =1;
%t = linspace(0,2,250);
    q = length(B);
    num_moments = 2 * q;
    moments = zeros(1, num_moments);
    [r,c]=size(C); % make sure C matrix in correct form
    if r~=1
        C= C';
    end
    for k = 1:num_moments
        moments(k) = (-1) * C * (A)^-(k) * B;
    end
    moments(1)=moments(1)+D;
    approx_order = length(B);

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end

    % Solve for denominator coefficients
    b_matrix = moment_matrix^-1 * Vector_c;

    % Compute poles
    poles = roots([b_matrix', 1]);

    % Compute residues
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1 / poles(j)^(i-1);
        end
    end

    A_diag = diag(1 ./ poles);
    r_moments = moments(1:approx_order);
    residues = -1 * (A_diag \ (V \ r_moments'));

    % Impulse response
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues(i) * exp(poles(i) * t);
    end
    h_s =@(s) 0;
    for i = 1:length(poles)
        h_s =@(s) h_s(s) + residues(i)./(s-poles(i));
   end

    % Step response using recursive convolution
    y_step = zeros(size(t));
    y = zeros(length(poles), 1);

    for n = 2:length(t)
        dt = t(n) - t(n-1);
        exp_term = exp(poles * dt);
        for i = 1:length(poles)
            y(i) = residues(i) * (1 - exp_term(i))/(-poles(i)) * input + exp_term(i) * y(i);
        end
        y_step(n) = sum(y);
    end
plot(t,y_values,t,y_step,'r*')
xlabel('time (s)')
ylabel('Y(t)')
title('AWE vs Theory impulse')
legend('Theory step','AWE')
grid on
RMSE = sqrt(sum((y_step-y_values).^2)/length(y_values));
abs(RMSE)
%%
clear
clc
l=400;
N =9;
dz=l/N;
Ldz = 2.5e-7*dz;   % Inductance
Cdz = 1e-10*dz;
Rs =0;
Rdz = 0;
numStates = 2 * N; % Each section has 2 states (current and voltage)
A = zeros(numStates, numStates);% Initialize A matrix
for i = 1:N
    if i == 1
        A(1, 1) = -(Rs + Rdz) / Ldz; % firs term (Rs + Rdz)
    else
        A(2*i-1, 2*i-1) = -Rdz / Ldz;
    end
    if i > 1
        A(2*i-1, 2*(i-1)) = 1 / Ldz;
        A(2*i-1, 2*i) = -1 / Ldz;
    end
    if i < N
        A(2*i-1, 2*i) = -1 / Ldz;
        A(2*i, 2*i-1) = 1 / Cdz; 
        A(2*i, 2*i+1) = -1 / Cdz; 
    else
        A(2*i, 2*i-1) = 1 / Cdz; 
    end   
end
% Initialize B matrix
B = zeros(numStates, 1);
B(1) = 1 / Ldz; 
%C matrix
C = zeros(1, numStates);
C(end) = 1; 
D = 0;
[h_impulse,h_s, y_step, t] = AWE(A,B,C,D,30,20e-6);
plot(t,y_step);