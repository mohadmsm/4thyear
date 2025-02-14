clear 
clc
l = 400;
R = 0.01;
L = 2.5e-7;  
C = 1e-10; 
G=0;
f=0:10:5000;
w = 2*pi*f;
s=1i*w;
Z = (R+s.*L);
Y = G+s.*C;
Zo = sqrt(Z./Y);
gama = sqrt(Z.*Y);
Y11= cosh(gama.* l)./(Zo.*sinh(gama.*l));
%Y11
plot(f,Y11)
%%
clear all
clc
% Given the last 3 points
Yr = [0.9253, -1.0521, -1.2332];  % Real part of Y11
Yi = [-0.0044, -0.2690, -1.6812]; % Imaginary part of Y11
w = [3.1416e+6, 1.2566e+6,0.8976e+6]; 
Yr = flip(Yr);
Yi = flip(Yi);
w = flip(w);
A = [];
C = [];
% Loop through each frequency point to construct A and C
for k = 1:length(w)
    wk = w(k);
    Yr_k = Yr(k);
    Yi_k = Yi(k); 
    % Construct rows for A and C
    A_row1 = [-1, Yr_k, 0, -wk*Yi_k]; % Real part 
    A_row2 = [0, Yi_k, -wk, wk*Yr_k]; % Imaginary part 
    
    % Append to A
    A = [A; A_row1; A_row2];    
    % C
    C_row1 = wk^2 * Yr_k; % Real part
    C_row2 = wk^2 * Yi_k; % Imaginary part   
    % Append to C
    C = [C; C_row1; C_row2];
end

% Solve for B = [a0; b0; a1; b1]
B = A \ C;
% get cof
a0 = B(1);
b0 = B(2);
a1 = B(3);
b1 = B(4);
f = 0:100:10000;
w = 2*pi*f;
%s = i*w;
% generated H
H = @(s)(a1*s+a0)./(s.^2+b1*s+b0) * 30./s;
l = 400;
R = 0.1;
L = 2.5e-7;  
C = 1e-10; 
G=0;
vs=30;
vo =@(s) vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
[y,t]=niltcv(H,20e-6,'pt1');
[y1,t1]=niltcv(vo,20e-6,'pt1');
plot(t,y,t1,y1);
%{
l = 400;
R = 0.01;
L = 2.5e-7;  
C = 1e-10; 
G=0;
Z = (R+s.*L);
Y = G+s.*C;
Zo = sqrt(Z./Y);
gama = sqrt(Z.*Y);
Y11= cosh(gama.* l)./(Zo.*sinh(gama.*l));
% find the error
n =length(H)-1;
Error = abs(H-Y11);
Error = Error(2:end);
Error = sum(Error)/n;
% plot both in the same figure 
figure(1)
plot(f,H,f,Y11,'r *');
legend('generated Y' ,'Exact Y',sprintf('Error = %.4f', Error))
grid on
%}
%%

