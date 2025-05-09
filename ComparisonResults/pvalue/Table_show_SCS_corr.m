addpath([cd '/Datasets']);
addpath([cd '/Simulations']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
index = zeros(25,1);
for I = 1:25
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    index(I,1) = TestCat(X);
end
clusterable_index = find(index<0.01);
%%
load('Table_show_SCS.mat')
SCS_clusterable_List = SCS_List(:,clusterable_index);
%%
%% Show_corr: ACC
Table_ACC_list = [Metric_Random(:,1)'; Metric_MHTC(:,1)'; Metric_CU(:,1)'; Metric_kmodes(:,1)'; Metric_Entropy(:,1)'; ... 
    Metric_CDC_DR(:,1)'; Metric_CMS(:,1)'; Metric_CDE(:,1)'; Metric_Het2Hom(:,1)'; Metric_HDNDW(:,1)'; Metric_COForest(:,1)';];
Table_clusterable_ACC_list = Table_ACC_list(:,clusterable_index);
%% Show_corr: NMI
Table_NMI_list = [Metric_Random(:,2)'; Metric_MHTC(:,2)'; Metric_CU(:,2)'; Metric_kmodes(:,2)'; Metric_Entropy(:,2)'; ... 
    Metric_CDC_DR(:,2)'; Metric_CMS(:,2)'; Metric_CDE(:,2)'; Metric_Het2Hom(:,2)'; Metric_HDNDW(:,2)'; Metric_COForest(:,2)';];
Table_clusterable_NMI_list = Table_NMI_list(:,clusterable_index);
%% Show_corr: ARI
Table_ARI_list = [Metric_Random(:,4)'; Metric_MHTC(:,4)'; Metric_CU(:,4)'; Metric_kmodes(:,4)'; Metric_Entropy(:,4)'; ... 
    Metric_CDC_DR(:,4)'; Metric_CMS(:,4)'; Metric_CDE(:,4)'; Metric_Het2Hom(:,4)'; Metric_HDNDW(:,4)'; Metric_COForest(:,4)';];
Table_clusterable_ARI_list = Table_ARI_list(:,clusterable_index);
%% 

[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_ACC_list(:),'type','Pearson');
[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_ACC_list(:),'type','Kendall');
[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_ACC_list(:),'type','Spearman');

[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_NMI_list(:),'type','Pearson');
[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_NMI_list(:),'type','Kendall');
[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_NMI_list(:),'type','Spearman');

[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_ARI_list(:),'type','Pearson');
[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_ARI_list(:),'type','Kendall');
[rho,pval] = corr(SCS_clusterable_List(:),Table_clusterable_ARI_list(:),'type','Spearman');
