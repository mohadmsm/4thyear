clear all
clc


A = [ 1 2 3; 4 5 6];
A(:,1)% disply that colum
A(:,2)
A(1,:) %row can use end
%%
clear
clc
p1 = [ 1 2 3]; % 1x^2 + 2x +3
p2 = [ 3 4 5];


A = [ 1 2 3; 4 5 6];
A(:,1)% disply that colum
A(:,2)
A(1,:) %row can use end
%%
clear
clc
p1 = [ 1 2 3]; % 1x^2 + 2x +3
p2 = [ 3 4 5];
pT = conv(p1,p2); %p1*p2
rootsPT = roots(pT);
polynew = poly(rootsPT); % find the poly from the roots
num = [ 4 5 ];
den = conv([1 3],[1 2]);
sysGtf = tf(num,den); % create a tf using num and den starting from high order left to right
% if you have zero and poles of a system you can use zpk to create the
% modual 
tfZeros = zero(sysGtf);
ploess = pole(sysGtf);
sysGtf_zpk = zpk(tfZeros,ploess,4);

% only poles deside system stability 
%for feedback, we find closedd loop as y/r where y is out and r is input
%,and make E as the value after feedback where y = E * G , and E is r * p
%-H *y, then find y/r by subtituation. 
% stable == negtive poles, poles in the left-half s-plane 
% asymptotically stable == complex poles but real part in the left-half
% marginally/critically stable == rela part of one pole is 0 


% sensitivity 

% D and N are disturbance for input and output
% steady state gain is when s goes to 0 in tf CL

%pg14
%%
clear all 
clc 
k =  15;
G = tf(1,[0.6 1]);
GOpen = series(G,k);
H = 0.45;
GCLTF = feedback(GOpen,H);
%%
clear all
clc
% tut 1
G1= tf(1,[1 0]);
a1 = 5;
a2 = 10;
gCL1 = feedback(G1,a1);
p_2 = 18;
p_1 =tf([0.45 0],(1));
p =series(p_2,p_1);
GOpen = series(G1,gCL1);
GFtf = feedback(GOpen,a2);
GFtf2 = series(GFtf,p);
%%
% ex 3 11 and 12 
clear
clc
tstop = 0.04;
C1 = tf(10,1);
C2 =tf([5],[1 5]);
H = tf([4], [1 2 4]);
G = tf(4.*[1 0.2],[[1 -0.5-1i*0.37].*[1 -0.5+1i*0.37]]);
F = tf(50,[1 5]);
G1 = parallel(series(C2,G),F);
CLTF1= feedback(G1,H);
CLTFF = feedback(series(C1,CLTF1),1);

open('ex3_14.slx');
sim("ex3_14.slx");
figure(1);

plot(tout,youtCLTF);
%%
