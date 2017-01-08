% This function runs a quantum trajectory without discretising the time
% step
%
%
% Last modified: 19/03/2014

function [obs wf] = BEC_SingTrajRho(in,psi0,op)

global H

if in.flagdyn=='n'
    
    [obs wf]=BEC_ComputeSingTrajRho(0,@ApplyJump,in,psi0,op);
    
elseif in.flagdyn=='y'
    
    [obs wf]=BEC_ComputeSingTrajRho(@drho,@ApplyJump,in,psi0,op);
    
else
    fprintf('ERROR: dynamics type not programmed')
    error()
end

end

