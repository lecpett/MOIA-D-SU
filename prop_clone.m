function [Ct,Ct_index] = prop_clone(Population,spi)
    %%
    Et_size = 10;
    Nc = 20;
    [~,index] = sort(spi,'descend');
    na_index  = index(1 : Et_size);
    Ct = [];
    Ct_index = [];
    for i = 1:Et_size
        cur_spi = spi(na_index(i));
        i_num = ceil(Nc*((cur_spi + 0.1e-10) / (sum(spi(na_index))+ 0.1e-10)));
        Ct = [Ct;repmat(Population(na_index(i)),i_num,1)];
        Ct_index = [Ct_index;repmat(na_index(i),i_num,1)];
    end
end
