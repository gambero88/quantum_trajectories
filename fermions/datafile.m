%% INPUT

in.name='test';      % simulation name


%% INITIALIZATION
in.bc='OBC';         % boundary conditions:
                     % -- OBC: Open Boundary Conditions
                     % -- PBC: Periodic Boundary Conditions
                        
in.state='gs';  % initial state
                % -- gs: ground state
                % -- r:  random state
                % -- f:  Fock state -> needs to specify in.fock.u and
                %        in.fock.d as row vectors
                % -- c:  superposition of doubly occupied sites
                % -- file: load from file -> needs to specify in.filepsi0

dt=     [0.02];    % time step for sampling
tsteps= [2000];    % number of time steps required
                   % the simulation runs from t=0 to t=dt*tsteps


%% SYSTEM SIZE (If only one species is present use DOWN)
in.Nu=2;       % up fermions
in.Nd=2;       % down fermions
in.L=4;        % lattice sites (maximum is 32)

%% HAMILTONIAN PARAMETERS                        
in.J=1;        % hopping amplitude
U=[0];         % interaction between up and down

%% MEASUREMENT PARAMETERS
in.nch=1;       % number of jump operators

in.ch(1).modefunU=[0 1 1 0]; % J_ii coefficients for the up fermions (same dimension as the lattice)
in.ch(1).modefunD=[0 1 1 0]; % J_ii coefficients for the down fermions (same dimension as the lattice)

in.ntraj=10;   % number of trajectory to compute
k=[0.1];       % measurement strength (it is called gamma in the papers)

%% FEEDBACK PARAMETERS
in.flagfb='n';  % is feedback on? (y/n)
z=0;            % feedback strength

%% FLAGS

in.flagdyn='y'; % is tunnelling included? (y/n)
in.flagwf='y';  % save the wavefunction? (large output files) (y/n)

in.flagham='y';     % recompute the hamiltonian? (y/n/auto)
in.flagdiag='y';    % recompute the ground state?(y/n/auto)
in.flagop='y';      % recompute the operators?   (y/n/auto)
                    % auto: loads from file (if present in ./matrices, otherwise is equivalent to n)
                       
                       
                       
