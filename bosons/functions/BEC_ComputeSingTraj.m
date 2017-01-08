% This function runs a quantum trajectory
%
%
% Last modified: 22/07/2014

function [obs wf] = BEC_ComputeSingTraj(Evolution,ApplyJump,in,psi0,op);

global r

% Initialise the variables
[obs wf]=BEC_InitializeObs(in,op);
nj=0;

% compute the observables on the initial state
obs=BEC_ComputeObs(1,psi0,op,obs,in);
obs.countj(1,:)=0;
obs.overlap(1,1)=1;

% store the wavefunction (if required)
wf=StoreWf(1,in,psi0,wf);

% set the solver to detect jumps
options=odeset('Events',@CheckJump,'AbsTol',1e-9);

wfnew=psi0;

% generate a random number
r=rand(1);

for it=1:in.tsteps-1
    t0=in.dt*(it-1);
    tf=in.dt*it;
    wfold=wfnew;
    
    while t0<tf
        % evolution until the next jump
        tspan=[t0 (t0+tf)*0.5 tf];
        [TOUT,YOUT,TE,YE,IE]=ode45(Evolution,tspan,wfold',options);
        
        % check if the jump is occurred
        if ~isempty(IE)
            
            [wfold nj]=ApplyJump(op.ch,YE,nj);     % apply jump
            
            t0=TE;  %reset the evolution starting point
            
            % generate a random number
            r=rand(1);
        else
            t0=tf;                              %evolution untill next step is complete
            wfnew=YOUT(3,:)';
        end
        
    end
    
    % compute the observables on the new state
    obs.countj(it+1,:)=nj(1,:);
    obs=BEC_ComputeObs(it+1,wfnew,op,obs,in);
    obs.overlap(it+1,1)=abs(psi0'*wfnew)/sqrt(obs.norm2(it+1,1));
    
    % store the wavefunction (if required)
    wf=StoreWf(it,in,wfnew,wf);
    
end

end

