% This function generates computes averages over the trajectory ensamble
%
%
% Last modified: 28/05/2015

function av=BEC_ComputeAverages2(in,m,op);

% Compute the average over the trajectories ensamble
% fill the temporary matrices

fprintf('...Importing trajectories from %s.......... ',m. Properties.Source)
av.in=m.in;

av.prob=op.ch.prob;
traj=m.traj;
fprintf('\n...Importing trajectories from %s..........DONE \n',m. Properties.Source)

% compute averages
fprintf('...Computing averages.......... ')
[av.norm2 av.std.norm2]=StructureAverage(av.in,traj,'norm2',m.done);

[av.ch.jump.val av.std.ch.jump.val]=StructureAverage(av.in,traj,'ch.jump.val',m.done);
[av.ch.jump.fluc av.std.ch.jump.fluc]=StructureAverage(av.in,traj,'ch.jump.fluc',m.done);

[av.countj av.std.countj]=StructureAverage(av.in,traj,'countj',m.done);
[av.overlap av.std.overlap]=StructureAverage(av.in,traj,'overlap',m.done);
[av.energy av.std.energy]=StructureAverage(av.in,traj,'energy',m.done);

[av.na.val av.std.na.val]=StructureAverage(av.in,traj,'na.val',m.done);
[av.na.fluc av.std.na.fluc]=StructureAverage(av.in,traj,'na.fluc',m.done);

[av.nb.val av.std.nb.val]=StructureAverage(av.in,traj,'nb.val',m.done);
[av.nb.fluc av.std.nb.fluc]=StructureAverage(av.in,traj,'nb.fluc',m.done);

[av.delta.val av.std.delta.val]=StructureAverage(av.in,traj,'delta.val',m.done);
[av.delta.fluc av.std.delta.fluc]=StructureAverage(av.in,traj,'delta.fluc',m.done);

[av.corrAB.val av.std.corrAB.val]=StructureAverage(av.in,traj,'corrAB.val',m.done);
[av.corrAB.fluc av.std.corrAB.fluc]=StructureAverage(av.in,traj,'corrAB.fluc',m.done);

[av.ch.jump.prob.val av.std.ch.jump.prob.val]=StructureAverage(av.in,traj,'ch.jump.prob.val',m.done);
av.ch.jump.prob.bin=traj(1,1).ch.jump.prob.bin;

fprintf('\n...Computing averages.......... DONE \n')

end
