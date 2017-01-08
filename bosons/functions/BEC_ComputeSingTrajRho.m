% This function runs a quantum trajectory
%
%
% Last modified: 22/07/2014

function [obs wf] = BEC_ComputeSingTrajRho(Evolution,ApplyJump,in,psi0,op);

global D H c cd cdc Vtrace r

% Initialise the variables
[obs wf]=BEC_InitializeObs(in,op);
nj=0;

% compute the observables on the initial state
obs=BEC_ComputeObs(1,psi0,op,obs,in);
obs.countj(1,:)=0;
obs.overlap(1,1)=1;

% set the solver to detect jumps
options=odeset('Events',@CheckJumpRho,'AbsTol',1e-9);

%% set vectors and matrices
D=length(psi0); % matrix size

% initial state as a matrix
Mrho=sparse(psi0*psi0');

% initial density matrix as a vector
Vrho=reshape(Mrho,[D^2 1]); 

% jump operator as a matrix
c=sqrt(in.k)*op.mat.ch.jump; % c
cd=c';                       % c^dagger
cdc=cd*c;                    % c^dagger c

% empty matrix (needed for computing traces without converting from vector to matrix)
Vtrace=sparse(reshape(eye(D,D),[D^2 1]));

% generate a random number
r=rand(1);
  
for it=1:in.tsteps-1
    t0=in.dt*(it-1);
    tf=in.dt*it;
    
    while t0<tf
        % evolution until the next jump
        tspan=[t0 (t0+tf)*0.5 tf];

        [TOUT,YOUT,TE,YE,IE]=ode45(Evolution,tspan,Vrho',options);
        
        % check if the jump is occurred
        if ~isempty(IE)
            
            nj=nj+1;
            
            % from vector to matrix
            Mrho=reshape(YE',[D D]);
            
            % apply jump and convert from matrix to vector
            Vrho=reshape(c*Mrho*cd/trace(c*Mrho*cd),[D^2 1]);
            
            t0=TE;  %reset the evolution starting point
            
            % generate a random number
            r=rand(1);
        else
            t0=tf;                              %evolution untill next step is complete
            
            Vrho=YOUT(3,:)';
        end
        
    end
    
    % from vector to matrix
    Mrho=reshape(Vrho,[D D]);
    
    % compute the observables on the new state
    obs.countj(it+1,:)=nj(1,:);
    obs=BEC_ComputeObsRho(it+1,Mrho,op,obs,in);
    
end


end

