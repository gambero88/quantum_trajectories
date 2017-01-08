function [av st]=StructureAverage(in,traj,sname,done);

substruct=strread(sname,'%s','delimiter','.');

if length(substruct)==1
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}));
    
elseif length(substruct)==2
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}).(substruct{2}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}).(substruct{2}));
    
elseif length(substruct)==3
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}).(substruct{2}).(substruct{3}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}).(substruct{2}).(substruct{3}));
    
elseif  length(substruct)==4
    
    scell=arrayfun(@(x) traj(x,1).(substruct{1}).(substruct{2}).(substruct{3}).(substruct{4}), 1:done, 'uni', 0);
    matsize=size(traj(1,1).(substruct{1}).(substruct{2}).(substruct{3}).(substruct{4}));
    
end

smat = reshape(cell2mat(scell),[matsize(1) matsize(2) done]);

av=squeeze(mean(smat,3));
st=squeeze(std(smat,0,3));

end
