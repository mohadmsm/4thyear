function [h_impulse, y_step, t] = AWE(A,B,C,D,w,time)   
    t = linspace(0,time,250);
    q = length(B);
    num_moments = 2 * q;
    s0=1i*w;
    moments = zeros(1, num_moments);
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C' * (s0 * eye(size(A)) - A)^-(k) * B;
    end
    moments(1)=moments(1)+D;
    approx_order = length(B);

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end

    % Solve for denominator coefficients
    b_matrix = inv(moment_matrix) * Vector_c;

    % Compute poles
    poles = roots([b_matrix', 1]);

    % Compute residues
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1 / poles(j)^(i-1);
        end
    end

    A_diag = diag(1 ./ poles);
    r_moments = moments(1:approx_order);
    residues = -1 * (A_diag \ (V \ r_moments'));

    % Impulse response
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues(i) * exp(poles(i) * t);
    end

    % Step response using recursive convolution
    y_step = zeros(size(t));
    y = zeros(length(poles), 1);

    for n = 2:length(t)
        dt = t(n) - t(n-1);
        exp_term = exp(poles * dt);
        for i = 1:length(poles)
            y(i) = residues(i) * (1 - exp_term(i))/(-poles(i)) * 1 + exp_term(i) * y(i);
        end
        y_step(n) = sum(y);
    end
end