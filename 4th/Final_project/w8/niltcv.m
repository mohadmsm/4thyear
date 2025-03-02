function [ft,t]=niltcv(F,tm)
alfa=0; M=1000; P=3; Er=1e-10; % adjustable
N=2*M; qd=2*P+1; t=linspace(0,tm,M); NT=2*tm*N/(N-2);
omega=2*pi/NT;
c=alfa+log(1+1/Er)/NT; s=c-1i*omega*(0:N+qd-1);
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
B1=B2; z1=repmat(exp(-1i*omega*t),[lv,1]); z=cat(3,z1,conj(z1));
for n=2:qd
 Dn=repmat(D(:,n,:),[1,M,1]);
 A=A1+Dn.*z.*A2; B=B1+Dn.*z.*B2; A2=A1; B2=B1; A1=A; B1=B;
end
ft=ft+A./B; ft=sum(ft,3)-repmat(Fs(:,1,2),[1,M,1]);
ft=repmat(exp(c*t)/NT,[lv,1]).*ft; ft(:,1)=2*ft(:,1);
end
