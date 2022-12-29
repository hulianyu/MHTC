clearvars
addpath([cd '/']);
load('PerformanceComparison.mat');
%% 19 UCI data sets
addpath([cd '/Datasets']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
IS = size(filename,1);
ET = 50;
combined_pv = zeros(IS,ET);
combined_pv_CU  = zeros(IS,ET);
combined_pv_kmodes  = zeros(IS,ET);
combined_pv_Entropy  = zeros(IS,ET);
combined_pv_DV  = zeros(IS,1);
combined_pv_CDC_DR  = zeros(IS,ET);
combined_pv_CMS  = zeros(IS,ET);
combined_pv_CDE  = zeros(IS,ET);
combined_pv_Het2Hom  = zeros(IS,ET);
combined_pv_HDNDW  = zeros(IS,ET);
combined_pv_random = zeros(IS,ET);
C = zeros(IS,ET);
C_random = zeros(IS,ET);
P = cell(IS,ET);
P_random = cell(IS,ET);
p_GT = zeros(IS,2);
for I=1:IS
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    N = size(X,1); %Attribute Number
    M = size(X,2); %Attribute Number
    K = length(unique(X_Label)); %Cluster Number
    r = floor(M/2);% half of all
%     r = ceil(M/2);% half of all
    %%
    rng(I,'twister'); % Generate Random Numbers That Are Repeatable
    pi0 = randi([1 K],N,ET);
    for runs=1:ET
        [chi,p] = chi_squared_test(X,pi0(:,runs));
        C_random(I,runs) = chi;
        P_random{I,runs} = p;
        combined_pv_random(I,runs) = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_MHTC{I,1}(:,runs));
        C(I,runs) = chi;
        P{I,runs} = p;
        combined_pv(I,runs) = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_CU{I,1}(:,runs));
        combined_pv_CU(I,runs) = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_kmodes{I,1}(:,runs));
        combined_pv_kmodes(I,runs)  = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_Entropy{I,1}(:,runs));
        combined_pv_Entropy(I,runs)  = rOP_pvals_SETr(p,r);

%         [chi,p] = chi_squared_test(X,Pi_DV{I,1}(:,runs));
%         combined_pv_DV  = zeros(IS,ET);

        [chi,p] = chi_squared_test(X,Pi_CDC_DR{I,1}(:,runs));
        combined_pv_CDC_DR(I,runs)  = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_CMS{I,1}(:,runs));
        combined_pv_CMS(I,runs)  = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_CDE{I,1}(:,runs));
        combined_pv_CDE(I,runs)  = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_Het2Hom{I,1}(:,runs));
        combined_pv_Het2Hom(I,runs)  = rOP_pvals_SETr(p,r);

        [chi,p] = chi_squared_test(X,Pi_HDNDW{I,1}(:,runs));
        combined_pv_HDNDW(I,runs)  = rOP_pvals_SETr(p,r);
    end
    [p_GT(I,1),p_g] = chi_squared_test(X,X_Label);
    p_GT(I,2) = rOP_pvals_SETr(p_g,r);
end
List = [3 6 9 10 13 14 17 24];
for I=1:8
    [chi,p] = chi_squared_test(X,Pi_DV{List(I),1}(:,1));
    combined_pv_DV(I,1)  = rOP_pvals_SETr(p,r);
end
combined_pv_List = [mean(combined_pv,2) mean(combined_pv_CU,2) mean(combined_pv_kmodes,2) mean(combined_pv_Entropy,2) combined_pv_DV mean(combined_pv_CDC_DR,2) mean(combined_pv_CMS,2) mean(combined_pv_CDE,2) mean(combined_pv_Het2Hom,2) mean(combined_pv_HDNDW,2)];
% save('pvalue.mat','C','C_random','combined_pv','combined_pv_random','P','p_GT','P_random')