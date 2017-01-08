function [value,isterminal,direction] = CheckJump(t,psi)

global r

direction=0;
isterminal=1;
value=psi'*psi-r;

end