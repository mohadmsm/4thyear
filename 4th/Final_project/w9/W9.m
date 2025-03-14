clear
clc
% Generate frequency points
f = linspace(0, 9e5, 100);
w = 2*pi*f;
s = 1i * w;
t = 50e-6;
first_idx = 1:10;
vo =1./(cosh(400.*(1e-10.*s).^(1/2).*(0.1+2.5e-7.*s).^(1/2)));
[H1a,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H1,~,~,p1,m1]=AWE2(A,B,C,D,0,30,t);% to compare it with the results
[p1,np1,r1,m1] = AWE_poles(A,B,C,D,w(first_idx(1)));
%second model ----------------------------------------------------------
idx = 11:15; % f = 9.09e4 : 1.2727e+05
H_diff = vo(idx)-H1a(s(idx));
[H2a,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
%[H2a,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[p2,np2,r2,m2] = AWE_poles(A,B,C,D,w(idx(1))*i);
test_poles = [p1',p2'];
% remove unstable poles 
for i=1:length(test_poles)
if real(test_poles(i))<0
    ptest(i) = test_poles(i);
end
end
moments = m1; % moments from the first model has 1 value and zeros
[hs,r]= generate_hs(ptest,length(ptest),moments);
RMSE_idx = 1:25;
R1 = RMSE(hs(s(RMSE_idx)),vo(RMSE_idx));
R2 = RMSE(H1a(s(RMSE_idx)),vo(RMSE_idx));
plot(f,hs(s),f,vo,f,H1a(s),'ro');
legend('result','exact','first model');
xlabel('f (Hz)')

