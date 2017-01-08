%% This code generate the kinetic part of the hamiltonian for the Fermi Hubbard model

function H_kin = GenerateHKin(in,states)

fprintf('Generating hopping hamiltonian........ \n')

D = size(states.index,2);
Du = size(states.u,2);
Dd = size(states.d,2);
nzpos=0;
nzneg=0;

if in.bc=='OBC'
    fprintf('Counting the number of non-zero matrix elements.......... \n')
    
    % Count nonzero elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:Du
        
        fprintf('\b\b\b\b\b\b%5.2f%%',100*i/(Du+Dd))
        
        temp=states.u(i); % look at the nonzero matrix elements involving temp
        
        for j=1:in.L-1
            link=bitget(temp,j:j+1);     % look at two consecutive bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                % hopping is possible
                nzpos=nzpos+Dd;
            end
        end
        
    end
    
    for i=1:Dd
        
        fprintf('\b\b\b\b\b\b%5.2f%%',100*(i+Du)/(Du+Dd))
        
        temp=states.d(i); % look at the nonzero matrix elements involving temp
        
        for j=1:in.L-1
            link=bitget(temp,j:j+1); % look at two consecutive bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                % hopping is possible
                nzpos=nzpos+Du;
            end
        end
        
    end
    
    posColIndex=zeros(nzpos,1);
    posRowIndex=zeros(nzpos,1);
    
    npos=0;
    
    fprintf('\n')
    fprintf('---There are %i non-zero matrix elements (%5.3f%%) \n',nzpos+nzneg+D, 100*(nzpos+nzneg+D)/D^2)
    fprintf('Counting the number of non-zero matrix elements........DONE \n')
    
    % Compute matrix elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('Computing the hopping matrix elements for the UP states.......... \n')
    
    for i=1:Du
        
        fprintf('\b\b\b\b\b\b%5.2f%%',100*i/Du)
        
        temp=states.u(i); % look at the nonzero matrix elements involving temp
        
        for j=1:in.L-1
            link=bitget(temp,j:j+1); % look at two consecutive bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                %hopping is possible
                dest=temp;
                dest=bitset(dest,j,link(2));
                dest=bitset(dest,j+1,link(1));
                
                idest=find(states.u==dest);
                
                for k=1:Dd % <fin|H_kin|init>: generate the states of the other species
                    npos=npos+1;
                    posColIndex(npos)=(k-1)*Du+i;
                    posRowIndex(npos)=(k-1)*Du+idest;
                end
                
            end
        end
        
    end
    
    fprintf('\n')
    fprintf('Computing the hopping matrix elements for the UP states........DONE \n')
    fprintf('Computing the hopping matrix elements for the DOWN states.......... \n') 
    
    for i=1:Dd
        
        fprintf('\b\b\b\b\b\b%5.2f%%',100*i/Dd)
        
        temp=states.d(i); % look at the nonzero matrix elements involving temp
        
        for j=1:in.L-1
            link=bitget(temp,j:j+1); % look at two consecutive bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                %hopping is possible
                dest=temp;
                dest=bitset(dest,j,link(2));
                dest=bitset(dest,j+1,link(1));
                
                idest=find(states.d==dest);
                
                for k=1:Du % <fin|H_kin|init>: generate the states of the other species
                    npos=npos+1;
                    posColIndex(npos)=(i-1)*Du+k;
                    posRowIndex(npos)=(idest-1)*Du+k;
                end
                
            end
        end
        
    end
    
    fprintf('\n')
    fprintf('Computing the hopping matrix elements for the DOWN states........DONE \n')
    
    % fill the hamiltonian matrix
    H_kin = sparse(posRowIndex, posColIndex, 1, D, D, nzpos);
    
    H_kin = in.J*H_kin;
    
    fprintf('Generating hopping hamiltonian........DONE \n \n')
    
