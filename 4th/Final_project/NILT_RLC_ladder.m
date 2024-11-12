clear all 
clc
N = 2; % Number of sections in the transmission line
l = 40 ; % line length 
dz = l/N ; % section length
L = 2.5e-7 * dz;   % Inductance
C = 1e-10 * dz;    % Capacitance
R = 0 * dz;       % Resistance per section *dz
Rs = 0;       % Source resistance
Rl = 100;     % Load resistance
Vs  = 30;      % Source voltage (could be a function of time)
y = zeros(2 * N, 1);
tspan = [0 20e-6];   
h =tspan(2)/1000;
In = y(1:2:2*N);  
Vn = y(2:2:2*N); 
% I
B = @(s) (Vs - Vn(1))/L .* 1./s;
C = 1;
G = R/L;
Xo =0;
X_func = @(s) (B(s) + C*Xo)./(G+C.*s);
M = 10;
[poles, residues] = R_Approximation(M);
result(1) = - (1 / (h)) .*sum(real(X_func(poles/(h)).*residues));
X_prev = result(1);
for i=1:1000
    if i>1
    X_prev =result(i-1); %use the previous to approximate the next one
    end
    X_hat = @(s) (B(s) + C*X_prev)./(G+C.*s); %X_hat as per p.g123
    result(i) =  - (1 ./ (h)) .*sum(real(X_hat(poles./(h)).*residues));
end
