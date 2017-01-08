function RunSim(ik,iz)

startup2 % add the folder with the functions to Matlab path

% read the input indeces
if ischar(ik) ik = str2num(ik);  end;
if ischar(iz) iz = str2num(iz);  end;

%% Global variables
global fb;

%% INPUT
datafile; %load datafile

% load the parameters for the trajectories
in.k=k(ik);             % atoms-light coupling
in.dt=dt(ik);           % time step
in.tsteps=tsteps(ik)+1; % number of time steps considered
in.z=z(iz);             % fb strength

% feedback parameters
in.z=z(iz);
fb=z(iz);

% set efficiency to 1 (needed for plotting)
in.eta=1;

% define the output folder
in.folder=sprintf('./trajectories/%s_N%i/',in.name,in.N);
mkdir(in.folder);

% copy the input file in the output folder
copyfile('datafile.m',in.folder)

%% Initialize initial states and matrices
[psi0 op]=BEC_InitializeMat(in) ;

%% RUN THE TRAJECTORIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if in.flagdyn=='n' % no tunnelling
    fprintf('Running the trajectories without dynamics.......... ')
    
    in.file=sprintf('DynOff_k%gfb%g',in.k,in.z);
    str=sprintf('%s%s.mat',in.folder,in.file);
    
elseif in.flagdyn=='y'% tunnelling
    fprintf('Running the trajectories with dynamics.......... ')
    
    in.file=sprintf('DynOn_k%gfb%g',in.k,in.z);
    str=sprintf('%s%s.mat',in.folder,in.file);
    
else
    fprintf('ERROR: flagdyn not valid')
    error()
end

% create the output file
delete(str);
m = matfile(str,'Writable',true);

m.in=in;    % save input variables
m.done=0;   % counter

rng(1);     % random number seed

for itraj=1:in.ntraj % run the trajectories
    
    fprintf('%4.3g%%',100*(itraj-1)/in.ntraj) % print status on screen
    
    [obs wf] = BEC_SingTrajMeas_ode(in,psi0,op);
    
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
