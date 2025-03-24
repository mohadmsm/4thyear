clear
clc
% 2/s+2
f = 0:0.1:1;
w = 2*pi*f;
s = i*w;
time = 5;
t = linspace(0, time, 1000);
exact = 2./(s+2);
exact_impulse = 2*exp(-2*t);
[H,num,deno]=first_order_approximation(real(exact),imag(exact),w);
[A,B,C,D] = create_state_space(num,deno);
[y_impulse, ~, ~, t] = AWE2(A, B, C, D, w(1), 1, time);
plot(t,exact_impulse,t,y_impulse,"--")
grid on
R = RMSE(y_impulse,exact_impulse);