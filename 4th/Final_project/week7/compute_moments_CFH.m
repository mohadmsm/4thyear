function moments = compute_moments_CFH(A, B, C, D, s0)
    % Shift system matrices to s' = s - s0
    Y_shifted = s0 * eye(size(A)) - A;
    moments = zeros(1, 20); % Preallocate for 20 moments
    
    % Compute moments recursively (avoid nested loops)
    sol = Y_shifted \ B; % LU decomposition reused
    moments(1) = C * sol + D; % Zeroth moment (DC term)
    
    for k = 2:length(moments)
        sol = Y_shifted \ sol; % Reuse LU factorization
        moments(k) = (-1)^(k-1) * C * sol;
    end
end