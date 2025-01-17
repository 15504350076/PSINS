function [data, idx, m, s] = datacut(data0, t1, t2)
% Extract data between time tags t1 & t2.
%
% Prototype: [data, idx] = datacut(data0, t1, t2)
% Inputs: data0 - input data, whose last column should be time index
%         t1, t2 - start & end time tags
% Outputs: data, idx - output data & index in data0
%
% See also  datahalf, datacuts, datadel, getat, combinet.

% Copyright(c) 2009-2021, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/09/2014, 12/11/2021
    if length(t1)>1            % [data, datas, mean, sum] = datacut(data0, t1, t2)
        data = [];  idx = [];  m = []; s = [];
        for k=1:length(t1)
            datai = datacut(data0, t1(k), t2(k));
%             data = [data; datai];
            data{k} = datai;
            idx{k} = datai;
            m(k,:) = mean(datai,1);  s(k,:) = sum(datai,1);
        end
        return;
    end
    if nargin<3, t2=data0(end,end); end
    i1 = find(data0(:,end)>=t1, 1, 'first');
    i2 = find(data0(:,end)<=t2, 1, 'last');
    idx = (i1:i2)';
    data = data0(idx,:);
