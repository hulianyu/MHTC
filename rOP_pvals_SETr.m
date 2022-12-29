function rp = rOP_pvals_SETr(p,r)
% ref: Song C, Tseng G C. 
% Hypothesis setting and order statistic for robust genomic meta-analysis[J]. The annals of applied statistics, 2014.
p_list = sort(p);
p_r = p_list(r);% r-th ordered pval
%%  beta distribution
a = r;
b = length(p)-r+1;
rp = 1-betacdf(p_r,a,b,'upper');