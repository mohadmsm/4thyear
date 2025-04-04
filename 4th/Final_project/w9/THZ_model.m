clear;clc;
R = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           % sourcce Resistence (Ω)
G = 0;            
l = 150e-6;  
f = 100e9;
f = linspace(1,f,100);
w = 2*pi*f;
s = i *w; 
Rs = 0.06;
R = R+Rs*(1+1j)*sqrt(w);
v = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
R = 1200;
v2 = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
plot(f,abs(v),f,abs(v2));
xlabel('Frequency (Hz)')
legend('Wtih R changed', 'R = 1200')
grid on
