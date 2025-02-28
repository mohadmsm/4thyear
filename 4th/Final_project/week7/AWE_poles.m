function [poles, moments,h_s] = AWE_poles(A,B,C,D,w)   
    q = 10;
    num_moments = 2 * q;
    s0=1i*w;
    moments = zeros(1, num_moments);
    [r,c]=size(C);
    if r~=1
        C= C';
    end
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C * (s0 * eye(size(A)) - A)^-(k) * B;
    end
    moments(1)=moments(1)+D;
    approx_order = q;

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end

    % Solve for denominator coefficients
    b_matrix = moment_matrix^-1 * Vector_c;

    % Compute poles
    poles = roots([b_matrix', 1]);
    
    % Compute residues
    V = zeros(length(poles));
    for i = 1:length(poles)
        for j = 1:length(poles)
            V(i, j) = 1 / (poles(j))^(i-1);
        end
    end

    A_diag = diag(1 ./ (poles));
    r_moments = moments(1:approx_order);
    residues = -1 * (A_diag \ (V \ r_moments'));
    poles = poles+s0;
    % Impulse response
    h_s =@(s) 0;
    for i = 1:length(poles)
        h_s =@(s) h_s(s) + residues(i)./((s-s0)-poles(i));
    end

end