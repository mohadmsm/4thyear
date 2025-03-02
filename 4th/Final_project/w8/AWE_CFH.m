function [h_impulse,h_s, y_step, t,poles]= AWE_CFH(A, B, C, D, M, w0, input, t)
    L=M;
    t = linspace(0, t, 1000);
    num_moments = L + M + 1; % Moments from m₀ to m_{L+M}
    s0 = 1i * w0; % Complex frequency point
    moments = zeros(1, num_moments);
    
    % Ensure C is a row vector
    [r, ~] = size(C);
    if r ~= 1
        C = C';
    end
    
    % Compute moments m₀ to m_{L+M}
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C * (s0 * eye(size(A)) - A) ^-(k) *(B);
        % For k > 1, replace with iterative LU solves for efficiency
    end
    moments(1) = moments(1) + D; % Add direct coupling term D to m₀

    approx_order = M;
    
    % Construct moment matrix and vector for denominator coefficients
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1 : 2*approx_order)';
    for i = 1:approx_order
        moment_matrix(i, :) = moments(i : i + approx_order - 1);
    end
    
    % Solve for denominator coefficients
    b_matrix = moment_matrix \ Vector_c;
    poles_unshifted = roots([b_matrix; 1]);  % Unshifted poles (s' = s - s0)
    
    % Compute residues using unshifted poles
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1 / (poles_unshifted(j))^(i-1);
        end
    end
    A_diag = diag(1 ./ poles_unshifted);
    r_moments = moments(1:approx_order);
    residues = -A_diag \ (V \ r_moments(:));
    
    % Shift poles to s-plane
    poles = poles_unshifted + s0;
    
    % Impulse response using shifted poles
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues(i) * exp(poles(i) * t);
    end
    
    % Transfer function in s-domain
    h_s = @(s) sum(residues ./ (s - poles), 1);
    
    % Step response using recursive convolution
    y_step = zeros(size(t));
    y = zeros(length(poles), 1);
    for n = 2:length(t)
        dt = t(n) - t(n-1);
        exp_term = exp(poles * dt);
        for i = 1:length(poles)
            y(i) = residues(i) * (1 - exp_term(i))/(-poles(i)) * input + exp_term(i) * y(i);
        end
        y_step(n) = sum(y);
    end

end