%% This function computes averages over many trajectories and plots various observables
%
%
% The plot panel is labelled as
%
% | 1  2  3  4 |
% | 5  6  7  8 |
% | 9 10 11 12 |
%
% The variables to be plotted are called vars(panel_position).name='name' where name
% can be (3rd February 2015)
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
clf
close all
clear all

startup2;

%% Folder containing the trajectories to be plotted
folder='./trajectories/test3_L5u2d2/';

dyn='On'; % is tunnelling  On or Off?

% import the input file
run([folder 'datafile.m'])

% load the operators used in the simulation
str2=sprintf('./matrices/operatorsL%i_%s.mat',in.L,in.name);
mop=matfile(str2);
op=mop.op;

istep=0; % counter

%% Check trajectories
avname=sprintf('%sdynamics_%s.mat',folder,dyn);
delete(avname);

mav = matfile(avname,'Writable',true);

% Compute the averages for each simulation

for iz =1:size(z,2) % cicle on the feedback strength
    for ik=1:size(k,2) % cicle on the measurement strength
        for iU=1:size(U,2)% cicle on the interaction strength
            str=sprintf('%sDyn%s_k%gU%gfb%g.mat',folder,dyn,k(ik),U(iU),z(iz));
            if exist(str,'file')
                m = matfile(str);
                fprintf('Completed %i of %i from %s\n',m.done,in.ntraj,m. Properties.Source)
            end
        end
    end
end

%% Import trajectories

% Compute the averages for each simulation
istep=0; % counter
for iz =1:size(z,2) % cicle on the feedback strength
    for ik=1:size(k,2) % cicle on the measurement strength
        for iU=1:size(U,2)% cicle on the interaction strength
            istep=istep+1;
            fprintf('\nProgress... %4.3g%%  \n ',100*(istep-1)/(size(k,2)*size(U,2)*size(z,2)))
            str=sprintf('%sDyn%s_k%gU%gfb%g.mat',folder,dyn,k(ik),U(iU),z(iz));
            if exist(str,'file')
                m = matfile(str);
                
                out=ComputeAverages(in,m);
                mav.av(ik,iU)=out;
                
                fprintf('\n.......................Plotting...\n')
                
                picfolder=sprintf('%spics%g',folder,z(iz));
                mkdir(picfolder);
                
                %% plot average trajectories
                
                % Variables to be plotted
                % row 1
                vars(1).name='jump1';
                vars(2).name='flucjump1';
                vars(3).name='rhoD';
                vars(4).name='counts';
                
                % row 2
                vars(5).name='rhoU';
                vars(6).name='mag';
                vars(7).name='corr';
                vars(8).name='overlap';
                
                % row 3
                vars(9).name='flucrhoD';
                vars(10).name='flucrhoD';
                vars(11).name='staggered2';
                vars(12).name='corrUDeo';
                
                
                tmp=mav.av(ik,iU);
                inav=tmp.in;
                inav.done=m.done;
                
                %% Plot the trajectories in different time intervals
                % from t=0 to t=tfin/10
                y=PlotTrajSing(inav,[1 floor(inav.tsteps/10)],mav.av(ik,iU),vars);
                picname=sprintf('%s/short_trajk%gU%gfb%g.jpeg',picfolder,k(ik),U(iU),z(iz));
                set(y,'PaperPosition', [0 0 40 25]);
                print(y,'-djpeg','-r400',picname);
                
                % from t=0 to t=tfin
                y=PlotTrajSing(inav,[1 inav.tsteps],mav.av(ik,iU),vars);
                picname=sprintf('%s/long_trajk%gU%gfb%g.jpeg',picfolder,k(ik),U(iU),z(iz));
                set(y,'PaperPosition', [0 0 40 25]);
                print(y,'-djpeg','-r400',picname);
                
                % from t=0 to t=tfin/3
                y=PlotTrajSing(inav,[1 floor(inav.tsteps/3)],mav.av(ik,iU),vars);
                picname=sprintf('%s/trajk%gU%gfb%g.jpeg',picfolder,k(ik),U(iU),z(iz));
                set(y,'PaperPosition', [0 0 40 25]);
                print(y,'-djpeg','-r400',picname);
                
                % from t=.9tfin to t=tfin
                y=PlotTrajSing(inav,[inav.tsteps-floor(inav.tsteps/10) inav.tsteps],mav.av(ik,iU),vars);
                picname=sprintf('%s/end_trajk%gU%gfb%g.jpeg',picfolder,k(ik),U(iU),z(iz));
                set(y,'PaperPosition', [0 0 40 25]);
                print(y,'-djpeg','-r400',picname);
                
            end
        end
    end
end


