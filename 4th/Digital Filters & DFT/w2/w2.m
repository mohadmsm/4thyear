clear;
clc

t = 0:0.0001:0.05;

xa = cos(480*pi*t)+3*cos(720*pi*t);
figure(1);
plot(t,xa);
xlabel('time s');
title('Analog signal');
fs = 1000;
ts = 1/fs;
n=0:30;
xn = cos(480*pi*n*ts)+3*cos(720*pi*n*ts);
figure(2);
stem(n,xn);
xlabel('n');
title('output when fs=600Hz');

Nt = length(t);
ya = zeros(1,Nt);
for ii=1:Nt
    ya(ii)= ya(ii)+ sum(xn.*sinc((t(ii)-n.*ts)/ts));
end
figure(3)
plot(n*ts,xn,'*',t,ya,'b');
xlabel('time')
legend('samples','reconstructed')
%%
clear
clc
fs = 1000;
w = 2*pi*fs;
Ts = 1/fs;
t = 0:0.0001:0.05;
xa = cos(480*pi*t)+3*cos(720*pi*t);

N=30;
n=0:N-1;
xn = cos(480*pi*n*Ts)+3*cos(720*pi*n*Ts);
Nt = length(t);
ya = zeros(1,Nt);
for ii=1:Nt
    for nn=1:N
        if abs(t(ii)-n(nn)*Ts)<Ts
            ya(ii)= ya(ii)+xn(nn).*(1-abs(t(ii)-n(nn)*Ts)/Ts);
        else
            ya(ii)= ya(ii);
        end
    end
end
plot(n*Ts,xn,'*',t,ya,'b');
xlabel('time')
legend('samples','linear interplation')
% freaquncy response 
yaf = zeros(1,Nt);
for ii=1:Nt
    yaf(ii)= yaf(ii)+ (2-2*cos(w*Ts))/(w^2*Ts);
end
plot(yaf);
%%
clear all
clc
t= 0:0.001:0.2;
Ts = 0.01;
N=20;
Nt=length(t);
n=0:N-1;
yn =0.5.^n+0.1375*(0.5).^n+0.3625*cos(2.*n)+0.1364*sin(2.*n);
ya=zeros(1,Nt);
for i=1:Nt
    ya(i)=ya(i)+ sum(yn.*sinc((t(i)-n.*Ts)/Ts));
end
plot(n.*Ts,yn,'*',t,ya,'r')