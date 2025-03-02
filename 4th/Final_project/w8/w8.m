clear
clc
% Generate frequency points
f = linspace(0, 9e5, 100);
w = 2*pi*f;
s = 1i * w;
M = 6;
t = 50e-6;
first_idx = 1:15;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[Hi,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,H,y1,~,p1]=AWE_CFH(A,B,C,D,M,w(1),30,t);
[~,H,y1,~,p1]=AWE2(A,B,C,D,w(1),30,t);
%RMSE = sqrt(sum(abs(Hi(s(first_idx))-vo(first_idx)).^2)/length(vo(first_idx)));
%second model ----------------------------------------------------------
idx = 16:25;
%H_diff = vo(idx)-H(s(idx));
[Hi,num,deno] = generate_yp(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,H2,y2,~,p2]=AWE_CFH(A,B,C,D,M,w(16),30,t);
[~,H2,y2,~,p2]=AWE2(A,B,C,D,w(16),30,t);
% Third model ---------------------------------------------
idx = 26:35;
H = @(s) H(s)+H2(s);
%H_diff = vo(idx)-H(s(idx));
%[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[Hi,num,deno] = generate_yp(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,H3,y3,~,p3]=AWE_CFH(A,B,C,D,M,w(idx(1)),30,t);
[~,H3,y3,~,p3]=AWE2(A,B,C,D,w(idx(1)),30,t);
% Forth model ---------------------------------------------------
idx = 36:45;
H = @(s) H(s)+H3(s);
%H_diff = vo(idx)-H(s(idx));
%[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[Hi,num,deno] = generate_yp(real(vo(idx)),imag(vo(idx)),w(idx(1)));
[A,B,C,D] = create_state_space(num,deno);
%[~,H4,y4,t,p4]=AWE_CFH(A,B,C,D,M,w(idx(1)),30,t);
[~,H4,y4,t,p4]=AWE2(A,B,C,D,w(idx(1)),30,t);
%y_t = y1+y2+y3+y4;
f = @(s) 30 ./ (s.*cosh(400 .* sqrt((0.1 + 2.5e-7.*s) .* (0 + 1e-10.*s))));
[y1,t]=niltcv(f,50e-6);
%plot(t,y_t,t,y1);
%RMSE = sqrt(sum(abs(y_t-y1).^2)/length(y1));
poles = [p1',p2',p3',p4'];
apoles = 0;
for i =1: length(poles)
if real(poles(i))<0
apoles = [apoles,poles(i)];
end
end
apoles = apoles(2:end);