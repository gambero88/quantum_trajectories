%% This code generates the number operators for the illuminated part of the lattice

function [H] = BEC_GenerateH(in);

D=in.N+1; % matrix dimensionality

% initialize a b^{dagger} operator
abd=sparse(D,D);

fprintf('Generating the Hamiltonian.......... \n')

% Initialise the Hamiltonian
for k=1:in.N
 
    % a b^{dagger} operator
    abd(k,k+1)=sqrt(k*(in.N-k+1));
end

% hamiltonian
H=-(abd+abd');
H=sparse(H);

fprintf('\n')
fprintf('Generating the Hamiltonian........DONE \n \n')

end