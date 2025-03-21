function [y,t]=RLC(R,L,C,length,Rs,t_max,N)
%N = 50; % Number of sections in the transmission line
dz=length/N;
L = L*dz;   % Inductance
C = C*dz;    % Capacitance
R =R*dz;       % Resistance per section
Vs  = 1;     % Source voltage step input
Vs_sine = @(t) sin(2*pi*100e9*t);% input sin with 0.1THz 
y0 = zeros(2 * N, 1);
tspan = 0:1e-14:t_max;  
% Solve using ode23
[t, y_step] = ode23(@(t, y) fline_noR(t, y, N, L, C, R, Rs, Vs), tspan, y0);
y =  y_step(:,N*2);
end