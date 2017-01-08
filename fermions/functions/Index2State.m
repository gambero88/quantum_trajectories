% This function convert the dictionary word to a Fock state in binary
% representation
%
%
% Last modified: 19/03/2014

function [u d] = Index2State(in,x)

if in.L<=8
    u=uint8(mod(x,2^in.L));
    d=uint8(floor(x/2^in.L));
elseif in.L>8 & in.L<=16
    u=uint16(mod(x,2^in.L));
    d=uint16(floor(x/2^in.L));
elseif in.L>16 & in.L<=32
    u=uint32(mod(x,2^in.L));
    d=uint32(floor(x/2^in.L));
end

end
