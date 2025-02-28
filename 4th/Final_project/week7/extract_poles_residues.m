function [poles, residues] = extract_poles_residues(moments)
    % Construct Padé matrix 
    q = 8; 
    moment_matrix = zeros(q);
    for i = 1:q
        moment_matrix(i, :) = moments(i:i+q-1);
    end
    
    % Solve for denominator coefficients
    b = moment_matrix \ (-moments(q+1:2*q)');
    denominator = [flipud(b); 1]; % Denominator polynomial
    
    % Compute poles (roots of denominator)
    poles = roots(denominator);
    
    % Compute residues using moments and poles
    V = zeros(q);
    for i = 1:q
        for j = 1:q
            V(i, j) = 1 / poles(j)^(i-1);
        end
    end
    residues = V \ moments(1:q)';
end