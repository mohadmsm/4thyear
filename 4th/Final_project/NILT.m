clear all,
clc
% Define the Laplace transform function this for a single M value
%%
clear all
clc
t =0:0.01:1;
X_func = @(s) 1 ./ (s+4);
%input = @(s) 1./s;
G = @(s) X_func(s) .* input(s);
%time step  to evaluate around
M=10;
[poles,residues] =  R_Approximation(M);
result = - (1 ./ t) .*sum(G(poles./t).*residues);
exact = 0.25*(1 - exp(-4*t));
error = abs(exact-result);
plot(t,error)
fprintf('The approximation at t = %.3f is: %.4f\n', t, result);

%}
%% 
%test multiple vlaues of M for fast observation.
% Define the Laplace transform function
X_func = @(s) 100 ./ ((s + 3).*(s + 5));

%time step  to evaluate around

t = 0:0.01:10;

exact = 50*(exp(-3.*t)-exp(-5*t));% X(t)
error = zeros(1,length(t)); 
result = zeros(1,length(t));
figure;
%only take the even M
for M= 2: 2: 12
for n=1:length(t)
result(n) = NILT_approximation(X_func,t(n),M);
error(n) = abs(exact(n) - result(n));
end
%fprintf('The error at t = %.2f is: %.12f\n', t(n), error(n));

% for observation purpose 
subplot(3, 2, M/2); % Arrange subplots in a 3x2 grid
plot(t,error)
xlabel('time t in seconds')
ylabel('Error' )
title(['Error for M = ', num2str(M)]);

end
%}
%%
clear all
clc
% Define constants
R = 0.75; % Insert value of R
L = 0.25; % Insert value of L
C = 2; % Insert value of C
vs = 5;% Define the source voltage
tspan = 0:0.001:10; % Define the time range for the simulation
G = @(s) (1/(L*C))./(s.^2+R/L.*s+1/(L*C)) * vs./s; %if the input is constant 
M = 9;
[poles,residues] =  R_Approximation(M);
NILT0_result = - (1 ./ tspan) .*sum(G(poles./tspan).*residues);
% Define the system of equations

% Initial conditions
y0 = [0 0]; % v0(0) = 0 and dv0/dt(0) = 0

exact = -10*exp(-tspan) + 5*exp(-2.*tspan) + vs;
% Solve the system using ode45
[t, y] = ode45(@(t,y)circuitODE(t,y,R,L,C,vs), tspan, y0);
%find the error 
NILT_err = abs(exact - NILT0_result);
exact = exact.';
ode_err = abs(exact - y(:,1));
 
%%
clear all
clc
N = 10; % Number of sections in the transmission line
l = 400 ; % line length 
dz = l/N ; % section length
L = 2.5e-7 * dz;   % Inductance
C = 1e-10 * dz;    % Capacitance
R = 0 * dz;       % Resistance per section *dz
Rs = 0;       % Source resistance
Rl = 100;     % Load resistance
Vs  = 30;      % Source voltage (could be a function of time)
y0 = zeros(2 * N, 1);
tspan = [0 20e-6];  
% Solve using ode45
[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, Rl, Vs), tspan, y0);
figure(1);
plot(t, y(:,N*2));  % Plot voltage at the load (VN)
xlabel('Time (us)');
ylabel('Voltage at Load (V)');
title('Voltage at Load over Time');


%%
%% Clear workspace and define variables
clear all
clc
t = 0:0.01:1;
% find X(s) = (B(s)+Cx(0))/(G+Cs)
%ie 1/s+1, x(0)=0
B = @(s) 1;
C = 1;
G = 1;
Xo = 0;
X_func = @(s) (B(s) + C*Xo)./(G+C.*s);
% Approximation order
M = 5;
[poles, residues] = R_Approximation(M);
result = - (1 ./ t) .*sum(real(X_func(poles./t).*residues));
exact = exp(-t);
error = abs(exact - result);
% Plot error
plot(t, error);
xlabel('Time (t)');
ylabel('Error');
% Display results









%%

