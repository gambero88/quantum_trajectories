% This function converts a Fock state into a dictionary entry
%
%
% Last modified: 19/03/2014

function x = State2Index(in,u,d)

x=d*2^in.L+u;

end