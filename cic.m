function [data_cic,tmp_all] = cic(data_pdm,R,N)
%% Brief: Matlab cic code
%% Author: myuzhao@163.com
    if nargin < 1
        ['Usage error,nargin must greater than 1']
        return;
    end
    if nargin < 2
        N = 4;
    end
    if nargin < 3
        R = 16;
        N = 4;
    end
    D = 1;
    intOut = zeros(N,1);
    delay_intOut = zeros(N,1);
    yn = [];
    for i = 1:length(data_pdm)
        tmp = data_pdm(i);
        for j = 1:N      %%integrate        
            intOut(j) = intOut(j) + tmp;
            tmp = intOut(j);
        end
        if mod(i,R) == 1  %%decimator
             tmp = intOut(N);
             for j = 1:N  %%comb
                combOut = tmp - delay_intOut(j,1);
                delay_intOut(j,1) = tmp;
                tmp = combOut ;
             end
             yn = [yn combOut];
        end
    end
    data_cic = yn(:)/(R^N);
end

