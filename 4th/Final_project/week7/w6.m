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
f=0:10:1e5;
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
%[h_impulse, y_step, t] = AWE(A,B,C,D,0,2e-6);
f=2.5e5:10:4.8e5;
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
%%
clear 
clc
f=0:10:2e5;
wo = 2*pi*f;
s=1i*wo;
vo1 = 1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[H1]=generate_yp(real(vo1),imag(vo1),wo);
%H2
f2 = 2e5:10:4.5e5;
w1 = 2*pi*f2;
s=1i*w1;
vo2 = 1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
H1_w1 = feval(H1,s);
vo_H1 = vo2- H1_w1;
[H2]=generate_yp(real(vo_H1),imag(vo_H1),w1);
%H3
H12 =@(s) H1(s)+H2(s);
f3 = 4.5e5:10:6.5e5;
w2 = 2*pi*f3;
s=1i*w2;
vo3_s = 1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
H12_w2 = feval(H12,s);
vo_H2 = vo3_s- H12_w2;
[H3]=generate_yp(real(vo_H2),imag(vo_H2),w2);
%final
H = @(s)(H1(s) + H2(s) +H3(s))*30./s;
vo3 =@(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(H,50e-6,'pt1');
[y1,t1]=niltcv(vo3,50e-6,'pt1');
plot(t,y,t1,y1)
%plot(f3,H,f3,vo3)
%%
clear 
clc
H = get_H(1e6,50);
vo =@(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(H,50e-6,'pt1');
[y1,t1]=niltcv(vo,50e-6,'pt1');
plot(t,y,t1,y1)
RMSE = sqrt(sum((y-y1).^2)/length(y1));
abs(RMSE)
%%
clear
clc
f = 9e5;
f = linspace(0,f,100+1);
w = 2*pi*f(2:end);
s = i *w;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
N=2; % number of section basicly 100/N
H_total = @(s)0;
section_size = ceil(length(vo)/N);  % Points per section (except last)
for i = 1:N
    start_idx = (i-1)*section_size + 1;
    end_idx = min(i*section_size, length(w));
    seg_idx = start_idx:end_idx;
    w_i = w(seg_idx);
    s_i = 1i * w_i;
    vo_i = vo(seg_idx);
    H_prev_eval = H_total(s_i);
    
    % Calculate residual response
    vo_residual = vo_i - H_prev_eval;
    
    % Fit new model to residual
    Hi = generate_yp2(real(vo_residual), imag(vo_residual), w_i);
    
    % Add to total transfer function
    H_total = @(s) H_total(s) + Hi(s);
end
H = @(s) H_total(s) * 30 ./ s;
v =@(s)30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(H,50e-6,'pt1');
[y1,t1]=niltcv(v,50e-6,'pt1');
RMSE = sqrt(sum((y-y1).^2)/length(y1));
plot(t,y,t1,y1)
grid on
xlabel('time s')
ylabel('Vo')
legend('approximated','exact');
title('approximation at N = ',num2str(N));
abs(RMSE)
%%
clear
clc
% generate 100 points.
f = 9e5;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
v =@(s)30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
%H is as H = @(s) a1s+a0/s^2+b1s+b0;
[H,num,deno] = generate_yp2(real(vo(1:25)),imag(vo(1:25)),w(1:25));
[A,B,C,D] = create_state_space(num,deno);
%HAWE is Hs= @(s) resdue/s-pole + ...;30 is the inout, 50e-6 is t for plot
[h_impulse,HAWE, y, t] = AWE2(A,B,C,D,w(1),30,50e-6);
[y1,t1]=niltcv(v,50e-6,'pt1');
RMSE = sqrt(sum((y-y1).^2)/length(y1));
plot(t,y,t1,y1);
grid on
xlabel('time s')
ylabel('Vo')
legend('approximated','exact');
abs(RMSE)
%%
clear
clc
% generate 100 points.
f = 9e5;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
v =@(s)30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
%H is as H = @(s) a1s+a0/s^2+b1s+b0;
[Hi,num,deno] = generate_yp2(real(vo(1:15)),imag(vo(1:15)),w(1:15));
[A,B,C,D] = create_state_space(num,deno);
%HAWE is Hs= @(s) resdue/s-pole + ...;30 is the inout, 50e-6 is t for plot
[h_impulse,HAWEi, y, t] = AWE2(A,B,C,D,w(1),30,50e-6);
models =5;
%N = ceil(70/models); %8
minr = 99;
N =3; % number of points per section or model 
range = 16; % starting point of the second mmodel
for i=1:models 
    range = range(end):N + range(end); % raange of frequency and exact values
   % range
    H_diff = vo(range)-HAWEi(s(range));
    [Hj,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff ),w(range));
    [A,B,C,D] = create_state_space(numi,denoi);
    [h_impulse,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(end)),30,50e-6);
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
   % Hi = @(s) Hi(s)+Hj(s);    
end
HS = @(s) HAWEi(s).*30./s;
[y1,t1]=niltcv(v,50e-6,'pt1');
[y0,t1]=niltcv(HS,50e-6,'pt1');
RMSE = sqrt(sum((y0-y1).^2)/length(y1));
figure
plot(t1,y0,t1,y1)
abs(RMSE)
if (abs(RMSE) < minr)
minr = abs(RMSE);
nModel = models + 1;
end
grid on
xlabel('time s')
legend('AWE Step', 'Exact');
title('approximation with models = ',num2str(models+1));
models = models+1;
%{
r = 15:23; %8 points 
s0 = i*w(r);
H_diff = vo(r) - HAWE(s0);
[H1,num1,deno1] = generate_yp2(real(H_diff),imag(H_diff ),w(r));
[A,B,C,D] = create_state_space(num1,deno1);
[h_impulse1,HAWE1, y0, t1] = AWE(A,B,C,D,w(r(1)),30,50e-6);
%
r = 24:32;
s0 = i*w(r);
H_diff = vo(r) - HAWE1(s0);
[H1,num1,deno1] = generate_yp2(real(H_diff),imag(H_diff ),w(r));
[A,B,C,D] = create_state_space(num1,deno1);
[h_impulse,HAWE2, y1, t1] = AWE(A,B,C,D,w(r(1)),30,50e-6);
Hs_total =@(s) HAWE(s)+ HAWE1(s)+ HAWE2(s);
Hs_total= @(s) Hs_total(s)*30./s;
plot(f,Hs_total(s),f,vo*30./s)
plot(t1,y1+y0+y)
%}
%%
clear
clc
% State-space matrices
A = [-1]; B = [1]; C = [1]; D = 0;
w = 2; input = 1; time = 5;

% Run AWE
[h_impulse, h_s, y_step, t] = AWE2(A, B, C, D, w, input, time);

% Exact solutions
h_exact = exp(-t);
y_exact = 1 - exp(-t);

% Plot comparisons
figure;
subplot(2,1,1);
plot(t, real(h_impulse), 'r', t, h_exact, 'b--'); % Use real() to discard numerical noise
legend('AWE Impulse', 'Exact');
title('Impulse Response (w = 0.5)');

subplot(2,1,2);
plot(t, real(y_step), 'r', t, y_exact, 'b--');    % Use real() for consistency
legend('AWE Step', 'Exact');
title('Step Response (w = 0.5)');