clear all 
clc
R = 0;        % Resistance per unit length (Ohms per meter)
L = 2.5e-7;     % Inductance per unit length (Henries per meter)
G = 0;        % Conductance per unit length (Siemens per meter)
C = 1e-10;    % Capacitance per unit length (Farads per meter)
l = 400;    % Length of the transmission line (meters)
vs = 1;
z = @(s)(R+s.*L); 
y = @(s)(G + s .* C);
gamma = @(s)sqrt(z(s) .* y(s));
Z0 = @(s) sqrt(z(s) ./ y(s));
Z_series =@(s) Z0(s) .* sinh(gamma(s) .* l);
Y_parallel =@(s) (1 ./ Z0(s)) .* tanh((gamma(s) .* l)./2);
Z_parallel = @(s) 1./Y_parallel(s);
TF = @(s) Z_parallel(s) ./ (Z_series(s) + Z_parallel(s));
vo = @(s) TF(s) * vs./s;
%vo = @(s) vs./(s.*cosh(l.*(G + C.*s).^(1/2).*(R + L.*s).^(1/2)));
tm =100e-6;                    
[ft,t] = niltv(vo,tm,'pl1');

%******* NiLTV – FUNCTION DEFINITION (vector version) *******%
function [ft,t]=niltv(F,tm,pl)
global ft t;
alfa=0; M=200; P=3; Er=1e-10;             % adjustable
N=2*M; qd=2*P+1; t=linspace(0,tm,M);
NT=2*tm*N/(N-2); omega=2*pi/NT; c=alfa-log(Er)/NT;
s=c-1i*omega*(0:N+qd-1);Fsc=F(s); ft=fft(Fsc,N,2);
ft=ft(:,1:M); delv=size(Fsc,1); d=zeros(delv,qd); e=d;
q=Fsc(:,N+2:N+qd)./Fsc(:,N+1:N+qd-1);
d(:,1)=Fsc(:,N+1); d(:,2)=-q(:,1);
for r=2:2:qd-1
   w=qd-r; e(:,1:w)=q(:,2:w+1)-q(:,1:w)+e(:,2:w+1);d(:,r+1)=-e(:,1);
   if r>2
      q(:,1:w-1)=q(:,2:w).*e(:,2:w)./e(:,1:w-1); d(:,r)=-q(:,1);
   end
end
A2=zeros(delv,M); B2=ones(delv,M); A1=repmat(d(:,1),[1,M]); B1=B2;
z=repmat(exp(-1i*omega*t),[delv,1]);
for n=2:qd
   Dn=repmat(d(:,n),[1,M]); A=A1+Dn.*z.*A2; B=B1+Dn.*z.*B2;
   A2=A1; B2=B1; A1=A; B1=B;
end
ft=2*real(ft+A./B)-repmat(Fsc(:,1),[1,M]);
ft=repmat(exp(c*t)/NT,[delv,1]).*ft; ft(:,1)=2*ft(:,1);
feval(pl);
end
%**********************************************************************%

%************ PLOT1 – FUNCTION DEFINITION **************%
function pl1                           % multiple plotting into a single figure
global ft t;
plot(t,ft); xlabel('t'); ylabel('f(t)'); grid on;
end
%**********************************************************************%




%*************** PLOT2 – FUNCTION DEFINITION ****************%
function pl2                           % plotting into separate figures
global ft t;
for k=1:size(ft,1)
    figure;
    plot(t,ft(k,:)); xlabel('t'); ylabel('f(t)'); grid on;
end
end
%***********************************************************************%

%******* NILTM – FUNCTION DEFINITION (matrix version) *******%
function [ft,t,x]=niltm(F,tm,pl);
global ft t x;
alfa=0; M=256; P=3; Er=1e-10;             % adjustable
N=2*M; qd=2*P+1; t=linspace(0,tm,M);
NT=2*tm*N/(N-2); omega=2*pi/NT; c=alfa-log(Er)/NT;
s=c-1i*omega*(0:N+qd-1); Fsc=feval(F,s); ft=fft(Fsc,N,2);
ft=ft(:,1:M); dim1=size(Fsc,1); dim3=size(Fsc,3);
d=zeros(dim1,qd,dim3); e=d;
q=Fsc(:,N+2:N+qd,:)./Fsc(:,N+1:N+qd-1,:);
d(:,1,:)=Fsc(:,N+1,:); d(:,2,:)=q(:,1,:);
for r=2:2:qd-1
   w=qd-r; e(:,1:w,:)=q(:,2:w+1,:)-q(:,1:w,:)+e(:,2:w+1,:);
   d(:,r+1,:)=-e(:,1,:);
   if r>2
      q(:,1:w-1,:)=q(:,2:w,:).*e(:,2:w,:)./e(:,1:w-1,:); d(:,r,:)=-q(:,1,:);
   end
end
A2=zeros(dim1,M,dim3); B2=ones(dim1,M,dim3);
A1=repmat(d(:,1,:),[1,M]); B1=B2;
z=repmat(exp(-1i*omega*t),[dim1,1,dim3]);
for n=2:qd
   Dn=repmat(d(:,n,:),[1,M]); A=A1+Dn.*z.*A2; B=B1+Dn.*z.*B2;
   A2=A1; B2=B1; A1=A; B1=B;
end
ft=ft+A./B; ft=2*real(ft)-repmat(real(Fsc(:,1,:)),[1,M]);
ft=repmat(exp(c*t)/NT,[dim1,1,dim3]).*ft; ft(:,1,:)=2*ft(:,1,:);
feval(pl);
end
%***********************************************************************%

%*************** PLOT3 – FUNCTION DEFINITION ****************%
function pl3
global ft t x;
m=length(t); tgr=[1:m/64:m,m];               % 65 time points
for k=1:size(ft,3)
    figure; mesh(t(tgr),x(k,:),ft(:,tgr,k));
    xlabel('t'); ylabel('x'); zlabel(strcat('f',num2str(k),'{t}'));
end
end
%***********************************************************************%
