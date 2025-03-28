clear
clc
% generate 100 points.
R = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           % sourcce Resistence (Ω)
G = 0;            
l = 150e-6;  
f = 700e10;
f = linspace(1,f,100);
w = 2*pi*f;
s = i *w; 
% exact solution and generating 100 points 
vo = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
%vo = 1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
% to be used in NILT
v = @(s) sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
v = @(s) v(s)*1./s;
%v =@(s)1./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
first_idx = 1:5;
time = 10e-12;
models =1;% the number of desired model
r1 =inf;
r2 = inf;
nm = 0;
nm2 = 0;
for j=1:23
[~,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);

%[~,num,deno] = first_order_approximation(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
%[A,B,C,D] = create_state_space(num,deno);

%HAWE is Hs= @(s) resdue/s-pole + ...;1 is the inout, 50e-6 is t for plot
[~,HAWEi, y0,t1] = AWE2(A,B,C,D,w(1),1,time);
N =4; % number of points per section or model 
range = 5; % starting point of the second model
for i=1:models
    range = range(end):N + range(end); % range of frequency and exact values
    H_diff = vo(range)-HAWEi(s(range));
    [~,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff ),w(range));    
    [A,B,C,D] = create_state_space(numi,denoi);
    [~,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(1)),1,time);
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
    y0 = y0+yi;    
end
hss = @(s)HAWEi(s)*1./s;
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
%{
figure(1)
%plot(t1,y0,ti,y1)% step response
plot(f,abs(HAWEi(s)),f,abs(vo)); % frequency response
grid on
%xlabel('Frequency (Hz)')
xlabel('time (s)')
legend('AWE approximation', 'Exact');
title('approximation with models = ',num2str(models+1));
%}