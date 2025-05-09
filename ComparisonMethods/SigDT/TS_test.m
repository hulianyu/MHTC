function [pi,pval] = TS_test(X,m,cat,Q)
% Ref: Nonparametric Statistical Methods - Chapter 10.1
pi = (X(:,m)~=cat) + 1;
Q_range = 1:Q;
edges = [Q_range-0.5, max(Q_range)+0.5];
X_drop = X;
X_drop(:,m) = [];
N = height(X_drop);
sample1 = X_drop(pi==1,:);
n1 = height(sample1);
% O11 = histcounts(sample1, edges);
O11 = simplifiedHistcounts(sample1, edges);
sample2 = X_drop(pi==2,:);
n2 = height(sample2);
% O21 = histcounts(sample2, edges);
O21 = simplifiedHistcounts(sample2, edges);
p = (O11 + O21)/N;
p1 = O11/n1;
p2 = O21/n2;
SD = sqrt(p.*(1-p).*(1/n1 + 1/n2));
%% the test stastic |A|
absA = abs((p1-p2)./SD);
%% compute p-values
% pvs = 2*(normcdf(absA,'upper'));
% pvs = 2*(normcdf(-absA));
pvs = 2*(simplifiedNormcdf(-absA));
%% combine p-values
alpha = 0.01;
pval = binomtest(pvs,alpha);
end