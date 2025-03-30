function df = fline_noR(t, y, N, L, C, R, Rs, Vs)
    % Evaluate the source voltage at time t if Vs is a function handle.
    if isa(Vs, 'function_handle')
        Vs_val = Vs(t);
    else
        Vs_val = Vs;
    end

    % Similarly, check if R is time-dependent
    if isa(R, 'function_handle')
        R_val = R(t);
    else
        R_val = R;
    end

    df = zeros(2 * N, 1);  
    % Extract currents and voltages
    In = y(1:2:2*N);  % Currents
    Vn = y(2:2:2*N);  % Voltages

    % Boundary condition at the source end (n = 1)
    df(1) = (-1 / L) * Vn(1) - (Rs + R_val) / L * In(1) + (1 / L) * Vs_val;  % dI1/dt
    df(2) = (1 / C) * In(1) - (1 / C) * In(2);  % dV1/dt   

    % Interior sections (n = 2 to N-1)
    for n = 1:N-1
        df(2*n + 1) = (-1 / L) * Vn(n+1) - R_val / L * In(n) + (1 / L) * Vn(n);  % dIn/dt
        df(2*n)     = (1 / C) * In(n) - (1 / C) * In(n+1);  % dVn/dt
    end

    % Load end
    df(2*N-1) = (-1 / L) * Vn(N) - R_val / L * In(N) + (1 / L) * Vn(N-1);
    df(2*N)   = (1 / C) * In(N);  % dVN/dt (voltage at the load)
end
