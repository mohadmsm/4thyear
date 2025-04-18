clear
clc
% generate 100 points.
Ro = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           % sourcce Resistence (Ω)
G = 0;            
l = 150e-6;  
fm = 750e10;
f = linspace(1,fm,100);
w = 2*pi*f;
s = i *w; 
% exact solution and generating 100 points 
R = Ro+0.06*(1+i)*sqrt(w);
vo = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
% to be used in NILT
R = @(s) Ro+0.06*sqrt(s)*sqrt(2);
vs = @(s) sqrt(s*C.*(R(s)+s*L))./(sqrt(s*C.*(R(s)+s*L)).*cosh(l*sqrt(s*C.*(R(s)+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R(s)+s*L))));
v = @(s) vs(s)*1./s;
%v =@(s)1./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
first_idx = 1:7;
time = 10e-12;
models =1;% the number of desired model
r1 =inf;
r2 = inf;
nm = 0;
nm2 = 0;

for j=1:15
pol = 0;
res = 0;
[~,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,num,deno] = first_order_approximation(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
%[A,B,C,D] = create_state_space(num,deno);
%HAWE is Hs= @(s) resdue/s-pole + ...;1 is the inout, 50e-6 is t for plot
[~,HAWEi, y0,t1,poi,resi] = AWE2(A,B,C,D,w(1),1,time);
pol = [pol,poi'];
res = [res,resi'];
N =5; % number of points per section or model 
range = 7; % starting point of the second model
for i=1:models
    range = range(end)-2:N + range(end); % range of frequency and exact values
    H_diff = vo(range)-HAWEi(s(range));
    [~,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff ),w(range));    
    [A,B,C,D] = create_state_space(numi,denoi);
    [~,HAWEj, yi, ti,poi,resi] = AWE2(A,B,C,D,w(1),1,time);
    pol = [pol,poi'];
    res = [res,resi'];
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
    y0 = y0+yi;    
end

%hss = @(s)HAWEi(s).*1./s;
%[y1,t1]=niltcv(hss,time,1000);
[y1,t1]=niltcv(v,time,1000);
R1= sqrt(sum(abs(y0-y1).^2)/length(y1)); %unit step 
R2 = sqrt(sum(abs(HAWEi(s)-vo).^2)/length(vo));% impulse
if R1<r1
    r1 = R1;
    nm = models;
end
if R2<r2
    r2 = R2;
    nm2 = models;
end
models = models+1;
end
poles = pol(2:end);
residues = res(2:end);
%{
t = linspace(0,time,1000);
Tr = 1e-12;  % 1 ps rise/fall
Tp = 5e-12;  % 5 ps high
Amp = 1;     % 1 V amplitude
wo = 2*pi*100e9;
vs_sine = @(s) wo./(s.^2 + wo^2);% Laplace transform of sin(wt)

% Laplace transform of the trapezoid
vpulse = @(s) (Amp./(Tr*s.^2)).*(1 - exp(-Tr.*s))- (Amp./(Tr.*s.^2)).*(exp(-(Tr+Tp).*s) - exp(-(2*Tr+Tp).*s));
v_sine = @(s) vs(s).*vs_sine(s);
[y,t]=sine_response2(poles,residues,t);
[y2,t2] = niltcv(v_sine,time,1000);
R4 =RMSE(y,y2);
figure(1)
plot(t1,y,t2,y2)% step response
xlabel('time (s)')
grid on
legend('AWE approximation', 'Exact');
title("AWE approximation Vs the Exact simulation with Trapezoidal pulse input")
%}
%{
wo = 2*pi*100e9;
vs_sine = @(s) wo./(s.^2 + wo^2);% Laplace transform of sin(wt)
hss = @(s)HAWEi(s).*vs_sine(s);
[y1,t1]=niltcv(hss,time,1000);
%}
%
%{
figure(1)
plot(t1,y0,ti,y1)% step response
%plot(f,abs(HAWEi(s)),f,abs(vo)); % frequency response
grid on
%xlabel('Frequency (Hz)')
xlabel('time (s)')
legend('AWE approximation', 'Exact');
title('AWE approximation with 16 models');
%}
%%
clear;
clc
Ro = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 0;           
G = 0;            
l = 150e-6;        % Length of the transmission line 
f_max = 100e9;    % Maximum frequency (100 GHz)
wo = 2*pi*f_max;   
fm = 750e10;
f = linspace(1,fm,100);
w = 2*pi*f;
s = 1i*w; 
vs_sine = @(s) wo./(s.^2 + wo^2);% Laplace transform of sin(wt)
% Transfer function (exact solution)
R1 = @(s) Ro+0.06*sqrt(s)*sqrt(2);
vo = @(s) sqrt(s*C.*(R1(s)+s*L))./(sqrt(s*C.*(R1(s)+s*L)).*cosh(l*sqrt(s*C.*(R1(s)+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R1(s)+s*L))));
vo_sine = @(s) vs_sine(s).*vo(s);
time =10e-12;
[y_sine,t] = niltcv(vo_sine,time,1000);
% Plot the Results
plot(t, y_sine)
xlabel('time (s)');
ylabel('Vo');