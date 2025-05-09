load('PerformanceComparison-2025.mat')
load('PerformanceComparison-DV.mat')
algo_list = {'K-MHTC','CU','k-modes','Entropy',...
    'CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};
%% ACC
Table_ACC_list = [Metric_MHTC(:,1)'; Metric_CU(:,1)'; Metric_kmodes(:,1)'; Metric_Entropy(:,1)'; ... 
    Metric_CDC_DR(:,1)'; Metric_CMS(:,1)'; Metric_CDE(:,1)'; Metric_Het2Hom(:,1)'; Metric_HDNDW(:,1)'; Metric_COForest(:,1)';];
iACC_algo = [];
avgTable_ACC_list = [mean(Table_ACC_list,1);mean(output_Rank(Table_ACC_list),1)];
%% NNI
Table_NMI_list = [Metric_MHTC(:,2)'; Metric_CU(:,2)'; Metric_kmodes(:,2)'; Metric_Entropy(:,2)'; ... 
    Metric_CDC_DR(:,2)'; Metric_CMS(:,2)'; Metric_CDE(:,2)'; Metric_Het2Hom(:,2)'; Metric_HDNDW(:,2)'; Metric_COForest(:,2)';];
avgTable_NMI_list = [mean(Table_NMI_list,1);mean(output_Rank(Table_NMI_list),1)];
%% ARI
Table_ARI_list = [Metric_MHTC(:,4)'; Metric_CU(:,4)'; Metric_kmodes(:,4)'; Metric_Entropy(:,4)'; ... 
    Metric_CDC_DR(:,4)'; Metric_CMS(:,4)'; Metric_CDE(:,4)'; Metric_Het2Hom(:,4)'; Metric_HDNDW(:,4)'; Metric_COForest(:,4)';];
avgTable_ARI_list = [mean(Table_ARI_list,1);mean(output_Rank(Table_ARI_list),1)];

summary_list = [mean(output_Rank(Table_ACC_list),1); mean(output_Rank(Table_NMI_list),1); mean(output_Rank(Table_ARI_list),1)];
avg_summary = mean(summary_list,1);
%% Rank Boxplots
avgRank_ACC_list = output_Rank(Table_ACC_list);
avgRank_NMI_list = output_Rank(Table_NMI_list);
avgRank_ARI_list = output_Rank(Table_ARI_list);
% DV-verified
DV_verified = [3 6 9 10 13 14 17 24];
tmpACC = avgRank_ACC_list(:,DV_verified);
tmpNMI = avgRank_NMI_list(:,DV_verified);
tmpARI = avgRank_ARI_list(:,DV_verified);
DV_verified_boxplots = [tmpACC(:) tmpNMI(:) tmpARI(:)];
% SigDT-verified
SigDT_verified = [2 3 6 7 9 10 11 12 13 14 16 17 18 19 20 22 23 24];
tmpACC = avgRank_ACC_list(:,SigDT_verified);
tmpNMI = avgRank_NMI_list(:,SigDT_verified);
tmpARI = avgRank_ARI_list(:,SigDT_verified);
SigDT_verified_boxplots = [tmpACC(:) tmpNMI(:) tmpARI(:)];
% sig
sig = [3 4 5 6 9 10 12 13 14 16 17 20 24];
tmpACC = avgRank_ACC_list(:,sig);
tmpNMI = avgRank_NMI_list(:,sig);
tmpARI = avgRank_ARI_list(:,sig);
sig_boxplots = [tmpACC(:) tmpNMI(:) tmpARI(:)];
% unsig
unsig = [1 2 7 8 11 15 18 19 21 22 23 25];
tmpACC = avgRank_ACC_list(:,unsig);
tmpNMI = avgRank_NMI_list(:,unsig);
tmpARI = avgRank_ARI_list(:,unsig);
unsig_boxplots = [tmpACC(:) tmpNMI(:) tmpARI(:)];
% all
tmpACC = avgRank_ACC_list;
tmpNMI = avgRank_NMI_list;
tmpARI = avgRank_ARI_list;
all_boxplots = [tmpACC(:) tmpNMI(:) tmpARI(:)];

%% [Plot] Rank Boxplots
colorACC = [0.2980, 0.4470, 0.7410];  
colorNMI = [0.8500, 0.3250, 0.0980];  
colorARI = [0.9290, 0.6940, 0.1250];  
%% 
groupNames = {'{\it X}\rm (DV)', '{\it X}\rm (sig)', '{\it X}\rm (SigDT)', '{\it X}', '{\it X}\rm (unsig)'};
dataGroups = {DV_verified_boxplots, sig_boxplots, SigDT_verified_boxplots, all_boxplots, unsig_boxplots};
%% 
figure;
set(gcf, 'color', 'w');
%% 
for i = 1:length(dataGroups)
    subplot(1,5,i);
    data = dataGroups{i};
    n = size(data,1);     
    dataVec = data(:);
    groupLabels = repmat({'ACC','NMI','ARI'}, n, 1);
    groupLabels = groupLabels(:); 
    boxplot(dataVec, groupLabels, 'Notch', 'on', 'Widths', 0.5);
    set(gca, 'FontSize', 12, 'LineWidth', 1.5);
    title(groupNames{i}, 'Interpreter', 'tex');
    set(gca, 'XGrid', 'off', 'YGrid', 'off');
    boxes = flipud(findobj(gca, 'Tag', 'Box'));
    if length(boxes) >= 3
        set(boxes(1), 'Color', colorACC, 'LineWidth', 1.5); % ACC
        set(boxes(2), 'Color', colorNMI, 'LineWidth', 1.5); % NMI
        set(boxes(3), 'Color', colorARI, 'LineWidth', 1.5); % ARI
    end  
    medianACC = round(median(data(:,1)));
    hold on;
    yline(medianACC, 'k--', 'LineWidth', 1);
    hold off;
end