function x_t = NILT_approximation(X_func, t, M)

    [poles,residues] =  R_Approximation(M);
    % Initialize the approximation sum
    x_t_sum = 0;
    % Loop through each pole-residue pair
    for i = 1:M
        p_i = poles(i);
        k_i = residues(i);
        
        % Evaluate X(s) at s = p_i / t
        X_value = X_func(p_i / t);
        

        x_t_sum = x_t_sum +  real(k_i * X_value ) ;
    end
    %x_t_sum = x_t_sum + additional_term;
    % Compute the final approximation
    x_t = - (1 / t) * x_t_sum;
end