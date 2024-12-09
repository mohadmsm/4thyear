
None selected 

Skip to content
Using Dublin City University Mail with screen readers
in:sent 

Conversations
 
Programme Policies
Powered by Google
Last account activity: 16 minutes ago
Details
clear all
clc 
% Week 12, time domain approximation.
% define parameater
R = 0;
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
Vs = 30; 
t = 0:1e-10:20e-6; % this indicate that dt = 1e-11
N=2;
dz = 400/N;
Rs = 0;
R = R*dz;  % per unit length      
L = L *dz;
C = C *dz;
RL = 100;
R_dz = 0;
dz = 400/2;
C_dz = 1e-10 *dz;
L_dz = 2.5e-7 *dz;
Vs = 30;
y0 = zeros(2 * N, 1);
[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, RL, Vs), t, y0);
Vo = @(S) (RL*Vs./S)./(RL*C_dz^2*L_dz^2*S.^4 + 2*RL*C_dz^2*L_dz*R_dz*S.^3 + RL*C_dz^2*R_dz^2*S.^2 + C_dz*L_dz^2*S.^3 + 2*C_dz*L_dz*R_dz*S.^2 + 3*RL*C_dz*L_dz*S.^2 + C_dz*R_dz^2.*S + 3*RL*C_dz*R_dz.*S + 2*L_dz.*S + 2*R_dz + RL);
[y1,t1]=niltcv(Vo,20e-6,'ppp1');
plot(t, y(:,N*2));
hold on
plot(t1,y1,'ro');
hold off
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title(['RLC with ODE45 vs tf NILT at N = ',num2str(N)]);
grid on;

%%
clear all, clc
syms R_dz L_dz C_dz RL Vs S
C_S_dz = 1/(S*C_dz);
z1 = (RL * C_S_dz)/(RL+C_S_dz);
z2 = z1 + R_dz + S*L_dz;
z3 = (z2*C_S_dz)/(z2+C_S_dz);
V1 = Vs *z3/(z3+R_dz+L_dz*S);
V2 = z1/(z1+R_dz+S*L_dz)*V1;
V2 = simplify(V2);
%%
clear all, clc
RL = 100;
R_dz = 0;
dz = 400/2;
C_dz = 1e-10 *dz;
L_dz = 2.5e-7 *dz;
Vs = 30;
Vo = @(S) (RL*Vs./S)./(RL*C_dz^2*L_dz^2*S.^4 + 2*RL*C_dz^2*L_dz*R_dz*S.^3 + RL*C_dz^2*R_dz^2*S.^2 + C_dz*L_dz^2*S.^3 + 2*C_dz*L_dz*R_dz*S.^2 + 3*RL*C_dz*L_dz*S.^2 + C_dz*R_dz^2.*S + 3*RL*C_dz*R_dz.*S + 2*L_dz.*S + 2*R_dz + RL);
[y,t]=niltcv(Vo,20e-6,'ppp1');
%%
% RLC vs exact with diffrent value for N
clear all, clc
R = 0.1;
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
Vs = 30; 
Rs = 0;
RL =100;
tspan = 0:1e-10:20e-6;

Vo = @(s) Vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
[y1,t1]=niltcv(Vo,20e-6,'ppp');
figure(1);

None selected 

Skip to content
Using Dublin City University Mail with screen readers
in:sent 

Conversations
 
Programme Policies
Powered by Google
Last account activity: 16 minutes ago
Details
clear all
clc 
% Week 12, time domain approximation.
% define parameater
R = 0;
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
Vs = 30; 
t = 0:1e-10:20e-6; % this indicate that dt = 1e-11
N=2;
dz = 400/N;
Rs = 0;
R = R*dz;  % per unit length      
L = L *dz;
C = C *dz;
RL = 100;
R_dz = 0;
dz = 400/2;
C_dz = 1e-10 *dz;
L_dz = 2.5e-7 *dz;
Vs = 30;
y0 = zeros(2 * N, 1);
[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, RL, Vs), t, y0);
Vo = @(S) (RL*Vs./S)./(RL*C_dz^2*L_dz^2*S.^4 + 2*RL*C_dz^2*L_dz*R_dz*S.^3 + RL*C_dz^2*R_dz^2*S.^2 + C_dz*L_dz^2*S.^3 + 2*C_dz*L_dz*R_dz*S.^2 + 3*RL*C_dz*L_dz*S.^2 + C_dz*R_dz^2.*S + 3*RL*C_dz*R_dz.*S + 2*L_dz.*S + 2*R_dz + RL);
[y1,t1]=niltcv(Vo,20e-6,'ppp1');
plot(t, y(:,N*2));
hold on
plot(t1,y1,'ro');
hold off
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title(['RLC with ODE45 vs tf NILT at N = ',num2str(N)]);
grid on;

