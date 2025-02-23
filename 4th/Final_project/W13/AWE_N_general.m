clear
clc
Rs =0;
Rdz = 5;
Ldz = 2;
Cdz =10;
N = 4;
numStates = 2 * N; % Each section has 2 states (current and voltage)
A = zeros(numStates, numStates);% Initialize A matrix
for i = 1:N
    if i == 1
        A(1, 1) = -(Rs + Rdz) / Ldz; % firs term (Rs + Rdz)
    else
        A(2*i-1, 2*i-1) = -Rdz / Ldz;
    end
    if i > 1
        A(2*i-1, 2*(i-1)) = 1 / Ldz;
        A(2*i-1, 2*i) = -1 / Ldz;
    end
    if i < N
        A(2*i-1, 2*i) = -1 / Ldz;
        A(2*i, 2*i-1) = 1 / Cdz; 
        A(2*i, 2*i+1) = -1 / Cdz; 
    else
        A(2*i, 2*i-1) = 1 / Cdz; 
    end   
end
% Initialize B matrix
B = zeros(numStates, 1);
B(1) = 1 / Ldz; 
%C matrix
C = zeros(1, numStates);
C(end) = 1; 