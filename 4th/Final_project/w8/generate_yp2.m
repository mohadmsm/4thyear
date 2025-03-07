function [H_impulse,num,deno]=generate_yp2(realV,imagV,wo)
Yr = realV;  % Real part of Y11
Yi = imagV; % Imaginary part of Y11
w = wo; 
A = [];
C = [];
% Loop through each frequency point to construct A and C
A = [];
C = [];
% Loop through each frequency point to construct A and C
for k = 1:length(w)
    wk = w(k);
    Yr_k = Yr(k);
    Yi_k = Yi(k); 
    % Construct rows for A and C
    A_row1 = [-1, Yr_k, 0, -wk*Yi_k]; % Real part 
    A_row2 = [0, Yi_k, -wk, wk*Yr_k]; % Imaginary part 
    
    % Append to A
    A = [A; A_row1; A_row2];    
    % C
    C_row1 = wk^2 * Yr_k; % Real part
    C_row2 = wk^2 * Yi_k; % Imaginary part   
    % Append to C
    C = [C; C_row1; C_row2];
end

% Solve for B = [a0; b0; a1; b1]
B = A \ C;
D=0;
% get cof
a0 = B(1);
b0 = B(2);
a1 = B(3);
b1 = B(4);
num = [a1,a0];
deno = [1,b1,b0];
% generated H
H_impulse =@(s) (a1*s+a0)./(s.^2+b1*s+b0);
end
