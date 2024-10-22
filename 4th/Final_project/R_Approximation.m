function [poles,res]=R_Approximation(M)

N = M-2; % as per the paper
num = zeros(1,N);
deno = zeros(1,M);
for i=0:N
    ai_M_N = factorial(M+N-i)/factorial(M + N) * nchoosek(N, i);% ai,M,N
    num(i+1)= ai_M_N ;
end

for i=0:M
    ai_N_M = factorial(M+N-i)/factorial(M + N) * nchoosek(M, i);% ai,N,M
    deno(i+1)= (-1)^i* ai_N_M;
end

fs=0.1;
ts=1/fs;% this only to convert from s to z when using tf function.
num = flip(num);
deno = flip(deno);
approximation =tf(num,deno,ts,'variable','z');
res = residue(num,deno);
poles = pole(approximation);
end