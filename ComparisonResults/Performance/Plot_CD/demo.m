load('PerformanceComparison-2025.mat')
load('PerformanceComparison-DV.mat')
% load('PerformanceComparison-SigDT.mat')
% For Bonferroni-Dunn (BD) test
alpha = 0.05;
%% DV-verified data sets
list = [3 6 9 10 13 14 17 24];
algo_DV = {'K-MHTC','CU','k-modes','Entropy','CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest', 'SigDT','DV'};
Metric_DV_DV = Metric_DV(list,:);
Metric_MHTC_DV = Metric_MHTC(list,:);
Metric_CU_DV = Metric_CU(list,:);
Metric_kmodes_DV = Metric_kmodes(list,:);
Metric_Entropy_DV = Metric_Entropy(list,:);
Metric_CDC_DR_DV = Metric_CDC_DR(list,:);
Metric_CMS_DV = Metric_CMS(list,:);
Metric_CDE_DV = Metric_CDE(list,:);
Metric_Het2Hom_DV = Metric_Het2Hom(list,:);
Metric_HDNDW_DV = Metric_HDNDW(list,:);
Metric_COForest_DV = Metric_COForest(list,:);
Metric_SigDT_DV = Metric_SigDT(list,:);
ACC_list = [Metric_MHTC_DV(:,1) Metric_CU_DV(:,1) Metric_kmodes_DV(:,1) Metric_Entropy_DV(:,1) Metric_CDC_DR_DV(:,1) Metric_CMS_DV(:,1) Metric_CDE_DV(:,1) Metric_Het2Hom_DV(:,1) Metric_HDNDW_DV(:,1) Metric_COForest_DV(:,1) Metric_SigDT_DV(:,1) Metric_DV_DV(:,1)];
NMI_list = [Metric_MHTC_DV(:,2) Metric_CU_DV(:,2) Metric_kmodes_DV(:,2) Metric_Entropy_DV(:,2) Metric_CDC_DR_DV(:,2) Metric_CMS_DV(:,2) Metric_CDE_DV(:,2) Metric_Het2Hom_DV(:,2) Metric_HDNDW_DV(:,2) Metric_COForest_DV(:,2) Metric_SigDT_DV(:,2) Metric_DV_DV(:,2)];
ARI_list = [Metric_MHTC_DV(:,4) Metric_CU_DV(:,4) Metric_kmodes_DV(:,4) Metric_Entropy_DV(:,4) Metric_CDC_DR_DV(:,4) Metric_CMS_DV(:,4) Metric_CDE_DV(:,4) Metric_Het2Hom_DV(:,4) Metric_HDNDW_DV(:,4) Metric_COForest_DV(:,4) Metric_SigDT_DV(:,4) Metric_DV_DV(:,4)];
% [cd_ACC_DV,f_ACC_DV] = criticaldifference('ACC_CD_DV',ACC_list,algo_DV,alpha);
% [cd_NMI_DV,f_NMI_DV] = criticaldifference('NMI_CD_DV',NMI_list,algo_DV,alpha);
% [cd_ARI_DV,f_ARI_DV] = criticaldifference('ARI_CD_DV',ARI_list,algo_DV,alpha);
f_allinone = figure('Name','AllInOne','Units','normalized','Position',[0.1,0.1,0.4,0.8],'Color','w');
tiledlayout(f_allinone, 3, 1, 'TileSpacing','compact', 'Padding','compact');
% 
ax1 = nexttile;
[cd_ACC_DV, ax1] = criticaldifference_modified('', ACC_list, algo_DV, alpha, ax1);
title(ax1, 'Test for ACC comparison', 'FontSize', 12, 'FontWeight','bold');
%
ax2 = nexttile;
[cd_NMI_DV, ax2] = criticaldifference_modified('', NMI_list, algo_DV, alpha, ax2);
title(ax2, 'Test for NMI comparison', 'FontSize', 12, 'FontWeight','bold');
% 
ax3 = nexttile;
[cd_ARI_DV, ax3] = criticaldifference_modified('', ARI_list, algo_DV, alpha, ax3);
title(ax3, 'Test for ARI comparison', 'FontSize', 12, 'FontWeight','bold');
%
savefig(f_allinone, 'DV_verified_CD.fig');

