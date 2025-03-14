function [poles,poles_unshifted,residues,moments]= AWE_poles(A, B, C, D, w)
    q = length(B);
    num_moments = 2 * q;
    s0 = 1i * w;
    moments = zeros(1, num_moments);
    [r, c] = size(C);
    if r ~= 1
        C = C';
    end
    for k = 1:num_moments
        moments(k) = (-1)^(k-1)*C*(s0*eye(size(A))- A)^-(k)*B;
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
    poles = poles_unshifted+s0;
end