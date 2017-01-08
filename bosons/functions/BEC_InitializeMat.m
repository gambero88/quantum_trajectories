% This function initializes the relevant matrices for a quantum trajectory
% simulation
%
%
% Last modified: 20/11/2015

function [psi0 op]=BEC_InitializeMat(in)

%% Global variables
global H;     % hermitian Hamiltonian
global Heff;  % effective Hamiltonian
global jump2; % decay Hamiltonian

%% Initialize the matrices

str=sprintf('./matrices/matN%i.mat',in.N);

if in.flagham=='y'
    
    % generate the hamiltonian
    H = BEC_GenerateH(in);
    
    % save the matrix
    save(str,'H');
    
elseif in.flagham=='n'
    
    fprintf('Loading the matrices file.......... \n')
    load(str,'H');
    
elseif in.flagham=='auto'
    
    if exist(str,'file')
        
        fprintf('Loading the matrices file.......... \n')
        load(str,'H');
        
    else
        
    % generate the hamiltonian
    H = BEC_GenerateH(in);
    
    % save the matrix
    save(str,'H');
    end
    
else
    fprintf('ERROR: flagham not valid')
    error()
end

%% Compute the operators

str=sprintf('./matrices/operatorsN%i_%s.mat',in.N,in.name);

if in.flagop=='y'
    
    % generate the number operators for the illuminated lattice and the jump operators
    [op] = BEC_GenerateOperators(in);
    
    % save the matrices
    save(str,'op');
    
elseif in.flagop=='y'
    
    fprintf('Loading the operators file.......... \n')
    load(str,'op');
    
elseif in.flagop=='auto'
    
    if exist(str,'file')
        
        fprintf('Loading the operators file.......... \n')
        load(str,'op');
        
    else
        
        % generate the number operators for the illuminated lattice and the jump operators
        [op] = BEC_GenerateOperators(in);
        
        % save the matrices
        save(str,'op');
        
    end
    
else
    fprintf('ERROR: flagop not valid')
    error()
end

%% Compute the initial state

if strcmp(in.state,'sf')==1 % superfluid state across the whole lattice
    
    D=in.N+1;
    psi0=zeros(D,1);
    
    %initialise the initial state
    for j=0:in.N
        psi0(j+1,1)=sqrt(nchoosek(in.N,j));
    end
    
    psi0=psi0/(norm(psi0));
    norm(psi0);
    
elseif strcmp(in.state,'fock')==1 % product of two superfluids
    
    D=in.N+1;
    psi0=zeros(D,1);
    
    %initialise the initial state
    psi0(in.fock+1,1)=1;
    psi0=psi0/(norm(psi0));
    
elseif strcmp(in.state,'r')==1 % random state
    
    D=in.N+1;
    psi0=rand(D,1);
    
    psi0=psi0/norm(psi0);

elseif strcmp(in.state,'file')==1 % load from file
    
    load(in.filepsi0,'psi0')
       
else
    fprintf('ERROR: initial state not valid')
    error()
end


%% Initialise the non-hermitian hamiltonian

i=sqrt(-1);

% square of the jump operator
jump2=sparse(1:D,1:D,op.ch.jump.*op.ch.jump);

% non-hermitian Hamiltonian
Heff=sparse(H-i*in.k*jump2);

end