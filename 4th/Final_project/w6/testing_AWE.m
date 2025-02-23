clear
clc
% test AWE
A = [-2, 1, 0, 0; 1, -2, 1, 0; 0, 1, -2, 1;0, 0, 1, -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
D = 0;
sys = ss(A,B,C',D);
t=0:0.1:2;
[h1,t1]=impulse(sys,t);
t_end = 2;
wo = 1;
[h,hs,y,t]=AWE(A,B,C,D,1,t_end);
plot(t,h,t1,h1)
xlabel('time s')
ylabel('H(t)')
title(['Impulse response at w= ', num2str(wo)]);
grid on
%%
clear
clc
num = [3 1];
deno = [1 5 6];
[A,B,C,D] = create_state_space(num,deno);
%%
clear
clc

