% This function initializes the observables structures
%
%
% Last modified: 02/02/2015

function [obs wf]=BEC_InitializeObs(in,op);

% norm of the wavefunction
obs.norm2=zeros(in.tsteps,1);

% number of detected photons
obs.countj=zeros(in.tsteps,1);

% overlap with the initial state
obs.overlap=zeros(in.tsteps,1);

% jump operator (mean and fluctuations)
obs.jump.val=zeros(in.tsteps,1);
obs.jump.fluc=zeros(in.tsteps,1);

% number of atoms in mode a (mean and fluctuations)
obs.na.val=zeros(in.tsteps,1);
obs.na.fluc=zeros(in.tsteps,1);

% number of atoms in mode b (mean and fluctuations)
obs.nb.val=zeros(in.tsteps,1);
obs.nb.fluc=zeros(in.tsteps,1);

% current (mean and fluctuations)
obs.delta.val=zeros(in.tsteps,1);
obs.delta.fluc=zeros(in.tsteps,1);

% energy
obs.energy=zeros(in.tsteps,1);

% number correlations (<Na Nb>-<Na><Nb> (mean and fluctuations)
obs.corrAB.val=zeros(in.tsteps,1);
obs.corrAB.fluc=zeros(in.tsteps,1);

% initialize the wavefunction
D=in.N+1;

if in.flagwf=='y'
    wf=zeros(in.tsteps,D);
elseif in.flagwf=='n'
    wf=[];
else
    fprintf('ERROR: flagwf not valid')
    error()
end

% initialize arrays for computing the probability distribution
obs.ch.jump.prob.bin=op.ch.prob.bin;
obs.ch.jump.prob.val=zeros(in.tsteps,op.ch.prob.bin.size);

end