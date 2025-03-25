clear;
clc;
step_data = load('step');
vo = step_data(:,2);
time = step_data(:,1);
line_data = load("data_line");
f = line_data(:,1);
v = line_data(:, 2) + 1i*line_data(:, 3);
%{
plot(time,vo);
xlabel('time (s)')
grid on
title('step response')
%}
plot(f,abs(v));
xlabel("Frequency (Hz)")
ylabel("|Vo|")
grid on
title('Frequency response')
%%
clear;clc;
step_data = load('step');
vo = step_data(:,2);
time = step_data(:,1);
line_data = load("data_line");
f = line_data(:,1);
w = 2*pi*f;
s = i*w;
v = line_data(:, 2) + 1i*line_data(:, 3);
first_idx = 1:20;
models =48;% the number of desired model
[~,num,deno] = generate_yp2(real(v(first_idx)),imag(v(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
%HAWE is Hs= @(s) resdue/s-pole + ...;1 is the inout, 50e-6 is t for plot
[~,HAWEi, y0,t1] = AWE2(A,B,C,D,w(1),1,time(end));
N =20; % number of points per section or model 
range = 21; % starting point of the second model
for i=1:models
    range = range(end):N + range(end); % range of frequency and exact values
    H_diff = v(range)-HAWEi(s(range));
    [~,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff ),w(range));    
    [A,B,C,D] = create_state_space(numi,denoi);
    [~,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(1)),1,time(end));
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
    y0 = y0+yi;    
end
plot(f,abs(HAWEi(s)),f,abs(v))
HS = @(s) HAWEi(s) *1./s;
[y,t]=niltcv(HS,time(end),1000);
plot(time,vo,ti,y0)