% This function generates the dictionary and the Fock states for a  chain of Fermions
%
%
% Last modified: 02/02/2015

function [states] = GenerateBasis(in)

fprintf('Generating the states tables........ \n')

% dimension of the Hilbert space
D=(factorial(in.L)/(factorial(in.L-in.Nu)*factorial(in.Nu)))*(factorial(in.L)/(factorial(in.L-in.Nd)*factorial(in.Nd)));

fprintf('---The dimension of the Hilbert space is %i \n',D)

% initialize basis table
states.index=zeros(D,1);

% generate the basis states
set=[0:in.L-1];          % set of the exponents
temp=combnk(set,in.Nu)'; % combinations of Nu elements
if in.Nu>1
    states.u=sum(2.^temp);
elseif in.Nu==1
    states.u=2.^temp;
elseif in.Nu==0
    states.u=0;
end

temp=combnk(set,in.Nd)'; % combinations of Nd elements
if in.Nd>1
    states.d=sum(2.^temp);
else
    states.d=2.^temp;
end

% index for the states
states.index=zeros(1,size(states.u,2)*size(states.d,2));
id=ones(1,size(states.u,2));
first=1;

% fill the index vector: index(i + (n-1)*Du)=2^L*dstates(n) + ustates(i)
for i=1:size(states.d,2) 
    last=first+size(states.u,2)-1;
    states.index(first:last)=2^in.L*states.d(i)*id+states.u;
    first=first+size(states.u,2);
end

fprintf('Generating the states tables........ DONE \n \n')

end