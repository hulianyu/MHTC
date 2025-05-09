% clearvars
% addpath([cd '/']);
% load('PerformanceComparison-2025.mat')
% load('PerformanceComparison-DV.mat')
%% 25 UCI data sets
addpath([cd '/Datasets']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
IS = size(filename,1);
ET = 50;
%%
combined_pv_MHTC = zeros(IS,ET);
combined_pv_CU = zeros(IS,ET);
combined_pv_kmodes = zeros(IS,ET);
combined_pv_Entropy = zeros(IS,ET);
combined_pv_CDC_DR = zeros(IS,ET);
combined_pv_CMS = zeros(IS,ET);
combined_pv_CDE = zeros(IS,ET);
combined_pv_Het2Hom = zeros(IS,ET);
combined_pv_HDNDW = zeros(IS,ET);
combined_pv_COForest = zeros(IS,ET);
%%
for I=1:IS
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    M = size(X,2); %Attribute Number
    r = floor(M/2);% half of all
    %% Pi_MHTC
    tmp = [];
    for runs=1:ET
        pi = Pi_MHTC{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_MHTC(I,:) = tmp;

    %% Pi_CU
    tmp = [];
    for runs=1:ET
        pi = Pi_CU{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CU(I,:) = tmp;

    %% Pi_kmodes
    tmp = [];
    for runs=1:ET
        pi = Pi_kmodes{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_kmodes(I,:) = tmp;

    %% Pi_Entropy
    tmp = [];
    for runs=1:ET
        pi = Pi_Entropy{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_Entropy(I,:) = tmp;

    %% Pi_CDC_DR
    tmp = [];
    for runs=1:ET
        pi = Pi_CDC_DR{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CDC_DR(I,:) = tmp;

    %% Pi_CMS
    tmp = [];
    for runs=1:ET
        pi = Pi_CMS{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CMS(I,:) = tmp;

    %% Pi_CDE
    tmp = [];
    for runs=1:ET
        pi = Pi_CDE{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CDE(I,:) = tmp;

    %% Pi_Het2Hom
    tmp = [];
    for runs=1:ET
        pi = Pi_Het2Hom{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_Het2Hom(I,:) = tmp;

    %% Pi_HDNDW
    tmp = [];
    for runs=1:ET
        pi = Pi_HDNDW{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_HDNDW(I,:) = tmp;

    %% Pi_COForest
    tmp = [];
    for runs=1:ET
        pi = Pi_COForest{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_COForest(I,:) = tmp;
end

combined_pv_List = [combined_pv_MHTC combined_pv_CU combined_pv_kmodes combined_pv_Entropy... 
    combined_pv_CDC_DR combined_pv_CMS combined_pv_CDE combined_pv_Het2Hom... 
    combined_pv_HDNDW combined_pv_COForest];

per = sum(combined_pv_List<=0.01,2)/500;
sig = per==1;
summary_list = [per';sig'];
% summary_list = [sum(combined_pv_List(:,1)>0.01) sum(combined_pv_List(:,2)>0.01) sum(combined_pv_List(:,3)>0.01)];
%% Save the results
save('Avg_Table_pvalue.mat',...
    'summary_list',...
    "combined_pv_List",...
    'combined_pv_MHTC',...
    'combined_pv_CU',...
    'combined_pv_kmodes',...
    'combined_pv_Entropy',...
    'combined_pv_CDC_DR',...
    'combined_pv_CMS',...
    'combined_pv_CDE',...
    'combined_pv_Het2Hom',...
    'combined_pv_HDNDW',...
    "combined_pv_COForest");