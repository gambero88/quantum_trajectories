% This function plots interesting quantities on a single trajectory
%
%
% Last modified: 19/03/2014

function [y]=BEC_PlotTrajSing(in,tstep,traj,vars)

% initialize
clf
t=in.dt*[tstep(1)-1:tstep(2)-1];
tindex=[tstep(1):tstep(2)];

% figure 1
y=figure(1);
set(y,'Position', [200 500 1500 700]);
clf

ncol=2;
for i=1:length(vars)
    p=subplot(ceil(length(vars)/ncol),ncol,i);
    BEC_CallPlot(p,vars(i),traj,tstep,in);
end

str=sprintf('ntraj=%i of %i     N=%i      k=%g     z=%g     eta=%g     %s',in.done, in.ntraj, in.N, in.k,in.z,in.eta, in.name);
annotation('textbox', [0 0.9 1 0.1], ...
    'String', str, ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontSize', 18)
end