function [poles,res]=R_Approximation(M)

num = zeros(1,(M-2)); % N = M-2
deno = zeros(1,M);

for i=0:M
    common_term = factorial(M+(M-2)-i)/factorial(M + (M-2));
    if i <= (M-2)
    ai_M_N = common_term  * nchoosek((M-2), i);% ai,M,N
    num(i+1)= ai_M_N ;
    end
    ai_N_M = common_term  * nchoosek(M, i);% ai,N,M
    deno(i+1)= (-1)^i* ai_N_M;

end
num = flip(num);
deno = flip(deno);
[res,poles] = residue(num,deno);
end