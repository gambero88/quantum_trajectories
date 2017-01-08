% This function initializes the relevant matrices for a quantum trajectory
% simulation
%
%
% Last modified: 19/03/2014

function [psi0 op]=InitializeMat(in)

%% Global variables
global H;     % hermitian Hamiltonian
global Heff;  % effective Hamiltonian
global jump2; % decay Hamiltonian
global H_kin; % tunnelling Hamiltonian

%% Initialize the states and the matrices

% define the file for saving the matrices
str=sprintf('./matrices/matL%iu%id%i.mat',in.L,in.Nu,in.Nd);

if in.flagham=='y'
    
    % generate the basis states
    states = GenerateBasis(in);
    
    % generate the kinetic part of the hamiltonian
    H_kin = GenerateHKin(in,states);
    
    % generate the interaction part of the hamiltonian (setting U=1)
    H_int = GenerateHInt(in,states);
    
    % save the matrices
    save(str,'states','H_kin','H_int');
    
elseif in.flagham=='n'
    
    fprintf('Loading the matrices file.......... \n')
    load(str,'states','H_kin','H_int');
    
elseif in.flagham=='auto'
    
    if exist(str,'file')
        
        fprintf('Loading the matrices file.......... \n')
        load(str,'states','H_kin','H_int');
        
    else
        
        % generate the basis states
        states = GenerateBasis(in);
        
        % generate the kinetic part of the hamiltonian
        H_kin = GenerateHKin(in,states);
        
        % generate the interaction part of the hamiltonian (setting U=1)
        H_int = GenerateHInt(in,states);
        
        % save the matrices
        save(str,'states','H_kin','H_int');
    end
    
else
    fprintf('ERROR: flagham not valid')
    error()
end

%% Compute the operators

% define the file for saving the operators
str=sprintf('./matrices/operatorsL%i_%s.mat',in.L,in.name);

if in.flagop=='y'
    
    % generate the number operators for the illuminated lattice and the jump operators
    [op] = GenerateOperators(in,states);
    
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
        [op] = GenerateOperators(in,states);
        
        % save the matrices
        save(str,'op');
        
    end
    
else
    fprintf('ERROR: flagop not valid')
    error()
end
%% Compute the effective hamiltonian

% define the file for saving the gs and the Hamiltonian
str=sprintf('./matrices/gsL%iu%id%iU%g.mat',in.L,in.Nu,in.Nd,in.U);

if in.flagdiag=='y'
        
        % compute the hamiltonian matrix
        H=-in.J*H_kin-in.U*H_int;
        
        % diagonalize the hamiltonian
        [Egs wf]=DiagonalizeH(H);
        psi0=wf;
        
        % save the matrices
        save(str,'H','Egs','psi0');
        
    elseif in.flagdiag=='n'
        
        fprintf('Loading the Hamiltonian.......... \n\n')
        load(str,'H','Egs','psi0');
        
    elseif in.flagdiag=='auto'
        
        if exist(str,'file')
            
            fprintf('Loading the Hamiltonian.......... \n\n')
            load(str,'H','Egs','psi0');
            
        else
            
            % compute the hamiltonian matrix
            H=-in.J*H_kin-in.U*H_int;
            
            % diagonalize the hamiltonian
            [Egs wf]=DiagonalizeH(H);
            psi0=wf;
            
            % save the matrices
            save(str,'H','Egs','psi0');
            
        end
        
    else
        fprintf('ERROR: flagdiag not valid')
        error()
    end

%% Load the initial state

if strcmp(in.state,'gs')==1 % ground state
    
    load(str,'psi0');
    
elseif strcmp(in.state,'r')==1 %random state
    
    D=size(H_int,2);
    psi0=rand(D,1)+sqrt(-1)*rand(D,1);
    psi0=psi0/norm(psi0); 
    
elseif strcmp(in.state,'fock')==1 % fock state
    
    expset=[0:in.L-1];
    u=sum((2.^expset).*in.fock.u);
    d=sum((2.^expset).*in.fock.d);
    ind = find(states.index==State2Index(in,u,d));
    
    D=size(H_int,2);
    psi0=zeros(D,1);
    psi0(ind,1)=1;
    
elseif strcmp(in.state,'c')==1 % superposition of couples
    
    D=size(H_int,2);
    psi0=zeros(D,1);
    
    for istate=1:size(states,2)
        % look for doubly occupied sites
        ind = find(states.index==State2Index(in,state(istate),state(istate)));
        psi0(ind,1)=1;
    end
    
    psi0=psi0/norm(psi0);

elseif strcmp(in.state,'file')==1 % from file
    
    load(in.filepsi0,'psi0')
       
else
    fprintf('ERROR: initial state not valid')
    error()
end


%% Initialise the non-hermitian hamiltonian
i=sqrt(-1);

D=size(psi0,1);
jump2=sparse(1:D,1:D,0);

for ij=1:in.nch
    jump2=jump2+sparse(1:D,1:D,in.k*conj(op.ch(ij).jump).*op.ch(ij).jump);
end

% effective Hamiltonian
Heff=sparse(-i*jump2+H);

end