%% SigDT-verified data sets
list = find(clusterability==1)'; % list = [2 3 6 7 9 10 11 12 13 14 16 17 18 19 20 22 23 24];
algo_SigDT = {'K-MHTC','CU','k-modes','Entropy','CDC\_DR','CMS','CDE','Het2Hom','HD-NDW', 'COForest', 'SigDT'};
Metric_MHTC_SigDT = Metric_MHTC(list,:);
Metric_CU_SigDT = Metric_CU(list,:);
Metric_kmodes_SigDT = Metric_kmodes(list,:);
Metric_Entropy_SigDT = Metric_Entropy(list,:);
Metric_CDC_DR_SigDT = Metric_CDC_DR(list,:);
Metric_CMS_SigDT = Metric_CMS(list,:);
Metric_CDE_SigDT = Metric_CDE(list,:);
Metric_Het2Hom_SigDT = Metric_Het2Hom(list,:);
Metric_HDNDW_SigDT = Metric_HDNDW(list,:);
Metric_COForest_SigDT = Metric_COForest(list,:);
Metric_SigDT_SigDT = Metric_SigDT(list,:);
ACC_list = [Metric_MHTC_SigDT(:,1) Metric_CU_SigDT(:,1) Metric_kmodes_SigDT(:,1) Metric_Entropy_SigDT(:,1) Metric_CDC_DR_SigDT(:,1) Metric_CMS_SigDT(:,1) Metric_CDE_SigDT(:,1) Metric_Het2Hom_SigDT(:,1) Metric_HDNDW_SigDT(:,1) Metric_COForest_SigDT(:,1) Metric_SigDT_SigDT(:,1)];
NMI_list = [Metric_MHTC_SigDT(:,2) Metric_CU_SigDT(:,2) Metric_kmodes_SigDT(:,2) Metric_Entropy_SigDT(:,2) Metric_CDC_DR_SigDT(:,2) Metric_CMS_SigDT(:,2) Metric_CDE_SigDT(:,2) Metric_Het2Hom_SigDT(:,2) Metric_HDNDW_SigDT(:,2) Metric_COForest_SigDT(:,2) Metric_SigDT_SigDT(:,2)];
ARI_list = [Metric_MHTC_SigDT(:,4) Metric_CU_SigDT(:,4) Metric_kmodes_SigDT(:,4) Metric_Entropy_SigDT(:,4) Metric_CDC_DR_SigDT(:,4) Metric_CMS_SigDT(:,4) Metric_CDE_SigDT(:,4) Metric_Het2Hom_SigDT(:,4) Metric_HDNDW_SigDT(:,4) Metric_COForest_SigDT(:,4) Metric_SigDT_SigDT(:,4)];
% [cd_ACC_SigDT,f_ACC_SigDT] = criticaldifference('ACC_CD_SigDT',ACC_list,algo_SigDT,alpha);
% [cd_NMI_SigDT,f_NMI_SigDT] = criticaldifference('NMI_CD_SigDT',NMI_list,algo_SigDT,alpha);
% [cd_ARI_SigDT,f_ARI_SigDT] = criticaldifference('ARI_CD_SigDT',ARI_list,algo_SigDT,alpha);
f_allinone = figure('Name','AllInOne','Units','normalized','Position',[0.1,0.1,0.4,0.8],'Color','w');
tiledlayout(f_allinone, 3, 1, 'TileSpacing','compact', 'Padding','compact');
% 
ax1 = nexttile;
[cd_ACC_SigDT, ax1] = criticaldifference_modified('', ACC_list, algo_DV, alpha, ax1);
title(ax1, 'Test for ACC comparison', 'FontSize', 12, 'FontWeight','bold');
% 
ax2 = nexttile;
[cd_NMI_SigDT, ax2] = criticaldifference_modified('', NMI_list, algo_DV, alpha, ax2);
title(ax2, 'Test for NMI comparison', 'FontSize', 12, 'FontWeight','bold');
% 
ax3 = nexttile;
[cd_ARI_SigDT, ax3] = criticaldifference_modified('', ARI_list, algo_DV, alpha, ax3);
title(ax3, 'Test for ARI comparison', 'FontSize', 12, 'FontWeight','bold');
% 
savefig(f_allinone, 'SigDT_verified_CD.fig');

%% all data sets
algo = {'K-MHTC','CU','k-modes','Entropy','CDC\_DR','CMS','CDE','Het2Hom','HD-NDW', 'COForest', 'SigDT'};
ACC_list = [Metric_MHTC(:,1) Metric_CU(:,1) Metric_kmodes(:,1) Metric_Entropy(:,1) Metric_CDC_DR(:,1) Metric_CMS(:,1) Metric_CDE(:,1) Metric_Het2Hom(:,1) Metric_HDNDW(:,1) Metric_COForest(:,1) Metric_SigDT(:,1)];
NMI_list = [Metric_MHTC(:,2) Metric_CU(:,2) Metric_kmodes(:,2) Metric_Entropy(:,2) Metric_CDC_DR(:,2) Metric_CMS(:,2) Metric_CDE(:,2) Metric_Het2Hom(:,2) Metric_HDNDW(:,2) Metric_COForest(:,2) Metric_SigDT(:,2)];
ARI_list = [Metric_MHTC(:,4) Metric_CU(:,4) Metric_kmodes(:,4) Metric_Entropy(:,4) Metric_CDC_DR(:,4) Metric_CMS(:,4) Metric_CDE(:,4) Metric_Het2Hom(:,4) Metric_HDNDW(:,4) Metric_COForest(:,4) Metric_SigDT(:,4)];
% [cd_ACC,f_ACC] = criticaldifference('ACC_CD',ACC_list,algo,alpha);
% [cd_NMI,f_NMI] = criticaldifference('NMI_CD',NMI_list,algo,alpha);
% [cd_ARI,f_ARI] = criticaldifference('ARI_CD',ARI_list,algo,alpha);
f_allinone = figure('Name','AllInOne','Units','normalized','Position',[0.1,0.1,0.4,0.8],'Color','w');
tiledlayout(f_allinone, 3, 1, 'TileSpacing','compact', 'Padding','compact');
% 
ax1 = nexttile;
[cd_ACC, ax1] = criticaldifference_modified('', ACC_list, algo_DV, alpha, ax1);
title(ax1, 'Test for ACC comparison', 'FontSize', 12, 'FontWeight','bold');
% 
ax2 = nexttile;
[cd_NMI, ax2] = criticaldifference_modified('', NMI_list, algo_DV, alpha, ax2);
title(ax2, 'Test for NMI comparison', 'FontSize', 12, 'FontWeight','bold');
% 
ax3 = nexttile;
[cd_ARI, ax3] = criticaldifference_modified('', ARI_list, algo_DV, alpha, ax3);
title(ax3, 'Test for ARI comparison', 'FontSize', 12, 'FontWeight','bold');
% 
savefig(f_allinone, 'Alldata_CD.fig');