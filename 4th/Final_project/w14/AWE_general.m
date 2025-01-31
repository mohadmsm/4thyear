clear all
clc
% Input state-space matrices
A = [-2 1 0 0; 1 -2 1 0; 0 1 -2 1; 0 0 1 -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];

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
    %set a value for t 
    %t=0:10;
    t = 0.5;
    %form the impulse response 
    h =0;
    for i = 1:approx_order
        h = h + residues(i) * exp(poles(i) * t);
    end
    h
    %{
    % plot the output 
    figure(approx_order);
    title(['Apprximation of order',num2str(approx_order)]);
    plot(t,h);
    xlabel('Time (\mus)');
    ylabel('V Load (Volts)');
    grid on
    %}
end