function RunDmat(ik,iz,ieta)

startup2 % add the folder with the functions to Matlab path

% read the input indeces
if ischar(ik) ik = str2num(ik);  end;
if ischar(iz) iz = str2num(iz);  end;
if ischar(ieta) ieta = str2num(ieta);  end;

%% Global variables
global fb eff;

%% INPUT
datafile; %load datafile

% load the parameters for the trajectories
in.k=k(ik);             % atoms-light coupling
in.dt=dt(ik);           % time step
in.tsteps=tsteps(ik)+1; % number of time steps considered

% efficiency parameters
in.eta=eta(ieta);       % efficiency
eff=in.eta;

% feedback parameters
in.z=z(iz);
fb=z(iz);

%% Initialize initial states and matrices
[psi0 op]=BEC_InitializeMatRho(in) ;

%% Initialise folders and files

in.folder=sprintf('./trajectories/%sN%i/',in.name,in.N);
mkdir(in.folder);

copyfile('datafile.m',in.folder);

if in.flagdyn=='n' % no tunnelling
    fprintf('Running the trajectories without dynamics.......... ')
    
    in.file=sprintf('DynOff_k%gfb%geta%g',in.k,in.z,in.eta);
    str=sprintf('%s%s.mat',in.folder,in.file);
    
elseif in.flagdyn=='y'% tunnelling
    fprintf('Running the trajectories with dynamics.......... ')
    
    in.file=sprintf('DynOn_k%gfb%geta%g',in.k,in.z,in.eta);
    str=sprintf('%s%s.mat',in.folder,in.file);
 
else
    fprintf('ERROR: flagdyn not valid')
    error()
end

%% Run the trajectories

% create the output file
delete(str);
m = matfile(str,'Writable',true);

m.in=in;    % save input variables
m.done=0;   % counter

rng(1);     % random number seed

for itraj=1:in.ntraj % run the trajectories
    
    fprintf('%4.3g%%',100*(itraj-1)/in.ntraj) % print status on screen
    
    [obs wf] = BEC_SingTrajRho(in,psi0,op);
    
    m.traj(itraj,1)=obs; % save the observables
    
    % save the wavefunction (if required)
    psi.wf=wf;
    m.psi(itraj,1)=psi;
    
    % update the counter and move to the next trajectory
    m.done=itraj;
    clear obs wf psi;
    
    fprintf('\n\b\b\b\b\b\b')
end
fprintf('\nRunning the trajectories..........DONE\n')

end
