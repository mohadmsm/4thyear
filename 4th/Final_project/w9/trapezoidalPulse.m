function v = trapezoidalPulse(t)
    % Define pulse parameters
    T_r = 1e-12;   % Rise time (1 ps)
    T_p = 5e-12;   % High-level duration (5 ps)
    T_total = 2*T_r + T_p;  % Total pulse duration (7 ps)
    
    % Piecewise definition of the pulse
    if t < 0
        v = 0;
    elseif t < T_r
        % Linear rise: from 0 to 1 V over T_r
        v = t / T_r;
    elseif t < T_r + T_p
        % Constant high level at 1 V
        v = 1;
    elseif t < T_total
        % Linear fall: from 1 V back to 0 over T_r
        v = (T_total - t) / T_r;
    else
        v = 0;
    end
end
