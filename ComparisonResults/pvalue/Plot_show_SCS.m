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
SCS_GT = zeros(IS,1);
SCS_Random = zeros(IS,1);
SCS_MHTC = zeros(IS,1);
SCS_CU = zeros(IS,1);
SCS_kmodes = zeros(IS,1);
SCS_Entropy = zeros(IS,1);
SCS_SigDT = zeros(IS,1);
SCS_CDC_DR = zeros(IS,1);
SCS_CMS = zeros(IS,1);
SCS_CDE = zeros(IS,1);
SCS_Het2Hom = zeros(IS,1);
SCS_HDNDW = zeros(IS,1);
SCS_COForest = zeros(IS,1);
SCS_DV = ones(IS,1);
%%
for I=1:IS
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    M = size(X,2); %Attribute Number
    r = floor(M/2);% half of all
    
    %% X_Label
    SCS_GT(I,1) = output_SCS(X,X_Label);
    %% Pi_Random
    tmp = [];
    for runs=1:ET
        pi = Pi_Random{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_Random(I,1) = mean(tmp);
    %% Pi_MHTC
    tmp = [];
    for runs=1:ET
        pi = Pi_MHTC{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_MHTC(I,1) = mean(tmp);
    %% Pi_CU
    tmp = [];
    for runs=1:ET
        pi = Pi_CU{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_CU(I,1) = mean(tmp);
    %% Pi_kmodes
    tmp = [];
    for runs=1:ET
        pi = Pi_kmodes{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_kmodes(I,1) = mean(tmp);
    %% Pi_Entropy
    tmp = [];
    for runs=1:ET
        pi = Pi_Entropy{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_Entropy(I,1) = mean(tmp);

    %% Pi_SigDT
    tmp = [];
    for runs=1:ET
        pi = Pi_SigDT{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_SigDT(I,1) = mean(tmp);
    %% Pi_CDC_DR
    tmp = [];
    for runs=1:ET
        pi = Pi_CDC_DR{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_CDC_DR(I,1) = mean(tmp);
    %% Pi_CMS
    tmp = [];
    for runs=1:ET
        pi = Pi_CMS{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_CMS(I,1) = mean(tmp);
    %% Pi_CDE
    tmp = [];
    for runs=1:ET
        pi = Pi_CDE{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_CDE(I,1) = mean(tmp);
    %% Pi_Het2Hom
    tmp = [];
    for runs=1:ET
        pi = Pi_Het2Hom{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_Het2Hom(I,1) = mean(tmp);
    %% Pi_HDNDW
    tmp = [];
    for runs=1:ET
        pi = Pi_HDNDW{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_HDNDW(I,1) = mean(tmp);
    %% Pi_COForest
    tmp = [];
    for runs=1:ET
        pi = Pi_COForest{I,1}(:,runs);
        tmp = [tmp output_SCS(X,pi)];
    end
    SCS_COForest(I,1) = mean(tmp);
end
boxplot(SCS_Random);
% SCS_List = [SCS_Random';...
%     SCS_MHTC';... %Data ID:  r2-[15,21,25] r3-[1,15,21,25]
%     SCS_CU';... %Data ID: r3-[1,15,21,25]
%     SCS_kmodes';...
%     SCS_Entropy';... %Data ID: r3-[1,25]
%     SCS_CDC_DR';... %Data ID: r1-[25] r2-[1,21,25] r3-[1,15,21,25]
%     SCS_CMS';... %Data ID: r3-[1,19,21,25]
%     SCS_CDE';... %Data ID: r3-[1,15,21,25]
%     SCS_Het2Hom';... %Data ID: r2-[21] r3-[21,25]
%     SCS_HDNDW';... %Data ID: r1-[1] r3-[21,25]
%     SCS_COForest';... %Data ID: r2-[21,25] r3-[1,21,25] 
% ];
Plot_List = [mean(SCS_Random)...
    mean(SCS_GT)...
    mean(SCS_MHTC)...
    mean(SCS_CU)...
    mean(SCS_kmodes)...
    mean(SCS_Entropy)...
    mean(SCS_CDC_DR)...
    mean(SCS_CMS)...
    mean(SCS_CDE)...
    mean(SCS_Het2Hom)...
    mean(SCS_HDNDW)...
    mean(SCS_COForest)];
%% Save the results
save('Plot_show_SCS.mat',...
    "Plot_List",...
    'SCS_GT',...
    'SCS_Random',...
    'SCS_MHTC',...
    'SCS_CU',...
    'SCS_kmodes',...
    'SCS_Entropy',...
    'SCS_CDC_DR',...
    'SCS_CMS',...
    'SCS_CDE',...
    'SCS_Het2Hom',...
    'SCS_HDNDW',...
    "SCS_COForest");

%% [Plot] 
load('Plot_show_SCS.mat')
Method_List = {'Random','GT','K-MHTC','CU','k-modes','Entropy','CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};
[sortedSCS, sortIdx] = sort(Plot_List, 'descend');
sortedMethod = Method_List(sortIdx);
figure;
b = bar(sortedSCS, 'FaceColor', 'flat', 'BarWidth', 0.6);
% #92D3B1
baseColor = [146, 211, 177] / 255;
N = length(sortedSCS);
alpha = 0.25; 
multipliers = linspace(1 - alpha, 1, N);
colors = zeros(N, 3);
for i = 1:N
    colors(i,:) = baseColor * multipliers(i);
end
b.CData = colors;
set(gca, 'XTick', 1:N, 'XTickLabel', sortedMethod, 'FontSize', 12);
xlabel('Method', 'FontSize', 12);
ylabel('Average SCS Value', 'FontSize', 12);
%title('Average SCS Value by Method (Sorted Descending)', 'FontSize', 14, 'FontWeight', 'bold');
xtickangle(45);