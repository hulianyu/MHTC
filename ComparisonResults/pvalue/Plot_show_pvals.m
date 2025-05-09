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
combined_pv_GT = zeros(IS,1);
combined_pv_Random = zeros(IS,50);
combined_pv_MHTC = zeros(IS,50);
combined_pv_CU = zeros(IS,50);
combined_pv_kmodes = zeros(IS,50);
combined_pv_Entropy = zeros(IS,50);
combined_pv_SigDT = zeros(IS,50);
combined_pv_CDC_DR = zeros(IS,50);
combined_pv_CMS = zeros(IS,50);
combined_pv_CDE = zeros(IS,50);
combined_pv_Het2Hom = zeros(IS,50);
combined_pv_HDNDW = zeros(IS,50);
combined_pv_COForest = zeros(IS,50);
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
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_Random{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_Random(I,:) = tmp;

    %% Pi_GT
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    combined_pv_GT(I,1) = output_combined_pval(X,X_Label,r);

    %% Pi_MHTC
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_MHTC{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_MHTC(I,:) = tmp;

    %% Pi_CU
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_CU{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CU(I,:) = tmp;

    %% Pi_kmodes
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_kmodes{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_kmodes(I,:) = tmp;

    %% Pi_Entropy
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_Entropy{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_Entropy(I,:) = tmp;

    %% Pi_CDC_DR
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_CDC_DR{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CDC_DR(I,:) = tmp;

    %% Pi_CMS
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_CMS{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CMS(I,:) = tmp;

    %% Pi_CDE
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_CDE{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_CDE(I,:) = tmp;

    %% Pi_Het2Hom
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_Het2Hom{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_Het2Hom(I,:) = tmp;

    %% Pi_HDNDW
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_HDNDW{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_HDNDW(I,:) = tmp;

    %% Pi_COForest
    tmp = [];
    % r = floor(0.5*M);
    % if r<1
    %     r = 1;
    % end
    for runs=1:ET
        pi = Pi_COForest{I,1}(:,runs);
        tmp = [tmp output_combined_pval(X,pi,r)];
    end
    combined_pv_COForest(I,:) = tmp;

end
combined_pv_List = [
    combined_pv_MHTC... %Data ID:  r2-[15,21,25]
    combined_pv_CU...
    combined_pv_kmodes...
    combined_pv_Entropy...
    combined_pv_CDC_DR... %Data ID: r2-[1,21,25]
    combined_pv_CMS...
    combined_pv_CDE...
    combined_pv_Het2Hom... %Data ID: r2-[21]
    combined_pv_HDNDW...
    combined_pv_COForest... %Data ID: r2-[21,25]
    ];
%% Save the results
save('Plot_show_pvals.mat',...
    "combined_pv_GT",...
    "combined_pv_List",...
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

%% [Plot] 
load('Plot_show_pvals.mat') 
dataname = char('Ls','Lc','So','Pe','Ae','Zo','Ps','Hr','Ly','Hd','Sf','Pt',...
    'De','Hv','Bs','Ca','Bc','Mm','Tt','Le','Ce','Ti','Ch','Mu','Nu');
annotateIndices = [1, 15, 21, 25];
figure('Position',[100,100,1200,900],'Color','w');
color_alg = [0.75, 0.75, 0.95]; 
color_rand = [0.95, 0.75, 0.75]; 
for i = 1:25
    subplot(5,5,i);    
    pvals = combined_pv_List(i, :);
    pvals_Random = combined_pv_Random(i, :);
    MHTC_le = sum(pvals <= 0.01) / 10;
    MHTC_gt = sum(pvals > 0.01) / 10;
    Random_le = sum(pvals_Random <= 0.01);
    Random_gt = sum(pvals_Random > 0.01);
    M = [MHTC_le, MHTC_gt;
         Random_le, Random_gt]; 
    hBar = bar(M, 'grouped'); 
    hBar(1).FaceColor = color_alg;
    hBar(2).FaceColor = color_rand;  
    set(gca, 'XTickLabel', {'Algorithm','Random'}); 
    title(strtrim(dataname(i,:)), 'FontSize',12);
    ylabel('Frequency','FontSize',10);
    ylim([0,50]);
    set(gca, 'YTick', [0 25 50]);
    grid on;
    if ismember(i, annotateIndices)
        if MHTC_gt > 0
            x_pos = hBar(2).XData(1) + hBar(2).XOffset;
            y_pos = MHTC_gt;
            text(x_pos, y_pos + 1, num2str(MHTC_gt), 'HorizontalAlignment', 'center', 'FontSize', 8, 'FontWeight','bold');
        end
    end
end
%sgtitle('Observed combined p-values in algorithm-optimized partitions vs. random partitions', 'FontSize', 14, 'FontWeight','bold');
hInvisible = axes('Position',[0 0 1 1],'Visible','off');
hold(hInvisible, 'on');
dummy1 = bar(nan, 'FaceColor', color_alg);
dummy2 = bar(nan, 'FaceColor', color_rand);
lgd = legend(hInvisible, [dummy1, dummy2], {' $p$-value$\le$0.01', ' $p$-value$>$0.01'}, ...
    'Orientation', 'horizontal', 'Interpreter', 'latex', 'FontSize',14);
lgd.Position = [0.35, 0.02, 0.3, 0.03];

%% [Plot] CDF curves
load('Plot_show_pvals.mat') 
%% Use "Plot_show_SCS_pvals.m"