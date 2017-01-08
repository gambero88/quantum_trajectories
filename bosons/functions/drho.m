function y = drho(t,Vrho)

global D H c cd cdc eff

% from vector to matrix
Mrho=reshape(Vrho,[D D]);

% commutator [H,rho]
commH=H*Mrho-Mrho*H;

% anticommutator {c^dagger c, rho}
antiCC=cdc*Mrho+Mrho*cdc;

% decoherence term c rho c^dagger
crhocd=c*Mrho*cd;

% evolution
My= -sqrt(-1)*commH-0.5*antiCC+(1-eff)*crhocd;

% from matrix to vector
y=reshape(My,[D^2 1]);


end