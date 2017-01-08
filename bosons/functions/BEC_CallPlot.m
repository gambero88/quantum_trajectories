%% LIST OF THE 'PLOTTABLE' QUANTITIES

% the plots are either (x,y)    -> var.type='2d';
%               or (x,y1;x,y2)  -> var.type='2x2d';
%               or (x,y,z)      -> var.type='colormap';
% where x is TIME

%&&&&& '2d' plots format:
%
% y= quantity to be plotted
% var.range.y=range of y (row vector)
% var.label.x='time';
% var.label.y= label for the y axis (string)
% var.label.title=label for the plot (string)
% var.type='2d';
% var.line= color of the line to be used (string)


%&&&&& '2x2d' plots format:
%
% y1= quantity to be plotted 1
% y2= quantity to be plotted 2
% var.range.y1=limits of the y axis(row vector)
% var.label.x='time';
% var.label.y1= label for the y axis (string)
% var.label.title=label for the plot (string)
% var.type='2x2d';
% var.line1= color to be used (string) for y1
% var.line2= color to be used (string) for y2


%&&&&& 'colormap' plots format:
%
% y= quantity to be plotted on the y axis
% z= quantity to be plotted as color
% var.range.z=limits of the z axis(row vector)
% var.label.x='time';
% var.label.y= label for the y axis (string)
% var.label.title=label for the plot (string)
% var.type='colormap';

function wf=BEC_CallPlot(panel,var,traj,tstep,in);

% define the x axis
t=in.dt*[tstep(1)-1:tstep(2)-1];
tindex=[tstep(1):tstep(2)];

var.range.t=[t(1) t(end)];

% are errors to be plotted?
if not(isfield(var,'err'));
    var.err='n';
end

