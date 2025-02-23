function df = fline_noR(t, y,N,L,C,R,Rs,Vs)
    % coudn't find a use for t maybe if the source is a sin or cos 
    df = zeros(2 * N, 1);  
    % Currents and voltages
    In = y(1:2:2*N);  % Currents
    Vn = y(2:2:2*N);  % Voltages
    % Boundary conditions at the source end (n=1)
    df(1) = (-1 / L) * Vn(1) - (Rs + R) / L * In(1) + (1 / L) * Vs;  % dI1/dt
    df(2) = (1 / C) * In(1) - (1 / C) * In(2);  % dV1/dt   
    % Interior sections (n=2 to N-1)
    for n = 1:N-1
        df(2*n + 1) = (-1 / L) * Vn(n+1) - R / L * In(n)+(1 / L) * Vn(n);  % dIn/dt
        df(2*n) = (1 / C) * In(n) - (1 / C) * In(n+1);  % dVn/dt
    end
    %df(2*N-1) = 0; % no inducatnce so =0
    df(2*N-1) = (-1 / L) * Vn(N) - R / L * In(N) + (1 / L) * Vn(N-1);
    df(2*N) = (1 / C) * In(N);  % dVN/dt (voltage at the load)
end