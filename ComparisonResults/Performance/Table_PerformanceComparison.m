load('PerformanceComparison-2025.mat')
load('PerformanceComparison-DV.mat')
algo_list = {'Random','K-MHTC','CU','k-modes','Entropy','DV','SigDT',...
    'CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};
%% ACC
Table_ACC_list = [Metric_Random(:,1)'; Metric_MHTC(:,1)'; Metric_CU(:,1)'; Metric_kmodes(:,1)'; Metric_Entropy(:,1)'; ... 
    Metric_DV(:,1)'; Metric_SigDT(:,1)'; Metric_CDC_DR(:,1)'; Metric_CMS(:,1)'; Metric_CDE(:,1)'; Metric_Het2Hom(:,1)'; Metric_HDNDW(:,1)'; Metric_COForest(:,1)';];
maxACC_algo = [];
iACC_algo = [];
for ind = 1:25
    [~,this] = max(Table_ACC_list(:,ind));
    % disp(algo_list(this));
    maxACC_algo = [maxACC_algo algo_list(this)];
    iACC_algo = [iACC_algo {algo_list(Table_ACC_list(:,ind)<Table_ACC_list(1,ind))}];
end
Table_ACC_list = [Table_ACC_list mean(Table_ACC_list,2)];
%% NNI
Table_NMI_list = [Metric_Random(:,2)'; Metric_MHTC(:,2)'; Metric_CU(:,2)'; Metric_kmodes(:,2)'; Metric_Entropy(:,2)'; ... 
    Metric_DV(:,2)'; Metric_SigDT(:,2)'; Metric_CDC_DR(:,2)'; Metric_CMS(:,2)'; Metric_CDE(:,2)'; Metric_Het2Hom(:,2)'; Metric_HDNDW(:,2)'; Metric_COForest(:,2)';];
maxNMI_algo = [];
iNMI_algo = [];
for ind = 1:25
    [~,this] = max(Table_NMI_list(:,ind));
    % disp(algo_list(this));
    maxNMI_algo = [maxNMI_algo algo_list(this)];
    iNMI_algo = [iNMI_algo {algo_list(Table_NMI_list(:,ind)<Table_NMI_list(1,ind))}];
end
Table_NMI_list = [Table_NMI_list mean(Table_NMI_list,2)];
%% ARI
Table_ARI_list = [Metric_Random(:,4)'; Metric_MHTC(:,4)'; Metric_CU(:,4)'; Metric_kmodes(:,4)'; Metric_Entropy(:,4)'; ... 
    Metric_DV(:,4)'; Metric_SigDT(:,4)'; Metric_CDC_DR(:,4)'; Metric_CMS(:,4)'; Metric_CDE(:,4)'; Metric_Het2Hom(:,4)'; Metric_HDNDW(:,4)'; Metric_COForest(:,4)';];
maxARI_algo = [];
iARI_algo = [];
for ind = 1:25
    [~,this] = max(Table_ARI_list(:,ind));
    % disp(algo_list(this));
    maxARI_algo = [maxARI_algo algo_list(this)];
    iARI_algo = [iARI_algo {algo_list(Table_ARI_list(:,ind)<Table_ARI_list(1,ind))}];
end
Table_ARI_list = [Table_ARI_list mean(Table_ARI_list,2)];

%% RunTime [1]K-MHTC [2]CU [3]k-modes [4]Entropy [5]CDC_DR [6]DV
%% [7]CMS [8]CDE [9]HD-NDW [10]Het2Hom [11]COForest [12]SigDT
load('PerformanceComparison-DV.mat') % record DV's RunningTimes
RunningTimes(:,6) = DV_RT;
run_algo_list = {'K-MHTC','CU','k-modes','Entropy','DV','SigDT',...
    'CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};
Table_RunningTimes = [RunningTimes(:,1)'; RunningTimes(:,2)'; RunningTimes(:,3)'; ...
    RunningTimes(:,4)'; RunningTimes(:,6)'; RunningTimes(:,12)';...
    RunningTimes(:,5)'; RunningTimes(:,7)'; RunningTimes(:,8)';...
    RunningTimes(:,10)'; RunningTimes(:,9)'; RunningTimes(:,11)';];
Table_RunningTimes = [Table_RunningTimes sum(Table_RunningTimes,2)];
