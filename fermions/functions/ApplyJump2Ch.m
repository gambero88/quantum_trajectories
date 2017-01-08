function [wfold nj]=ApplyJump2Ch(ch,YE,nj)

% choose between the two channel
p1=real(YE*(abs(ch(1).jump).^2.*YE'));
p2=real(YE*(abs(ch(2).jump).^2.*YE'));

r=rand();

if r<p1/(p1+p2)
    ij=1;
else
    ij=2;
end

tmp=ch(ij).jump.*YE';              %jump
%wfold=wfold/(sqrt(wfold'*wfold));    %normalize
nj(1,ij)=nj(1,ij)+1;

% apply feedback
tmp2=ode45(@ComputeFb,[0 1],tmp');
wfold=tmp2.y(:,end);
wfold=wfold/(sqrt(wfold'*wfold));    %normalize
end