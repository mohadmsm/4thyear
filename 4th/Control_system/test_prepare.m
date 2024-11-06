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