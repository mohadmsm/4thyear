% =============================================
% Recursive Convolution for Unit Step Response
% =============================================

% Define parameters
k_inf = 0;       % Direct coupling term (adjust based on your AWE results)
poles = [...];   % Column vector of poles (from AWE)
residues = [...];% Column vector of residues (from AWE)

% Time parameters
t_start = 0;     % Start time (s)
t_end = 1e-9;    % End time (s)
dt = 1e-12;      % Time step (s). Ensure dt << 1/max(|real(poles)|)
t = t_start:dt:t_end; % Time vector
N = length(t);   % Number of time points

% Unit step input (x(t) = 1 for t >= 0)
x = ones(size(t));

% Initialize output arrays
y_total = zeros(size(t)); % Total response
y_terms = zeros(length(poles), N); % Individual pole contributions

% Recursive convolution loop
for n = 2:N
    % Time step delta
    delta_t = dt;
    
    % Update each pole-residue term
    for i = 1:length(poles)
        p = poles(i);
        k = residues(i);
        
        % Recursive formula (Eq. 15 in the paper)
        y_terms(i, n) = k * (1 - exp(-p * delta_t)) * x(n-1) ...
                       + exp(-p * delta_t) * y_terms(i, n-1);
    end
    
    % Total response = sum of all terms + k_inf * x(t)
    y_total(n) = k_inf * x(n) + sum(y_terms(:, n));
end

% Plot results
figure;
plot(t, y_total, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Response');
title('Unit Step Response via Recursive Convolution');
grid on;
%%
% ======================================================
% Unit Step Response via lsim (State-Space Representation)
% ======================================================

% Define system parameters (replace with your AWE results)
poles = [-1e9, -5e9];   % Column vector of stable poles (Re(p) < 0)
residues = [2e9, -1e9]; % Row vector of residues
k_inf = 0.1;            % Direct coupling term

% Time vector
t = 0:1e-12:5e-9;       % Time grid: 0 to 5 ns with 1 ps steps
u = ones(size(t));       % Unit step input

% --------------------------------------
% Step 1: Construct state-space model
% --------------------------------------
% State-space equations:
%   dx/dt = A x + B u
%      y  = C x + D u
% For H(s) = k_inf + sum(k_i / (s - p_i)), we use:
A = diag(poles);        % Diagonal matrix of poles
B = ones(length(poles), 1); 
C = residues;           % Residues as output matrix
D = k_inf;              % Direct coupling term

sys = ss(A, B, C, D);   % Create state-space model

% --------------------------------------
% Step 2: Compute response with lsim
% --------------------------------------
[y_lsim, ~, ~] = lsim(sys, u, t);

% --------------------------------------
% Step 3: Validate with recursive convolution
% --------------------------------------
% Implement recursive convolution (from previous code)
[y_recursive, ~] = lsim_custom(poles(:), residues(:), k_inf, u, t);

% --------------------------------------
% Plot results
% --------------------------------------
figure;
plot(t, y_lsim, 'b', 'LineWidth', 1.5); hold on;
plot(t, y_recursive, 'ro', 'MarkerSize', 4, 'LineWidth', 1.0);
xlabel('Time (s)');
ylabel('Response');
legend('lsim (State-Space)', 'Recursive Convolution');
title('Unit Step Response Comparison');
grid on;
