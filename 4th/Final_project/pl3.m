
%*************** PLOT3 – FUNCTION DEFINITION ****************%
function pl3
global ft t x;
m=length(t); tgr=[1:m/64:m,m];               % 65 time points
for k=1:size(ft,3)
    figure; mesh(t(tgr),x(k,:),ft(:,tgr,k));
    xlabel('t'); ylabel('x'); zlabel(strcat('f',num2str(k),'{t}'));
end

%***********************************************************************%