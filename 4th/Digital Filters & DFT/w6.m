clear 
clc
T = 1/2000;
f = 0:0.1:1000;
w = 2*pi*f;
s= i*w;
z = exp(i*w*T);
Hs = 200*pi./(s+200*pi);
s0 = 2/T * ((z-1)./(z+1));
%Hz =(0.125*pi/(1+0.125*pi)*(z+1))./(z+(0.125*pi-1)/(1+0.125*pi));
Hz= 200*pi./(s0+200*pi);
plot(f,abs(Hs),f,abs(Hz),'r')
%%
clear
clc
T = 0.05;
f = 0:0.001:1/(2*T); % cutt of if you want to 2 decimal then step = 0.01 and so on
w = 2*pi*f;
s= i*w;
z = exp(i*w*T);
Hs = 3./(3+2);
s0 = 2/T * ((z-1)./(z+1));
Hz = 3./(s0+3);
%Hz = (z+1)./(z*(T+1));
a = (2-2*T)/(2+2*T);
b = 3*T/(2+3*T);
Hz_claclated = b*(z+1)./(z-a);
plot(f,abs(Hs),f,abs(Hz_claclated),'r')
Hdiff = abs(Hz)-1/sqrt(2);
[aa,ff] = min(abs(Hdiff));
fc=f(ff);% 5/2pi
%actal cut off
c=(2-2*T)/(2+2*T);
a= 2*T/(2+2*T);
fcc = 1/(2*pi*T) *acos((1+c^2-4*a^2)/(4*a^2+2*c));
fc
%%
clear
clc
T =0.1;
wa = 2;
Ha = tf(wa,[1 wa]);
Hd = tf([2*T/(2+2*T) 2*T/(2+2*T)], [1 (-2+2*T)/(2+2*T)], T);
t = 0:T:2;
[y,t] = impulse(Ha,t);
[yd,td] = impulse(Hd,t);% change to step if you want step
plot(t,y)
hold on
stem(td,yd)
xlabel('time ')
legend('Analog','Discrete')
%%
clear
clc
T = 0.05;
f = 0:0.001:1/(2*T); % cutt of if you want to 2 decimal then step = 0.01 and so on
w = 2*pi*f;
s= i*w;
z = exp(i*w*T);
Hs = 2.*s./(s.^2+2*s+9);
s0 = 2/T * ((z-1)./(z+1));
Hz = 2*s0./(s0.^2+2*s0+9);
a = 4*T/(4+4*T+9*T^2);
b = (18*T^2-8)/(4+4*T+9*T^2);
c = (4-4*T+9*T^2)/(4+4*T+9*T^2);
Hz_calculated = a.*(z.^2+1)./(z.^2+b.*z+c);
plot(f,abs(Hs),f,abs(Hz),'r')
Hdiff = abs(Hz(1:500))-1/sqrt(2);
[aa,ff1] = min(abs(Hdiff));
Hdiff = abs(Hz(500:end))-1/sqrt(2);
[aa,ff2] = min(abs(Hdiff));
fc=f(ff1)-f(ff2);