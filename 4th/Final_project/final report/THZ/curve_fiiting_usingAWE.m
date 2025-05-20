clear 
clc 
tic
% Generate 100 frequency points for analysis 
Ro = 1200;          % Resistance per unit length (Ω/m) 
L = 250e-9;        % Inductance per unit length (H/m) 
C = 1e-10;         % Capacitance per unit length (F/m) 
Rs = 10;           % Source resistance (Ω) 
G = 0;             % Conductance (S/m) - set to zero in this case 
l = 150e-6;        % Length of transmission line (m) 
f = 750e10;        % Maximum frequency (7.5 THz) to capture many peaks 
f = linspace(1,f,100); % Create 100 frequency points from 1Hz to 7.5THz 
w = 2*pi*f;         
s = 1i * w;         
% Exact solution calculation for comparison 
% Frequency-dependent resistance including skin effect 
R = Ro + 0.06*(1+1i)*sqrt(w); 
% Exact voltage transfer function in frequency domain 
vo = sqrt(s*C.*(R+s*L))./(sqrt(s*C.*(R+s*L)).*cosh(l*sqrt(s*C.*(R+s*L))) + Rs*s*C.*sinh(l*sqrt(s*C.*(R+s*L)))); 
% Function definitions for NILT 
% Skin effect resistance as a function of complex frequency 
R = @(s) Ro + 0.06*sqrt(s)*sqrt(2); 
% Voltage transfer function definition for NILT 
v = @(s) sqrt(s*C.*(R(s)+s*L))./(sqrt(s*C.*(R(s)+s*L)).*cosh(l*sqrt(s*C.*(R(s)+s*L))) + Rs*s*C.*sinh(l*sqrt(s*C.*(R(s)+s*L)))); 
v = @(s) v(s)*1./s; % Scale for unit step response 
% Initial model fitting using first 7 frequency points 
first_idx = 1:7; 
time = 10e-12; % Simulation time window (10ps) 
[~,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx)); 
[A,B,C,D] = create_state_space(num,deno); 
% Perform  (AWE) for initial approximation 
[~,HAWEi, y0,t1] = AWE2(A,B,C,D,w(1),1,time); 
% approximation setup 
N = 5; % Number of points per section/model  
range = 7; % Starting point for second model 
models = 15; % Total number of models to create 
% approximation loop 
for i = 1:models 
    % Define frequency range for current model 
    range = range(end)-2:N + range(end); 
    % Calculate difference between exact solution and current approximation 
    H_diff = vo(range) - HAWEi(s(range)); 
    % Fit new model to the residual error 
    [~,numi,denoi] = generate_yp2(real(H_diff),imag(H_diff),w(range));     
    [A,B,C,D] = create_state_space(numi,denoi); 
    [~,HAWEj, yi, ti] = AWE2(A,B,C,D,w(1),1,time); 
    % Update overall approximation 
    HAWEi = @(s) HAWEi(s) + HAWEj(s); 
    y0 = y0 + yi;     
end 
toc
% Calculate exact solution using NILT for comparison 
[y1,t1] = niltcv(v,time,1000); 
% Calculate error metrics 
R1 = sqrt(sum(abs(y0-y1).^2)/length(y1)); % RMS error for step response 
R2 = sqrt(sum(abs(HAWEi(s)-vo).^2)/length(vo)); % RMS error for frequency response 
% Plot results 
figure(1) 
plot(t1,y0,ti,y1) % Plot step responses 
grid on 
xlabel('time (s)') 
ylabel('Response') 
legend('AWE approximation', 'Exact'); 
title(['approximation with models = ',num2str(models)]); 
% Alternative frequency response plot (commented out) 
% figure(2) 
% plot(f,abs(HAWEi(s)),f,abs(vo)); % frequency response 
% grid on  
% xlabel('Frequency (Hz)') 
% ylabel('Magnitude') 
% legend('AWE approximation', 'Exact'); 