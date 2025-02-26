
% ------------------ Plotting into 3D graphs ------------------
function plott3(t,ft)
global x; % x must be global in F
 m=length(t); tgr=[1:m/64:m,m]; % 65 time points chosen
 figure; mesh(t(tgr),x,real(ft(:,tgr)));
 figure; mesh(t(tgr),x,imag(ft(:,tgr)));