else if in.bc=='PBC'
        
        fprintf('Counting the number of non-zero matrix elements.......... \n')
        
        % Count nonzero elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:Du
            
            fprintf('\b\b\b\b\b\b%5.2f%%',100*i/(Du+Dd))
            
            temp=states.u(i); % look at the nonzero matrix elements involving temp
            
            for j=1:in.L-1
                link=bitget(temp,j:j+1); % look at two consecutive bits
                hop=bitxor(link(1),link(2)); % apply the XOR operator
                if hop==1
                    % hopping is possible
                    nzpos=nzpos+Dd;
                end
            end
            
            % boundary conditions
            link=bitget(temp,[1 in.L]); % look at the fisrt and last bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                % hopping is possible
                nzneg=nzneg+Dd;
            end
        end
        
        for i=1:Dd
            
            fprintf('\b\b\b\b\b\b%5.2f%%',100*(i+Du)/(Du+Dd))
            
            temp=states.d(i); % look at the nonzero matrix elements involving temp
            
            for j=1:in.L-1
                link=bitget(temp,j:j+1); % look at two consecutive bits
                hop=bitxor(link(1),link(2));
                if hop==1
                    % hopping is possible
                    nzpos=nzpos+Du;
                end
            end
            
            % boundary conditions
            link=bitget(temp,[1 in.L]); % look at the fisrt and last bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                % hopping is possible
                nzneg=nzneg+Du;
            end
        end
        
        posColIndex=zeros(nzpos,1);
        posRowIndex=zeros(nzpos,1);
        negColIndex=zeros(nzneg,1);
        negRowIndex=zeros(nzneg,1);
        
        npos=0;
        nneg=0;
        
        fprintf('\n')
        fprintf('---There are %i non-zero matrix elements (%5.3f%%) \n',nzpos+nzneg+D, 100*(nzpos+nzneg+D)/D^2)
        fprintf('Counting the number of non-zero matrix elements........DONE \n')
        
        % Compute matrix elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fprintf('Computing the hopping matrix elements for the UP states.......... \n')
        
        for i=1:Du
            
            fprintf('\b\b\b\b\b\b%5.2f%%',100*i/Du)
            
            temp=states.u(i); % look at the nonzero matrix elements involving temp
            
            for j=1:in.L-1
                link=bitget(temp,j:j+1); % look at two consecutive bits
                hop=bitxor(link(1),link(2)); % apply the XOR operator
                if hop==1
                    %hopping is possible
                    dest=temp;
                    dest=bitset(dest,j,link(2));
                    dest=bitset(dest,j+1,link(1));
                    
                    idest=find(states.u==dest);
                    
                    for k=1:Dd % <fin|H_kin|init>: generate the states of the other species
                        npos=npos+1;
                        posColIndex(npos)=(k-1)*Du+i;
                        posRowIndex(npos)=(k-1)*Du+idest;
                    end
                    
                end
            end
            
            % boundary conditions
            link=bitget(temp,[1 in.L]); % look at the fisrt and last bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                dest=temp;
                dest=bitset(dest,1,link(2));
                dest=bitset(dest,in.L,link(1));
                
                idest=find(states.u==dest);
                
                for k=1:Dd % <fin|H_kin|init>: generate the states of the other species
                    % hopping is possible
                    nneg=nneg+1;
                    negColIndex(nneg)=(k-1)*Du+i;
                    negRowIndex(nneg)=(k-1)*Du+idest;
                end
            end
        end
        
        fprintf('\n')
        fprintf('Computing the hopping matrix elements for the UP states........DONE \n')
        fprintf('Computing the hopping matrix elements for the DOWN states.......... \n')
        
        
        for i=1:Dd
            
            fprintf('\b\b\b\b\b\b%5.2f%%',100*i/Dd)
            
            temp=states.d(i); % look at the nonzero matrix elements involving temp
            
            for j=1:in.L-1
                link=bitget(temp,j:j+1); % look at two consecutive bits
                hop=bitxor(link(1),link(2)); % apply the XOR operator
                if hop==1
                    %hopping is possible
                    dest=temp;
                    dest=bitset(dest,j,link(2));
                    dest=bitset(dest,j+1,link(1));
                    
                    idest=find(states.d==dest);
                    
                    for k=1:Du % <fin|H_kin|init>: generate the states of the other species
                        npos=npos+1;
                        posColIndex(npos)=(i-1)*Du+k;
                        posRowIndex(npos)=(idest-1)*Du+k;
                    end
                    
                end
            end
            
            % boundary conditions
            link=bitget(temp,[1 in.L]); % look at the fisrt and last bits
            hop=bitxor(link(1),link(2)); % apply the XOR operator
            if hop==1
                dest=temp;
                dest=bitset(dest,1,link(2));
                dest=bitset(dest,in.L,link(1));
                
                idest=find(states.d==dest);
                
                for k=1:Du % <fin|H_kin|init>: generate the states of the other species
                    % hopping is possible
                    nneg=nneg+1;
                    negColIndex(nneg)=(i-1)*Du+k;
                    negRowIndex(nneg)=(idest-1)*Du+k;
                end
            end
        end
        
        fprintf('\n')
        fprintf('Computing the hopping matrix elements for the DOWN states........DONE \n')
        
        % fill the hamiltonian matrix
        H_kin = sparse(posRowIndex, posColIndex, 1, D, D, nzpos);
        H_kin = H_kin-sparse(negRowIndex, negColIndex, 1, D, D, nzneg);
        
        H_kin = in.J*H_kin;
        
        fprintf('Generating hopping hamiltonian........DONE \n \n')
    end
    
    
end