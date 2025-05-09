clearvars
addpath([cd '/']);
%% 25 UCI data sets
addpath([cd '/Datasets']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
IS = size(filename,1);
RunningTimes = zeros(IS,12); % seconds (for each clustering algorithm)
%% Load Evaluation package
addpath([cd '/Evaluation']); % 7 metrics [ACC, NMI, Purity, ARI, Precision, Recall, F-score]
%% set execute times (for each clustering algorithm)
ET = 50;
%% Random partition
% [0] Random
Pi_Random = cell(IS,1);
Metric_Random = zeros(IS,7); % performance metrics
%% Our method
% [1] K-MHTC
Pi_MHTC = cell(IS,1); % a locally optimal partition
Metric_MHTC = zeros(IS,7); % performance metrics
%% Comparison methods: CU, k-modes, Entropy, CDC_DR, DV, CMS, CDE, HD-NDW, Het2Hom, COForest, SigDT
% [2] CU
addpath([cd '/ComparisonMethods/CU']);
Pi_CU = cell(IS,1); % a locally optimal partition
Metric_CU = zeros(IS,7); % performance metrics
% [3] k-modes
addpath([cd '/ComparisonMethods/k-modes']);
Pi_kmodes = cell(IS,1);
Metric_kmodes = zeros(IS,7);
% [4] Entropy
addpath([cd '/ComparisonMethods/Entropy']);
Pi_Entropy = cell(IS,1);
Metric_Entropy = zeros(IS,7);
% [5] CDC_DR
addpath([cd '/ComparisonMethods/CDC_DR']);
Pi_CDC_DR = cell(IS,1);
Metric_CDC_DR = zeros(IS,7);
% [6] DV
addpath([cd '/ComparisonMethods/DV']);
Pi_DV = cell(IS,1);
Metric_DV = zeros(IS,7);
DV_k = zeros(IS,1); % Detect k clusters
% [7] CMS
addpath([cd '/ComparisonMethods/CMS']);
addpath([cd '/ComparisonMethods/CMS/Ncut']); % NcutClustering
Pi_CMS = cell(IS,1);
Metric_CMS = zeros(IS,7);
% [8] CDE
addpath([cd '/ComparisonMethods/CDE']);
Pi_CDE = cell(IS,1);
Metric_CDE = zeros(IS,7);
% [9] HD-NDW
addpath([cd '/ComparisonMethods/HD-NDW']);
Pi_HDNDW = cell(IS,1);
Metric_HDNDW = zeros(IS,7);
% [10] Het2Hom
addpath([cd '/ComparisonMethods/Het2Hom']);
Pi_Het2Hom = cell(IS,1);
Metric_Het2Hom = zeros(IS,7);
% [11] COForest
addpath([cd '/ComparisonMethods/COForest']);
Pi_COForest = cell(IS,1);
Metric_COForest = zeros(IS,7);
% [12] SigDT
addpath([cd '/ComparisonMethods/SigDT']);
Pi_SigDT = cell(IS,1);
Metric_SigDT = zeros(IS,7);
%% Choose a data set I
for I=1:2
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    N = size(X,1); %Attribute Number
    M = size(X,2); %Attribute Number
    K = length(unique(X_Label)); %Cluster Number
    %% Performance
    %% [0] Random
    disp("Random");
    rng(I,'twister'); % Generate Random Numbers That Are Repeatable
    pi0 = randi([1 K],N,ET);
    Pi_Random{I,1} = pi0;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_Random(I,:) = Metric_Random(I,:) + [ClusteringMeasure(X_Label, pi0(:,runs))];
    end
    Metric_Random(I,:) = Metric_Random(I,:)./ET;
    %% [1] K-MHTC
    disp("K-MHTC");
    Pi = zeros(size(X,1),ET);
    % initialization of pi
    tic
    rng(I,'twister'); % Generate Random Numbers That Are Repeatable
    pi0 = randi([1 K],N,ET);
    % Pi_random{I,1} = pi0;
    for runs=1:ET
        [~,pi_runs,chi] = Refinement_Chi(X,pi0(:,runs));
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,1) = toc;
    Pi_MHTC{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_MHTC(I,:) = Metric_MHTC(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_MHTC(I,:) = Metric_MHTC(I,:)./ET;
    %% [2] CU
    disp("CU");
    Pi = zeros(size(X,1),ET);
    % initialization of pi
    tic
    rng(I,'twister'); % Generate Random Numbers That Are Repeatable
    pi0 = randi([1 K],N,ET);
    % Pi_random{I,1} = pi0;
    for runs=1:ET
        [~,pi_runs,chi] = Refinement_CU(X,pi0(:,runs));
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,2) = toc;
    Pi_CU{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_CU(I,:) = Metric_CU(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_CU(I,:) = Metric_CU(I,:)./ET;
    %% [3] k-modes
    disp("k-modes");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = kmode_random(X, K);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,3) = toc;
    Pi_kmodes{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_kmodes(I,:) = Metric_kmodes(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_kmodes(I,:) = Metric_kmodes(I,:)./ET;
    %% [4] Entropy
    disp("Entropy");
    % initialization of pi
    Pi = zeros(size(X,1),ET);
    tic
    [eva0,freq_pi0,freq_m0,eva_m0,eva_2_0] = EE_init(X,K);
    for runs = 1:ET
        [~,pi_runs] = minMC_EE(X,K,eva0,freq_pi0,freq_m0,eva_m0,eva_2_0);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,4) = toc;
    Pi_Entropy{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_Entropy(I,:) = Metric_Entropy(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_Entropy(I,:) = Metric_Entropy(I,:)./ET;
    %% [5] CDC_DR
    disp("CDC_DR");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = CDC_DR_SE(X,K);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,5) = toc;
    Pi_CDC_DR{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_CDC_DR(I,:) = Metric_CDC_DR(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_CDC_DR(I,:) = Metric_CDC_DR(I,:)./ET;
    %% [6] DV
    disp("DV");
    tic
    try
        Pi = ccdv(X);
    catch
        Pi = 0; % fail to detect clusters
    end
    RunningTimes(I,6) = toc*ET;
    if Pi~=0
        Pi_DV{I,1} = Pi;
        % evaluate the metrics
        Metric_DV(I,:) = ClusteringMeasure(X_Label, Pi);
    else
        Metric_DV(I,:) = 0;
    end
    DV_k(I,1) = max(Pi);
    %% [7] CMS
    disp("CMS");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = CMS(X,K);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,7) = toc;
    Pi_CMS{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_CMS(I,:) = Metric_CMS(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_CMS(I,:) = Metric_CMS(I,:)./ET;
    %% [8] CDE
    disp("CDE");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = CDE_Clustering(X,K);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,8) = toc;
    Pi_CDE{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_CDE(I,:) = Metric_CDE(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_CDE(I,:) = Metric_CDE(I,:)./ET;
    %% [9] HD-NDW
    disp("HD-NDW");
    Pi = zeros(size(X,1),ET);
    tic
%     ordinal_num = floor(M/2);% half of all
    ordinal_num = 0;
    for runs = 1:ET
        pi_runs = HD_NDW_Clustering(X,K,ordinal_num);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,9) = toc;
    Pi_HDNDW{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_HDNDW(I,:) = Metric_HDNDW(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_HDNDW(I,:) = Metric_HDNDW(I,:)./ET;
    %% [10] Het2Hom
    disp("Het2Hom");
    Pi = zeros(size(X,1),ET);
    tic
%     ordinal_num = floor(M/2);% half of all
    ordinal_num = 0;
    nominal_num = M-ordinal_num;
    for runs = 1:ET
        pi_runs = Het2Hom_Clustering(X,K,nominal_num,ordinal_num);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,10) = toc;
    Pi_Het2Hom{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_Het2Hom(I,:) = Metric_Het2Hom(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_Het2Hom(I,:) = Metric_Het2Hom(I,:)./ET;
    %% [11] COForest (2024)
    disp("COForest");
    Pi = zeros(size(X,1),ET);
    tic
    runs = 1;
    while runs <= ET
        try
            pi_runs = COForest_main(X,K);
            Pi(:,runs) = pi_runs;
            runs = runs + 1;  
        catch
            disp('An error occurred. Skipping this run.');
        end
    end
    RunningTimes(I,11) = toc;
    Pi_COForest{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_COForest(I,:) = Metric_COForest(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_COForest(I,:) = Metric_COForest(I,:)./ET;
    %% [12] SigDT (2025)
    disp("SigDT");
    Pi = zeros(size(X,1),ET);
    tic
    for runs = 1:ET
        pi_runs = SigDT_main(X);
        Pi(:,runs) = pi_runs;
    end
    RunningTimes(I,12) = toc;
    Pi_SigDT{I,1} = Pi;
    % evaluate the metrics (average)
    for runs = 1:ET
        Metric_SigDT(I,:) = Metric_SigDT(I,:) + [ClusteringMeasure(X_Label, Pi(:,runs))];
    end
    Metric_SigDT(I,:) = Metric_SigDT(I,:)./ET;
    %% Save the results
    save('_PerformanceComparison-2025.mat','RunningTimes','ET',...
        'Pi_Random','Metric_Random',...
        'Pi_MHTC','Metric_MHTC',...
        'Pi_CU','Metric_CU',...
        'Pi_kmodes','Metric_kmodes',...
        'Pi_Entropy','Metric_Entropy',...
        'Pi_CDC_DR','Metric_CDC_DR',...
        'Pi_CMS','Metric_CMS',...
        'Pi_CDE','Metric_CDE',...
        'Pi_HDNDW','Metric_HDNDW',...
        'Pi_Het2Hom','Metric_Het2Hom',...
        'Pi_COForest','Metric_COForest',...
        'Pi_SigDT','Metric_SigDT');
end