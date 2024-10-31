clear all;
clc;

% Transmission line parameters
N = 10;          % Number of sections
l = 400;         % Total line length
dz = l / N;      % Section length
L = 2.5e-7 * dz; % Inductance per section
C = 1e-10 * dz;  % Capacitance per section
R = 0 * dz;      % Resistance per section
Rs = 0;          % Source resistance
Rl = 100;        % Load resistance
Vs = 30;         % Source voltage (constant here, could be time-varying)
t = 0:1e-9:20e-6;
Gt = @(s) s.*C./(R*C.*s+L.*s.^2*C+1) * Vs./s;
M = 13;
[poles, residues] = R_Approximation(M);
result = - (1 ./ t) .*sum(real(Gt(poles./t).*residues));
plot(t,result)
