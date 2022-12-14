classdef MOIADSU < ALGORITHM
% <multi> <real/binary> <sparse>

    methods
    
        function main(Algorithm,Problem)
             %% Generate the weight vectors
             [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
             T = ceil(Problem.N/5);
             %% Detect the neighbours of each solution
             B = pdist2(W,W);
             [~,B] = sort(B,2);
             B = B(:,1:T);
             %% Generate population MI-based
             [Score,Population] = InitPop(Problem);
%              Population = Problem.Initialization();
             %% ideal point
             Z = min(Population.objs,[],1);
             %%
             ge_dist = max(abs(Population.objs-repmat(Z,Problem.N,1)).*W,[],2);
             %% reproduction operator
             cros_muta_Metrix = (1-ge_dist) .* (Score .* Population.decs);
             %% initialize solution performance increase     
             spi = sum(cros_muta_Metrix,2) ./ sum(cros_muta_Metrix~=0,2);
             %% 
%              Nonzero = ones(1, Problem.N);
             %% Optimization
             while Algorithm.NotTerminated(Population,Problem)
                % Ct proportional clone 
                [Ct,~] = prop_clone(Population,spi);
                % For each solution
                for i = 1 : Problem.N   
                    % i-th solution neighbours
                    P = B(i,randperm(size(B,2)));
                    % Choose the parents
                    if rand < 0.7     
                        % parents and their index
                        parents = Population(P(1:2));
                    else
                        % parents and their index
                        t_index = randperm(size(Ct,1),2);
                        parents = Ct(t_index);
                    end
                    % Generate an offspring
                    Offspring = Generate_Offspring(parents, Score);    
                    % Update the ideal point
                    Z = min(Z,Offspring.obj);
                    % Update the neighbours
                    g_all = max(repmat(abs(Offspring.obj-Z),Problem.N,1).*W,[],2);
                    [~,update_W] = min(g_all);
                    P = B(update_W,randperm(size(B,2)));
                    % Tchebycheff approach
                    g_old = max(abs(Population(P).objs-repmat(Z,T,1)).*W(P,:),[],2);
                    g_new = max(repmat(abs(Offspring.obj-Z),T,1).*W(P,:),[],2);  
                    C = logical(g_new < g_old);
                    Population(P(C)) = Offspring;
                end
                
               %%
                ge_dist = max(abs(Population.objs-repmat(Z,Problem.N,1)).*W,[],2);
                % update cros_muta_Metrix
                cros_muta_Metrix = (1-ge_dist) .* (Score .* Population.decs);
                % update solution performance increase
                spi = sum(cros_muta_Metrix,2) ./ sum(cros_muta_Metrix~=0,2);
                spi(isnan(spi)) = 0;
             end
        end
    end    
end
