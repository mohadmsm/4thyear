%% Q1(C) phase lag
% Es = 0.05, phase margin>= 40, margin os = 10
% C(s) = k.(B*tau*s+1)/(tau*s+1), B>1
clear all, clc
sys_g = zpk([],[0 -2 -3],1);
% step 1 find K = 120
k=120;
margin_safty = 10;
margin(series(k,sys_g))
% find zeta, We know PM, S9_p10
%PM = atan(2*zeta/sqrt(-2*zeta^2+sqrt(1+4*zeta^4)));% in rad
term = 1/((4+2*(tan(40*pi/180))^2)^2-4);
zeta = nthroot(term,4);
% Note 180 - PM_desired_deg - margin_of_safety = -1 * current phase angle needs
% -(180-40-10) = -130, then from the bodeplot find wcnew
% step 4, find new_mag(original magnitude at wcnew), 20log10k|G(jwcnew)|
wcnew = 0.872; % from the plot at -130 Deg
G = @(s) 1./(s*(s+2)*(s+3));
z=20*log10(k*abs(G(1j*w))); %from the note , find new mag
new_mag =z;

% Step 5, determine \beta so that the compensated magnitude is 0dB at new_wm
%%
beta = 10^(-1*new_mag/20); % needs to less than 1, if not then wrong

% step 6 find tau from 1/(B*tau) = wcnew/10
tau = 10/(beta*wcnew);
%step 7 
sys_c = tf([k*tau*beta k],[tau 1] )

