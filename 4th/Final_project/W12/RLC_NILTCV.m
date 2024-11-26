% RLC Ladded using ode45 vs exact woth niltcv
clear all, clc
R = 0.1;  
Rs = 0;
RL = 100;
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
Vs = 30; 
% Find the exact soluation using niltcv before changing R,L and C
Vo = @(s) Vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2))); % simplified version 
[y, t]= niltcv(Vo,20e-6,'ppp'); %passing ppp as we don't want a plot
% change R, L and C to be per unit length with N=20
N=20;
dz = l/N;
R = R *dz; % the issue 
L = L *dz;
C = C *dz;
y0 = zeros(2 * N, 1); % initial conditions
[RLC_t, RLC_y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, RL, Vs), t, y0);
% now plot both of them
figure(1);
plot(RLC_t,RLC_y(:,N*2),'r');
hold on
plot(t,y,'b');
hold off
xlabel('Time (s)');
ylabel('Output Voltage (V)');
grid on;

