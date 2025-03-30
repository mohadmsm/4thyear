function [poles, residues, d, h] = custom_rationalfit(f, H, N, starting_poles)
    % Normalize frequency to GHz
    f_ghz = f / 1e9;
    s = 1i * 2 * pi * f_ghz(:);
    H = H(:);

    % Generate starting poles if not provided
    if nargin < 4
        beta = logspace(log10(min(f_ghz)), log10(max(f_ghz)), N/2) * 2 * pi;
        alpha = beta / 100;
        starting_poles = [-alpha + 1i*beta, -alpha - 1i*beta].';
    end

    % Stage 1: Pole Identification (with scaling)
    A = zeros(2*length(s), 2*N + 2);
    b = zeros(2*length(s), 1);
    scale_factor = 1e-10;

    for k = 1:length(s)
        sk = s(k);
        Hk = H(k);
        row_top = zeros(1, 2*N + 2);
        
        for n = 1:N
            denom = sk - starting_poles(n);
            row_top(n) = 1 / denom;
            row_top(N + 2 + n) = -Hk / denom;
        end
        row_top(N+1) = 1;
        row_top(N+2) = sk;
        
        A(2*k-1, :) = real(row_top) * scale_factor;
        A(2*k, :) = imag(row_top) * scale_factor;
        b(2*k-1) = real(Hk) * scale_factor;
        b(2*k) = imag(Hk) * scale_factor;
    end

    x = pinv(A) * b;
    x = x / scale_factor;

    % Compute new poles (same as before)
    c_tilde = x(N+3:end);
    A_matrix = diag(starting_poles);
    H_matrix = A_matrix - ones(N,1) * c_tilde.';
    H_matrix = make_real(H_matrix, starting_poles);
    new_poles = eig(H_matrix);
    new_poles = -abs(real(new_poles)) + 1i*imag(new_poles);

    % Stage 2: Residue Identification (with regularization)
    A_res = zeros(2*length(s), length(new_poles) + 2);
    for k = 1:length(s)
        sk = s(k);
        row = [1./(sk - new_poles).', 1, sk];
        A_res(2*k-1, :) = real(row);
        A_res(2*k, :) = imag(row);
    end

    lambda = 1e-6; % Regularization parameter
    x_res = (A_res' * A_res + lambda * eye(size(A_res,2))) \ (A_res' * [real(H); imag(H)]);
    
    residues = x_res(1:end-2);
    d = x_res(end-1);
    h = x_res(end);
    poles = new_poles;
end