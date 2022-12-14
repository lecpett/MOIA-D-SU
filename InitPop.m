function [MI, Population] = InitPop(Problem)
     %% 
     Train_D = [Problem.TrainIn;Problem.ValidIn];
     Train_L = [Problem.TrainOut;Problem.ValidOut];

     %% 计算互信息
     MI = MI_Cal(Problem, Train_D, Train_L);
     %% 归一化
%      max_MI = max(MI);
%      min_MI = min(MI);
%      MI = (MI-min_MI)/(max_MI-min_MI);

     %% 种群初始化
     Pop = zeros(Problem.N,Problem.D);
     for i = 1:Problem.N
        for j = 1:ceil(rand*Problem.D)
            index = randperm(Problem.D,2);
            if MI(index(1)) > MI(index(2))
               Pop(i,index(1)) = 1;
            else
               Pop(i,index(2)) = 1;
            end
        end
     end
     Population = SOLUTION(Pop);
     
end
%计算特征与类别的互信息
function MI = MI_Cal(Problem, Train_D, Train_L)
     for k = 1:Problem.D
         MI(k) = cal_mi(Train_D(:,k),Train_L);
     end
    function su = cal_mi(a,b)
        %% culate MI of a and b in the region of the overlap part
        %% 计算重叠部分
        [Ma,Na] = size(a);     % 行数,列数
        [Mb,Nb] = size(b);
        M=min(Ma,Mb);   %M个实例（行）
        N=min(Na,Nb);   %N个特征（列）
        %% 初始化直方图数组
        hab = zeros(256,256);
        ha = zeros(1,256);
        hb = zeros(1,256);
        %归一化
        if max(max(a))~=min(min(a))
            a = (a-min(min(a)))/(max(max(a))-min(min(a)));
        else
            a = zeros(M,N);
        end
        %
        if max(max(b))~=min(min(b))
            b = (b-min(min(b)))/(max(max(b))-min(min(b)));
        else
            b = zeros(M,N);
        end
        a = double(int16(a*255))+1;   %a,b是整数
        b = double(int16(b*255))+1;
        %% 统计直方图
        for i=1:M
            for j=1:N
               indexx =  a(i,j);
               indeyy =  b(i,j) ;
               hab(indexx,indeyy) = hab(indexx,indeyy)+1;%联合直方图
               ha(indexx) = ha(indexx)+1;%a图直方图
               hb(indeyy) = hb(indeyy)+1;%b图直方图
           end
        end
        
        %% 计算a图信息熵
        hsum = sum(sum(ha));
        index = find(ha~=0);
        p = ha/hsum;
        Ha = -sum(p(index).*log(p(index)));
        
        %% 计算b图信息熵
        hsum = sum(sum(hb));
        index = find(hb~=0);
        p = hb/hsum;
        Hb = -sum(p(index).*log(p(index)));
        
        %% 计算联合信息熵
        hsum1 = sum(sum(hab));
        index1 = find(hab~=0);
        p1 = hab/hsum1;
        Hab = -sum(sum(p1(index1).*log(p1(index1))));

        %% 计算a和b的互信息
        I_ab = Ha+Hb-Hab;

        %% 计算a和b的标准化互信息（对称不确定性）
        su = 2* (I_ab / (Ha+Hb));
    end
end
% %计算特征间的冗余值
% function [Each_Corr] = calculate_corr(data)
%     [Each_Corr] = corr(data);      %X是两组数必须要用列向量的方式来表达，计算自相关性
%     Each_Corr(isnan(Each_Corr))=1; %
% end
