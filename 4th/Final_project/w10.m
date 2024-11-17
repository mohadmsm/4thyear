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
clear all, clc, close all
% state space for RLC ladder (Uniform TL) R,L,C and G stays the same.
% define vars
%syms s Z Y l Vs
R = 0.1;        
L = 2.5e-7;     
G = 0;       
C = 1e-10;    
l = 400;   
Vs = 30;
Z =@(s) R + s*L;
Y =@(s)  G + s*C;
%}
% define M and N
%M = [0 -Z; -Y 0];
%N = [0 L; C 0];
%}
% define phi = e^M*l
%phi = expm(M* l);
% Extract submatrices from phi
%{
Phi_11 = phi(1, 1);
Phi_12 = phi(1, 2); 
Phi_21 = phi(2, 1); 
Phi_22 = phi(2, 2); 
%}
% assuoming open circuit, I(l,s) = 0 Then V(l,s)
%V_l_s = Phi_11 * Vs - Phi_12 * Phi_22^-1 * Phi_21 * Vs;

% I used syms toolbox to get a simplified expersion for V_l_s in term of
% Z,Y,Vs and l. in the S domain as follow 
%V_l_s =@(s) (2*Vs*exp(l*(Y*Z)^(1/2)))/(exp(2*l*(Y*Z)^(1/2)) + 1);

% convert Vs to s domin as if just const make it over s
V_l_s = @(s) (2*Vs./s.*exp(l*(Y(s).*Z(s)).^(1/2)))./(exp(2*l*(Y(s).*Z(s)).^(1/2)) + 1);
Vo = @(s) vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
M = 2;
t = 20e-6;
[Vo_RLC,t1]=NILT0(V_l_s,t,M);
[Vo_exact,t2]=NILT0(V_l_s,t,M);

%[Vo_RLC,t1]=niltcv(V_l_s,t,'plot');
%[Vo_exact,t2]=niltcv(V_l_s,t,'plot');

figure(1);
plot(t1, Vo_RLC, 'b'); % Blue line for Vo_RLC
%grid on
hold on;
plot(t2, Vo_exact, 'ro'); % Red circles for Vo_exact
hold off;
legend('RLC Ladder', 'Exact(Red Circles)', 'FontSize', 12, 'Location', 'Best');
xlabel('Time (t)');
ylabel('Voltage (Vo)');
title('Voltage Comparison: Exact TL vs. RLC Ladder using NILTcv');
grid on;

%}





