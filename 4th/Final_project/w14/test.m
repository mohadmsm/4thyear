clear all;
clc;

% Define state-space matrices (4th-order system)
A = [-2 1 0 0; 1 -2 1 0; 0 1 -2 1; 0 0 1 -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
sys = ss(A, B, C', 0); % Direct term D = 0

% Time vector
t = 0:0.1:2; % Time steps (μs)

% Compute theoretical impulse response using MATLAB's `impulse`
[y_theory, t] = impulse(sys, t);

% ==================================================================
% Step 1: Compute Moments and Perform AWE to Extract Poles/Residues
% ==================================================================
q = size(A, 1); % System order (4)
num_moments = 2 * q; % Number of moments needed for AWE

% Initialize moments
moments = zeros(1, num_moments);
for i = 1:num_moments
    moments(i) = (-1)^i * C' * (A^(-i)) * B; % Moment calculation
end

% ==================================================================
% Step 2: Generalized AWE Approximation (Pole-Residue Extraction)
% ==================================================================
approx_order = 4; % Match system order for exact results

% Construct moment matrix and solve for denominator coefficients
moment_matrix = zeros(approx_order);
Vector_c = -moments(approx_order+1:2*approx_order)';

for i = 1:approx_order
    moment_matrix(i, :) = moments(i:i+approx_order-1);
end

b_matrix = moment_matrix \ Vector_c; % Solve for denominator coefficients
poles = roots([transpose(b_matrix) ,1]); % Poles of the system

% Compute residues using Vandermonde matrix
V = zeros(approx_order);
for i = 1:approx_order
    for j = 1:approx_order
        V(i, j) = 1 / poles(j)^(i-1);
    end
end

residues = V \ moments(1:approx_order)'; % Residues

% Ensure stability: Keep only left-half-plane poles
stable_poles = poles(real(poles) < 0);
stable_residues = residues(real(poles) < 0);

% ==================================================================
% Step 3: Recursive Convolution (Section V Integration Method)
% ==================================================================
% Initialize variables
y_awe = zeros(size(t));
dt = t(2) - t(1); % Time step
exp_terms = exp(stable_poles * dt); % Precompute exponentials

% State variables for each pole
state = zeros(length(stable_poles), 1);

% Recursive convolution loop
for n = 2:length(t)
    for i = 1:length(stable_poles)
        % Update state using Eq. (15)
        state(i) = stable_residues(i) * (1 - exp_terms(i)) * (n > 1) ... 
                  + exp_terms(i) * state(i);
    end
    y_awe(n) = sum(state); % Total response
end

% ==================================================================
% Step 4: Plot Results
% ==================================================================
figure;
plot(t, y_theory, 'b-', 'LineWidth', 1.5); hold on;
plot(t, y_awe, 'ro--', 'MarkerSize', 8, 'LineWidth', 1.0);
xlabel('Time (μs)');
ylabel('Impulse Response');
title('AWE Approximation vs. Theoretical Response (Order 4)');
legend('Theoretical', 'AWE');
grid on;