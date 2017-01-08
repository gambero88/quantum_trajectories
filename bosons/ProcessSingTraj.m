%This function plots various observables for each quantum trajectory
%
%
% The plot panel is labelled as
%
% | 1  2  |
% | 3  4  |
% | 5  6  |
% | 7  8  |
%
% The variables to be plotted are called as vars(panel_position).name='name' where name
% can be (up to 3rd February 2015)
%	'jump'      : jump operator
%   'jumpSq'    : absolute value of the 1st jump operator
%   'Na'        : number of atoms in the mode A
%   'Nb'        : number of atoms in the mode B
%   'delta'     : atom current
%   'corrAB'    : correlations between the modes <Na Nb>-<Na><Nb>
%   'norm2'     : norm of the wf
%   'energy'    : energy
%   'overlap'   : overlap with the initial state
%   'counts'    : photocounts
%   'flucjump'  : fluctuations of the jump operator
%   'flucNa'    : fluctuations of Na
%   'flucNb'    : fluctuations of Nb
%   'flucDelta' : current fluctuations
%   'flucCorrAB': fluctuations of corrAB
%   'none'      : empty canvas
%   'prob'      : probability distribution
%
%% IMPORTANT: the name is not sufficient for plotting probability distributions.
%% One has to specify the following fields:
%%       vars(panel_position).name='prob';
%%       vars(panel_position).prob= array containing the data
%%       vars(panel_position).label.x= x label;
%%       vars(panel_position).label.y='eigenvalue';
%%       vars(panel_position).label.title=panel title;
%%


clc
clf
close all
clear all

startup2;

%% Folder containing the trajectories to be plotted
folder='./trajectories/dyn_N100/';

dyn='On'; % is tunnelling  On or Off?

% import the input file
run([folder 'datafile.m'])

% load the operators used in the simulation
str2=sprintf('./matrices/operatorsN%i_%s.mat',in.N,in.name);
mop=matfile(str2);
op=mop.op;


%% Import trajectories

istep=0; % counter
for iz=1:size(z,2) % cicle on the feedback strength
    for ik=1:size(k,2) % cicle on the measurement strength
        
        % print status
        istep=istep+1; % update counter
        fprintf('\nProgress... %4.3g%%  \n',100*(istep-1)/(size(z,2)*size(k,2)))
        
        % file to be loaded
        str=sprintf('%sDyn%s_k%gfb%g.mat',folder,dyn,k(ik),z(iz));
        in.file=sprintf('%sDyn%s_k%gfb%g',folder,dyn,k(ik),z(iz));
        
        
        if exist(str,'file')
            
            % load the file
            m=matfile(str);
            in=m.in;
            mout.in=in;
            in.done=m.done;
            
            % define the folder where to save the pics
            picfolder=sprintf('%spics%s',in.folder,in.file);
            mkdir(picfolder);
            
            %% plot single trajectories
            if m.done>0   
                
                for ntraj=1:m.done % cicle on the completed trajectories
                    
                    fprintf('.........Plotting... %4.3g%%  \n ',100*ntraj/m.done)
                    
                    
                    vars(1).name='jump';
                    vars(1).range.y=[min(op.ch(1).jump) max(op.ch(1).jump)];
                    vars(2).name='flucjump';
                    
                    vars(3).name='Na';
                    vars(4).name='flucNa';
                    
                    vars(5).name='counts';
                    
                    vars(6).name='energy';
                    vars(7).name='norm2';
                    
                    vars(8).name='prob';
                    tmp=m.traj(ntraj,1);
                    vars(8).prob=tmp.ch.jump.prob;
                    vars(8).label.x='time';
                    vars(8).label.y='eigenvalue';
                    vars(8).label.title='jump prob dist';
                    
                    y=BEC_PlotTrajSing(in,[1 floor(tsteps(ik)/10)],m.traj(ntraj,1),vars);
                    picname=sprintf('%s/short_traj%i.jpeg',picfolder,ntraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                    
                    y=BEC_PlotTrajSing(in,[1 tsteps(ik)],m.traj(ntraj,1),vars);
                    picname=sprintf('%s/long_traj%i.jpeg',picfolder,ntraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                    
                    y=BEC_PlotTrajSing(in,[1 floor(tsteps(ik)/3)],m.traj(ntraj,1),vars);
                    picname=sprintf('%s/traj%i.jpeg',picfolder,ntraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                end
            end
        end
    end
end

