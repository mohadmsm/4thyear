clear 
clc
l = 400;
R = 0.1;
L = 2.5e-7;  
C = 1e-10; 
G=0;
vs=30;
vo = @(s) vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
[y,t]=niltcv(vo,20e-6,'pt1');
plot(t,y)
xlabel('time s')
ylabel('Vo')
grid on
%%
%frequency response 
clear
clc
l = 400;
R = 0.1;
L = 2.5e-7;  
C = 1e-10; 
G=0;
vs=30;
f=0:10:2e5;
w=2*pi*f;
s=i*w;
vo = 30./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
plot(f,vo);
grid on 
%%
clear
clc
l = 400;
R = 0.1;
L = 2.5e-7;  
C = 1e-10; 
G=0;
vs=1;
%T = [1e-2, 0.5e-2, 0.2e-2, 0.1e-2, 2e-4];
f=2.5e5:10:4.8e5;
wo = 2*pi*f;
s=1i*wo;
vo1 = vs./(cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
%[y,t]=niltcv(vo,20e-6,'pt1');
%plot(f,vo)

Yr = real(vo1);  % Real part of Y11
Yi = imag(vo1); % Imaginary part of Y11
w = wo; 
A = [];
C = [];
% Loop through each frequency point to construct A and C
A = [];
C = [];
% Loop through each frequency point to construct A and C
for k = 1:length(w)
    wk = w(k);
    Yr_k = Yr(k);
    Yi_k = Yi(k); 
    % Construct rows for A and C
    A_row1 = [-1, Yr_k, 0, -wk*Yi_k, wk^2, -Yr_k*wk^2]; % Real part 
    A_row2 = [0, Yi_k, -wk, wk*Yr_k, 0, -Yi_k*wk^2]; % Imaginary part 
    
    % Append to A
    A = [A; A_row1; A_row2];    
    % C
    C_row1 = -wk^3 *Yi_k ; % Real part
    C_row2 = wk^3 * Yr_k; % Imaginary part   
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
a2 = B(5);
b2 = B(6);
% generated H
f=0:10:4.8e5;
w=2*pi*f;
s=i*w;
H = (a2*s.^2+a1*s+a0)./(s.^3+b2*s.^2+b1*s+b0) *30./s;
l = 400;
R = 0.1;
L = 2.5e-7;  
C = 1e-10; 
G=0;
vs=30;
vo = vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));

%[y,t]=niltcv(H,20e-6,'pt1');
%[y1,t1]=niltcv(vo,20e-6,'pt1');
%RMSE = sqrt(sum((y-y1).^2)/length(y));
plot(f,H,f,vo);
grid on
xlabel('time s')
ylabel('Vo')