function InitializeSim(ik,iU,iz)
clc
close all

startup2  % add the folder with the functions to Matlab path

global fb % global variable


if ischar(iU) iU = str2num(iU);  end;
if ischar(ik) ik = str2num(ik);  end;
if ischar(iz) iz = str2num(iz);  end;

%% INPUT
datafile;  %load datafile

% load the parameters for the trajectories
in.U=U(iU);                % atom-atom interaction
in.k=k(ik);                % atoms-light coupling
in.dt=dt(ik);              % time step
in.tsteps=tsteps(ik)+1;    % number of time steps considered

% feedback parameters
in.z=z(iz);
fb=z(iz);

% define the output folder
in.folder=sprintf('./trajectories/%s_L%iu%id%i/',in.name,in.L,in.Nu,in.Nd);
mkdir(in.folder);

% copy the input file in the output folder
copyfile('datafile.m',in.folder)

%% Initialize states and operators
[psi0 op]=InitializeMat(in) ;


end

