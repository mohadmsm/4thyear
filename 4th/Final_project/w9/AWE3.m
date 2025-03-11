function [h_impulse, h_s, y_step, t, poles,moments] = AWE3(A, B, C, D, w, input, time)
    t = linspace(0, time, 1000);
    q = length(B);
    num_moments = 2 * q;
    s0 = 1i * w; % Expansion point (e.g., jω)
    moments = zeros(1, num_moments);
    
    % Ensure C is a row vector
    if size(C, 1) ~= 1
        C = C';
    end
    
    % Generate moments around s0
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C * (s0 * eye(size(A)) - A)^-(k) * B;
    end
    moments(1) = moments(1) + D; % Include D in zeroth moment
    
    approx_order = q;
    
    % Split moments into real/imaginary parts to enforce real coefficients
    real_moments = real(moments);
    imag_moments = imag(moments);
    
    % Construct combined real matrix for denominator coefficients
    moment_matrix_real = zeros(approx_order);
    moment_matrix_imag = zeros(approx_order);
    for i = 1:approx_order
        moment_matrix_real(i, :) = real_moments(i:i+approx_order-1);
        moment_matrix_imag(i, :) = imag_moments(i:i+approx_order-1);
    end
    combined_matrix = [moment_matrix_real; moment_matrix_imag];
    combined_vector = -[real(moments(approx_order+1:2*approx_order))'; ...
                       imag(moments(approx_order+1:2*approx_order))'];
    
    % Solve for real coefficients
    b_matrix = combined_matrix \ combined_vector;
    b_matrix = real(b_matrix); % Force real coefficients
    
    % Denominator polynomial and poles in shifted domain (s')
    denominator = [b_matrix; 1];
    poles_unshifted = roots(denominator);
    
    % Compute residues using real coefficients
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = poles_unshifted(j)^(1-i); % Equivalent to 1/poles_unshifted(j)^(i-1)
        end
    end
    residues_unshifted = V \ moments(1:approx_order)';
    
    % Shift poles back to original s-plane
    poles = poles_unshifted + s0;
    
    % Impulse response
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues_unshifted(i) * exp(poles(i) * t);
    end
    
    % Transfer function
    h_s = @(s) sum(residues_unshifted ./ (s - poles));
    
    % Step response (simplified)
    y_step = zeros(size(t));
    for i = 1:length(t)
        y_step(i) = sum(residues_unshifted ./ (-poles) .* (exp(poles * t(i)) - 1));
    end
end