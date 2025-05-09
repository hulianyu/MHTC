addpath([cd '/Datasets']);
addpath([cd '/ComparisonResults/pvalue']); % output_SCS.m
addpath([cd '/Evaluation']);  
addpath([cd '/Simulations']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
% First_row = [3,6,14,17];
% Second_row = [1,15,21,25];
%% Random_partition_rate
ET = 50;
all_random_pi = cell(20,length(filename));
for partition_rate = 1:20
    disp(partition_rate);
    alpha = partition_rate*0.05;
    for I = 1:length(filename)
        X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
        X_Label = X_data(:,1); %Ground Truth
        random_pi = [];
        for run = 1:ET
            random_pi = [random_pi Random_partition_rate(X_Label,alpha)];
        end
        all_random_pi{partition_rate,I} = random_pi;
    end
end
%% calculate SCS and ACC/NMI/ART
all_SCS_Metrics_list = cell(25,1);
for I = 1:length(filename)
    disp(I);
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    tmp_rate = [];
    parfor partition_rate = 1:20
        % disp(partition_rate);
        tmp_SCS = [];
        tmp_ACC = [];
        tmp_NMI = [];
        tmp_ARI = [];
        for run = 1:ET
            random_pi = all_random_pi{partition_rate,I}(:,run);
            tmp_SCS = [tmp_SCS output_SCS(X,random_pi)];
            tmp_metrics = ClusteringMeasure(X_Label, random_pi);
            tmp_ACC = [tmp_ACC tmp_metrics(1)];
            tmp_NMI = [tmp_NMI tmp_metrics(2)];
            tmp_ARI = [tmp_ARI tmp_metrics(4)];
        end
        tmp_rate = [tmp_rate; [mean(tmp_SCS) mean(tmp_ACC) mean(tmp_NMI) mean(tmp_ARI)]];
    end
    all_SCS_Metrics_list{I,1} = tmp_rate;
end

%% Save the results
save('Plot_different_rate_SCS.mat',...
    "all_random_pi",...
    "all_SCS_Metrics_list");


%% Plot
% load('Plot_different_rate_SCS.mat')
dataname = char('Ls','Lc','So','Pe','Ae','Zo','Ps','Hr','Ly','Hd','Sf','Pt',...
    'De','Hv','Bs','Ca','Bc','Mm','Tt','Le','Ce','Ti','Ch','Mu','Nu');
figure('Position',[100,100,1200,900],'Color','w');
t = tiledlayout(5,5, 'TileSpacing','compact','Padding','compact');
for I = 1:25
    ax = nexttile;
    X = all_SCS_Metrics_list{I,1}(:,1);
    Y1 = all_SCS_Metrics_list{I,1}(:,2); % ACC
    Y2 = all_SCS_Metrics_list{I,1}(:,3); % NMI
    Y3 = all_SCS_Metrics_list{I,1}(:,4); % ARI 
    scatter(ax, X, Y1, 20, [0.8500, 0.3250, 0.0980], 'o', 'filled', 'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'on');
    scatter(ax, X, Y2, 20, [1, 0.6, 0], '^', 'filled', 'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'on');
    scatter(ax, X, Y3, 20, [0, 0.4470, 0.7410], 's', 'filled', 'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
end