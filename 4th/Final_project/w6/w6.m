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
f=0:100:7e5;
w=2*pi*f;
s=i*w;
vo = 30./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
plot(f,vo);
grid on 
%%
clear
clc
%T = [1e-2, 0.5e-2, 0.2e-2, 0.1e-2, 2e-4];
f=10:10:1e5;
wo = 2*pi*f;
s=1i*wo;
vo1 = 1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
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
num = [a2,a1,a0];
deno = [1,b2,b1,b0];
[A,B,C,D] = create_state_space(num,deno);
[h_impulse, y_step, t] = AWE(A,B,C,D,0,2e-6);
f=0:10:1e6;
w=2*pi*f;
s=i*w;
H =(a2*s.^2+a1*s+a0)./(s.^3+b2*s.^2+b1*s+b0);
%H =@(s) (H1(s)+H2(s)+H3(s));
vo = 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
%[y,t]=niltcv(H,80e-6,'pt1');
%[y1,t1]=niltcv(vo,80e-6,'pt1');
%RMSE = sqrt(sum((y-y1).^2)/length(y));
plot(f,H,f,vo);
%plot(t,y,t1,y1)
%grid on
%xlabel('f')
%ylabel('Vo')
%legend('approximation','exact')
%}

%%
clear 
clc
%2.5 - 4.8
p2 = [0, (-1.9702e+05 + 2.3815e+06i), (-1.9702e+05 - 2.3815e+06i)];
z =[0, 1.6951e+07];
%0  - 1.5e5
p1 =[ 0,-1.6179e+05 + 7.5657e+05i, -1.6179e+05 - 7.5657e+05i];
z1 =[0, 3.5813e+06];
%H = zpk(z,p2,1);
f=0:10:1e6;
w=2*pi*f;
s=i*w;
vo = 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
f=0:10:1e6;
w=2*pi*f;
s=i*w;
fo = 0:10:1e5;
wo = 2*pi*fo;
so = i*wo;
s_trimmed = s(1:length(so));
s2 = s_trimmed - so;
s2 = [s2,s(length(so)+1:end)];
H2 =@(s)(1.506e05.* s2.^2 - 2.552e12.* s2)./( (s2.^3 + 3.94e05.*s2.^2 + s2.*5.71e12))*30./s2;
H1 =@(s)(-1.713e05.*s.^2 + 6.135e11.*s)./(s.^3 + 3.236e05.*s.^2 + 5.986e11.*s)*30./s;
%H = @(s) (H1(s)+H2(s))*30./s;
H =@(s) (H1(s)+H2(s));
%H(f > 1e5) = H2(f > 1e5);
%[y,t]=niltcv(H,50e-6,'pt1');
%[y1,t1]=niltcv(vo,50e-6,'pt1');
%plot(t,y,t1,y1)
plot(f,H,f,vo)
grid on
xlabel('f')
ylabel('Vo')
legend('approximation','exact')
