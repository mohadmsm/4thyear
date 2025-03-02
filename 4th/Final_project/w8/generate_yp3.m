function [H_impulse, num, deno] = generate_yp3(realV, imagV, wo)
    Yr = realV;
    Yi = imagV;
    w_max = max(wo);  % Frequency scaling
    w_scaled = wo / w_max;  % Normalize frequencies to [0, 1]
    
    A = [];
    C = [];
    for k = 1:length(wo)
        wk = w_scaled(k);
        Yr_k = Yr(k);
        Yi_k = Yi(k);
        
        % Scaled equations (avoid wk^3 dominance)
        A_row1 = [-1, Yr_k, 0, -wk*Yi_k, wk^2, -Yr_k*wk^2];
        A_row2 = [0, Yi_k, -wk, wk*Yr_k, 0, -Yi_k*wk^2];
        A = [A; A_row1; A_row2];
        
        % Scale RHS by wk^3 (compensate for normalization)
        C = [C; -wk^3 * Yi_k * w_max^3; wk^3 * Yr_k * w_max^3];
    end
    
    % Regularized solve
    lambda = 1e-3;  % Adjusted regularization
    B = (A' * A + lambda * eye(6)) \ (A' * C);
    
    % Extract coefficients and reverse scaling
    a0 = B(1); b0 = B(2); a1 = B(3); b1 = B(4); a2 = B(5); b2 = B(6);
    deno = [1, b2/w_max, b1/w_max^2, b0/w_max^3];  % Reverse frequency scaling
    num = [a2/w_max^2, a1/w_max, a0];  % Scaling adjustments
    
    H_impulse = @(s) (num(1)*s.^2 + num(2)*s + num(3)) ./ ...
        (s.^3 + deno(2)*s.^2 + deno(3)*s + deno(4));
end