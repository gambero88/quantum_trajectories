function wf=CallPlot(panel,var,traj,tstep,in);

% initialize time arrays
t=in.dt*[tstep(1)-1:tstep(2)-1];
tindex=[tstep(1):tstep(2)];
var.range.t=[t(1) t(end)];

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


switch var.name 
    
    % jump operator channel 1
    case 'jump1' 
        y=traj.ch(1).jump.val(tindex);
        var.range.y=[min(y) max(y)];
        var.label.x='time';
        var.label.y='jump operator ch1';
        var.label.title='Jump operator ch1';
        var.type='2d';
        var.line='r';
    % jump operator channel 2
    case 'jump2'
        y=traj.ch(2).jump.val(tindex);
        var.range.y=[min(y) max(y)];
        var.label.x='time';
        var.label.y='jump operator ch2';
        var.label.title='Jump operator ch2';
        var.type='2d';
        var.line='b';
    % all jump operators    
    case 'jumps'
        for ich=1:in.nch
        y(ich,:)=traj.ch(ich).jump.val(tindex);
        end
        var.range.y=[min(min(y)) max(max(y))];
        var.label.x='time';
        var.label.y='jump operators';
        var.label.title='Jump operators';
        var.type='2d';
        var.line='';
    % absolute value of the 1st jump operator    
    case 'jumpSq'
        y(1,:)=abs(traj.ch(1).jump.val(tindex)).^2;
        var.range.y=[min(min(y)) max(max(y))];
        var.label.x='time';
        var.label.y='jump operators';
        var.label.title='Jump operators Abs squared';
        var.type='2d';
        var.line='';
    % local density (UP)    
    case 'rhoU'
        y=1:in.L;
        z=traj.rhoU(tindex,:)';
        var.range.z=[0 1];
        var.label.x='time';
        var.label.y='site';
        var.label.title='U density';
        var.type='colormap';
    % local density (DOWN)    
    case 'rhoD'
        y=1:in.L;
        z=traj.rhoD(tindex,:)';
        var.range.z=[0 1];
        var.label.x='time';
        var.label.y='site';
        var.label.title='D density';
        var.type='colormap';
    % local density (UP + DOWN)    
    case 'rho'
        y=1:in.L;
        z=traj.rhoU(tindex,:)'+traj.rhoD(tindex,:)';
        var.range.z=[0 2];
        var.label.x='time';
        var.label.y='site';
        var.label.title='Density';
        var.type='colormap';
    % local magnetisation (UP - DOWN)     
    case 'mag'
        y=1:in.L;
        z=traj.rhoU(tindex,:)'-traj.rhoD(tindex,:)';
        var.range.z=[-1 1];
        var.label.x='time';
        var.label.y='site';
        var.label.title='Magnetisation';
        var.type='colormap';
    % density correlations with the central site (DOWN)
    case 'corrC'
        y=1:in.L;
        z=squeeze(reshape(traj.corr.DD(tindex,:,floor(in.L/2)),[size(tindex) in.L]))';
        z(floor(in.L/2),:)=0;
        var.range.z=[min(min(z)) min(max(z))];
        var.label.x='time';
        var.label.y='site';
        var.label.title='Correlation with central site';
        var.type='colormap'; 
    % density correlations with the edge site (DOWN)
    case 'corr'
        y=1:in.L;
        z=squeeze(reshape(traj.corr.DD(tindex,:,1),[size(tindex) in.L]))';
        z(1,:)=0;
        var.range.z=[min(min(z)) min(max(z))];
        var.label.x='time';
        var.label.y='site';
        var.label.title='Correlation with edge site';
        var.type='colormap';
    % staggered magnetisation    
    case 'staggered'
        y=sum(((traj.rhoU(tindex,:)-traj.rhoD(tindex,:)).*kron((-1).^[1:in.L],ones(size(tindex,2),1)))')'./(in.Nu+in.Nd);
        var.range.y=[-1 1];
        var.label.x='time';
        var.label.y='stag mag';
        var.label.title='Staggered magnetisation';
        var.type='2d';
        var.line='r';
    % staggered magnetisation squared    
    case 'staggered2'
        y=zeros(size(tindex,2),1);
        for j=1:in.L
            for k=1:in.L
            y=y+(-1)^(j+k)*(traj.corr.UU(tindex,j,k)+traj.corr.DD(tindex,j,k)-...
                            traj.corr.UD(tindex,j,k)-traj.corr.DU(tindex,j,k)+...
                            (traj.rhoU(tindex,j)-traj.rhoD(tindex,j)).*(traj.rhoU(tindex,k)-traj.rhoD(tindex,k)));
            end
        end
        y=sqrt(y)/(in.Nu+in.Nd);
        var.range.y=[0 1];
        var.label.x='time';
        var.label.y='stag mag';
        var.label.title='Staggered magnetisation squared';
        var.type='2d';
        var.line='r';
    % correlations between odd and even sites <Nodd Neven>-<Nodd><Neven>
    case 'corrUDeo'
        y=zeros(size(tindex,2),1);
        for j=1:2:in.L
            for k=2:2:in.L
            y=y+traj.corr.UD(tindex,j,k);
            end
        end    
        var.range.y=[min([min(y),-0.1]) max([max(y),0.1])];
        var.label.x='time';
        var.label.y='corr';
        var.label.title='Uodd-Deven corr';
        var.type='2d';
        var.line='r';
    % magnetic structure factor
    case 'Smag'
        ii=sqrt(-1);
        nq=in.L+1;
        y=linspace(0,1,nq);
        q=kron(y,ones(size(tindex,2),1));
        S=zeros(size(tindex,2),nq);
        for i=1:in.L
            for j =1:in.L
                S=S+exp(ii*(i-j)*q*2*pi).*kron(...
                    traj.corr.UU(tindex,i,j) + traj.corr.DD(tindex,i,j)-...
                    traj.corr.UD(tindex,i,j) - traj.corr.DU(tindex,i,j)+...
                    (traj.rhoU(tindex,i)-traj.rhoD(tindex,i)).*(traj.rhoU(tindex,j)-traj.rhoD(tindex,j)),ones(1,nq));
            end
        end

        S=real(S/(in.Nu+in.Nd));
        z=S';
        var.range.z=[0 in.L];
        var.label.x='time';
        var.label.y='q/pi';
        var.label.title='Mag structure factor';
        var.type='colormap';
    % density structure factor 
    case 'Srho'
        ii=sqrt(-1);
        nq=in.L+1;
        y=linspace(0,1,nq);
        q=kron(y,ones(size(tindex,2),1));
        S=zeros(size(tindex,2),nq);
        for i=1:in.L
            for j =1:in.L
                S=S+exp(ii*(i-j)*q*2*pi).*kron(...
                    traj.corr.UU(tindex,i,j) + traj.corr.DD(tindex,i,j)+...
                    traj.corr.UD(tindex,i,j) + traj.corr.DU(tindex,i,j)+...
                    (traj.rhoU(tindex,i)+traj.rhoD(tindex,i)).*(traj.rhoU(tindex,j)+traj.rhoD(tindex,j)),ones(1,nq));
            end
        end

        S=real(S/(in.Nu+in.Nd));
        z=S';
        var.range.z=[0 in.L/4];
        %var.range.z=[min(min(S)) max(max(S))];
        var.label.x='time';
        var.label.y='q/pi';
        var.label.title='Rho structure factor';
        var.type='colormap';
    % energy
    case 'energy'
        y=traj.energy(tindex);
        var.range.y=[min(y) max(y)];
        var.label.x='time';
        var.label.y='<H>';
        var.label.title='Energy';
        var.type='2d';
        var.line='m';
    % overlap with the initial state    
    case 'overlap'
        y=traj.overlap(tindex);
        var.range.y=[0 1];
        var.label.x='time';
        var.label.y='overlap';
        var.label.title='Overlap with gs';
        var.type='2d';
        var.line='k';
    % photocounts    
    case 'counts'
        y=traj.countj(tindex,:);
        var.range.y=[0 max(max(y))+1];
        var.label.x='time';
        var.label.y='nph';
        var.label.title='Photocounts';
        var.type='2d';
        var.line='';
    % fluctuations of the 1s jump operator         
    case 'flucjump1'
        y=traj.ch(1).jump.fluc(tindex);
        var.range.y=[0 max(y)];
        var.label.x='time';
        var.label.y='jump ch1 fluctuations';
        var.label.title='Jump ch1 fluctuations ';
        var.type='2d';
        var.line='r';
    % fluctuations of the 1s jump operator    
    case 'flucjump2'
        y=traj.ch(2).jump.fluc(tindex);
        var.range.y=[0 max(y)];
        var.label.x='time';
        var.label.y='jump ch2 fluctuations';
        var.label.title='Jump ch2 fluctuations ';
        var.type='2d';
        var.line='b';
    % local fluctuations of the UP density    
    case 'flucrhoU'
        y=1:in.L;
        z=traj.fluc.UU(tindex,:)';
        var.range.z=[0 .5];
        var.label.x='time';
        var.label.y='site';
        var.label.title='U density fluc';
        var.type='colormap';
    % local fluctuations of the DOWN density     
    case 'flucrhoD'
        y=1:in.L;
        z=traj.fluc.DD(tindex,:)';
        var.range.z=[0 .5];
        var.label.x='time';
        var.label.y='site';
        var.label.title='D density fluc';
        var.type='colormap';
    % local fluctuations of the UP+DOWN density     
     case 'flucrho'
        y=1:in.L;
        z=traj.fluc.DD(tindex,:)'+traj.fluc.DD(tindex,:)'+traj.fluc.DU(tindex,:)'+traj.fluc.UD(tindex,:)';
        var.range.z=[0 2];
        var.label.x='time';
        var.label.y='site';
        var.label.title='Density fluc';
        var.type='colormap';
     % local fluctuations of the UP-DOWN magnetisation       
     case 'flucmag'
        y=1:in.L;
        z=traj.fluc.DD(tindex,:)'+traj.fluc.DD(tindex,:)'-traj.fluc.DU(tindex,:)'-traj.fluc.UD(tindex,:)';
        var.range.z=[0 1];
        var.label.x='time';
        var.label.y='site';
        var.label.title='Magnetisation fluc';
        var.type='colormap';
    % local UP/DOWN density correlations    
    case 'flucUD'
        y=1:in.L;
        z=traj.fluc.UD(tindex,:)';
        var.range.z=[-.5 .5];
        var.label.x='time';
        var.label.y='site';
        var.label.title='UD correlations';
        var.type='colormap';
    % probability distribution    
    case 'prob'
        y=var.prob.bin.center;
        z=var.prob.val(tindex,:)';
        var.range.z=[0 1];
        var.type='colormap';
    % UP/UP correlations between the central site and the rest of the lattice
    case 'corrUU'
        y=1:in.L;
        z=reshape(traj.corr.UU(tindex,:,floor(in.L/2)),[tindex(end) in.L])';
        z(floor(in.L/2),:)=0;
        var.range.z=0.01*[floor(100*min(min(z))) ceil(100*max(max(z)))];
        var.label.x='time';
        var.label.y='site';
        var.label.title='UU corr';
        var.type='colormap';
    % UP/DOWN correlations between the central site and the rest of the lattice    
    case 'corrUD'
        y=1:in.L;
        z=reshape(traj.corr.UD(tindex,:,floor(in.L/2)),[tindex(end) in.L])';
        %z(floor(in.L/2),:)=0;
        var.range.z=0.01*[floor(100*min(min(z))) ceil(100*max(max(z)))];
        var.label.x='time';
        var.label.y='site';
        var.label.title='UD corr';
        var.type='colormap';
     % DOWN/DOWN correlations between the central site and the rest of the lattice
    case 'corrDD'
        y=1:in.L;
        z=reshape(traj.corr.UU(tindex,:,floor(in.L/2)),[tindex(end) in.L])';
        z(floor(in.L/2),:)=0;
        var.range.z=0.01*[floor(100*min(min(z))) ceil(100*max(max(z)))];
        var.label.x='time';
        var.label.y='site';
        var.label.title='DD corr';
        var.type='colormap';                 
end

switch var.type 
    
    case '2d'      
        plot(t,y,var.line);
        xlim(var.range.t);
        ylim(var.range.y);
        xlabel(var.label.x);
        ylabel(var.label.y); 
        title(var.label.title);
    case '2x2d'
        plot(t,y1,var.line1,t,y2,var.line2);
        xlim(var.range.t);
        ylim(var.range.y1);
        xlabel(var.label.x);
        ylabel(var.label.y1); 
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
