clear
clc
% Generate frequency points
f = linspace(0, 9e5, 100);
w = 2*pi*f;
s = 1i * w;
M = 6;
t = 50e-6;
first_idx = 1:15;
vo =1./(cosh(400.*(1e-10.*s).^(1/2).*(0.1+2.5e-7.*s).^(1/2)));
[H1a,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H1,~,~,p1,m1]=AWE3(A,B,C,D,0,30,t);
%[p1,np1,r1,m1] = AWE_poles(A,B,C,D,w(first_idx(1)));
%second model ----------------------------------------------------------
idx = 15:20;
H_diff = vo(idx)-H1a(s(idx));
[H2a,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
%[H2a,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H2,~,~]=AWE2(A,B,C,D,w(15),30,t);
[p2,np2,r2,m2] = AWE_poles(A,B,C,D,w(15));
% Third model ---------------------------------------------
idx = 31:40;
H_diff = vo(idx)-H2a(s(idx));
%[H3s,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[H3s,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H3,~,~,p3,m3]=AWE3(A,B,C,D,w(idx(1)),30,t);
%[p3,np3,r3,m3] = AWE_poles(A,B,C,D,w(1));
% Forth model ---------------------------------------------------
idx = 41:50;
H_diff = vo(idx)-H3s(s(idx));
[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
%[H4a,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[p4,np4,r4,m4] = AWE_poles(A,B,C,D,w(1));
[~,H4]=AWE2(A,B,C,D,w(idx(1)),30,t);
%}
pt = [p1',p2'];
ptest = 0;
% remove unstable poles 
for i=1:length(pt)
if real(pt(i))<0
    ptest = [ptest,pt(i)];
end
end
%ptest = [ptest(3:4),ptest(end)];
ptest = ptest(2:end);
%ptest = [ptest(2:3),ptest(end)];
mtest = [m1]; %% moments from the first model has 1 value and zeros
[~,hs,r]= generate_hs(ptest,length(ptest),mtest,w(1));
%hs = @(s) hs(s)+H1(s);
RMSE_idx = 1:25;
R1 = RMSE(hs(s(RMSE_idx)),vo(RMSE_idx));
R2 = RMSE(H1a(s(RMSE_idx)),vo(RMSE_idx));
plot(f,hs(s),f,vo,f,H1a(s),'ro');
legend('result','exact','first model');
xlabel('f (Hz)')
R1
R2
