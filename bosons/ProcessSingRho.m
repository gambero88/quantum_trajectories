clc
clf
close all
clear all
startup2

%% Data input
folder='./trajectories/testN10/';
run(sprintf('%sdatafile.m',folder));

kstep=size(k,2);
zstep=size(z,2);
etastep=size(eta,2);

str2=sprintf('./matrices/operatorsN%i_%s.mat',in.N,in.name);
mop=matfile(str2);
op=mop.op;

%% Check trajectories with dynamics
avname=sprintf('%sdynamics_on.mat',folder);
delete(avname);

mav = matfile(avname,'Writable',true);

% Compute the averages for each simulation
istep=0;
for iz=1:zstep
    for ik=1:kstep
        for ieta=1:etastep
            str=sprintf('%sDynOn_k%gfb%geta%g.mat',folder,k(ik),z(iz),eta(ieta));
            if exist(str,'file')
                m = matfile(str);
                fprintf('Completed %i of %i from %s\n',m.done,in.ntraj,m. Properties.Source)
            end
        end
    end
end

%% Import trajectories with dynamics

% Compute the averages for each simulation
istep=0;

for iz=1:zstep
    for ik=1:kstep
        for ieta=1:etastep
            istep=istep+1;
            fprintf('\nProgress... %4.3g%%  \n',100*(istep-1)/(kstep*zstep*etastep))
            str=sprintf('%sDynOn_k%gfb%geta%g.mat',folder,k(ik),z(iz),eta(ieta));
            if exist(str,'file')
                m=matfile(str);
                tmpstr=sprintf('%sTMP_DynOn_k%gfb%geta%g.mat',folder,k(ik),z(iz),eta(ieta));
                
                if m.done<in.ntraj
                    delete(tmpstr)
                    copyfile(str,tmpstr);
                    m = matfile(tmpstr);
                end
                
                picfolder=sprintf('%spics%g',folder,eta(ieta));
                mkdir(picfolder);
                
                prob=op.ch.prob;
                in=m.in;
                in.done=m.done;
                
                for itraj=1:m.done
                    
                    traj=m.traj;
                    
                    fprintf('\n.......................Plotting...\n')
                    
                    %% plot average trajectories
                    
                    % plot panel is
                    % | 1  2  3  4 |
                    % | 5  6  7  8 |
                    % | 9 10 11 12 |
                    
                    vars(1).name='jump';
                    vars(1).err='n';
                    vars(1).range.y=[min(op.ch(1).jump) max(op.ch(1).jump)];
                    vars(2).name='flucjump';
                    vars(2).err='n';
                    
                    vars(3).name='Na';
                    vars(3).err='rho';
                    vars(4).name='flucNa';
                    vars(4).err='n';
                    
                    vars(5).name='counts';
                   
                    vars(6).name='energy';
                    vars(6).err='n';
                    
                    y=BEC_PlotTrajSing(in,[1 floor(tsteps(ik)/10)],traj(itraj,1),vars);
                    picname=sprintf('%s/short_traj%i.jpeg',picfolder,itraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                    
                    y=BEC_PlotTrajSing(in,[1 tsteps(ik)],traj(itraj,1),vars);
                    picname=sprintf('%s/long_traj%i.jpeg',picfolder,itraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                    
                    y=BEC_PlotTrajSing(in,[1 floor(tsteps(ik)/3)],traj(itraj,1),vars);
                    picname=sprintf('%s/traj%i.jpeg',picfolder,itraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                    
                    y=BEC_PlotTrajSing(in,[tsteps(ik)-floor(tsteps(ik)/4) tsteps(ik)],traj(itraj,1),vars);
                    picname=sprintf('%s/end_traj%i.jpeg',picfolder,itraj);
                    set(y,'PaperPosition', [0 0 40 25]);
                    print(y,'-djpeg','-r400',picname);
                    
                end
                if exist(tmpstr)
                    delete(tmpstr)
                end
            end
        end
    end
end

