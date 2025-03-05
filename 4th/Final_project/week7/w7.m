clear
clc
f = 1e6;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[H,num,deno] = generate_yp2(real(vo(1:30)),imag(vo(1:30)),w(1:30));
[A,B,C,D] = create_state_space(num,deno);
[poles1, moments1] = AWE_poles(A,B,C,D,w(1));
H_diff = vo(30:45)-H(s(30:45));
[H2,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(30:45));
[A,B,C,D] = create_state_space(num,deno);
[poles2, moments2] = AWE_poles(A,B,C,D,w(30));
%-------------------------------------------------
poles = [poles1(1),poles2(1)];
moments = moments1;
approx_order = length(B);
V = zeros(approx_order);
for i = 1:length(poles)
    for j = 1:length(poles)
            V(i, j) = 1 / (poles(j))^(i-1);
     end
end
A_diag = diag(1 ./ (poles));%i tried with adding s0 here
r_moments = moments(1:approx_order);
residues = -1 * (A_diag \ (V \ r_moments'));
h_s =@(s) 0;
s0= i*w(20);
for i = 1:length(poles)
    h_s =@(s) h_s(s) + residues(i)./((s)-poles(i));
end
hs2 = @(s) (h_s(s)+H2(s))*30./s;
h12 = @(s) (H(s)+H2(s))*30./s;
hss =@(s) h_s(s) * 30./s;
vo1 =@(s) 30./(s.*cosh(400.*(1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(hs2,50e-6,'ppp');
[y1,t]=niltcv(h12,50e-6,'ppp');
[y2,t1]=niltcv(vo1,50e-6,'ppp');
plot(t,y,t,y1,t,y2);
plot(f,h_s(s),f,vo,f,H(s),f,H2(s))
plot(f,h_s(s)*30./s,f,vo*30./s,f,H(s)*30./s,f,H2(s)*30./s)
xlabel('f')
grid on 

%%
clear 
clc
R = 1200;
L = 250e-9;
C = 1e-10;
Rs = 10;
G = 0;
l = 150e-6;
f = 100e10;
f = linspace(0,f,100);
w = 2*pi*f;
s = i*w;
vs = @(s) 1./s; 
vs_sine = @(s) w./(s.^2 + w^2);  % Laplace transform of sin(wt)
% exact sol
vo = @(s) 1./(cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
vo_step = @(s) vo(s).*vs(s);
vo_sine = @(s) vo(s).*vs_sine(s);
[y_step,t] = niltcv(vo_step,1e-11,'pp');
%[y_sin,t] = niltcv(vo_sine,1e-11,'pp');
%plot(t,y_sin);
plot(t,y_step);
xlabel('f');
ylabel('Vo');
grid on
%%
clear
clc
R = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           
G = 0;            
l = 150e-6;        % Length of the transmission line 
f_max = 100e10;    % Maximum frequency (100 GHz)
%f = linspace(0, f_max, 100); 
w = 2*pi*f_max;        
s = 1i*w; 
vs_sine = @(s) w./(s.^2 + w^2);% Laplace transform of sin(wt)
% Transfer function (exact solution)
vo = @(s) 1 ./ (cosh(l .* sqrt((R + L.*s) .* (G + C.*s))));
vo_step = @(s) 10./s.* vo(s);
vo_sine = @(s) vs_sine(s).*vo(s);
time =10e-12;
%[y_step,t] = niltcv(vo_step,time,'pp');
[y_sine,t] = niltcv(vo_sine,time,'pp');
% Plot the frequency response
%plot(f / 1e9, 20*log10(abs(vo(s)))); %20*log10 for scaling  
plot(t, y_sine)
xlabel('time (s)');
ylabel('Vo');
grid on;
%%
clear
clc
f = 1e6;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w;
% obtain 100 points from the exact soluation
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
vos =@(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
% use the first 15 points (low frequency)
[H1,num,deno] = generate_yp2(real(vo(1:20)),imag(vo(1:20)),w(1:20));
[A,B,C,D] = create_state_space(num,deno);
[h_impulse, h_s1]=AWE2(A,B,C,D,w(1),30,20e-6);
idx = 25:45;
H_diff = vo(idx) - H1(s(idx));
[H2,num,deno] = generate_yp(real(H_diff),imag(H_diff),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[h_impulse, h_s2]=AWE2(A,B,C,D,w(30),30,20e-6);
h_s = @(s)(h_s1(s)+h_s2(s));
H = @(s) (H1(s)+H2(s));
h_ss = @(s)(h_s1(s)+h_s2(s)).*30./s;
Hs = @(s) (H1(s)+H2(s))*30./s;
%plot(f,h_s(s),f,vo,f,H(s));
idx = 2:idx(end);
RMSE1 = abs(sqrt(sum((h_s(s(idx))-vo(idx)).^2)/length(vo(idx))));
RMSE2 = abs(sqrt(sum((H(s(idx))-vo(idx)).^2)/length(vo(idx))));
[y,t]=niltcv(h_s,50e-6,'ppp');
[y1,t]=niltcv(H1,50e-6,'ppp');
[y2,t1]=niltcv(vos,50e-6,'ppp');
%{
min = 99;
j = 1;
for i =1 : 40
[poles2, moments2,h_s] = AWE_poles(A,B,C,D,w(25));
plot(f,h_s(s).*30./s,f,vo.*30./s);
%plot(f,H2(s).*30./s,f,vo.*30./s)
RMSE1 = abs(sqrt(sum((h_s(s(idx))-vo(idx)).^2)/length(vo(idx))));
RMSE2 = abs(sqrt(sum((H2(s(idx))-vo(idx)).^2)/length(vo(idx))));
if RMSE1<RMSE2
    j = i;
    min = RMSE1;
end
grid on
end
%}
%%
clear
clc
% generate 100 points.
f = 1e6;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
v =@(s)30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
%H is as H = @(s) a1s+a0/s^2+b1s+b0;
first_idx = 1:15;
%HAWE is Hs= @(s) resdue/s-pole + ...;30 is the inout, 50e-6 is t for plot
%[h_impulse,HAWEi, y0, t] = AWE2(A,B,C,D,w(1),30,20e-6);
models =1;
minr = 99;
minr1 = 99;
minr2 = 99;
for j=1:20
[Hi,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
[h_impulse,HAWEi, y0, t] = AWE2(A,B,C,D,w(1),30,50e-6);
N =4; % number of points per section or model 
range = 15; % starting point of the second mmodel
for i=1:models 
    range = range(end):N + range(end); % raange of frequency and exact values
   % range
    H_diff = vo(range)-HAWEi(s(range));
    H_diff2 = vo(range)-Hi(s(range));
    [~,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff ),w(range));
    [Hj,~,~] = generate_yp(real(H_diff2),imag(H_diff2 ),w(range));
    [A,B,C,D] = create_state_space(numi,denoi);
    [h_impulse,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(1)),30,50e-6);
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
    Hi = @(s) Hi(s)+Hj(s);
    y0 = y0+yi;    
end
HS = @(s) HAWEi(s).*30./s;
[y1,t1]=niltcv(v,50e-6,'pt1');
%[y0,t1]=niltcv(HS,50e-6,'pt1');
RMSE = sqrt(sum(abs(y0-y1).^2)/length(y1));
RMSE2 = sqrt(sum(abs(HAWEi(s)-vo).^2)/length(vo));
RMSE3 = sqrt(sum(abs(Hi(s)-vo).^2)/length(vo));
%figure
%plot(t1,y0,t1,y1)
%abs(RMSE)
if (abs(RMSE) < minr)
minr = abs(RMSE);
nModel = models + 1;
end
if (RMSE2 < minr1)
minr1 = RMSE2;
nModel1 = models + 1;
end
if (RMSE3 < minr2)
minr2 = RMSE3;
nModel2 = models + 1;
end
%grid on
%xlabel('time s')
%legend('AWE Step', 'Exact');
%title('approximation with models = ',num2str(models+1));
models = models+1;
end
%%
clear; clc;
% Generate frequency points
f = linspace(0, 9e5, 100);
w = 2*pi*f;
s = 1i * w;
M = 6;
first_idx = 1:15;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[Hi,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H,y1,~,p1]=AWE_CFH(A,B,C,D,M,w(1),30,20e-6);
RMSE = sqrt(sum(abs(Hi(s(first_idx))-vo(first_idx)).^2)/length(vo(first_idx)));
%second model ----------------------------------------------------------
idx = 16:25;
H_diff = vo(idx)-H(s(idx));
[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[poles,m] = AWE_poles(A,B,C,D,w(idx(1)));
[~,H2,y2,~,p2]=AWE_CFH(A,B,C,D,M,w(16),30,20e-6);
% Third model ---------------------------------------------
idx = 26:35;
H = @(s) H(s)+H2(s);
H_diff = vo(idx)-H(s(idx));
[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H3,y3,~,p3]=AWE_CFH(A,B,C,D,M,w(idx(1)),30,20e-6);
% Forth model ---------------------------------------------------
idx = 36:45;
H = @(s) H(s)+H3(s);
H_diff = vo(idx)-H(s(idx));
[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H4,y4,t,p4]=AWE_CFH(A,B,C,D,M,w(idx(1)),30,20e-6);
y_t = y1+y2+y3+y4;
plot(t,y_t);
