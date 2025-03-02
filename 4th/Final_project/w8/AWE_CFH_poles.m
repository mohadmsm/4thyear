function [poles,poles_unshifted,residues,moments]= AWE_CFH_poles(A, B, C, D, M, w0)
    L=M;
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
    b_matrix = moment_matrix\ Vector_c;
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
 
end