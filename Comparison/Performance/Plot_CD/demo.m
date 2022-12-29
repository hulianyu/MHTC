load('PerformanceComparison.mat')
% For Bonferroni-Dunn (BD) test
alpha = 0.05;
%% Significant (DV) data sets
list = [3 6 9 10 13 14 17 24];
algo = {'K-MHTC','CU','k-modes','Entropy','DV','CDC\_DR','CMS','CDE','Het2Hom','HD-NDW'};
Metric_MHTC_Sig = Metric_MHTC(list,:);
Metric_CU_Sig = Metric_CU(list,:);
Metric_kmodes_Sig = Metric_kmodes(list,:);
Metric_Entropy_Sig = Metric_Entropy(list,:);
Metric_DV_Sig = Metric_DV(list,:);
Metric_CDC_DR_Sig = Metric_CDC_DR(list,:);
Metric_CMS_Sig = Metric_CMS(list,:);
Metric_CDE_Sig = Metric_CDE(list,:);
Metric_Het2Hom_Sig = Metric_Het2Hom(list,:);
Metric_HDNDW_Sig = Metric_HDNDW(list,:);
ACC_list = [Metric_MHTC_Sig(:,1) Metric_CU_Sig(:,1) Metric_kmodes_Sig(:,1) Metric_Entropy_Sig(:,1) Metric_DV_Sig(:,1) Metric_CDC_DR_Sig(:,1) Metric_CMS_Sig(:,1) Metric_CDE_Sig(:,1) Metric_Het2Hom_Sig(:,1) Metric_HDNDW_Sig(:,1)];
NMI_list = [Metric_MHTC_Sig(:,2) Metric_CU_Sig(:,2) Metric_kmodes_Sig(:,2) Metric_Entropy_Sig(:,2) Metric_DV_Sig(:,2) Metric_CDC_DR_Sig(:,2) Metric_CMS_Sig(:,2) Metric_CDE_Sig(:,2) Metric_Het2Hom_Sig(:,2) Metric_HDNDW_Sig(:,2)];
[cd,f] = criticaldifference('NMI_CD',NMI_list,algo,alpha);