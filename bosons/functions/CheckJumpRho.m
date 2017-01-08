function [value,isterminal,direction] = CheckJumpRho(t,Vrho)

global r Vtrace

direction=0;
isterminal=1;
value=real(Vtrace'*Vrho)-r;

end