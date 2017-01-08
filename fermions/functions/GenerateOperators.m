%% This code generates the number operators for the illuminated part of the lattice

function [op] = GenerateOperators(in,states);

% jump operator, global operators and local operators

fprintf('Generating the operators.......... \n')

D = size(states.index,2);
j=sqrt(-1);
sites=1:in.L;

% initialize density operators
op.rhoU=zeros(D,in.L);
op.rhoD=zeros(D,in.L);

% initialize jump operators
for ich=1:in.nch;   
    op.ch(ich).jump= zeros(D,1);
end
    
% compute operators
for i=1:D;
    
    [ut dt] = Index2State(in,states.index(i));
    
    u=bitget(ut,sites);
    d=bitget(dt,sites);
    
    nu=double(u)';
    nd=double(d)';
    
    op.rhoU(i,:)=nu; % local UP density
    op.rhoD(i,:)=nd; % local DOWN density

    for ich=1:in.nch; 
        nwu=in.ch(ich).modefunU*nu;
        nwd=in.ch(ich).modefunD*nd;
        
        op.ch(ich).jump(i,1)=nwu+nwd; % generate the jump operator
    end
end

% Initialize arrays for computing the prob distribution of the jump
% operator

tmp=op.ch(1).jump;
cc=whos('tmp');
if cc.complex==0 % real eigenvalues
    
    % define the parameters for the histogram
    op.ch(1).omax=max(op.ch(1).jump);
    op.ch(1).omin=min(op.ch(1).jump);
    op.ch(1).esize=op.ch(1).omax-op.ch(1).omin+1;
    
    % prepare a lengend for filling the histogram (expensive computation)
    for i=op.ch(1).omin:op.ch(1).omax
        
        [row,col,v]=find(op.ch(1).jump==i);
        
        index=1+i-op.ch(1).omin;
        op.ch(1).legend(index).vals=row;
    end
else % complex eigenvalues
    eigj=unique(op.ch(1).jump);
    op.ch(1).esize=max(size(eigj));
    for i=1:op.ch(1).esize
        
        [row,col,v]=find(op.ch(1).jump==eigj(i));
        
        op.ch(1).legend(i).vals=row;
    end
end

fprintf('\n')
fprintf('Generating the operators........DONE \n \n')

end