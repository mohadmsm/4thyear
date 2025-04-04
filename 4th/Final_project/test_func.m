clear all
clc 
syms s L R C G l vs Rs
z = (R+s*L); 
y = (G + s * C);
gamma = sqrt(z * y);
Z0 =  sqrt(z / y);
Z_series = Z0 * sinh(gamma .* l);
Y_parallel = (1 / Z0) * tanh((gamma* l)/2);
Z_parallel =  1/Y_parallel;
TF =  Z_parallel / (Z_series + Z_parallel);
vo =  TF * vs/s;
simplify(vo)
%%
clc 
syms s L R C G l vs Rs
z = (R+s*L); 
y = (G + s * C);
gamma = sqrt(z * y);
Z0 =  sqrt(z / y);
Z_series = Z0 * sinh(gamma * l);
Y_parallel = (1 / Z0) * tanh((gamma * l)/2);
Z_parallel =  1/Y_parallel;

% With source resistor Rs, the total series impedance is (Rs + Z_series + Z_parallel)
TF = Z_parallel / (Rs + Z_series + Z_parallel);

vo = TF;
simplify(vo)
