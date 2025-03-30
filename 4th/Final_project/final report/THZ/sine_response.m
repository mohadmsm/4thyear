function [ y_sin,t]=sine_response(poles,residues,t)

dt = t(2) - t(1);
omega = 2*pi*100e9;
% Poles and residues (assumed known)
% e.g. poles = [...];  residues = [...];
% (User must supply these from the system analysis.)

% Allocate output arrays
y_sin = zeros(size(t));
y_state = zeros(length(poles), 1);

% Recursive convolution
for n = 2:length(t)
    dt = t(n) - t(n-1);
    exp_term = exp(poles * dt);
    
    % Input at previous time point (zero-order hold)
    input_val = sin(omega * t(n-1));
    
    for i = 1:length(poles)
        % Update the i-th state
        y_state(i) = ...
            y_state(i) * exp_term(i) + ...
            residues(i) * (1 - exp_term(i)) / (-poles(i)) * input_val;
    end
    
    % Sum contribution of all poles
    y_sin(n) = sum(y_state);
end
end