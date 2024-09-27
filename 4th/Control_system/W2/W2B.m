clear 
clc
%k = 5;
Gnum = [1 4 0];
Gden = conv([1 4.5 0 6.25],[1 3]);
Gtf = tf(Gnum,Gden);
Gtf = series(Gtf,5); 
Cs = zpk(-1,-10,2);% 2 * tf
Hs = zpk([],-0.4,4); % if no zeros just add []
a1 = cell2mat(Gtf.Denominator);
a2 = roots(cell2mat(Gtf.Denominator));
b = pole(Gtf);
c = zero(Cs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a_fd = series(Gtf,Cs);% forward path
b_b = feedback(a_fd,Hs); %closed loop
c_c = poly(pole(b_b)); % 
d_d = pole(b_b);
e_e = zero(b_b);
f = ss(b_b);% issue 
g = eig(f);
