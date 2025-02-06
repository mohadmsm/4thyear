clear all
clc
f=0:0.01:2;
T=1;
w = 2*pi*f;
s = 1./(1.25-cos(w*T));
plot(f,s)
%title()

%%
clear 
clc

x=[1 0 -2 1.5];
T=1;
f =0:0.01:1/T;
z=exp(i*2*pi*f*T);
Xz= x(1)+x(2)*z.^-1+x(3)*z.^-2+x(4)*z.^-3;
Xdft=fft(x);
f_dft=[0 1/(4*T) 2/(4*T) 4/(4*T)];
plot(f,abs(Xz),f_dft,abs(Xdft),'*');
xlabel('frequency')
legend('DTFT','DFT')

% the energy
E = sum(abs(x).^2);
Ep = 1/4*sum(abs(Xdft).^2); %parseval's theorem
%%
%filters Backward difference
clear 
clc
x = 0:-0.1:-100;
T = 0.001;
y=-1000:1000;
for ii=1:length(x)
    for j = 1:length(y)
        z(ii,j)=1./(1-x(ii)-i*y(j)*T);
    end
end
plot(real(z),imag(z))
%%
clear
clc
T = 0.005;
wc_analog=4;
f = 0:0.01:1/T;
w = 2*pi*f;
s= i*w;
H = 4./(s+4);
z = exp(i*w*T);
cof1=(wc_analog*T)/(1+wc_analog*T);
y = +4*T/(1+4*T)*z./(z-(1/(1+4*T)));
%cutoff freq
Hdiff = abs(H)-1/sqrt(2);
[aa,ff] = min(abs(Hdiff));
fc=f(ff);% 4/2pi
plot(f,abs(H),f,abs(y),'r')
%analog freq = 4/2pi, decrease T to get f close to analog cutt off
T = 0.005;
c = 1/(1+4*T);
f = 1/(2*pi*T)*acos((4*c-c^2-1)/(2*c));
f
%%
clear 
clc
T = 0.005;
f = 0:0.01:1/T;
w = 2*pi*f;
s= i*w;
H = s./(s+5);
z = exp(i*w*T);
Hz = ((z-1)/(1+5*T))./(z-(1/(1+5*T)));
plot(f,abs(H),f,abs(Hz),'r')
%numericlly
Hdiff = abs(H)-1/sqrt(2);
[aa,ff] = min(abs(Hdiff));
fc=f(ff);% 5/2pi
