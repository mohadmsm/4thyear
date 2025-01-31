clear all
clc
% Input state-space matrices
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
B = [1/L;0;0;0].*30;
C = [0;0;0;1];
% Determine the order of the system
q = length(B);

% Compute moments
num_moments = 2 * q;
moments = zeros(1, num_moments);
for i = 1:num_moments
    moments(i) = -transpose(C) * (A^(-i)) * B;
end

% Generalized approximation for all orders
for approx_order = 1:q
    fprintf('Case %d:\n', approx_order);

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end
    % find b matrix (deno coef)
    b_matrix = inv(moment_matrix)*Vector_c;
    
    %find the ploes 
    poles = roots([transpose(b_matrix) ,1]);
    
    % determine residuses 
    % form the V matrix 
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1/poles(j)^(i-1);
        end
    end
    % form the A matrix 
    A_diag = diag(1 ./ poles);
    r_moments = moments(1:approx_order); % a helper matrix
    % find the residuse
    residues = -1*inv(A_diag)* inv(V)* transpose(r_moments);
    %set a value for t 
    %t=0:10;
    t = 0:1e-10:20e-6;
    %form the impulse response 
    h =0;
    for i = 1:approx_order
        h = h + residues(i) * exp(poles(i) * t);
    end
    % plot the output 
    figure(approx_order);
    plot(t,h);
    xlabel('Time (\mus)');
    ylabel('V Load (Volts)');
    title(['Apprximation of order',num2str(approx_order)]);
    grid on
end

%%
clear all
clc

%find the theyritical impulse response
%syms t
A = [-2 1 0 0; 1 -2 1 0; 0 1 -2 1; 0 0 1 -1];
B = [1; 0; 0; 0];
C = [1; 0; 0; 0];
C = transpose(C);
eat = @(t) expm(A.*t); 
y = @(t)mtimes(mtimes(C,eat(t)),B); 
t = 0:0.01:2;
y_values = arrayfun(@(t) y(t), t);

% Plot y(t)
plot(t, y_values);