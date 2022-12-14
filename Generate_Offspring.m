function Offspring = Generate_Offspring(parents, Score)
    %% 
    Parent1 = parents(1).dec;
    Parent2 = parents(2).dec;
    [N,D]   = size(Parent1);
    %% Uniform crossover
    kc = rand(N,D) < 0.5;
    kc(repmat(rand(N,1)>1,1,D)) = false;
    Offspring    = Parent1;
    Offspring(kc) = Parent2(kc);
    %% Bit-flip mutation
    Site = rand(N,D) < 1/D;
    site_index = find(Site);
    b = randperm(size(site_index,2));
    site_index = site_index(b);
    Offspring(Site) = ~Offspring(Site);
    for i = 1:floor(0.5 * size(site_index,2))
        if Offspring(site_index(i)) == 0
            if Score(site_index(i)) > rand
                Offspring(site_index(i)) = 1;
            end
        else
            if Score(site_index(i)) < rand
                Offspring(site_index(i)) = 0;
            end
        end
    end
    Offspring = SOLUTION(Offspring);
end


