clear all
clc
%find the approximation for any N,M values,
N = 0;
M = 2;
num = zeros(1,N+1);
deno = zeros(1,M);
for i=0:N
    ai_M_N = factorial(M+N-i)/factorial(M + N) * nchoosek(M, i);
    num(i+1)= ai_M_N ;
end

for i=0:M
    ai_M_N = factorial(M+N-i)/factorial(M + N) * nchoosek(M, i);
    deno(i+1)= (-1)^i* ai_M_N;
end
fs=100;
ts=1/fs;
approximation =tf(num,deno,ts,'variable','z');