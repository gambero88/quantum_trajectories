% This function initializes the observables structures
%
%
% Last modified: 02/02/2015

function [obs wf]=InitializeObs(in,op)

obs.norm2=zeros(in.tsteps,1);
obs.countj=zeros(in.tsteps,in.nch);
obs.overlap=zeros(in.tsteps,1);

% Global observables
for ich=1:in.nch
obs.ch(ich).jump.val=zeros(in.tsteps,1);
obs.ch(ich).jump.fluc=zeros(in.tsteps,1);
end

obs.energy=zeros(in.tsteps,1);

% Local observables
obs.rhoU=zeros(in.tsteps,in.L);
obs.rhoD=zeros(in.tsteps,in.L);
obs.corr.UU=zeros(in.tsteps,in.L,in.L);
obs.corr.DD=zeros(in.tsteps,in.L,in.L);
obs.corr.UD=zeros(in.tsteps,in.L,in.L);
obs.corr.DU=zeros(in.tsteps,in.L,in.L);

% Wavefunction
D=(factorial(in.L)/(factorial(in.L-in.Nu)*factorial(in.Nu)))*(factorial(in.L)/(factorial(in.L-in.Nd)*factorial(in.Nd)));

if in.flagwf=='y'
    wf=zeros(in.tsteps,D);
elseif in.flagwf=='n'
    wf=[];
else
    fprintf('ERROR: flagwf not valid')
    error()
end


tmp=op.ch(1).jump;
cc=whos('tmp');
if cc.complex==0
    % Probability distribution
    obs.prob.val=zeros(in.tsteps,op.ch(1).esize);
    obs.prob.range=[op.ch(1).omin:op.ch(1).omax];
else
    
end

end