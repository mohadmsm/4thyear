function [Q, R, H_strictly_proper] = proper(N, D)
    % N: Coefficients of numerator polynomial
    % D: Coefficients of denominator polynomial
    % Q: Quotient polynomial (improper part)
    % R: Remainder polynomial (strictly proper part)
    % H_strictly_proper: Transfer function with strictly proper form

    % Perform polynomial division
    [Q, R] = deconv(N, D);

    % Construct the strictly proper transfer function
    H_strictly_proper = tf(R, D);

    % Display results
    H_strictly_proper
end
