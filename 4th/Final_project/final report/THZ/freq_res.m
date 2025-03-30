clear
clc
% generate 100 points.
Ro = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           % sourcce Resistence (Ω)
G = 0;            
l = 150e-6;  
fmx = 750e10;
f = linspace(1,fmx,1000);
w = 2*pi*f;
s = i*w;
R = Ro+0.06*(1+1i)*sqrt(w);
vo =  sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
plot(f,abs(vo))
grid on
xlabel("Frequency (Hz)")
ylabel("|Vo|")
title('Frequency Response')
xlim([0,fmx]);