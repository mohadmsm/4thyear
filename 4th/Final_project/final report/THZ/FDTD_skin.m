function [y,t]=FDTD_skin(Ro, Rs_skin, L, C, length, Rs, t_max)
NDZ = 100;          % Number of spatial steps
dz = length / NDZ;  % Spatial step
dt = 1e-17;         % Time step
t_steps = round(t_max / dt);
time = (0:t_steps-1)*dt;
V = zeros(NDZ+1, t_steps);
I = zeros(NDZ, t_steps);
Psi = zeros(NDZ, 3); % Auxiliary variables for convolution

% Vector fitting coefficients (example values)
alpha = dt * Rs_skin * [0.5, 0.3, 0.2]; % R_s * a_k
beta = [1e9, 5e9, 10e9]; % Poles b_k

% Source definition (e.g., unit step)
Vs = 1 * ones(1, t_steps);

for n = 1:t_steps-1
    V(1, n+1) = (Rs*C/2*dz/dt + 0.5)^-1 * ((Rs*C/2*dz/dt - 0.5)*V(1,n) - Rs*I(1,n) + 0.5*(Vs(n+1)+Vs(n)));
    for k = 1:NDZ
        if k > 1
            % Update auxiliary variables
            for m = 1:3
                Psi(k-1, m) = exp(beta(m)*dt) * Psi(k-1, m) + alpha(m) * I(k-1, n);
            end
            R_conv = sum(Psi(k-1, :), 2); % Sum over poles
            % Update current with frequency-dependent R
            I(k-1, n+1) = I(k-1, n) - (dt/(L*dz))*(V(k, n+1) - V(k-1, n+1)) ...
                          - (Ro*dt/L)*I(k-1, n) - (dt/L)*R_conv;
        end
    end
    V(NDZ, n+1) = V(NDZ, n) + dt*(I(NDZ-1, n)/(C*dz));
end
y = V(NDZ, :);
t = time;
end