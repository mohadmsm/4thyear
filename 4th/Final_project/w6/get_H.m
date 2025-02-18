function H = get_H(F_end, N)
    f_step = 10;

    section_edges = linspace(0, F_end, N+1);
    H_total = @(s) 0;
    
    for i = 1:N
        f_start = section_edges(i);
        f_end_section = section_edges(i+1);

        f_i = f_start:f_step:f_end_section;        
        % Avoid empty frequency vectors if f_start == f_end_section
        if isempty(f_i)
            f_i = f_end_section;
        end

        w_i = 2 * pi * f_i;
        s_i = 1i * w_i;

        vo_i = 1 ./ cosh(400 * sqrt(1e-10 * s_i) .* sqrt(0.1 + 2.5e-7 * s_i));

        H_prev_eval = H_total(s_i);        
        vo_residual = vo_i - H_prev_eval;
        [Hi] = generate_yp2(real(vo_residual), imag(vo_residual), w_i);
        
        % Update the total transfer function
        H_total = @(s) H_total(s) + Hi(s);
    end

    H = @(s) (H_total(s)) * 30 ./ s;
end