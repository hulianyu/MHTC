function pval = output_combined_pval(X,pi,r)
[~,pvals] = chi_squared_test(X,pi);
pval =  rOP_pvals_SETr(pvals,r);
end

function [chi,p] = chi_squared_test(X,pi)
[N,M] = size(X);
k_list = unique(pi);
K = length(k_list);
p = zeros(1,M);
chi = 0;
for m=1:M
    Xm = X(:,m);
    Q = length(unique(Xm));
    oc = zeros(Q+1,K+1);% observed counts
    for k=1:K
        for q=1:Q
            set = Xm(pi==k_list(k));
            oc(q,k) = sum(set==q);
        end
    end
    oc(Q+1,:) = sum(oc);
    oc(:,K+1) = sum(oc,2);
    ec = (oc(end,1:end-1).*oc(1:end-1,end))./N;
    oc = oc(1:end-1,1:end-1);
    s = sum(((oc-ec).^2)./ec,'all');% chi-squared statistic
    chi = chi + s;
    df = (Q-1)*(K-1);% degrees of freedom
    % p(1,m) = chi2cdf(s,df,'upper');
    p(1,m) = simplifiedChi2cdf(s,df); % 'upper'
end
end

function rp = rOP_pvals_SETr(p,r)
% ref: Song C, Tseng G C. 
% Hypothesis setting and order statistic for robust genomic meta-analysis[J]. The annals of applied statistics, 2014.
p_list = sort(p);
p_r = p_list(r);% r-th ordered pval
%%  beta distribution
a = r;
b = length(p)-r+1;
rp = 1-betacdf(p_r,a,b,'upper');
end

function p = simplifiedChi2cdf(x,v)
% Simplified GAMCDF Gamma cumulative distribution function.
z = x/2;
a = v/2;
p = gammainc(z, a,'upper');
end