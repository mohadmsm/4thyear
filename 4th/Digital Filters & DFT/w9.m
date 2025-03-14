clear
clc
f = 200:0.1:250;
w = 2*pi*f;
s = 1i*w;
H= 2*pi*50*s./(s.^2+2*pi*50*s+4*pi^2*250*200);
plot(f,abs(H))
xlabel('frequency (Hz)')
grid on
%or
f = 0:500;
fu = 250;
fl=200;
s = i*2*pi*f;
H = 2*pi*50*s./(s.^2+2*pi*50*s+4*pi^2*250*200);
plot(f,abs(H),200,1/sqrt(2),'*',250,1/sqrt(2),'*')
xlabel('frequency (Hz)')
grid on
%%
clear
clc
f = 0:500;
T = 1/5050;
z = exp(i*2*pi*f*T);
s = 2/T*(z-1)./(z+1);
fu = 1/(pi*T)*tan(pi*250/5000);
fl = 1/(pi*T)*tan(pi*200/5000);
H = 2*pi*(fu-fl).*s./(s.^2+2*pi*(fu-fl).*s+4*pi^2*fu*fl);
s = 2*pi*f*i;
Hs= 2*pi*(fu-fl).*s./(s.^2+2*pi*(fu-fl)*s+4*pi^2*fu*fl);
%Ha = (z.^2*(2*pi*50*2*T)-2*pi*50*2*T)./(z.^2*(4+2*pi*50*2*T+4*pi^2*250*200*T^2)+z*(-2+T^2*8*pi^2*250*200)+4*pi^2*250*200*T^2*(z+1).^2);
%co1 = 2*a*T./(4+2*b*T+c*T^2);
plot(f,abs(Hs),f,abs(H))
%%
clear
clc
%sample question from quiz 
T = 2*pi/40;
w = 4;
c1 = (4+w^2*T^2)/(4+2*T+w^2*T^2);
c2 = (2*w^2*T^2-8)/(4+2*T+w^2*T^2);
c3 = c1;
c4 = c2;
c5 = (4-2*T+w^2*T^2)/(4+2*T+w^2*T^2);
z = exp(1i*pi/5);
Hz = (z^2*c1+c2*z+c3)./(z.^2+c4*z+c5);
abs(Hz)
fd = 4/(2*pi);
T = 1/10;
fu = 1/(pi*T)*tan(pi*fd*T);
%%
clear
clc
% Sampling frequency 
fc = 18e3;
fs = 48e3;
N=41;
n= -(N-1)/2:(N-1)/2;
w_h = 0.54+0.46*cos(2*pi*n./(N-1));
w_B = 0.42+0.5*cos(2*pi*n/(N-1));
h = 0.75*sinc(0.75*n);
hf = h.*w_h;
ndel = 0:N-1;
figure(1)
stem(ndel,hf)
xlabel('n')
%freq response
f = 0:100:48e3;
T = 1/fs;
z= exp(1i*2*pi*f*T);
n=0:N-1;
for ii =1:length(f)
    Hz(ii) = sum(hf.*z(ii).^(-n));
end
figure(2)
plot(f,abs(Hz))
xlabel('frequency (Hz)')
t = 0:0.0001:0.00001/T;
w1 = 20;
w2 = 50;
x1 = sin(w1*t);
x2 = sin(w2*t);
z1 = exp(1i*w1*T);
z2 = exp(1i*w2*T);
H1 = sum(hf.*z1.^(-n));
H2 = sum(hf.*z2.^(-n));
y1 = abs(H1)*sin(w1*t+angle(H1));
y2 = abs(H2)*sin(w2*t+angle(H2));
figure(3)
plot(t,x1,t,y1);
figure(4)
plot(t,x2,t,y2);