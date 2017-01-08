% This code diagonalizes a large sparse matrix using the eigs function
%
%
%
% Last modified: 19/03/2014

function [Egs psi] = DiagonalizeH(H)

fprintf('Diagonalizing the hamiltonian........ \n')

%diagonalize the hamiltonian
opts.tol=eps;
opts.issym=1;
opts.isreal=1;
opts.p=min(100,size(H,2));
% 
[GSL energyL]=eigs(H,2,'sa',opts);
format long
energyL=diag(energyL)
format short
Egs=min(energyL)
psi=GSL(:,1);

fprintf('Diagonalizing the hamiltonian........DONE \n \n')

end
