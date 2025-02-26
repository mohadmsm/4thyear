clear
clc
f = 9e5;
f = linspace(0,f,100);
w = 2*pi*f;
s=1i*w;
vo = 1./(cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[H,num,deno] = generate_yp2(real(vo(1:15)),imag(vo(1:15)),w(1:15));
[A,B,C,D] = create_state_space(num,deno);
[poles1,mo1,h1] = AWE_poles(A,B,C,D,0);
H_diff = vo(15:20)-H(s(15:20));
[H2,num2,deno2] = generate_yp2(real(H_diff),imag(H_diff),w(15:20));
[A,B,C,D] = create_state_space(num2,deno2);
[poles2,mo2,h2] = AWE_poles(A,B,C,D,w(15));
poles = [poles1(1),poles2(1)];
r_moments= [mo1(2),mo2(2)];
approx_order = length(B);
V = zeros(approx_order);
for i = 1:approx_order
   for j = 1:approx_order
      V(i, j) = 1 / (poles(j))^(i-1);
   end
end
A_diag = diag(1 ./ (poles));
%r_moments = moments(1:approx_order);
residues = -1 * (A_diag \ (V \ r_moments'));
s0 = i*w(15);
h_s =@(so) 0;
for i = 1:length(poles)
    h_s =@(so) h_s(so) + residues(i)./((so+s0)-poles(i));
end
h = @(s) h_s(s) *30./s;
first = @(s) h1(s)*30./s;
hf = @(s) h(s)+first(s);
h12 = @(s) H(s)+H2(s);
plot(f,h(s),f,vo*30./s)
%{
vo =@(s) 30./(s.*cosh(400.*(0 + 1e-10.*s).^(1/2).*(0.1 + 2.5e-7.*s).^(1/2)));
[y,t]=niltcv(hf,20e-6,'p1');
[y1,t1]=niltcv(first,20e-6,'ppp');
%[y2,t2]=niltcv(vo,20e-6,'ppp');
plot(t,y,t,y1)
grid on
%}
%{
[h_impulse,HAWEj, yi, ti] = AWE2(A,B,C,D,w(range(1)),30,50e-6);
%}
%RMSE = sqrt(sum((y0-y1).^2)/length(y1));
%{
    q = length(B);
    num_moments = 2 * q;
    s0=1i*w;
    moments = zeros(1, num_moments);
    [r,c]=size(C);
    if r~=1
        C= C';
    end
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C * (s0 * eye(size(A)) - A)^-(k) * B;
    end
    moments(1)=moments(1)+D;
    approx_order = length(B);

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end

    % Solve for denominator coefficients
    b_matrix = moment_matrix^-1 * Vector_c;

    % Compute poles
    poles = roots([b_matrix', 1]);
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1 / (poles(j))^(i-1);
        end
    end

    A_diag = diag(1 ./ (poles));
    r_moments = moments(1:approx_order);
    residues = -1 * (A_diag \ (V \ r_moments'));

    % Impulse response
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues(i) * exp(poles(i) * t);
    end
    h_s =@(s) 0;
    for i = 1:length(poles)
        h_s =@(s) h_s(s) + residues(i)./((s-s0)-poles(i));
    end
%}
%}
%%
%poles
