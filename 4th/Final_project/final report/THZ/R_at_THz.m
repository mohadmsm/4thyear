clear;
clc;
Ro = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           % Source resistence (Ω)
G = 0;            
l = 150e-6;        % Length of the transmission line 
f_max = 100e9;    % Maximum frequency (100 GHz)
t_max = 10e-12;
f = linspace(1,f_max,110);
w = 2*pi*f;
s = i*w;
R1 = @(s) Ro+0.06*sqrt(s)*sqrt(2);
Rs = 10;
vo = @(s) sqrt(s*C.*(R1(s)+s*L))./(sqrt(s*C.*(R1(s)+s*L)).*cosh(l*sqrt(s*C.*(R1(s)+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R1(s)+s*L))));
vo2 = @(s)vo2(s)./s;
[y,t] = niltcv(vo2,t_max,1000);
plot(t,y)
grid on
xlabel('time (s)')
title("Unit Step Response with Frequency-Dependent Resistance")
%%
H = @(s)0;
idx = 1:10;
[H,num,deno] = generate_yp2(real(R(idx)),imag(R(idx)),w(idx)); % generate a rational model 
for n=10:10:100
    k = n:n+10;
    Hd= R(k)-H(s(k));
    [Hi,num,deno] = first_order_approximation(real(Hd),imag(Hd),w(k)); % generate a rational model 
    H = @(s) H(s)+Hi(s);
end
R1 = RMSE(H(s),R);
semilogx(f,abs(R),f,abs(H(s)))
%%
clear;clc;
f = 100e9;
f = linspace(1,f,1000);
w = 2*pi*f;
s = i*w;
R = 1200+0.06*(1+j)*sqrt(w);
fit = rationalfit(f,R);
[H,freq]=freqresp(fit,f);
plot(f,abs(R) ,f,abs(H))
grid on
legend("Exact R", "Approximation",Location="northwest")
%%
% Given frequency
f_max = 100e9;

% Create frequency vector
f = linspace(1, f_max, 100);

% Angular frequency
w = 2 * pi * f;

% Complex frequency variable (Laplace domain)
s = 1i * w;

% Impedance expression
R = 1200 + 0.06 * (1 + 1i) * sqrt(w);

% Symbolic Time Domain Model (Approximation)
syms t s_sym;
w_sym = s_sym / 1i;
R_sym = 1200 + 0.06 * (1 + 1i) * sqrt(w_sym);
R_sym_simplified = simplify(R_sym);

% Taylor series expansion around 0
R_series = series(R_sym, s_sym, 'ExpansionPoint', 0, 'Order', 5); %expand to s^2, we could expand more.
R_series_simplified = simplify(R_series);

% Inverse Laplace transform (approximate)
R_time_domain = ilaplace(R_series_simplified, s_sym, t);

disp('Symbolic Impedance in Laplace domain:');
disp(R_sym_simplified);

disp('Taylor Series Expansion in Laplace domain:');
disp(R_series_simplified);

disp('Time Domain Model (Approximation via Taylor Series):');
disp(R_time_domain);

% Numerical Time Domain Model (Impulse and Step Response)
num_coeffs = coeffs(R_series_simplified, s_sym, 'All');
den_coeffs = coeffs(denominator(R_series_simplified), s_sym, 'All');

num_coeffs_num = double(num_coeffs);
den_coeffs_num = double(den_coeffs);

% Convert to row vectors
num_coeffs_num = num_coeffs_num(:)';
den_coeffs_num = den_coeffs_num(:)';

% Time vector
time = linspace(0, 1e-9, 1000);

% Impulse response
[h_impulse, t_impulse] = impulse(tf(num_coeffs_num, den_coeffs_num), time);

% Step response
[h_step, t_step] = step(tf(num_coeffs_num, den_coeffs_num), time);

disp('Numerical time domain impulse response time vector:');
disp(t_impulse);
disp('Numerical time domain impulse response:');
disp(h_impulse);

disp('Numerical time domain step response time vector:');
disp(t_step);
disp('Numerical time domain step response:');
disp(h_step);

% Plot the results (optional)
figure;
subplot(2, 1, 1);
plot(t_impulse, h_impulse);
title('Impulse Response');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t_step, h_step);
title('Step Response');
xlabel('Time (s)');
ylabel('Amplitude');
%%
clear;
clc;
Ro = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)          % Source resistence (Ω)
G = 0;            
l = 150e-6;        % Length of the transmission line % Maximum frequency (100 GHz)
t_max = 10e-12;
f_max = 750e10; 
f = linspace(1,f_max,110);
w = 2*pi*f;
s = i*w;
R1 = Ro+0.06*(1+1i)*sqrt(w);
Rs = 10;
R =@(s) Ro+0.06*sqrt(s)*sqrt(2);
vo =  sqrt(s*C.*(R1+s*L))./(sqrt(s*C.*(R1+s*L)).*cosh(l*sqrt(s*C.*(R1+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R1+s*L))));

vos = @(s) sqrt(s*C.*(R(s)+s*L))./(sqrt(s*C.*(R(s)+s*L)).*cosh(l*sqrt(s*C.*(R(s)+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R(s)+s*L))));
fit = rationalfit(f,vo);
[H,freq]=freqresp(fit,f);
vo =  sqrt(s*C.*(R1+s*L))./(sqrt(s*C.*(R1+s*L)).*cosh(l*sqrt(s*C.*(R1+s*L)))+Rs*s*C.*sinh(l*sqrt(s*C.*(R1+s*L))));
[p2,r2] = custom_rationalfit(f,vo,10);
h_s2 = @(s) 0;
for i=1:length(p2)
     h_s2 = @(s) h_s2(s)+r2(i)./(s-p2(i));
end
plot(f,abs(h_s2(s)));

poles = fit.A';
residues = fit.C';
h_s = @(s) 0;
for i=1:length(poles)
     h_s = @(s) h_s(s)+residues(i)./(s-poles(i));
end
h_s = @(s) h_s(s)*1./s;
vos = @(s) vos(s)./s;
[y,t] = niltcv(h_s,t_max,1000);
[y2,t] = niltcv(vos,t_max,1000);
plot(t,y,t,y2);
R = RMSE(poles,p2);