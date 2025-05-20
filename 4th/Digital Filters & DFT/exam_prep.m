clear
clc
w = pi/10;
N = 2*pi/w;
p = 0;
for n = -N:N
    x=sin(0.8*pi*n)+cos(1.6*pi*n)+2*sin(6*pi*n/40)*cos(3*pi*n/20);
    p = p+abs(x.^2);
end
p = p*1/(2*N+1);
%%
clear
clc
A = [1 1 ; 0.2 0.4];
c = [0.52; 0.08];
B = inv(A)*c;
%%
clear
clc
T = 0.01;
a = 2*T/(2+2*T);
c = (2-2*T)/(2+2*T);
w = 2;
z = exp(i*w*T);
H = a*(z+1)/(z-c);
mag = sqrt((a+a*cos(w*T))^2+(a*sin(w*T))^2)/sqrt((1-c*cos(w*T))^2+(c*sin(w*T))^2);
%%
clear
clc
T = 0.1;
w = 10;
z = exp(j*w*T);
xz = 1/(1-0.25*z^-1);
mag = 1/sqrt((1-0.25*cos(w*T))^2+(0.25*sin(w*T))^2);
%%
clear
clc
n = -3:3;
hw = (0.54+0.46*cos(2*pi.*n/6)).*(0.4*sinc(0.4.*n));
%%
clear
clc
A = [1 1 ; 4 5];
C = [0;20];
B = A\C;
%%
clear
clc
T = 0.1;
a= exp(-4*T)-exp(-5*T);
b =exp(-4*T)+exp(-5*T);
y = exp(-9*T);
f = 0.4541;
w = 2*pi*f;
z = exp(j*w*T);
HZ = 20*a*z^-1/(1-z^-1*b+y*z^-2)*T;
num_mag = sqrt((2*a*cos(w*T))^2+(-2*a*sin(w*T))^2);
deno_mag = sqrt((1-b*cos(w*T)+y*cos(2*w*T))^2+(-b*sin(w*T)+y*sin(w*T*2))^2);
mag = num_mag/deno_mag;
analog= 20/sqrt((20-w^2)^2+(9*w)^2);
%%
clear
clc
E = 1/(1-0.2^2);
%%
clear
clc
T = 0.05;
c = 1/(1+3*T);
fc= 1/(2*pi*T)*acos((4*c-c^2-1)/(2*c));
%%
clear
clc
xn = [2.37 2.12 1.65 2.15];
xq = [2.25 2.25 1.75 2.25];
noise = xn-xq;
pn = noise.^2;
pn = sum(pn);
psig = sum((xn.^2));
SQNR = 10*log10(psig/pn);
%%
clear
clc
A = [1 1; -1 -0.3];
C = [1 ; 0];
B = A\C;
%%
clear
clc
N=20;
p = 0;
for n=-N:N
    p = p+3*(1+cos(0.4*pi*n))/2;
end
power = 1/N * p;