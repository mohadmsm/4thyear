clear
clc
T = 0.01;
f = 0:0.001:1/T;
w = 2*pi*f;
s= i*w;
H = s./(s+5);
z = exp(i*w*T);
Hz = ((z-1)/(1+5*T))./(z-(1/(1+5*T)));
plot(f,abs(H),f,abs(Hz),'r')
grid on
%numericlly
Hdiff = abs(H)-1/sqrt(2);
[aa,ff] = min(abs(Hdiff));
fc=f(ff);% 5/2pi
a =1/(1+5*T);
A=2*a/(1+a);
fcc = 1/(2*pi*T)*acos((A^2*(1+a^2)-4*a^2)/(2*a*A^2-4*a^2));