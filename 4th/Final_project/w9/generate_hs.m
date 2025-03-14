function [h_s,residues]= generate_hs(poles,q,moments)
    approx_order =q;
    
    % Compute residues using given poles and moments
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1 / (poles(j))^(i-1);
        end
    end
    A_diag = diag(1 ./ poles);
    r_moments = moments(1:approx_order);
    residues = -A_diag \ (V \ r_moments(:));
    
    % Transfer function in s-domain
    h_s = @(s)0;
    for i =1:length(poles)
        h_s = @(s) h_s(s)+residues(i) ./ (s - poles(i));
    end
end