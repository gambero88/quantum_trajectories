%% INPUT

in.name='dyn';      % simulation name

%% INITIALIZATION
in.state='fock';  % initial state
                % -- sf: superfluid state
                % -- fock: product of two superfluids -> needs to specify
                % in.fock as integer
                % -- r:  random state
                % -- file: load from file -> needs to specify in.filepsi0
in.fock=5;
                
dt=     [0.02];    % time step for sampling
tsteps= [1000];    % number of time steps required
                   % the simulation runs from t=0 to t=dt*tsteps

%% SYSTEM SIZE
in.N=100;     % number of atoms

%% MEASUREMENT PARAMETERS

in.scheme='1010'; % jump operator to be simulated
                  % -- 1010: probing the odd sites
                  % -- diff: diffraction minimum (Nodd- Neven)

in.ntraj=1;   % number of trajectory to compute
k=[0.0];       % measurement strength (it is called gamma in the papers)

%% FEEDBACK PARAMETERS
z=[0]; % feedback parameters

%% EFFICIENCY PARAMETERS
eta=[1]; % efficiency

%% FLAGS

in.flagdyn='y'; % is tunnelling included? (y/n)
in.flagwf='y';  % save the wavefunction? (large output files) (y/n)

in.flagham='auto';     % recompute the hamiltonian? (y/n/auto)
in.flagdiag='auto';    % recompute the ground state?(y/n/auto)
in.flagop='auto';      % recompute the operators?   (y/n/auto)
                       % auto: loads from file (if present in ./matrices, otherwise is equivalent to n)
                       
                       