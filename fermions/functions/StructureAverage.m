%% This function computes averages and standard deviations of nested structures arrays.

function [av st]=StructureAverage(in,traj,sname,done);

% define the structure delimiter
substruct=strread(sname,'%s','delimiter','.');

% check the length of the structure and convert it to a cell
if length(substruct)==1
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}));
    
elseif length(substruct)==2
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}).(substruct{2}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}).(substruct{2}));
   
elseif length(substruct)==3
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}).(substruct{2}).(substruct{3}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}).(substruct{2}).(substruct{3}));
   
end

% set the dimension for computing the averages
if length(matsize)<=2
    rsize=[matsize(1) matsize(2) done];
else
    rsize=[matsize(1) matsize(2) done matsize(3:end)];
end
% reshape and converto the cell to an array
smat = reshape(cell2mat(scell),rsize);

%compute the averages
av=squeeze(mean(smat,3));

%compute the standard deviation
st=squeeze(std(smat,0,3));

end