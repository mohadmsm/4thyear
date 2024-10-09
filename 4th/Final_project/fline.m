function df = fline(t, y)
    N = length(y) / 2;  % Number of sections
    L = 2.5e-7;   % Inductance
    C = 1e-10;    % Capacitance
    R = 50;       % Resistance per section
    Rs = 0;       % Source resistance
    Rl = 100;     % Load resistance
    Vs = 30;      % Source voltage (could be a function of time)

    df = zeros(2 * N, 1);  % Initialize derivatives
    
    % Boundary conditions at the source end (n=1)
    I1 = y(1);
    V1 = y(2);
    df(1) = (-1 / L) * V1 - (Rs + R) / L * I1 + (1 / L) * Vs;  % dI1/dt
    df(2) = (1 / C) * I1 - (1 / C) * y(3);  % dV1/dt
    
    % Iteratively calculate the interior sections (n=2 to N-1)
    for n = 2:N-1
        In = y(2*n - 1);
        Vn = y(2*n);
        In_next = y(2*n + 1);
        df(2*n - 1) = (-1 / L) * Vn - R / L * In;  % dIn/dt
        df(2*n) = (1 / C) * In - (1 / C) * In_next;  % dVn/dt
    end

    % Boundary conditions at the load end (n=N)
    IN = y(2*N - 1);
    VN = y(2*N);
    df(2*N - 1) = (-1 / L) * VN - (R + Rl) / L * IN;  % dIN/dt
    df(2*N) = (1 / C) * IN;  % dVN/dt
end
