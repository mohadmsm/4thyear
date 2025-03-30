function [ y_sin,t]=sine_response2(poles,residues,t)
f     = 100e9;             % Frequency of sine wave (Hz)
omega = 2*pi*f;
dt    = t(2) - t(1);
numPoles = length(poles);
y_sin = zeros(size(t));              % final output
y_i   = zeros(length(poles), 1);     % internal states for each pole
% main loop
for n = 2:length(t)
    dt = t(n) - t(n-1);
    for i = 1:length(poles)
        p_i = poles(i);
        % update y_i(n) = e^(p_i dt)*y_i(n-1) + residue * integral(...)
        y_i(i) = exp(p_i*dt)*y_i(i) ...
                 + residues(i)*conv_sine_term(p_i, omega, t(n-1), t(n));
    end
    % sum of all pole contributions
    y_sin(n) = sum(y_i);
end
end