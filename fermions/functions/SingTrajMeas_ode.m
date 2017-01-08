% This function runs a quantum trajectory, depending on the number of jump
% operators
%
%
% Last modified: 19/03/2014

function [obs wf] = SingTrajMeas_ode(in,psi0,op)

if in.nch==1
    
    if in.flagdyn=='n'
        
        [obs wf]=ComputeSingTraj(@dpsi_noev,@ApplyJump1Ch,in,psi0,op);
        
    elseif in.flagdyn=='y'
        
        [obs wf]=ComputeSingTraj(@dpsi,@ApplyJump1Ch,in,psi0,op);
        
    else
        fprintf('ERROR: dynamics type not programmed')
        error()
    end
elseif in.nch==2
    if in.flagdyn=='n'
        
        [obs wf]=ComputeSingTraj(@dpsi_noev,@ApplyJump2Ch,in,psi0,op);
        
    elseif in.flagdyn=='y'
        
        [obs wf]=ComputeSingTraj(@dpsi,@ApplyJump2Ch,in,psi0,op);
        
    else
        fprintf('ERROR: dynamics type not programmed')
        error()
        
    end
elseif in.nch>2
    if in.flagdyn=='n'
        
        [obs wf]=ComputeSingTraj(@dpsi_noev,@ApplyJumpnCh,in,psi0,op);
        
    elseif in.flagdyn=='y'
        
        [obs wf]=ComputeSingTraj(@dpsi,@ApplyJumpnCh,in,psi0,op);
        
    else
        fprintf('ERROR: dynamics type not programmed')
        error()
    end
    
    
end

