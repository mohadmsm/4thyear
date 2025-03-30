function [y_step,t]=step_response(poles,residues,t)
% Poles and residues (assumed known)
y_step = zeros(size(t));
y = zeros(length(poles),1);
for n = 2:length(t)
    dt = t(n) - t(n-1);
    exp_term = exp(poles * dt);
    for i = 1:length(poles)
        y(i) = residues(i) * (1 - exp_term(i))/(-poles(i)) * 1 + exp_term(i) * y(i);
    end
    y_step(n) = sum(y);
end
end