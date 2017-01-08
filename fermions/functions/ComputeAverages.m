% This function generates computes averages over the trajectory ensamble
%
%
% Last modified: 04/11/2015

function av=ComputeAverages(in,m);

fprintf('...Importing trajectories from %s.......... ',m. Properties.Source)
av.in=m.in;

%av.prob=op.ch.prob;
traj=m.traj;
fprintf('\n...Importing trajectories from %s..........DONE \n',m. Properties.Source)

% compute averages
fprintf('...Computing averages.......... ')

[av.ch.jump.val av.std.ch.jump.val]=StructureAverage(av.in,traj,'ch.jump.val',m.done);
[av.ch.jump.fluc av.std.ch.jump.fluc]=StructureAverage(av.in,traj,'ch.jump.fluc',m.done);

[av.countj av.std.countj]=StructureAverage(av.in,traj,'countj',m.done);
[av.overlap av.std.overlap]=StructureAverage(av.in,traj,'overlap',m.done);
[av.energy av.std.energy]=StructureAverage(av.in,traj,'energy',m.done);

[av.rhoU av.std.rhoU]=StructureAverage(av.in,traj,'rhoU',m.done);
[av.rhoD av.std.rhoD]=StructureAverage(av.in,traj,'rhoD',m.done);

[av.corr.UU av.std.corr.UU]=StructureAverage(av.in,traj,'corr.UU',m.done);
[av.corr.DD av.std.corr.DD]=StructureAverage(av.in,traj,'corr.DD',m.done);
[av.corr.DU av.std.corr.DU]=StructureAverage(av.in,traj,'corr.DU',m.done);
[av.corr.UD av.std.corr.UD]=StructureAverage(av.in,traj,'corr.UD',m.done);

[av.prob.val av.std.prob.val]=StructureAverage(av.in,traj,'prob.val',m.done);
av.prob.bin.center=traj(1,1).prob.range;

fprintf('\n...Computing averages.......... DONE \n')


end
