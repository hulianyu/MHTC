clearvars
%% Our method
% [1] K-MHTC
Runtime_MHTC = zeros(10,10); % running time
%% Comparison methods: CU, k-modes, Entropy, CDC_DR, CMS, CDE, HD-NDW, Het2Hom, COForest, SigDT
%% Selected Comparison methods: CU, CDC_DR, CDE, HD-NDW, COForest, SigDT
% Selected [2] CU
addpath([cd '/ComparisonMethods/CU']);
Runtime_CU = zeros(10,10); % performance metrics
% Selected [5] CDC_DR
addpath([cd '/ComparisonMethods/CDC_DR']);
Runtime_CDC_DR = zeros(10,10);
% Selected [7] CDE
addpath([cd '/ComparisonMethods/CDE']);
Runtime_CDE = zeros(10,10);
% Selected [8] HD-NDW
addpath([cd '/ComparisonMethods/HD-NDW']);
Runtime_HDNDW = zeros(10,10);
% Selected [10] COForest
addpath([cd '/ComparisonMethods/COForest']);
Runtime_COForest = zeros(10,10);
% Selected [11] SigDT
addpath([cd '/ComparisonMethods/SigDT']);
Runtime_SigDT = zeros(10,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% increaseing N from 10,000 to 100,000 with fixed M=20
K = 5; % Cluster Number
M = 20; % Attribute Number
int_N = 10000;
all_X_increN = cell(10,1);
for increaseing = 1:10
    %% increaseing N
    N = int_N*increaseing;
    X_increN = randi([1, 5], N, M);
    all_X_increN{increaseing,1} = X_increN;
    disp("N:");
    disp(N);
    for run = 1:10
    %% [1] K-MHTC
    disp("K-MHTC");
    tic
    pi0 = randi([1 K],N,1);
    [~,pi,~] = Refinement_Chi(X_increN,pi0);
    Runtime_MHTC(run,increaseing) = toc;
    %% [2] CU
    disp("CU");
    % initialization of pi
    tic
    pi_ = randi([1 K],N,1);
    [~,pi,~] = Refinement_CU(X_increN,pi0);
    Runtime_CU(run,increaseing) = toc;
    %% [5] CDC_DR
    disp("CDC_DR");
    tic
    pi = CDC_DR_SE(X_increN,K);
    Runtime_CDC_DR(run,increaseing) = toc;
    %% [7] CDE
    disp("CDE");
    tic
    pi = CDE_Clustering(X_increN,K);
    Runtime_CDE(run,increaseing) = toc;
    %% [8] HD-NDW
    disp("HD-NDW");
    tic
%     ordinal_num = floor(M/2);% half of all
    ordinal_num = 0;
    pi = HD_NDW_Clustering(X_increN,K,ordinal_num);
    Runtime_HDNDW(run,increaseing) = toc;
    %% [10] COForest (2024)
    disp("COForest");
    tic
    pi = COForest_main(X_increN,K);
    Runtime_COForest(run,increaseing) = toc;
    %% [11] SigDT (2025)
    disp("SigDT");
    tic
    pi = SigDT_main(X_increN);
    Runtime_SigDT(run,increaseing) = toc;
    %% Save the results
     save('_N_Increaseing_RuntimeComparison.mat',...
        'all_X_increN',...
        'Runtime_MHTC',...
        'Runtime_CU',...
        'Runtime_CDC_DR',...
        'Runtime_CDE',...
        'Runtime_HDNDW',...
        'Runtime_COForest',...
        'Runtime_SigDT');
    end
end