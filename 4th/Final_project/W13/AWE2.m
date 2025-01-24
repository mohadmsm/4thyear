clear all
clc
l = 400;
N = 2;
dz = l/N;
R = 0*dz;
L = 2.5e-7*dz;  
C = 1e-10*dz;  
G = 0;     
Rs = 0;       
Vs  = 30;
A = [-R/L -1/L 0 0;1/C 0 -1/C 0;0 1/L -R/L -1/L;0 0 1/C 0];
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
%syms t
t = 0:1e-10:20e-6;
ht1 = k*exp(p*t);
%Case 2
m2 = [moments(1),moments(2);moments(2),moments(3)];
m2_2 = -1*[moments(3);moments(4)];
b_case2 = inv(m2)*m2_2;
p_case2 = roots([b_case2(1),b_case2(2),1]);
%residues
V = [1 1 ;1/p_case2(1) 1/p_case2(2)];
A_case2 = [1/p_case2(1) 0;0 1/p_case2(2)];
k_case2 = -1* inv(A_case2) * inv(V) * [moments(1);moments(2)];
% hence the final expersion is 
ht_case2 = k_case2(1)*exp(p_case2(1)*t)+k_case2(2)*exp(p_case2(2)*t);
