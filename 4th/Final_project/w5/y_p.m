clear all
clc
% Define numerator coefficients of Y21 and Y22, and common denominator
num_Y21 =[2 3];
num_Y22 =[1 6];
den = [1 4 6];
N = -num_Y21;
D = num_Y22;
[Q,R]=deconv(N,D);
%%
clear all
clc
% Define numerator coefficients of Y21 and Y22, and common denominator
num_Y21 = [2 3];
num_Y22 = [1 6];
den = [1 4 5]; 
N = -num_Y21;
D = num_Y22;  
% Perform polynomial division to make it strictly proper
[Q, R] = deconv(N, D);
% check leading coefficient (assumed to be 1)
if D(1) ~= 1
    D=D/D(1);
    N = N/D(1);
    [Q, R] = deconv(N, D);
end
% Extract coefficients for state-space representation
g = D(2:end);  % Exclude leading coefficient ( g terms )
% f terms 
if R(1) ==0
    f=R(2:end);
else
    f = R; 
end
% Construct state-space matrices
n = length(g); % Order of system
A = [zeros(n-1,1), eye(n-1); -flip(g)];
B = [zeros(n-1,1); 1];
C = flip(f);
D = Q; 
A
B
C
D