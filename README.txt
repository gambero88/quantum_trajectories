The code in this folder computes the conditional evolution of a quantum system conditioned to quantum measurement.

The content of the folders is the following:
    
    /fermions: quantum trajectories for Fermi systems in one dimension

    /bosons: quantum trajectories for a double well system
             It is possible to solve the evolution of both pure and mixed states. The functions containing 'Rho' in their names solve the stochastic master equation.
             
The simulation starts by filling the input file datafile.m and running the MATLAB function RunSim.m

The outputs are organized in two folders:
    /matrices: contains the Hamiltonian and other operators that are expensive to compute and can be used for multiple simulations
    /trajectories: contains the quantum trajectories and the plots
    
Good luck!

Gabriel Mazzucchi - 15/09/2016

gabriel.mazzucchi@gmail.com