%%
clear all, clc
syms R_dz L_dz C_dz RL Vs S
C_S_dz = 1/(S*C_dz);
z1 = (RL * C_S_dz)/(RL+C_S_dz);
z2 = z1 + R_dz + S*L_dz;
z3 = (z2*C_S_dz)/(z2+C_S_dz);
V1 = Vs *z3/(z3+R_dz+L_dz*S);
V2 = z1/(z1+R_dz+S*L_dz)*V1;
V2 = simplify(V2);
%%
clear all, clc
RL = 100;
R_dz = 0;
dz = 400/2;
C_dz = 1e-10 *dz;
L_dz = 2.5e-7 *dz;
Vs = 30;
Vo = @(S) (RL*Vs./S)./(RL*C_dz^2*L_dz^2*S.^4 + 2*RL*C_dz^2*L_dz*R_dz*S.^3 + RL*C_dz^2*R_dz^2*S.^2 + C_dz*L_dz^2*S.^3 + 2*C_dz*L_dz*R_dz*S.^2 + 3*RL*C_dz*L_dz*S.^2 + C_dz*R_dz^2.*S + 3*RL*C_dz*R_dz.*S + 2*L_dz.*S + 2*R_dz + RL);
[y,t]=niltcv(Vo,20e-6,'ppp1');
%%
% RLC vs exact with diffrent value for N
clear all, clc
R = 0.1;
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
Vs = 30; 
Rs = 0;
RL =100;
N=20;
dz=400/N;
y0 = zeros(2 * N, 1);
tspan = 0:1e-10:20e-6;
Vo = @(s) Vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
[y1,t1]=niltcv(Vo,20e-6,'ppp');

R =0.1*dz;
L = 2.5e-7*dz;
C = 1e-10*dz;

[t, y] = ode45(@(t, y) fline(t, y, N, L, C, R, Rs, RL, Vs), tspan, y0);
figure(1);
hold on
plot(t,y(:,N*2),'r');
plot(t1,y1,'b');
hold off
%{
for N=2:10
 subplot(3, 3, (N-1));
 N_1 = N*10;
    y0 = zeros(2 * N_1, 1);
    dz = l/N_1;
    R =0.1;
    L = 2.5e-7*dz;
    C = 1e-10*dz;
    [t, y] = ode45(@(t, y) fline(t, y, N_1, L, C, R, Rs, RL, Vs), tspan, y0);
%plot t,y, in top of t1,y1 in one figure
%subplot(3, 3, (N-1));
  hold on;
  grid on;
  plot(t1,y1,'b');
  plot(t,y(:,N_1*2),'r');
  legend show;
  xlabel('Time (s)');
  ylabel('Output Voltage (V)');
  title(['Solution for N = ', num2str(N_1)]);
  hold off;
end
w12.m
Displaying w12.m.
for N=2:10
 subplot(3, 3, (N-1));
 N_1 = N*10;
    y0 = zeros(2 * N_1, 1);
    dz = l/N_1;
    R =0.1;
    L = 2.5e-7*dz;
    C = 1e-10*dz;
    [t, y] = ode45(@(t, y) fline(t, y, N_1, L, C, R, Rs, RL, Vs), tspan, y0);
%plot t,y, in top of t1,y1 in one figure
%subplot(3, 3, (N-1));
  hold on;
  grid on;
  plot(t1,y1,'b');
  plot(t,y(:,N_1*2),'r');
  legend show;
  xlabel('Time (s)');
  ylabel('Output Voltage (V)');
  title(['Solution for N = ', num2str(N_1)]);
  hold off;
end
w12.m
Displaying w12.m.
%}