function [wfold nj]=ApplyJumpnCh(ch,YE,nj)

% choose between the channels
for i=1:size(ch,2)
    p(i)=real(YE*(abs(ch(i).jump).^2.*YE'));
end
p=p/sum(p);

c(1)=0;
for i=1:size(ch,2)
    c(i+1)=c(i)+p(i);
end

r=rand();

ij=find(c==min(c(find(c>r))))-1;

tmp=ch(ij).jump.*YE';              %jump
%wfold=wfold/(sqrt(wfold'*wfold));    %normalize
nj(1,ij)=nj(1,ij)+1;


% apply feedback
tmp2=ode45(@ComputeFb,[0 1],tmp');
wfold=tmp2.y(:,end);
wfold=wfold/(sqrt(wfold'*wfold));    %normalize

end