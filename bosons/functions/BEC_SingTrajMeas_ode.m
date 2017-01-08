% This function runs a quantum trajectory without discretising the time
% step
%
%
% Last modified: 19/03/2014

function [obs wf] = BEC_SingTrajMeas_ode(in,psi0,op)

if in.flagdyn=='n'
    
    [obs wf]=BEC_ComputeSingTraj(@dpsi_noev,@ApplyJump,in,psi0,op);
    
elseif in.flagdyn=='y'
    
    [obs wf]=BEC_ComputeSingTraj(@dpsi,@ApplyJump,in,psi0,op);
    
else
    fprintf('ERROR: dynamics type not programmed')
    error()
end

end

