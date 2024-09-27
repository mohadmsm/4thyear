clear
clc
t = 0 : 0.01 : 10;
K = 50 :10 : 70;
Polynum = 1;
polyden = poly([-2 ; -3 ; -4 ]);
mytf = tf (Polynum,polyden);% 1 / (s+2)(s+3)(s+4)  use poly if you have roots and roots if not 
sysCGtf = series(K,mytf);
sysCLtfA = feedback (sysCGtf(1), 1 ); %H = 1
sysCLtfB = feedback (sysCGtf(2), 1 ); %H = 1
sysCLtfC = feedback (sysCGtf(3), 1 ); %H = 1
subplot(3,1,1)
step(sysCLtfA)
subplot(3,1,2)
step(sysCLtfB)
subplot(3,1,3)
step(sysCLtfC)