switch var.name
    % norm of the wavefunction
    case 'norm2'
        y=traj.norm2(tindex);
        var.label.x='time';
        var.label.y='norm';
        var.label.title='Norm';
        var.line='r';
        var.type='2d';
        var.range.y=[min(y) max(y)];
    % jump operator
    case 'jump'
        y=traj.ch.jump.val(tindex);
        var.label.x='time';
        var.label.y='jump operator';
        var.label.title='Jump operator';
        var.line='r';
        if var.err=='y'
            if isfield(traj,'std')
            e1=traj.ch.jump.val(tindex,:)+traj.std.ch.jump.val(tindex,:);
            e2=traj.ch.jump.val(tindex,:)-traj.std.ch.jump.val(tindex,:);
            else
            e1=traj.ch.jump.val(tindex,:)+sqrt(traj.ch.jump.fluc(tindex,:));
            e2=traj.ch.jump.val(tindex,:)-sqrt(traj.ch.jump.fluc(tindex,:));   
            end
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % absolute value of the 1st jump operator
    case 'jumpSq'
        y=abs(traj.jump.val(tindex)).^2;
        var.label.x='time';
        var.label.y='jump operators';
        var.label.title='Jump operator Abs squared';
        var.type='2d';
        var.line='r';
    % number of atoms in the mode A
    case 'Na'
        y=traj.na.val(tindex);
        var.label.x='time';
        var.label.y='Na';
        var.label.title='Na';
        var.line='r';
        
        if var.err=='y'
            if isfield(traj,'std')
                e1=traj.na.val(tindex,:)+traj.std.na.val(tindex,:);
                e2=traj.na.val(tindex,:)-traj.std.na.val(tindex,:);
            else
                e1=traj.na.val(tindex,:)+sqrt(traj.na.fluc(tindex,:));
                e2=traj.na.val(tindex,:)-sqrt(traj.na.fluc(tindex,:));
            end
            var.range.y=[0 in.N];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[0 in.N];
        end
    % number of atoms in the mode B
    case 'Nb'
        y=traj.nb.val(tindex);
        var.label.x='time';
        var.label.y='Nb';
        var.label.title='Nb';
        var.line='r';
        if var.err=='y'
            if isfield(traj,'std')
                e1=traj.nb.val(tindex,:)+traj.std.nb.val(tindex,:);
                e2=traj.nb.val(tindex,:)-traj.std.nb.val(tindex,:);
            else
                e1=traj.nb.val(tindex,:)+sqrt(traj.nb.fluc(tindex,:));
                e2=traj.nb.val(tindex,:)-sqrt(traj.nb.fluc(tindex,:));
            end
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % atom current
    case 'delta'
        y=traj.delta.val(tindex);
        var.label.x='time';
        var.label.y='Delta';
        var.label.title='Delta';
        var.line='b';
        if var.err=='y'
            if isfield(traj,'std')
                e1=traj.delta.val(tindex,:)+traj.std.delta.val(tindex,:);
                e2=traj.delta.val(tindex,:)-traj.std.delta.val(tindex,:);
            else
                e1=traj.delta.val(tindex,:)+sqrt(traj.delta.fluc(tindex,:));
                e2=traj.delta.val(tindex,:)-sqrt(traj.delta.fluc(tindex,:));
            end
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % correlations between the modes <Na Nb>-<Na><Nb>
    case 'corrAB'
        y=traj.corrAB.val(tindex);
        var.label.x='time';
        var.label.y='corrAB';
        var.label.title='corrAB';
        var.line='k';
        if var.err=='y'
            if isfield(traj,'std')
                e1=traj.corrAB.val(tindex,:)+traj.std.corrAB.val(tindex,:);
                e2=traj.corrAB.val(tindex,:)-traj.std.corrAB.val(tindex,:);
            else
                e1=traj.corrAB.val(tindex,:)+sqrt(traj.corrAB.fluc(tindex,:));
                e2=traj.corrAB.val(tindex,:)-sqrt(traj.corrAB.fluc(tindex,:));
            end
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % energy
    case 'energy'
        y=traj.energy(tindex);
        var.label.x='time';
        var.label.y='<H>';
        var.label.title='Energy';
        var.line='m';
        if var.err=='y'
            if isfield(traj,'std')
                e1=traj.energy(tindex,:)+traj.std.energy(tindex,:);
                e2=traj.energy(tindex,:)-traj.std.energy(tindex,:);
            else
                e1=traj.energy(tindex,:)+sqrt(traj.energy(tindex,:));
                e2=traj.energy(tindex,:)-sqrt(traj.energy(tindex,:));
            end
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % overlap with the initial state
    case 'overlap'
        y=traj.overlap(tindex);
        var.range.y=[0 1];
        var.label.x='time';
        var.label.y='overlap';
        var.label.title='Overlap with gs';
        var.line='k';
        if var.err=='y'
            e1=traj.overlap(tindex,:)+traj.std.overlap(tindex,:);
            e2=traj.overlap(tindex,:)-traj.std.overlap(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
        end
    %photocounts
    case 'counts'
        y=traj.countj(tindex,:);
        var.label.x='time';
        var.label.y='nph';
        var.label.title='Photocounts';
        var.line='b';
        if var.err=='y'
            e1=traj.countj(tindex,:)+traj.std.countj(tindex,:);
            e2=traj.countj(tindex,:)-traj.std.countj(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)+1];
        end
    % fluctuations of the jump operator
    case 'flucjump'
        y=traj.ch.jump.fluc(tindex);
        var.label.x='time';
        var.label.y='jump ch1 fluctuations';
        var.label.title='Jump ch1 fluctuations ';
        var.line='r';
        if var.err=='y'
            e1=traj.ch.jump.fluc(tindex,:)+traj.std.ch.jump.fluc(tindex,:);
            e2=traj.ch.jump.fluc(tindex,:)-traj.std.ch.jump.fluc(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % fluctuations of Na
    case 'flucNa'
        y=traj.na.fluc(tindex);
        var.label.x='time';
        var.label.y='Na fluctuations';
        var.label.title='Na fluctuations';
        var.line='r';
        if var.err=='y'
            e1=traj.na.fluc(tindex,:)+traj.std.na.fluc(tindex,:);
            e2=traj.na.fluc(tindex,:)-traj.std.na.fluc(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % fluctuations of Nb
    case 'flucNb'
        y=traj.nb.fluc(tindex);
        var.label.x='time';
        var.label.y='Nb fluctuations';
        var.label.title='Nb fluctuations';
        var.line='r';
        if var.err=='y'
            e1=traj.nb.fluc(tindex,:)+traj.std.nb.fluc(tindex,:);
            e2=traj.nb.fluc(tindex,:)-traj.std.nb.fluc(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % current fluctuations
    case 'flucDelta'
        y=traj.delta.fluc(tindex);
        var.label.x='time';
        var.label.y='Delta fluctuations';
        var.label.title='Delta fluctuations';
        var.line='b';
        if var.err=='y'
            e1=traj.delta.fluc(tindex,:)+traj.std.delta.fluc(tindex,:);
            e2=traj.delta.fluc(tindex,:)-traj.std.delta.fluc(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % fluctuations of corrAB
    case 'flucCorrAB'
        y=traj.corrAB.fluc(tindex);
        var.label.x='time';
        var.label.y='corrAB fluctuations';
        var.label.title='corrAB fluctuations';
        var.line='k';
        if var.err=='y'
            e1=traj.corrAB.fluc(tindex,:)+traj.std.corrAB.fluc(tindex,:);
            e2=traj.corrAB.fluc(tindex,:)-traj.std.corrAB.fluc(tindex,:);
            var.range.y=[min(e2) max(e1)];
            var.type='3x2d';
        else
            var.type='2d';
            var.range.y=[min(y) max(y)];
        end
    % probability distributions
    case 'prob'
        y=var.prob.bin.center;
        z=var.prob.val(tindex,:)';
        var.range.z=[0 1];
        var.type='colormap';
    % empty canvas
    case 'none'
        y1=[0 1];
        y2=[1 0];
        t=[t(1) t(end)];
        var.range.y1=[min(y1) max(y1)];
        var.range.y2=[min(y2) max(y2)];
        var.label.x='empty plot';
        var.label.y1='empty plot';
        var.label.title='empty plot';
        var.type='2x2d';
        var.line1='k';
        var.line2='k';
end

switch var.type
    
    case '2d'
        plot(t,y,var.line);
        xlim(var.range.t);
        ylim(var.range.y+[-1e-4 1e-4]);
        xlabel(var.label.x);
        ylabel(var.label.y);
        title(var.label.title);
    case '2x2d'
        plot(t,y1,var.line1,t,y2,var.line2);
        xlim(var.range.t);
        ylim(var.range.y1+[-1e-4 1e-4]);
        xlabel(var.label.x);
        ylabel(var.label.y1);
        title(var.label.title);
    case '3x2d'
        hold on
        X=[t,fliplr(t)];
        Y=[e2',fliplr(e1')];
        fill(X,Y,[255 204 204]/256,'EdgeColor','none');
        plot(t,y,var.line);
        hold off
        xlim(var.range.t);
        ylim(var.range.y+[-1e-4 1e-4]);
        xlabel(var.label.x);
        ylabel(var.label.y);
        title(var.label.title);
    case 'colormap'
        imagesc(t,y,z);
        pos=get(panel,'Position');
        c=colorbar('location','EastOutside');
        set(c,'Units','normalized', 'position', [1.01*(pos(1)+pos(3)) pos(2) pos(3)/20 pos(4)]);
        caxis(var.range.z);
        xlabel(var.label.x);
        ylabel(var.label.y);
        title(var.label.title);
    case '3d'
        
end
end
