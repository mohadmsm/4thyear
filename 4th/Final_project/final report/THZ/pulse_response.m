function [ y_pulse,t]=pulse_response(poles,residues,t)
% Assume you have poles, residues, and time vector t as before
y_pulse = zeros(size(t));           % total output
y_i     = zeros(length(poles),1);   % states for each pole

for n = 2:length(t)
    dt = t(n) - t(n-1);
    % Evaluate the trapezoid input at t(n-1) and t(n)
    x_in_lo = trapezoidalPulse(t(n-1));
    x_in_hi = trapezoidalPulse(t(n));
    x_avg   = 0.5*(x_in_lo + x_in_hi);

    for i = 1:length(poles)
        p_i = poles(i);
        % "previous state" factor
        y_i(i) = exp(p_i*dt) * y_i(i);
        % add the integral piece ~ x_avg * [ (1 - e^{p_i dt})/(-p_i) ]
        if abs(p_i) > 1e-30
            y_i(i) = y_i(i) + residues(i) * x_avg * (1 - exp(p_i*dt))/(-p_i);
        else
            % If p_i ~ 0, handle that limit carefully (approx dt)
            y_i(i) = y_i(i) + residues(i) * x_avg * (dt);
        end
    end
    y_pulse(n) = sum(y_i);
end
