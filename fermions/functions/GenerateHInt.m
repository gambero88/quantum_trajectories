%% This code generate the interaction part of the hamiltonian for the Fermi Hubbard model

function H_int = GenerateHInt(in,states)

fprintf('Generating the interaction hamiltonian.......... \n')

D = size(states.index,2);
H = zeros(1,D);

for i=1:D,
    fprintf('\b\b\b\b\b\b\b%6.2f%%',100*i/D)
    [u d] = Index2State(in,states.index(i));
    docc=bitand(u,d); % look for doubly occupied sites
    
    H(i) = sum(bitget(docc,1:in.L)); % fill the Hamiltonian
end

H_int = sparse(1:D,1:D,H,D,D);

fprintf('\n')
fprintf('Generating the interaction hamiltonian........DONE \n \n')


end