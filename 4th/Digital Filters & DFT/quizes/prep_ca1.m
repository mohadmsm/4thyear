clear all
clc
% if x values [1 2 3 4] use the below if not , =e^-(anT)^2 = (1/1-e^-a)then find
% the value
a=4;
xe= 1/(1-exp(-a));
x=[1 0 -2 1.5];
E = sum(abs(x).^2);
%Ep = 1/4*sum(abs(Xdft).^2);
%SQNR
xn = [0.4, 0.32, 0.56, 1.11];
x_quantied = [0.25, 0.75, 1.25, 0];
P_sig = 1/length(xn)*(sum((xn.^2)));
P_noise =  1/length(xn)*(sum((x_quantied- xn).^2));
%linear 
lin = P_sig/P_noise;
dB = 10*log10(lin);
%%
%AB = C, C= A\B
clear
clc
w=0.2;
A = [1,          1,             0;
    -2*cos(w), 0.25-cos(w), sin(w);
    1 ,       -0.25*cos(0.2), 0.25*sin(0.2)];
C = [0; sin(0.2); 0];
B = A\C;%[A;B;c]
% A(-0.25)^n + Bcos(wn) + Csin(wn)un
%%
clear
clc
w=2.2;
T =0.5;
z=exp(i*w*T);
H = z.^2/(z^2+0.5*z+0.06);
abs(H)
%%
clear
clc
xn = sin(0.2*pi.*n).*cos(0.3*pi.*n)+0.9.*(cos(0.4*pi.*n)).^2;
p = limit(1./(2*n+1)*sum(abs(xn).^2),n,inf);
%%
clear
clc
w=2;
T =0.1;
z=exp(i*w*T);
hz= 0.6+0.2*z.^-1+0.1*z.^-2+0.1*z.^-3;
xz = 0.3+0.2*z.^-1+-0.1*z.^-2+0.05*z.^-3;
yz=hz*xz;
angle(yz)