clear
clc
% Generate frequency points
f = linspace(0, 9e5, 100);
w = 2*pi*f;
s = 1i * w;
M = 6;
t = 50e-6;
first_idx = 1:20;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[Hi,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
[~,H1,y1,t1,p1]=AWE2(A,B,C,D,w(1),30,t);
[p1c,np1c,r1c,m1c] = AWE_CFH_poles(A,B,C,D,M,w(first_idx(1)));
[p1,np1,r1,m1] = AWE_poles(A,B,C,D,w(first_idx(1)));
%second model ----------------------------------------------------------
idx = 21:30;
%H_diff = vo(idx)-H(s(idx));
[H22,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,H2,y2,~,p2]=AWE_CFH(A,B,C,D,M,w(16),30,t);
[~,H2,y2,~,p2]=AWE2(A,B,C,D,w(16),30,t);
[p2c,np2c,r2c,m2c] = AWE_CFH_poles(A,B,C,D,M,w(idx(1)));
[p2,np2,r2,m2] = AWE_poles(A,B,C,D,w(idx(1)));
% Third model ---------------------------------------------
idx = 31:40;
H = @(s) H1(s)+H2(s);
%H_diff = vo(idx)-H(s(idx));
%[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[H33,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,H3,y3,~,p3]=AWE_CFH(A,B,C,D,M,w(idx(1)),30,t);
[~,H3,y3,~,p3]=AWE2(A,B,C,D,w(idx(1)),30,t);
[p3c,np3c,r3c,m3c] = AWE_CFH_poles(A,B,C,D,M,w(idx(1)));
[p3,np3,r3,m3] = AWE_poles(A,B,C,D,w(idx(1)));
% Forth model ---------------------------------------------------
idx = 41:50;
H = @(s) H(s)+H3(s);
%H_diff = vo(idx)-H(s(idx));
%[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[H44,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
%[~,H4,y4,t,p4]=AWE_CFH(A,B,C,D,M,w(idx(1)),30,t);
[~,H4,y4,t,p4]=AWE2(A,B,C,D,w(idx(1)),30,t);
[p4c,np4c,r4c,m4c] = AWE_CFH_poles(A,B,C,D,M,w(idx(1)));
[p4,np4,r4,m4] = AWE_poles(A,B,C,D,w(idx(1)));
H = @(s) H(s)+H4(s);
%y_t = y1+y2+y3+y4;
%f = @(s) 30 ./ (s.*cosh(400 .* sqrt((0.1 + 2.5e-7.*s) .* (0 + 1e-10.*s))));
%[y1,t]=niltcv(f,50e-6);
%plot(t,y_t,t,y1);
%RMSE = sqrt(sum(abs(y_t-y1).^2)/length(y1));
poles_c = [p1c,p2c,p3c,p4c];
poles_nc = [np1c,np2c,np3c,np4c];
poles = [p1,p2,p3,p4];
polesn = [np1,np2,np3,np4];
pt = [p3c',p2c',p1c'];
ptest = 0;
% remove unstable poles 
for i=1:length(pt)
if real(pt(i))<0
    ptest = [ptest,pt(i)];
end
end
ptest = ptest(2:end);
mtest = m1c; %% moments from the first model has 1 value and zeros
[hs,r]= generate_hs(ptest,length(ptest),mtest);
plot(f,hs(s),f,vo,f,H1(s));
%%
clear
clc
% Generate frequency points
f = linspace(0, 9e5, 100);
w = 2*pi*f;
s = 1i * w;
M = 6;
t = 50e-6;
first_idx = 1:20;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[H1,num,deno] = generate_yp2(real(vo(first_idx)),imag(vo(first_idx)),w(first_idx));
[A,B,C,D] = create_state_space(num,deno);
[p1c,np1c,r1c,m1c] = AWE_CFH_poles(A,B,C,D,M,w(first_idx(1)));
[p1,np1,r1,m1] = AWE_poles(A,B,C,D,w(first_idx(1)));
%second model ----------------------------------------------------------
idx = 21:30;
%H_diff = vo(idx)-H(s(idx));
[H2,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[p2c,np2c,r2c,m2c] = AWE_CFH_poles(A,B,C,D,M,w(idx(1)));
[p2,np2,r2,m2] = AWE_poles(A,B,C,D,w(idx(1)));
% Third model ---------------------------------------------
idx = 31:40;
%H_diff = vo(idx)-H(s(idx));
%[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[H3,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[p3c,np3c,r3c,m3c] = AWE_CFH_poles(A,B,C,D,M,w(idx(1)));
[p3,np3,r3,m3] = AWE_poles(A,B,C,D,w(idx(1)));
% Forth model ---------------------------------------------------
idx = 41:50;
%H_diff = vo(idx)-H(s(idx));
%[Hi,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(idx));
[H4,num,deno] = generate_yp2(real(vo(idx)),imag(vo(idx)),w(idx));
[A,B,C,D] = create_state_space(num,deno);
[p4c,np4c,r4c,m4c] = AWE_CFH_poles(A,B,C,D,M,w(idx(1)));
[p4,np4,r4,m4] = AWE_poles(A,B,C,D,w(idx(1)));
poles_c = [p1c,p2c,p3c,p4c];% poles from AWE_CFH with many moments
poles_nc = [np1c,np2c,np3c,np4c];% shifted poles
poles = [p1,p2,p3,p4]; % AWE with q = lenght(B)
polesn = [np1,np2,np3,np4]; %shifted poles
pt = [np3c',np2c',np1c'];
ptest = 0;
% remove unstable poles 
for i=1:length(pt)
if real(pt(i))<0
    ptest = [ptest,pt(i)];
end
end
ptest = ptest(2:end);
mtest = m1c; %% moments from the first model has 1 value and zeros
[hs,r]= generate_hs(ptest,length(ptest),mtest);
%plot(f,hs(s),f,vo,f,H1(s),'r*');