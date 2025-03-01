function moments = compute_moments_CFH(A, B, C, D, w0, L, M)
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
    
end