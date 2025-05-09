function [minpval,bpi,bm,bcat] = find_ts_mq(X,Q)
outliers = 5;
X(:,1) = []; % objsID
M = size(X,2);
pv = cell(M,1);
pi = cell(M,1);
discat = cell(M,1);
for m=1:M
    uList = unique(X(:,m));
    numQ = length(uList);
    if numQ~=1
        for q=1:numQ
            cat = uList(q);
            [pi_current, pv_current] = TS_test(X,m,cat,Q); % Two sample t-test
            pi{m,1} = [pi{m,1} pi_current];
            pv{m,1} = [pv{m,1} pv_current];
            discat{m,1} = [discat{m,1} cat];
        end
    else
        cat = uList(1);
        pi{m,1} = ones(size(X,1),1);
        pv{m,1} = 1;
        discat{m,1} = [discat{m,1} cat];
    end
end
%% Find the best partition
% Loop through each cell in pv
t_pv = 1;
Z = [1,1];
for x = 1:size(pv, 1)
    % Loop through each element in the current cell
    for y = 1:length(pv{x, 1})
        if t_pv>pv{x, 1}(y) && min(simplifiedHistcounts(pi{x}(:,y), 0.5:2.5))>outliers
            t_pv = pv{x, 1}(y);
            Z = [x, y];
        end
    end
end
bm = Z(1,1);
bq = Z(1,2);
minpval = t_pv;
bcat = discat{bm}(bq);
bpi = pi{bm}(:,bq);
end