clear all, close all, clc
%%NILT0 with no time stepping and M equal to low value 
R = 0;        
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
vs = 30; 
t=20e-6;
M = 2;
Vo = @(s) vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2))); % simplified version 
NILT0(Vo,t,M);
%niltv(Vo,20e-6,'pl1');
%%
clear,
clc,
% state space for RLC ladder (Uniform TL) R,L,C and G stays the same.
% define vars
%

syms s Z Y l Vs L C Rs

% define M and N
M = [0 -Z; -Y 0];
N = [0 L; C 0];
%}
% define phi = e^M*l
phi = expm(M* l);
% Extract submatrices from phi

Phi_11 = phi(1, 1);
Phi_12 = phi(1, 2); 
Phi_21 = phi(2, 1); 
Phi_22 = phi(2, 2); 
I = Phi_21 * Vs - Phi_22^-1;
q = Vs - Rs*I;
% assuoming open circuit, I(l,s) = 0 Then V(l,s)
V_l_s = Phi_11 * q - Phi_12 * Phi_22^-1 * Phi_21 * q;

%I used syms toolbox to get a simplified expersion for V_l_s in term of
%Z,Y,Vs and l. in the S domain as follow 
%V_l_s =@(s) (2*Vs*exp(l*(Y*Z)^(1/2)))/(exp(2*l*(Y*Z)^(1/2)) + 1);

%%
clear
clc
R = 1200;          % Resistance per unit length (Ω/m)
L = 250e-9;        % Inductance per unit length (H/m)
C = 1e-10;         % Capacitance per unit length (F/m)
Rs = 10;           
G = 0;            
l = 150e-6;        % Length of the transmission line 
Z =@(s) R + s*L;
Y =@(s)  G + s*C;
Vs = @(s) 1./s;
vo =@(s) (2.*exp(l.*(Y(s).*Z(s)).^(1/2)).*(Y(s).*Z(s)).^(1/2))./((Y(s).*Z(s)).^(1/2) - Rs.*Y(s) + exp(2*l.*(Y(s).*Z(s)).^(1/2)).*(Y(s).*Z(s)).^(1/2) + Rs.*Y(s).*exp(2*l.*(Y(s).*Z(s)).^(1/2)));
%vo = @(s) sqrt(Y(s).*Z(s))./(sqrt(Y(s).*Z(s)).*cosh(l.*sqrt(Y(s).*Z(s))+Rs.*Y(s).*sinh(l.*sqrt(Y(s).*Z(s)))));
vo= @(s) vo(s)*1./s;
[y,t] = niltcv(vo,10e-12);
plot(t, y)
xlabel('time (s)');
ylabel('Vo');
grid on;
%%
clear
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

% For an open-circuit load, I(l,s)=0 implies:
% I(0,s) = -Phi_22^-1 * Phi_21 * V(0,s)
%
% At the source, the effective voltage is:
% V(0,s) = Vs - Rs*I(0,s)
% Substitute I(0,s) = -Phi_22^-1 * Phi_21 * V(0,s):
%   V(0,s) = Vs + Rs*Phi_22^-1*Phi_21*V(0,s)
% => V(0,s)*(1 - Rs*Phi_22^-1*Phi_21) = Vs
% => V(0,s) = Vs/(1 - Rs*Phi_22^-1*Phi_21)
V0 = Vs / (1 - Rs * Phi_22^-1 * Phi_21);

% The load voltage V(l,s) is then:
V_l_s = (Phi_11 - Phi_12 * Phi_22^-1 * Phi_21) * V0;
V_l_s = simplify(V_l_s)
