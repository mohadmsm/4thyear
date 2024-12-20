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
% Note 180 - (PM_desired_deg + margin_of_safety) = -1 * current phase angle
% needs( intrest pint)
% -(180-40-10) = -130, then from the bodeplot find wcnew
% step 4, find new_mag(original magnitude at wcnew), 20log10k|G(jwcnew)|
wcnew = 0.872;
% from the plot at -130 Deg
w = wcnew;
G = @(s) 1./(s*(s+2)*(s+3));
z=20*log10(k*abs(G(1j*w))); %from the note , find new mag
new_mag =z;

% Step 5, determine \beta so that the compensated magnitude is 0dB at new_wm
%%
beta = 10^(-1*new_mag/20); % needs to less than 1, if not then wrong

% step 6 find tau from 1/(B*tau) = wcnew/10
tau = 10/(beta*wcnew);
%step 7 
sys_c = tf([k*tau*beta k],[tau 1] );
openloop = feedback(series(sys_c,sys_G),1);
margin(openloop)


%%
clear all
clc
%os =5/100;
%zeta = sqrt(log(os)^2)/sqrt(log(os)^2+pi^2);

a = 1:0.5:6;
zeta = a./8;
os = 100*exp(-pi*zeta./sqrt(1-zeta.^2));
plot(a, os);
ylabel("persentage os");

%%
clear all
clc
tstop = 5;
sys_G = tf([16],[1 5.52 0]);

open("q3biii.slx");
sim("q3biii.slx")
plot(tout,yout);
yss = mean(yout(901:end));
[maxout, indtp] = max(yout);
os = 100*(maxout-yss)/yss;
%%
clear all
clc
tstop =25;
k = 2.25;
sys_G = tf([k],[1 1 -2]);
stepinfo(feedback(sys_G,1))
open("q3biii.slx");
sim("q3biii.slx");
plot(tout,yout);
%[yout,tout]=step(sys_G,tstop);
%secon order rise time is 0 to 100% and sattle time 2%
yss = mean(yout(901:end));
i_hi = find(yout>=yss*0.9,1,"first");
i_hl = find(yout>=yss*0.1,1,"first");

tr = tout(i_hi)-tout(i_hl);
% setteling time 
i_hl = find(yout<=yss*0.98,1,'last');
i_hi = find(yout>=yss*1.02,1,'last');
i_ts = max(i_hi,i_hl);
ts = tout(i_ts);

%%
% phase lag Q1C
clear all
clc
sys_G = zpk([], [0 -1 -2],5);
%find K from ess , k = 120,
k =50;
%plot it 
margin(series(sys_G,k));
% find point of intrest  = -1(180 -PM - margin of safty)
PM = 40;
pointOfIntrest = -1*(180-PM-10);
%find wcnew from the plot using the point 
wcnew = 0.485;
% find Beta from , 20logB = 20log|D(jwcnew)|
% defind D
D= @(s) 5./(s.*(s+1).*(s+2));
mag_lag = 20*log10(abs(k*D(1j*wcnew)));
Beta = 10^(-mag_lag/20);
%find tau , 1/Btau = w_cnew/10
tau = 10/(wcnew*Beta);
sys_c = k*tf([tau*Beta 1],[tau 1]);
%plot it to check 
margin(series(sys_c,sys_G))
