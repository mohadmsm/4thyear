clear
clc
f = 9e5;
f = linspace(0,f,100);
w = 2*pi*f;
s = i *w;
vo =1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[H,num,deno] = generate_yp2(real(vo(1:30)),imag(vo(1:30)),w(1:30));
[A,B,C,D] = create_state_space(num,deno);
[poles1, moments1] = AWE_poles(A,B,C,D,w(1));
H_diff = vo(30:45)-H(s(30:45));
[H2,num,deno] = generate_yp2(real(H_diff),imag(H_diff),w(30:45));
[A,B,C,D] = create_state_space(num,deno);
[poles2, moments2] = AWE_poles(A,B,C,D,w(30));
%-------------------------------------------------
poles = [poles1(1),poles2(1)];
moments = moments1;
approx_order = length(B);
V = zeros(approx_order);
for i = 1:approx_order
    for j = 1:approx_order
            V(i, j) = 1 / (poles(j))^(i-1);
     end
end
A_diag = diag(1 ./ (poles));%i tried with adding s0 here
r_moments = moments(1:approx_order);
residues = -1 * (A_diag \ (V \ r_moments'));
h_s =@(s) 0;
s0= i*w(20);
for i = 1:length(poles)
    h_s =@(s) h_s(s) + residues(i)./((s)-poles(i));
end
hs2 = @(s) (h_s(s)+H2(s))*30./s;
h12 = @(s) (H(s)+H2(s))*30./s;
hss =@(s) h_s(s) * 30./s;
vo1 =@(s) 30./(s.*cosh(400.*(1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(hs2,50e-6,'ppp');
[y1,t]=niltcv(h12,50e-6,'ppp');
[y2,t1]=niltcv(vo1,50e-6,'ppp');
plot(t,y,t,y1,t,y2);
plot(f,h_s(s),f,vo,f,H(s),f,H2(s))
plot(f,h_s(s)*30./s,f,vo*30./s,f,H(s)*30./s,f,H2(s)*30./s)
