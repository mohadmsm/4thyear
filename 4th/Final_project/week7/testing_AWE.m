clear
clc
% test AWE
A = [-2, 1, 0, 0; 1, -2, 1, 0; 0, 1, -2, 1;0, 0, 1, -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
D = 0;
sys = ss(A,B,C',D);
t = linspace(0, 5, 1000);
[y1,t1]=impulse(sys,t);
t_end = 2;
wo = 0;
M = 6;
[h2, y_step, t,p1]= AWE_CFH(A, B, C, D, M,wo, 1, 5);
[h3, ~, y_step_old, t2,p2] = AWE2(A, B, C, D, wo, 1, 5);
plot(t,y_step,t1,y1)
xlabel('time s')
ylabel('H(t)')
title(['Impulse response at w= ', num2str(wo)]);
grid on
RMSE = sqrt(sum(abs(h2-y1').^2)/length(y1));
RMSE2 = sqrt(sum(abs(h3-y1').^2)/length(y1));

