clear
clc
Ro = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           
G = 0;            
l = 150e-6;        % Length of the transmission line 
f_max = 750e10;
f = linspace(1,f_max,100);
w = 2*pi*f;
s = 1i*w;
t_max = 10e-12;
t = linspace(0,t_max,1000);
% trapezoidal pulse
Tr = 1e-12;  % 1 ps rise/fall
Tp = 5e-12;  % 5 ps high
Amp = 1;     % 1 V amplitude
wo = 2*pi*100e9; %0.1 THz sine input 
vs_sine = @(s) wo./(s.^2 + wo^2);% Laplace transform of sin(wt)
% Laplace transform of the trapezoid
vpulse = @(s) (Amp./(Tr*s.^2)).*(1 - exp(-Tr.*s))- (Amp./(Tr.*s.^2)).*(exp(-(Tr+Tp).*s) - exp(-(2*Tr+Tp).*s));
R = Ro+0.06*(1+1i)*sqrt(w); % frequency depndent R
% obtain the exact frequency mesurements 
vo =  sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L))));
% for NILT
R =@(s) Ro+0.06*sqrt(s)*sqrt(2);
vos =@(s) sqrt(s*C.*(R(s)+s*L))./(sqrt(s*C.*(R(s)+s*L)).*cosh(l*sqrt(s*C.*(R(s)+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R(s)+s*L))));
vo_step = @(s) vos(s)./s;% exact step response
vo_sine = @(s) vos(s).*vs_sine(s);
vo_pulse = @(s) vos(s).*vpulse(s);
H = rationalfit(f,vo);
poles = H.A';
residues = H.C';
[y_step,t]=step_response(poles,residues,t);
[y_sine,t]=sine_response2(poles,residues,t);
[y_pulse,t]=pulse_response(poles,residues,t);
[y_NILT,t]=niltcv(vo_step,t_max,1000);
error=RMSE(y_pulse,y_NILT); %RMSE error
plot(t,y_step,t,y_NILT)
grid on
xlabel('time (s)')
%title("trapezoidal response with Frequency-Dependent Resistance of exact vs approximated")
legend("Approximated","Exact")