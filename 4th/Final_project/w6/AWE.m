function [h_impulse,h_s, y_step, t] = AWE(A,B,C,D,input,time)   
    t = linspace(0,time,250);
    q = length(B);
    num_moments = 2 * q;
    moments = zeros(1, num_moments);
    [r,c]=size(C); % make sure C matrix in correct form
    if r~=1
        C= C';
    end
    for k = 1:num_moments
        moments(k) = (-1) * C * (A)^-(k) * B;
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
    b_matrix = moment_matrix^-1 * Vector_c;

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
    h_s =@(s) 0;
    for i = 1:length(poles)
        h_s =@(s) h_s(s) + residues(i)./(s-poles(i));
    end

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