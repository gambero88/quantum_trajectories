function obs=ComputeObs(it,wf,op,obs,in);;

global H

% auxiliary  variables
n2=norm(wf)^2;
wf2=abs(wf).^2;

% norm of the wf
obs.norm2(it,1)=n2;

%% Global observables
for ich=1:in.nch % jump operator
    obs.ch(ich).jump.val(it,1)=wf2'*op.ch(ich).jump/n2;
    obs.ch(ich).jump.fluc(it,1)=real(wf2'*abs(op.ch(ich).jump).^2)/n2-abs(obs.ch(ich).jump.val(it,1))^2;
end

% energy
obs.energy(it,1)=real(wf'*H*wf)/n2;

%% Local observables
for isite=1:in.L %local density
    obs.rhoU(it,isite)=real(wf'*(op.rhoU(:,isite).*wf))/n2;
    obs.rhoD(it,isite)=real(wf'*(op.rhoD(:,isite).*wf))/n2;
end

%% two-points density correlations 
for isite=1:in.L
    temprhoU=op.rhoU(:,isite).*wf/n2;
    temprhoD=op.rhoD(:,isite).*wf/n2;
    for jsite=1:in.L
        obs.corr.UU(it,jsite,isite)=real(wf'*(op.rhoU(:,jsite).*temprhoU)) - obs.rhoU(it,jsite)*obs.rhoU(it,isite);
        obs.corr.DD(it,jsite,isite)=real(wf'*(op.rhoD(:,jsite).*temprhoD)) - obs.rhoD(it,jsite)*obs.rhoD(it,isite);
        obs.corr.UD(it,jsite,isite)=real(wf'*(op.rhoU(:,jsite).*temprhoD)) - obs.rhoU(it,jsite)*obs.rhoD(it,isite);
        obs.corr.DU(it,jsite,isite)=real(wf'*(op.rhoD(:,jsite).*temprhoU)) - obs.rhoD(it,jsite)*obs.rhoU(it,isite);
    end
end

% probability distribution for the first jump operator
tmp=op.ch(1).jump;
cc=whos('tmp');
if cc.complex==0
    % Probability distribution
    for i=op.ch(1).omin:op.ch(1).omax
        
        index=1+i-op.ch(1).omin;
        row=op.ch(1).legend(index).vals;
        
        if isempty(row)
            obs.prob.val(it,index)=0;
        else
            obs.prob.val(it,index)=sum(abs(wf(row,:)).^2/n2,1);
        end
    end
else
    
end

end