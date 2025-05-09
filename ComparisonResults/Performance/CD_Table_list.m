% For Bonferroni-Dunn (BD) test
alpha = 0.05;
%% DV-verified data sets
Plot_CD_algo_list = {'Random','K-MHTC','CU','k-modes','Entropy','SigDT',...
    'CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};

%% ACC
Plot_CD_ACC = Table_ACC_list;
Plot_CD_ACC(:,end) = [];% remove mean
Plot_CD_ACC = Plot_CD_ACC';
Plot_CD_ACC(:,6) = []; % remove DV
%% NMI
Plot_CD_NMI = Table_NMI_list;
Plot_CD_NMI(:,end) = [];% remove mean
Plot_CD_NMI = Plot_CD_NMI';
Plot_CD_NMI(:,6) = []; % remove DV
%% ARI
Plot_CD_ARI = Table_ARI_list;
Plot_CD_ARI(:,end) = [];% remove mean
Plot_CD_ARI = Plot_CD_ARI';
Plot_CD_ARI(:,6) = []; % remove DV
%%
f_allinone = figure('Name','AllInOne','Units','normalized','Position',[0.1,0.1,0.4,0.8],'Color','w');
tiledlayout(f_allinone, 3, 1, 'TileSpacing','compact', 'Padding','compact');
%
ax1 = nexttile;
[cd_ACC, ax1] = criticaldifference_modified('', Plot_CD_ACC, Plot_CD_algo_list, alpha, ax1);
title(ax1, 'Test for ACC comparison', 'FontSize', 12, 'FontWeight','bold');
%
ax2 = nexttile;
[cd_NMI, ax2] = criticaldifference_modified('', Plot_CD_NMI, Plot_CD_algo_list, alpha, ax2);
title(ax2, 'Test for NMI comparison', 'FontSize', 12, 'FontWeight','bold');
%
ax3 = nexttile;
[cd_ARI, ax3] = criticaldifference_modified('', Plot_CD_ARI, Plot_CD_algo_list, alpha, ax3);
title(ax3, 'Test for ARI comparison', 'FontSize', 12, 'FontWeight','bold');
%
% savefig(f_allinone, 'CD_Table_list.fig');

%% Running Time
alpha = 0.05;
run_algo_list = {'K-MHTC','CU','k-modes','Entropy','DV','SigDT',...
    'CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};
rank_RunningTimes = Table_RunningTimes;
rank_RunningTimes(:,end) = [];
rank_RunningTimes = rank_RunningTimes';
rank_RunningTimes = -rank_RunningTimes;
[cd_RunningTimes, ax_time] = criticaldifference_modified('', rank_RunningTimes, run_algo_list, alpha, nexttile);