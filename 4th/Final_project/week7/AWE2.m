function [h_impulse, h_s, y_step, t,poles] = AWE2(A, B, C, D, w, input, time)
    t = linspace(0, time, 1000);
    q = length(B);
    num_moments = 2 * q;
    s0 = 1i * w;
    moments = zeros(1, num_moments);
    [r, c] = size(C);
    if r ~= 1
        C = C';
    end
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C * (s0 * eye(size(A)) - A)^-(k) * B;
    end
    moments(1) = moments(1) + D;  % Include D in the zeroth moment
    
    approx_order = q;
    
    % Construct moment matrix and vector for denominator coefficients
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1 : 2*approx_order)';
    for i = 1:approx_order
        moment_matrix(i, :) = moments(i : i + approx_order - 1);
    end
    
    % Solve for denominator coefficients
    b_matrix = pinv(moment_matrix) * Vector_c;
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
    poles = poles_unshifted+s0;
    
    % Impulse response using shifted poles
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues(i) * exp(poles(i) * t);
    end
    
    % Transfer function in s-domain
    h_s = @(s) sum(residues ./ ((s) - poles), 1);
    
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