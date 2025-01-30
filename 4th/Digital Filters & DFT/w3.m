clear all
clc
n =0:29;
N = 30;
xn = [0 1 zeros(1,N-1)];
y(1) = 0;
for ii = 1:N
    y(ii+1) = -0.92*y(ii)+0.72*xn(ii+1);
end
%with rounding 
yr(1)=0;
for i = 1:N
        yr(i+1) =round((-0.9*yr(i)+0.7*xn(i+1)),1);
end
stem(n,y(2:N+1),'k')
hold on
stem(n,yr(2:N+1),'r*')
xlabel('n')
grid on
hold off
%%
clear
clc
f = 0:0.01:1;
T=1;
w = 2 *pi .*f;
z = exp(1*i .*w*T);
x = z./(z-0.45);
figure(1)
plot(f,abs(x));
xlabel('frequency Hz')
title('magnitude')
grid on
figure(2)
plot(f,angle(x));
grid on
xlabel('frequency Hz')
title('phase angle rad')

%%
clear
clc
f = 0:0.01:1;
T=1;
w = 2 *pi .*f;
z = exp(1*i .*w*T);
x = 0.45 *z.^-1./((1-0.45.*z.^-1).^2);
figure(1)
plot(f,abs(x));
xlabel('frequency Hz')
title('magnitude')
grid on
figure(2)
plot(f,unwrap(angle(x))); % to avoid switching from pi to -pi
grid on
xlabel('frequency Hz')
title('phase angle rad')








