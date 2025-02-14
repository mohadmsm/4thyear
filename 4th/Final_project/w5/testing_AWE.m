clear
clc
% test AWE
A = [-2, 1, 0, 0; 1, -2, 1, 0; 0, 1, -2, 1;0, 0, 1, -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
D = 0;
t_end = 2;
wo = 10*pi;
[h,y,t]=AWE(A,B,C,D,wo,t_end);
plot(t,h)
xlabel('time s')
ylabel('H(t)')
title(['Impulse response at w= ', num2str(wo)]);
grid on