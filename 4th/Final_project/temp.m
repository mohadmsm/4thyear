clear all
clc
% Define constants
R = 0.75; % Insert value of R
L = 0.25; % Insert value of L
C = 2; % Insert value of C
vs = 5;% Define the source voltage
tspan = 0:0.001:10; % Define the time range for the simulation
h = tspan(2) - tspan(1);
G = @(s) (1/(L*C))./(s.^2+(R/L).*s+1/(L*C)) * vs./s; %if the input is constant 
M = 5;
beta = 2;
[poles,residues] =  R_Approximation(M);
y0 = [0 0]; % v0(0) = 0 and dv0/dt(0) = 0
NILT0_result(1) = - (1 ./ h) .*sum(real(G(poles./h).*residues.*poles.^2));
for i=2:length(tspan)
    X_prev =NILT0_result(i-1); %use the previous to approximate the next one
    most_right_term = sum(poles.^(beta - 1).*X_prev);
    NILT0_result(i) =  - (1 ./ (h)) .*sum(real(G(poles./h).*residues.*(poles.^2) -most_right_term));
end

exact = -10*exp(-tspan) + 5*exp(-2.*tspan) + vs;
% Solve the system using ode45
[t, y] = ode45(@(t,y)circuitODE(t,y,R,L,C,vs), tspan, y0);
NILT_err = abs(exact - NILT0_result);
exact = exact.';
ode_err = abs(exact - y(:,1));
figure(1);

% Plot ode45 result
subplot(2, 2, 1);
plot(t, y(:,1), "Color", "blue");
xlabel('Time (s)');
ylabel('v_0(t) (V)');
title('ODE45 Solution');

% Plot NILT result
subplot(2, 2, 2);
plot(tspan, NILT0_result, "Color", "green");
xlabel('Time (s)');
ylabel('v_0(t) (V)');
title('NILT Solution at M = 5');

% Plot ode45 error
subplot(2, 2, 3);
plot(t, ode_err, "Color", "red");
xlabel('Time (s)');
ylabel('Error (V)');
title('ODE45 Solution Error');

% Plot NILT error
subplot(2, 2, 4);
plot(tspan, NILT_err, "Color", "magenta");
xlabel('Time (s)');
ylabel('Error (V)');
title('NILT Solution Error at M = 5');

