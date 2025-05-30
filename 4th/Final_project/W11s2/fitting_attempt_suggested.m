clear
clc
% generate 100 points.
R = 0;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           % sourcce Resistence (Ω)
G = 0;            
l = 150e-6;  
f = 750e10;
f = linspace(1,f,100);
w = 2*pi*f;
s = i *w; 
% exact solution and generating 100 points
vo1 = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
vo1s = @(s)sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
R = 1200+0.06*(1+j)*sqrt(w);
vo2 = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
vo = vo2-vo1;
% to be used in NILT
R = @(s) 1200+0.06*sqrt(s);
v = @(s) sqrt(s*C.*(R(s)+s*L))./(sqrt(s*C.*(R(s)+s*L)).*cosh(l*sqrt(s*C.*(R(s)+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R(s)+s*L))));
v = @(s) v(s)*1./s;
first_idx = 1:5;
time = 10e-12;
models =17;% the number of desired model
[~,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
%HAWE is Hs= @(s) resdue/s-pole + ...;1 is the input
[~,HAWEi, y0] = AWE2(A,B,C,D,w(1),1,time);
N =4; % number of points per section or model 
range = 5; % starting point of the second model
for i=1:models
    range = range(end):N + range(end); % range of frequency and exact values
    H_diff =vo(range)-HAWEi(s(range));
    [~,numi,denoi] =generate_yp2(real(H_diff),imag(H_diff ),w(range));    
    [A,B,C,D] = create_state_space(numi,denoi);
    [~,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(1)),1,time);
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
    %HAWEi = @(s) HAWEi(s)+HAWEj(s)+vo1(range);% add the lossles case 
    y0 = y0+yi;    
end
%attempt with nilt
%{
hss = @(s)(HAWEi(s) + vo1s(s))*1./s;
[y2,t2]=niltcv(hss,time,1000);
%}
[y1,t1]=niltcv(v,time,1000);
R1= sqrt(sum(abs(y0-y1).^2)/length(y1)); %unit step obtain error
%R2 = sqrt(sum(abs(HAWEi(s)-vo).^2)/length(vo));% impulse
%{
% plot
figure(1)
plot(t1,y0,ti,y1)% step response
%plot(f,abs(HAWEi(s)),f,abs(vo)); % frequency response
grid on
%xlabel('Frequency (Hz)')
xlabel('time (s)')
legend('AWE approximation', 'Exact');
title('approximation with models = ',num2str(models));
%}