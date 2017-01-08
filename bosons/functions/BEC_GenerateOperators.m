%% This code generates the number operators for the illuminated part of the lattice

function [op] = BEC_GenerateOperators(in);

D=in.N+1; % matrix dimensionality

% initialize the arrays
op.na=zeros(D,1);    % number of atoms in mode a
op.nb=zeros(D,1);    % number of atoms in mode b
op.abd=zeros(D,D);   % a b^dagger
op.delta=zeros(D,D); % current -i(b a^dagger -a b^dagger)

fprintf('Generating the operators.......... \n')

% Initialise the operators
for k=1:in.N
    
    % a b^{dagger} operator
    op.abd(k,k+1)=sqrt(k*(in.N-k+1));
    
    % a^{dagger} a operator
    op.na(k,1)=k-1;
end

op.abd=sparse(op.abd);

%number operators
op.na(in.N+1,1)=in.N;
op.nb=in.N-op.na;

% current operator
op.delta=-sqrt(-1)*(op.abd'-op.abd);
op.delta=sparse(op.delta);

%% initialize jump operators
if in.scheme=='diff' % diffraction minimum
    op.ch.jump=op.na-op.nb;
elseif in.scheme=='1010' % probing the odd sites
    op.ch.jump=op.na;
end

% Initialize arrays for computing the prob distribution
tol=1e-4;
op.ch.prob.eigj=unique(tol*round(unique(op.ch.jump)/tol));

op.ch.prob.bin.size=min(diff(op.ch.prob.eigj));
op.ch.prob.bin.range=op.ch.prob.eigj(end)-op.ch.prob.eigj(1);
op.ch.prob.bin.n=floor(op.ch.prob.bin.range/op.ch.prob.bin.size)+1;

for i=1:op.ch.prob.bin.n
    op.ch.prob.bin.center(i)=op.ch.prob.eigj(1)+(i-1)*op.ch.prob.bin.size;
 
    [row,col,v]=find(op.ch.jump<op.ch.prob.bin.center(i)+op.ch.prob.bin.size/2 ...
       & op.ch.jump>op.ch.prob.bin.center(i)-op.ch.prob.bin.size/2);
    
    op.ch.prob.legend(i).vals=row;
    
end

fprintf('\n')
fprintf('Generating the operators........DONE \n \n')

end