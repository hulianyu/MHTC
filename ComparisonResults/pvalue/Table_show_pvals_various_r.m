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
combined_pv_GT = zeros(IS,3);
combined_pv_Random = zeros(IS,3);
combined_pv_MHTC = zeros(IS,3);
combined_pv_CU = zeros(IS,3);
combined_pv_kmodes = zeros(IS,3);
combined_pv_Entropy = zeros(IS,3);
combined_pv_SigDT = zeros(IS,3);
combined_pv_CDC_DR = zeros(IS,3);
combined_pv_CMS = zeros(IS,3);
combined_pv_CDE = zeros(IS,3);
combined_pv_Het2Hom = zeros(IS,3);
combined_pv_HDNDW = zeros(IS,3);
combined_pv_COForest = zeros(IS,3);
combined_pv_DV = ones(IS,3);
%%
for I=1:IS
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    M = size(X,2); %Attribute Number
    r = floor(M/2);% half of all

    %% Pi_Random
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_Random{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_Random(I,s) = median(tmp);
    end

    %% Pi_MHTC
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_MHTC{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_MHTC(I,s) = median(tmp);
    end

    %% Pi_CU
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_CU{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_CU(I,s) = median(tmp);
    end

    %% Pi_kmodes
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_kmodes{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_kmodes(I,s) = median(tmp);
    end

    %% Pi_Entropy
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_Entropy{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_Entropy(I,s) = median(tmp);
    end

    %% Pi_CDC_DR
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_CDC_DR{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_CDC_DR(I,s) = median(tmp);
    end

    %% Pi_CMS
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_CMS{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_CMS(I,s) = median(tmp);
    end

    %% Pi_CDE
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_CDE{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_CDE(I,s) = median(tmp);
    end

    %% Pi_Het2Hom
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_Het2Hom{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_Het2Hom(I,s) = median(tmp);
    end

    %% Pi_HDNDW
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_HDNDW{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_HDNDW(I,s) = median(tmp);
    end

    %% Pi_COForest
    for s=1:3
        tmp = [];
        r = floor(s*0.25*M);
        if r<1
            r = 1;
        end
        for runs=1:ET
            pi = Pi_COForest{I,1}(:,runs);
            tmp = [tmp output_combined_pval(X,pi,r)];
        end
        combined_pv_COForest(I,s) = median(tmp);
    end

end
tt = combined_pv_DV(:,1);
combined_pv_DV(tt==1,:) = [];
boxplot(combined_pv_Random);
combined_pv_List_1 = [combined_pv_Random(:,1)';...
    combined_pv_MHTC(:,1)';... %Data ID:  r2-[15,21,25] r3-[1,15,21,25]
    combined_pv_CU(:,1)';... %Data ID: r3-[1,15,21,25]
    combined_pv_kmodes(:,1)';...
    combined_pv_Entropy(:,1)';... %Data ID: r3-[1,25]
    combined_pv_CDC_DR(:,1)';... %Data ID: r1-[25] r2-[1,21,25] r3-[1,15,21,25]
    combined_pv_CMS(:,1)';... %Data ID: r3-[1,19,21,25]
    combined_pv_CDE(:,1)';... %Data ID: r3-[1,15,21,25]
    combined_pv_Het2Hom(:,1)';... %Data ID: r2-[21] r3-[21,25]
    combined_pv_HDNDW(:,1)';... %Data ID: r1-[1] r3-[21,25]
    combined_pv_COForest(:,1)';... %Data ID: r2-[21,25] r3-[1,21,25] 
];

combined_pv_List_2 = [combined_pv_Random(:,2)';...
    combined_pv_MHTC(:,2)';... %Data ID:  r2-[15,21,25] r3-[1,15,21,25]
    combined_pv_CU(:,2)';... %Data ID: r3-[1,15,21,25]
    combined_pv_kmodes(:,2)';...
    combined_pv_Entropy(:,2)';... %Data ID: r3-[1,25]
    combined_pv_CDC_DR(:,2)';... %Data ID: r1-[25] r2-[1,21,25] r3-[1,15,21,25]
    combined_pv_CMS(:,2)';... %Data ID: r3-[1,19,21,25]
    combined_pv_CDE(:,2)';... %Data ID: r3-[1,15,21,25]
    combined_pv_Het2Hom(:,2)';... %Data ID: r2-[21] r3-[21,25]
    combined_pv_HDNDW(:,2)';... %Data ID: r1-[1] r3-[21,25]
    combined_pv_COForest(:,2)';... %Data ID: r2-[21,25] r3-[1,21,25] 
];

combined_pv_List_3 = [combined_pv_Random(:,3)';...
    combined_pv_MHTC(:,3)';... %Data ID:  r2-[15,21,25] r3-[1,15,21,25]
    combined_pv_CU(:,3)';... %Data ID: r3-[1,15,21,25]
    combined_pv_kmodes(:,3)';...
    combined_pv_Entropy(:,3)';... %Data ID: r3-[1,25]
    combined_pv_CDC_DR(:,3)';... %Data ID: r1-[25] r2-[1,21,25] r3-[1,15,21,25]
    combined_pv_CMS(:,3)';... %Data ID: r3-[1,19,21,25]
    combined_pv_CDE(:,3)';... %Data ID: r3-[1,15,21,25]
    combined_pv_Het2Hom(:,3)';... %Data ID: r2-[21] r3-[21,25]
    combined_pv_HDNDW(:,3)';... %Data ID: r1-[1] r3-[21,25]
    combined_pv_COForest(:,3)';... %Data ID: r2-[21,25] r3-[1,21,25] 
];
% summary_list = [sum(combined_pv_List(:,1)>0.01) sum(combined_pv_List(:,2)>0.01) sum(combined_pv_List(:,3)>0.01)];
%% Save the results
save('Table_show_pvals.mat',...
    "combined_pv_List_1",...
    "combined_pv_List_2",...
    "combined_pv_List_3",...
    'combined_pv_Random',...
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