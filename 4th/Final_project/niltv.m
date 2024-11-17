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
