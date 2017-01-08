function obs=BEC_ComputeObsRho(it,rho,op,obs,in);

global H

% auxiliary  variables
n2=real(trace(rho));

% norm of the wf
obs.norm2(it,1)=n2;

% jump operator (mean and fluctuations)
obs.ch.jump.val(it,1)=trace(rho*op.mat.ch.jump)/n2;
obs.ch.jump.fluc(it,1)=real(trace(op.mat.ch.jump*op.mat.ch.jump*rho)/n2-obs.ch.jump.val(it,1)^2);

% number of atoms in mode a (mean and fluctuations)
obs.na.val(it,1)=trace(rho*op.mat.na)/n2;
obs.na.fluc(it,1)=trace(op.mat.na*op.mat.na*rho)/n2-obs.na.val(it,1)^2;

% number of atoms in mode b (mean and fluctuations)
obs.nb.val(it,1)=trace(rho*op.mat.nb)/n2;
obs.nb.fluc(it,1)=trace(op.mat.nb*op.mat.nb*rho)/n2-obs.nb.val(it,1)^2;

% current (mean and fluctuations)
obs.delta.val(it,1)=real(trace(rho*op.mat.delta)/n2);
obs.delta.fluc(it,1)=real(trace(op.mat.delta*op.mat.delta*rho)/n2-obs.delta.val(it,1)^2);

% number correlations (<Na Nb>-<Na><Nb> (mean and fluctuations)
obs.corrAB.val(it,1)=trace(op.mat.na*op.mat.nb*rho)/n2-obs.na.val(it,1)*obs.nb.val(it,1);
obs.corrAB.fluc(it,1)=trace(op.mat.na*op.mat.nb*op.mat.na*op.mat.nb*rho)/n2-obs.corrAB.val(it,1)^2;

% energy
obs.energy(it,1)=real(trace(rho*H))/n2;

end