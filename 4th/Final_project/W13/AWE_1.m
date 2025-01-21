% Parameters for the transmission line
N = 2;          % Number of sections in the transmission line
l = 400;        % Total line length (meters)
dz = l / N;     % Section length
L = 2.5e-7;     % Inductance per section (H/m)
C = 1e-10;      % Capacitance per section (F/m)
G = 0;          % Conductance per section (S)
R = 0 * dz;     % Resistance per section (Ohms)
Rs = 0;         % Source resistance (Ohms)
Rl = 100;       % Load resistance (Ohms)

% Transfer function coefficients
RLC_dz = R * L * C;
RLC_dz_sq = R * L * C * dz^2;

a4 = R * L * C * dz^2 * dz^2; % Coefficient of s^4
a3 = 2 * R * L * C * dz^2 * dz + C * dz^2; % Coefficient of s^3
a2 = R * L * C * dz^2 * dz^2 + 2 * C * dz * R + 3 * R * L * dz; % Coefficient of s^2
a1 = C * dz^2 + 3 * R * L * dz + 2 * L; % Coefficient of s^1
a0 = 2 * R + Rl; % Coefficient of s^0

numerator = [Rl]; % Numerator is Rl for this transfer function
denominator = [a4 a3 a2 a1 a0]; % Denominator coefficients

% Define the transfer function
T = tf(numerator, denominator);

% Step 1: Compute state-space matrices
[A, B, C, D] = tf2ss(numerator, denominator);

disp('State-Space Representation:');
disp('A Matrix:');
disp(A);
disp('B Matrix:');
disp(B);
disp('C Matrix:');
disp(C);
disp('D Matrix:');
disp(D);

% Step 2: Compute the moments
m0 = C * (-A)^0 * B; % First moment
m1 = C * (-A)^1 * B; % Second moment
m2 = C * (-A)^2 * B; % Third moment
m3 = C * (-A)^3 * B; % Fourth moment

disp('Moments:');
disp(['m0 = ', num2str(m0)]);
disp(['m1 = ', num2str(m1)]);
disp(['m2 = ', num2str(m2)]);
disp(['m3 = ', num2str(m3)]);

% Step 3: Compute the poles of the system
poles = pole(T);
disp('Poles of the System:');
disp(poles);

% Step 4: Compute the residues
[residues, poles_res, ~] = residue(numerator, denominator);
disp('Residues:');
disp(residues);

% Step 5: Form the impulse response
syms t
h = 0;
for i = 1:length(poles_res)
    h = h + residues(i) * exp(poles_res(i) * t);
end
disp('Impulse Response:');
disp(h);
% Plot the impulse response from 0 to 20 microseconds
fplot(h, [0, 20e-6]);
title('Impulse Response');
xlabel('Time (t) [seconds]');
ylabel('h(t)');
grid on;
