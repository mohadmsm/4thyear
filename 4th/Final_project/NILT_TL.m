% Model a transmission line without considering time-stepping, using the same
% values as before for a lossless line, where Vs = 30.

clear all
clc
R = 0;        % Resistance per unit length (Ohms per meter)
L = 2.5e-7;     % Inductance per unit length (Henries per meter)
G = 0;        % Conductance per unit length (Siemens per meter)
C = 1e-10;    % Capacitance per unit length (Farads per meter)
l = 400;    % Length of the transmission line (meters)
vs = 30;
M =13;      
[poles,residues] =  R_Approximation(M); 
t= 0:1e-8:80e-6;
h = t(2) - t(1);
% Calculate propagation constant (gamma) in the s-domain
z = @(s)(R+s.*L); 
y = @(s)(G + s .* C);
gamma = @(s)sqrt(z(s) .* y(s));
% Calculate characteristic impedance (Z0) in the s-domain
Z0 = @(s) sqrt(z(s) ./ y(s));

% Calculate series impedance (Z_series) in the s-domain
Z_series =@(s) Z0(s) .* sinh(gamma(s) .* l);

Y_parallel =@(s) (1 ./ Z0(s)) .* tanh((gamma(s) .* l)./2); %y *tanh(gamma*l/2)

% Calculate parallel impedance (Z_parallel) in the s-domain
%Z_parallel =@(s) Z0(s) ./ tanh(gamma(s) .* l);
Z_parallel = @(s) 1./Y_parallel(s);
% Transfer function TF = Z_parallel / (Z_series + Z_parallel)
TF = @(s) Z_parallel(s) ./ (Z_series(s) + Z_parallel(s));
vo = @(s) TF(s) * vs./s;
% without prev step 
result = - (1 ./ t) .*sum(real(vo(poles./t).*residues)); %implement NILT without time steping
%consider prev step
%{
result(1) = - (1 ./ h) .*sum(real(vo(poles./h).*residues)); 
for i= 2 :length(t)
    vo = @(s) TF(s) .* (vs./s) + result(i-1);
    result(i) = - (1 ./ h) .*sum(real(vo(poles./h).*residues ));
end
%}
% plot the result
figure(1);
plot(t,result)
xlabel('Time (us)');
ylabel('Voltage at Load (V)');
title('Voltage at Load over Time');
grid on