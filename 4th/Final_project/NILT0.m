function [ft,t] = NILT0(F,endt,M)
[poles,residues] =  R_Approximation(M);
t = linspace(0, endt, 1000); 
NILT0 = - (1 ./ t) .*sum(real(F(poles./t).*residues));
ft = NILT0;
figure(1);
plot(t,NILT0);
xlabel('time')
ylabel('Voltage')
