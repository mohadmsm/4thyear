clear
clc
% low pass bilinear first order. a (z+1)/(z-c)
f = 500;
T = 1/f;
z = exp(j*2*pi*f*T);
Hz = 0.4208*(z+1)/(z-0.158);
Hdiff = abs(Hz)-1/sqrt(2);
[aa,ff] = min(abs(Hdiff));
fc=f(ff);% 5/2pi
%T = 0.1;
a=0.4208;
c= 0.158;
fcc = 1/(2*pi*T) *acos((1+c^2-4*a^2)/(4*a^2+2*c)); % memorize 
%%
clear
clc
f = 0:0.001:10;
w = 2*pi*f;
s = i*w;
H = s./(s.^2+s+9);
[~,idx]=max(abs(H));
