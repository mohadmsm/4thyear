clear all
clc
l = 400;
N = 2;
dz = l/N;
R = 0.1*dz;
L = 2.5e-7*dz;  
C = 1e-10*dz;      
Rs = 0;       
Vs  = 30; % this is u
A = [-(Rs+R)/L, -1/L, 0   , 0   ;
       1/C    ,  0  , -1/C, 0   ;
    0         , 1/L , -R/L, -1/L;
    0         , 0   , 1/C , 0  ];
B = [1/L;0;0;0];
C = [0;0;0;1];
q = length(B);
moments = zeros(1,2*q-1);
for i=1:length(moments)
    moments(i) = -1*transpose(C)*A^-i*B;
end
%for first order approximation (Case 1)
b = -moments(2)/moments(1);
%the poles
p = -1/b;
% residues
k=-moments(1)*p;
%t = 
%hense 
t = 0:1e-10:20e-6;
ht1 = k*exp(p*t);
%Case 2
m2 = [moments(1),moments(2);moments(2),moments(3)];
m2_2 = -1*[moments(3);moments(4)];
b_case2 = m2^-1*m2_2;
p_case2 = roots([b_case2(1),b_case2(2),1]);
%residues
V = [1 1 ;1/p_case2(1) 1/p_case2(2)];
A_case2 = [1/p_case2(1) 0;0 1/p_case2(2)];
k_case2 = -1* inv(A_case2) * inv(V) * [moments(1);moments(2)];
% hence the final expersion is 
ht_case2 = k_case2(1)*exp(p_case2(1)*t)+k_case2(2)*exp(p_case2(2)*t);
figure(1)
plot(t,ht1);
grid on
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title(['RLC with AWE first order at N = ',num2str(N)]);
figure(2)
plot(t,ht_case2);
grid on
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title(['RLC with AWE second order at N = ',num2str(N)]);
%case 3
m_case3 = [moments(1),moments(2),moments(3);
           moments(2),moments(3),moments(4);
           moments(3),moments(4),moments(5)];
m3_case3 = [moments(4);moments(5);moments(6)];
b_case3 = m_case3^-1*m3_case3;
p_case3 = roots([b_case3(1),b_case3(2),b_case3(3),1]);
V_case3 = [1 , 1 , 1;
           1/p_case3(1), 1/p_case3(2), 1/p_case3(3);
           1/(p_case3(1)^2), 1/(p_case3(2)^2), 1/(p_case3(1)^2)];
A_case3 = [1/p_case3(1), 0, 0;
            0 , 1/p_case3(2), 0;
            0 ,    0,   1/p_case3(3)];
k_case3 = -1* inv(A_case3) * inv(V_case3) * [moments(1);moments(2);moments(3)];
t = 0:1e-11:20e-6;
ht_case3 = k_case3(1)*exp(p_case3(1)*t)+k_case3(2)*exp(p_case3(2)*t)+k_case3(3)*exp(p_case3(3)*t);
figure(3)
plot(t,ht_case3);
grid on
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title(['RLC with AWE Third order at N = ',num2str(N)]);

%% testing with diffrent N using ode45
clear
clc
clear all
clc
N = 2; % Number of sections in the transmission line
l = 400 ;
dz = l/N ;
L = 2.5e-7 *dz;
C = 1e-10 *dz;  
G = 0;
R = 0.1 * dz;      
Rs = 0;       
RL = 100;     
Vs  = 1;  
t = 0:1e-10:20e-6;
y0 = zeros(2 * N, 1);
[t, y] = ode45(@(t, y) fline_noR(t, y, N, L, C, R, Rs, RL, Vs), t, y0);
plot(t, y(:,N*2));
xlabel('Time (\mus)');
ylabel('V Load (Volts)');
title(['RLC with ODE45 at N = ',num2str(N)]);
grid on;
