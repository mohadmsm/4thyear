clear all
clc
R = 0;        % Resistance per unit length (Ohms per meter)
L = 2.5e-7;     % Inductance per unit length (Henries per meter)
G = 0;        % Conductance per unit length (Siemens per meter)
C = 1e-10;    % Capacitance per unit length (Farads per meter)
l = 400;    % Length of the transmission line (meters)
vs = 30;
vo = @(s) vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
tm = 60e-6;
niltcv(vo,tm,'p1')
function [ft,t]=niltcv(F,tm,depict);
alfa=0; M=2506; P=3; Er=1e-10; % adjustable
N=2*M; qd=2*P+1; t=linspace(0,tm,M); NT=2*tm*N/(N-2);
omega=2*pi/NT;
c=alfa+log(1+1/Er)/NT; s=c-i*omega*(0:N+qd-1);
Fs(:,:,1)=feval(F,s); Fs(:,:,2)=feval(F,conj(s)); lv=size(Fs,1);
ft(:,:,1)=fft(Fs(:,:,1),N,2); ft(:,:,2)=N*ifft(Fs(:,:,2),N,2);
ft=ft(:,1:M,:);
D=zeros(lv,qd,2); E=D; Q=Fs(:,N+2:N+qd,:)./Fs(:,N+1:N+qd-1,:);
D(:,1,:)=Fs(:,N+1,:); D(:,2,:)=-Q(:,1,:);
for r=2:2:qd-1
 w=qd-r;
 E(:,1:w,:)=Q(:,2:w+1,:)-Q(:,1:w,:)+E(:,2:w+1,:);
 D(:,r+1,:)=-E(:,1,:);
 if r>2
 Q(:,1:w-1,:)=Q(:,2:w,:).*E(:,2:w,:)./E(:,1:w-1,:);
 D(:,r,:)=-Q(:,1,:);
 end
end
A2=zeros(lv,M,2); B2=ones(lv,M,2); A1=repmat(D(:,1,:),[1,M,1]);
B1=B2; z1=repmat(exp(-i*omega*t),[lv,1]); z=cat(3,z1,conj(z1));
for n=2:qd
 Dn=repmat(D(:,n,:),[1,M,1]);
 A=A1+Dn.*z.*A2; B=B1+Dn.*z.*B2; A2=A1; B2=B1; A1=A; B1=B;
end
ft=ft+A./B; ft=sum(ft,3)-repmat(Fs(:,1,2),[1,M,1]);
ft=repmat(exp(c*t)/NT,[lv,1]).*ft; ft(:,1)=2*ft(:,1);
switch depict
 case 'p1', plott1(t,ft); case 'p2', plott2(t,ft);
 case 'p3', plott3(t,ft); otherwise display('Invalid Plot');
end
end
% --- Plotting functions called by 1D NILT, vector version ----
%----------- Multiple plotting into single figure -------------
function plott1(t,ft)
figure; plot(t,real(ft)); grid on;
%figure; plot(t,imag(ft)); grid on; % optional
end
% ------------- Plotting into separate figures ----------------
function plott2(t,ft)
for k=1:size(ft,1)
 figure; plot(t,real(ft(k,:))); grid on;
 figure; plot(t,imag(ft(k,:))); grid on; % optional
end
end
% ------------------ Plotting into 3D graphs ------------------
function plott3(t,ft)
global x; % x must be global in F
 m=length(t); tgr=[1:m/64:m,m]; % 65 time points chosen
 figure; mesh(t(tgr),x,real(ft(:,tgr)));
 figure; mesh(t(tgr),x,imag(ft(:,tgr)));
end