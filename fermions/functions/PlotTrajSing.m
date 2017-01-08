% This function plots interesting quantities on a single trajectory
%
%
% Last modified: 19/03/2014

function [y]=PlotTrajSing(in,tstep,traj,vars)

% initialize
clf
t=in.dt*[tstep(1)-1:tstep(2)-1];
tindex=[tstep(1):tstep(2)];

% extract diagonal elements from fluctuation arrays
for it=tstep(1):tstep(end)
    traj.fluc.UU(it,:)=real(diag(reshape(traj.corr.UU(it,:,:),[in.L in.L])));
    traj.fluc.DD(it,:)=real(diag(reshape(traj.corr.DD(it,:,:),[in.L in.L])));
    traj.fluc.UD(it,:)=real(diag(reshape(traj.corr.UD(it,:,:),[in.L in.L])));
    traj.fluc.DU(it,:)=real(diag(reshape(traj.corr.DU(it,:,:),[in.L in.L])));
end

% figure 1
y=figure(1);
set(y,'Position', [200 500 1500 700]);
clf

% plot the variables vars
for i=1:12
    p=subplot(3,4,i);
    CallPlot(p,vars(i),traj,tstep,in);
end

str=sprintf('ntraj=%i of %i     L=%i      U=%s     k=%g     z=%g     %s',in.done, in.ntraj, in.L,num2str(in.U),in.k,in.z, in.name);
annotation('textbox', [0 0.9 1 0.1], ...
    'String', str, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontSize', 18)
end