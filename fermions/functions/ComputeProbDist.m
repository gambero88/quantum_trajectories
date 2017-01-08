% This function computes the probablility distributions for different
% observables
%
%
%
% Last modified: 03/02/2015

function [prob] = ComputeProbDist(in,op,wf);

% tollerance for histogram bins
tol=1e-4;

% histogram entries
prob.eigj=unique(tol*round(unique(op)/tol));

% define the histogram bins
prob.bin.size=min(diff(prob.eigj));
prob.bin.range=prob.eigj(end)-prob.eigj(1);
prob.bin.n=floor(prob.bin.range/prob.bin.size)+1;

% fill the histogram
for i=1:prob.bin.n
    prob.bin.center(i)=prob.eigj(1)+(i-1)*prob.bin.size;
    
    [row,col,v]=find(op<prob.bin.center(i)+prob.bin.size/2 & op>prob.bin.center(i)-prob.bin.size/2);
    
    if isempty(row)
        prob.val(:,i)=0;
    else
        prob.val(:,i)=sum(abs(wf(:,row)).^2,2);
    end
    
end


end