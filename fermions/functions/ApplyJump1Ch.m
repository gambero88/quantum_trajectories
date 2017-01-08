function [wfold nj]=ApplyJump1Ch(ch,YE,nj)

tmp=ch(1).jump.*YE';               %jump
%tmp=tmp/(sqrt(tmp'*tmp));    %normalize
nj(1,1)=nj(1,1)+1;

% apply feedback
tmp2=ode45(@ComputeFb,[0 1],tmp');
wfold=tmp2.y(:,end);
wfold=wfold/(sqrt(wfold'*wfold));    %normalize

end