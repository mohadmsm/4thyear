clc
syms s Z Y l Vs L C Rs

% Define the state-space matrix for the TL
M = [0, -Z; -Y, 0];
% Compute the state transition matrix phi(l) = expm(M*l)
phi = expm(M*l);

% Extract submatrices of phi
Phi_11 = phi(1,1);
Phi_12 = phi(1,2);
Phi_21 = phi(2,1);
Phi_22 = phi(2,2);

% At the source, the effective voltage is:
% V(0,s) = Vs - Rs*I(0,s)
V0 = Vs / (1 - Rs * Phi_22^-1 * Phi_21);

% The load voltage V(l,s) is then:
V_l_s = (Phi_11 - Phi_12 * Phi_22^-1 * Phi_21) * V0;
V_l_s = simplify(V_l_s)
vl = Phi_11 *Vs+Phi_11*Phi_21*Rs*Vs/(Phi_22-Phi_21*Rs)-Phi_12*Phi_21*Vs/(Phi_22-Phi_21*Rs);