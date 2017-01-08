function obs=BEC_ComputeObs(it,wf,op,obs,in);

global H

% auxiliary  variables
n2=norm(wf)^2;
wf2=abs(wf).^2;

% norm of the wf
obs.norm2(it,1)=n2;

% jump operator (mean and fluctuations)
obs.ch.jump.val(it,1)=wf2'*op.ch.jump/n2;
obs.ch.jump.fluc(it,1)=real(wf2'*abs(op.ch.jump).^2)/n2-abs(obs.ch.jump.val(it,1))^2;

% number of atoms in mode a (mean and fluctuations)
obs.na.val(it,1)=wf2'*op.na/n2;
obs.na.fluc(it,1)=wf2'*op.na.^2/n2-obs.na.val(it,1)^2;

% number of atoms in mode b (mean and fluctuations)
obs.nb.val(it,1)=wf2'*op.nb/n2;
obs.nb.fluc(it,1)=wf2'*op.nb.^2/n2-obs.nb.val(it,1)^2;

% current (mean and fluctuations)
obs.delta.val(it,1)=real(wf'*(op.delta*wf))/n2;
obs.delta.fluc(it,1)=real(wf'*((op.delta*op.delta)*wf))/n2-obs.delta.val(it,1)^2;

% number correlations (<Na Nb>-<Na><Nb> (mean and fluctuations)
obs.corrAB.val(it,1)=wf2'*(op.na.*op.nb)/n2-obs.na.val(it,1)*obs.nb.val(it,1);
obs.corrAB.fluc(it,1)=wf2'*(op.na.*op.nb.*op.na.*op.nb)/n2-obs.corrAB.val(it,1)^2;

% energy
obs.energy(it,1)=real(wf'*H*wf)/n2;

% Probability distribution of the jump operator
for i=1:op.ch.prob.bin.n
    
    row=op.ch.prob.legend(i).vals;
    
    if isempty(row)
        obs.ch.jump.prob.val(it,i)=0;
    else
        obs.ch.jump.prob.val(it,i)=sum(abs(wf(row,:)).^2/n2,1);
    end
end


end