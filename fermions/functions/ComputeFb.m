% This function computes the feedback current
%
%
% Last modified: 20/10/2015

function y=ComputeFb(t,psi);

global H_kin fb

y=-i*fb*H_kin*psi;

end
