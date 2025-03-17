clear
clc
% generate 100 points.
f = 1e6;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w; 
% exact solution and generating 100 points 
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
% to be used in NILT
v =@(s)1./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
first_idx = 1:6;
time = 50e-6;
models =17;
[~,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
R0 = num(end)/deno(end);
[A,B,C,D] = create_state_space(num,deno);
%HAWE is Hs= @(s) resdue/s-pole + ...;1 is the inout, 50e-6 is t for plot
[~,HAWEi, y0] = AWE2(A,B,C,D,w(1),1,time);
N =5; % number of points per section or model 
range = 6; % starting point of the second model
for i=1:models
    range = range(end):N + range(end); % raange of frequency and exact values
    H_diff = vo(range)-HAWEi(s(range));
    [~,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff ),w(range));    
    %numi=numi*R0;
    %numi(end)=numi(end)*R0;
    [A,B,C,D] = create_state_space(numi,denoi);
    R0 = numi(end)/denoi(end);
    [~,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(1)),1,time);
    HAWEi = @(s) HAWEi(s)+HAWEj(s);
    y0 = y0+yi;    
end
[y1,t1]=niltcv(v,time);
RMSE = sqrt(sum(abs(y0-y1).^2)/length(y1)); %unit step 
RMSE2 = sqrt(sum(abs(HAWEi(s)-vo).^2)/length(vo));% impulse
figure
plot(t1,y1,ti,y0)
%plot(f,abs(vo),f,abs(HAWEi(s)))
grid on
xlabel('time s')
legend('AWE approximation', 'Exact');
title('approximation with models = ',num2str(models+1));