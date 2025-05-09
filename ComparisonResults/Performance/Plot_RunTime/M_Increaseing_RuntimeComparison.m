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

%% increaseing M from 100 to 1,000 with fixed N=2,000
K = 5; %Cluster Number
N = 2000; % Object Number
int_M = 100;
all_X_increM = cell(10,1);
for increaseing = 1:10
    %% increaseing M
    M = int_M*increaseing;
    X_increM = randi([1, 5], N, M);
    all_X_increM{increaseing,1} = X_increM;
    disp("M:");
    disp(M);
    for run = 1:10
    %% [1] K-MHTC
    disp("K-MHTC");
    tic
    pi0 = randi([1 K],N,1);
    [~,pi,~] = Refinement_Chi(X_increM,pi0);
    Runtime_MHTC(run,increaseing) = toc;
    %% [2] CU
    disp("CU");
    % initialization of pi
    tic
    pi_ = randi([1 K],N,1);
    [~,pi,~] = Refinement_CU(X_increM,pi0);
    Runtime_CU(run,increaseing) = toc;
    %% [5] CDC_DR
    disp("CDC_DR");
    tic
    pi = CDC_DR_SE(X_increM,K);
    Runtime_CDC_DR(run,increaseing) = toc;
    %% [7] CDE
    if increaseing<5 % more time-consuming
        disp("CDE");
        tic
        pi = CDE_Clustering(X_increM,K);
        Runtime_CDE(run,increaseing) = toc;
    end
    %% [8] HD-NDW
    disp("HD-NDW");
    tic
%     ordinal_num = floor(M/2);% half of all
    ordinal_num = 0;
    pi = HD_NDW_Clustering(X_increM,K,ordinal_num);
    Runtime_HDNDW(run,increaseing) = toc;
    %% [10] COForest (2024)
    disp("COForest");
    tic
    pi = COForest_main(X_increM,K);
    Runtime_COForest(run,increaseing) = toc;
    %% [11] SigDT (2025)
    disp("SigDT");
    tic
    pi = SigDT_main(X_increM);
    Runtime_SigDT(run,increaseing) = toc;
    %% Save the results
     save('_M_Increaseing_RuntimeComparison.mat',...
        'all_X_increM',...
        'Runtime_MHTC',...
        'Runtime_CU',...
        'Runtime_CDC_DR',...
        'Runtime_CDE',...
        'Runtime_HDNDW',...
        'Runtime_COForest',...
        'Runtime_SigDT');
    end
end