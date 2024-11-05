% Parameters (example values, replace with your actual parameters)
R = 0;        % Resistance per unit length (Ohms per meter)
L = 1e-6;     % Inductance per unit length (Henries per meter)
G = 0;        % Conductance per unit length (Siemens per meter)
C = 1e-12;    % Capacitance per unit length (Farads per meter)
f = 1e9;      % Frequency (1 GHz, for example)
omega = 2 * pi * f;  % Angular frequency
ell = 0.1;    % Length of the transmission line (meters)

% Calculate propagation constant (gamma)
gamma = sqrt((R + 1i * omega * L) * (G + 1i * omega * C));

% Calculate characteristic impedance (Z0)
Z0 = sqrt((R + 1i * omega * L) / (G + 1i * omega * C));

% Calculate series impedance (Z_series)
Z_series = Z0 * sinh(gamma * ell);

% (Optional) Calculate parallel admittance (Y_parallel), if defined
% Y_parallel = Z0 * some function of gamma and ell, if defined

% Transfer function approximation (assumed)
TF = Z_series;  % Adjust based on the actual expression if known

% Display results
disp('Propagation constant (gamma):');
disp(gamma);
disp('Characteristic Impedance (Z0):');
disp(Z0);
disp('Series Impedance (Z_series):');
disp(Z_series);
disp('Transfer Function (TF):');
disp(TF);
