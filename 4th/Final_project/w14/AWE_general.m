clear all
clc
% Input state-space matrices
A = [-2 1 0 0; 1 -2 1 0; 0 1 -2 1; 0 0 1 -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
t = 0:0.1:2;
% impulse response 
%{
eat = @(t) expm(A.*t); 
y = @(t)mtimes(mtimes(transpose(C),eat(t)),B); 
y_values = arrayfun(@(t) y(t), t);
%}

% step response
sys = ss(A,B,transpose(C),0);
[y_theory, t] = step(sys, t); % get the step input response using step 
% Determine the order of the system
q = length(B);
% Compute moments
num_moments = 2 * q;
moments = zeros(1, num_moments);
for i = 1:num_moments
    moments(i) = -transpose(C) * (A^(-i)) * B;
end

% Generalized approximation for all orders
for approx_order = 1:q
    fprintf('Case %d:\n', approx_order);

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end
    % find b matrix (deno coef)
    b_matrix = inv(moment_matrix)*Vector_c;
    
    %find the ploes 
    poles = roots([transpose(b_matrix) ,1]);
    
    % determine residuses 
    % form the V matrix 
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1/poles(j)^(i-1);
        end
    end
    % form the A matrix 
    A_diag = diag(1 ./ poles);
    r_moments = moments(1:approx_order); % a helper matrix
    % find the residuse
    residues = -1*inv(A_diag)* inv(V)* transpose(r_moments);
    %form the impulse response 
    h =0;
    for i = 1:approx_order
        h = h + residues(i) * exp(poles(i) * t);
    end
    % Recursive Convolution (Section V)

    y_awe = zeros(size(t)); % AWE response

    % y variables for each pole
    y = zeros(length(poles), 1);

    % Recursive convolution loop
    for n = 2:length(t)
    dt = t(n) - t(n-1); % Time step
    exp_term = exp(poles * dt); % Precompute exponentials
        for i = 1:length(poles)
            % Updat state using Eq. (15)
            y(i) = residues(i) * (1 - exp_term(i)) * 1 + exp_term(i)*y(i);
        end
        y_awe(n) = sum(y); % Total response
    end

    % Plot Results
    figure(approx_order);
    plot(t, y_awe, 'b-'); hold on;
    plot(t, y_theory, 'ro--');
    xlabel('Time (μs)');
    ylabel('Response');
    title(['Approximation of Order ', num2str(approx_order)]);
    legend('AWE (Recursive Convolution)', 'Theoretical step', 'Location', 'Best');
    grid on;
    % plot the output 
    %{
    figure(approx_order);
    plot(t,h);
    hold on 
    plot(t, y_values,'ro');
    xlabel('Time (\mus)');
    ylabel('V Load (Volts)');
    title(['Apprximation of order',num2str(approx_order)]);
    legend('Awe', 'Theory Impulse', 'Location', 'Best');
    grid on
    %}
end
