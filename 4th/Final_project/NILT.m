clear all,
clc
% Define the Laplace transform function
X_func = @(s) 1 ./ (s+1);

%time step  to evaluate around
M=15;
t = 0.01;
result = NILT_approximation(X_func,t,M);
fprintf('The approximation at t = %.2f is: %.4f\n', t, result);

%{
t = 0:0.001:0.1;

exact = exp(-4.*t);% X(t)
error = zeros(1,length(t)); 
result = zeros(1,length(t));
figure;
%only take the even M
for M= 2:2: 12
for n=1:length(t)
result(n) = NILT_approximation(X_func,t(n),M);
error(n) = abs(exact(n) - result(n));
end
%fprintf('The error at t = %.2f is: %.12f\n', t(n), error(n));

% for observation purpose 
subplot(3, 2, M/2); % Arrange subplots in a 3x2 grid
plot(t,error)
xlabel('time t in seconds')
ylabel('Error' )
title(['Error for M = ', num2str(M)]);

end
%}
%sgtitle('Error Analysis for Different Approximation Orders');
% Display the result
%fprintf('The approximation at t = %.2f is: %.4f\n', t, result);

