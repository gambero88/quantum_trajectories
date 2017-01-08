DONE when finishes

%% This function plots various observables for each quantum trajectory
%
%
% The plot panel is labelled as
%
% | 1  2  3  4 |
% | 5  6  7  8 |
% | 9 10 11 12 |
%
% The variables to be plotted are called as vars(panel_position).name='name' where name
% can be (up to 3rd February 2015)
%	'jump1'     : jump operator channel 1
%   'jump2'     : jump operator channel 2
%   'jumps'     : all jump operators
%   'jumpSq'    : absolute value of the 1st jump operator
%   'rhoU'      : local density (UP) <n_up(i)>
%   'rhoD'      : local density (DOWN) <n_down(i)>
%   'rho'       : local density (UP + DOWN) <rho(i)>
%   'mag'       : local magnetisation (UP - DOWN) <m(i)>
%   'corrC'     : density correlations with the central site (DOWN)
%   'corr'      : density correlations with the edge site (DOWN)
%   'staggered' : staggered magnetisation
%   'staggered2': staggered magnetisation squared
%   'corrUDeo'  : correlations between odd and even sites <Nodd Neven>-<Nodd><Neven>
%   'Smag'      : magnetic structure factor
%   'Srho'      : density structure factor
%   'energy'    : energy
%   'overlap'   : overlap with the initial state
%   'counts'    : photocounts
%   'flucjump1' : fluctuations of the 1s jump operator
%   'flucjump2' : fluctuations of the 2nd jump operator
%   'flucrhoU'  : local fluctuations of the UP density
%   'flucrhoD'  : local fluctuations of the DOWN density
%   'flucrho'   : local fluctuations of the UP+DOWN density
%   'flucmag'   : local fluctuations of the UP-DOWN magnetisation
%   'flucUD'    : local UP/DOWN density correlations
%   'prob'      : probability distribution
%   'corrUU'    : UP/UP correlations between the central site and the rest of the lattice
%   'corrUD'    : UP/DOWN correlations between the central site and the rest of the lattice
%   'corrDD'    : DOWN/DOWN correlations between the central site and the rest of the lattice
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
clear all
close all

startup2;

%% Folder containing the trajectories to be plotted
filelist(1).name='./trajectories/test_L4u2d2/';

dyn='On'; % is tunnelling  On or Off?

for ifolder=1:size(filelist,2) % cicle on the folders
    folder=filelist(ifolder).name;
    
    % import the input file
    run([folder 'datafile.m'])
    
    istep=0; % counter
    for iz =1:size(z,2) % cicle on the feedback strength
        for ik=1:size(k,2) % cicle on the measurement strength
            for iU=1:size(U,2)% cicle on the interaction strength
                
                outfile=sprintf('%sProbOutputDyn%s_k%gU%gfb%g.mat',folder,dyn,k(ik),U(iU),z(iz));
                mout = matfile(outfile,'Writable',true);
                
                % file to be loaded
                str=sprintf('%sDyn%s_k%gU%gfb%g.mat',folder,dyn,k(ik),U(iU),z(iz));
                
                if exist(str)
                    
                    % load the file
                    m = matfile(str);
                    in=m.in;
                    mout.in=in;
                    in.done=m.done;
                    
                    % load the operators used in the simulation
                    str2=sprintf('./matrices/operatorsL%i_%s.mat',in.L,in.name);
                    mop=matfile(str2);
                    op=mop.op;
                    
                    % print status
                    istep=istep+1; % update counter
                    fprintf('\nProgress... %4.3g%% \n ',100*(istep-1)/(size(k,2)*size(U,2)*size(z,2)))
                    fprintf('Importing trajectories from %s..........\n ',m. Properties.Source)
                    
                    % define the folder where to save the pics
                    picfolder=sprintf('%spics%s',in.folder,in.file);
                    mkdir(picfolder);
                    
                    % compute the staggered magnetisation
                    stag=0*op.ch(1).jump;
                    for tmp=1:in.L
                        stag=stag+(op.rhoU(:,tmp)- op.rhoD(:,tmp))*(-1)^tmp;
                    end
                    
                    
                    %% plot single trajectories
                    if m.done>0
                        
                        % if the wavefunction is saved one can compute
                        % the probability distribution of any observable
                        % (EXPENSIVE)
                        
                        for ntraj=1:m.done % cicle on the completed trajectories
                            
                            fprintf('.........Plotting... %4.3g%%  \n ',100*ntraj/m.done)
                            
                            % import the wavefunction
                            tmp=m.psi(ntraj,1);
                            wf=tmp.wf;
                            
                            if in.flagwf=='y'
                                % Compute probability distributions
                                [prob] = ComputeProbDist(in,op.ch(1).jump,wf);
                                [sprob] = ComputeProbDist(in,stag,wf);
                                tj(ntraj).prob=prob;
                                mout.traj=tj;
                            end
                            
                            % Variables to be plotted
                            % row 1
                            vars(1).name='jumps';
                            vars(2).name='flucjump1';
                            vars(3).name='prob';
                            vars(3).prob=prob;
                            vars(3).label.x='time';
                            vars(3).label.y='eigenvalue';
                            vars(3).label.title='Jump prob dist';
                            vars(4).name='counts';
                            
                            % row 2
                            vars(5).name='rhoD';
                            vars(6).name='mag';
                            vars(7).name='corr';
                            vars(8).name='overlap';
                            
                            % row 3
                            vars(9).name='flucrhoD';
                            vars(10).name='flucrhoD';
                            vars(10).name='prob';
                            vars(10).prob=sprob;
                            vars(10).label.x='time';
                            vars(10).label.y='eigenvalue';
                            vars(10).label.title='st mag prob dist';
                            vars(11).name='staggered2';
                            vars(12).name='corrUDeo';
                            
                            %% Plot the trajectories in different time intervals
%                             % from t=0 to t=tfin/10
%                             y=PlotTrajSing(in,[1 floor(in.tsteps/10)],m.traj(ntraj,1),vars);
%                             picname=sprintf('%s/short_traj%i.jpeg',picfolder,ntraj);
%                             set(y,'PaperPosition', [0 0 40 25]);
%                             print(y,'-djpeg','-r400',picname);
                            
                            % from t=0 to t=tfin
                            y=PlotTrajSing(in,[1 in.tsteps],m.traj(ntraj,1),vars);
                            picname=sprintf('%s/long_traj%i.jpeg',picfolder,ntraj);
                            set(y,'PaperPosition', [0 0 40 25]);
                            print(y,'-djpeg','-r400',picname);
                            
%                             % from t=0 to t=tfin/3
%                             y=PlotTrajSing(in,[1 floor(in.tsteps/3)],m.traj(ntraj,1),vars);
%                             picname=sprintf('%s/traj%i.jpeg',picfolder,ntraj);
%                             set(y,'PaperPosition', [0 0 40 25]);
%                             print(y,'-djpeg','-r400',picname);
%                             
%                             % from t=.9tfin to t=tfin
%                             y=PlotTrajSing(in,[in.tsteps-floor(in.tsteps/10) in.tsteps],m.traj(ntraj,1),vars);
%                             picname=sprintf('%s/end_traj%i.jpeg',picfolder,ntraj);
%                             set(y,'PaperPosition', [0 0 40 25]);
%                             print(y,'-djpeg','-r400',picname);
        
                        end
                        
                    end
                else
                    'Trajectories not ready yet'
                end
            end
        end
    end
end
