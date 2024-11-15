%%Week 10 exercise 

sys_G = zpk([],[0 -1 -6],30);

% using Ess = lim s=0 S.Es, Es = 1/1+GC , C= K , 

K = 1/3;
margin_safty = 6;
sys_kG = series(K,sys_G);
%margin(sys_kG);
% the uncompensated phase margin is 31.8 , upm
upm = 31.8;
per_os = 29;
c = per_os/ 100;
zeta = sqrt(log(c)^2)/sqrt((log(c))^2+pi^2); %zeta = 0.3666
% find Pm desired , section 9 pg10 
PM_desired = atan(2*zeta/sqrt(-2*zeta^2+sqrt(1+4*zeta^4)));% in rad
% we want it in deg
PM_desired_deg = PM_desired *180/pi;
Pim_Lead = PM_desired_deg - upm + margin_safty;% phi
% step 4 find alph where sin(pim) = (alpha - 1)/(alpha + 1)
% pim must be in rad 
Pim_Lead_rad = Pim_Lead / (180/pi);
alpha = (sin(Pim_Lead_rad)+1)/(1-sin(Pim_Lead_rad));
% step 5 
lead_wm = -10*log10(alpha); % in db then check this form the plot and get Wm .
% so Wm = 1.29 rad
% find tau , where wm = 1/(sqrt(alpha) * tau)
Wm = 1.29;
tau = 1/(sqrt(alpha)*Wm);
sys_c = K * tf([alpha*tau 1],[tau 1]);
sys_cG = series(sys_c,sys_G);

margin(sys_kG)
hold on
margin(sys_cG)
hold off
sys_C = zpk([-1/(alpha*tau)],[-1/tau],K * alpha);
