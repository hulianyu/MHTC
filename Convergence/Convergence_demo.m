clearvars
addpath([cd '/']);
%% 25 UCI data sets
addpath([cd '/Datasets']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
IS = size(filename,1);
%% set execute times (for each clustering algorithm)
ET = 50;
%% Our method
% [1] K-MHTC
Pi_MHTC = cell(IS,1); % a locally optimal partition
% [2] CU
addpath([cd '/ComparisonMethods/CU']);
load('Pi_Random.mat') % load 50 Random partitions
MHTC_ITs = zeros(25,ET);
CU_ITs = zeros(25,ET);
MHTC_Convergence_curves = cell(25,ET);
%% Choose a data set I
for I=1:25
    disp("Datasets:");disp(strtrim(filename(I,:)));
    %% information from selected data set
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    X_Label = X_data(:,1); %Ground Truth
    N = size(X,1); %Attribute Number
    M = size(X,2); %Attribute Number
    K = length(unique(X_Label)); %Cluster Number
    %% Performance
    %% [1] K-MHTC
    disp("K-MHTC");
    % initialization of pi
    for runs=1:ET
        pi0 = Pi_Random{I,1}(:,runs);
        [it,chi] = Convergence_Refinement_Chi(X,pi0);
        MHTC_ITs(I,runs) = it(1);
        MHTC_Convergence_curves{I,runs} = chi;
    end
    % %% [2] CU
    % disp("CU");
    % % initialization of pi
    % for runs=1:ET
    %     pi0 = Pi_Random{I,1}(:,runs);
    %     [it,~] = Convergence_Refinement_CU(X,pi0);
    %     CU_ITs(I,runs) = it(1);
    % end
end

%% [Plot] boxplot for CU_ITs and MHTC_ITs
figure('Position',[100,100,600,400],'Color','w');
data = [CU_ITs(:); MHTC_ITs(:)];
group = [repmat({'CU'}, numel(CU_ITs), 1); repmat({'K-MHTC'}, numel(MHTC_ITs), 1)];
b = boxplot(data, group, 'Notch','off', 'Widths',0.5, 'Colors',[0 0 0]);
hold on;
colors = [0.1216, 0.4667, 0.7059;   
          1.0000, 0.4980, 0.0549];  
boxes = findobj(gca, 'Tag', 'Box');
boxes = flipud(boxes);
for j = 1:length(boxes)
    patch(get(boxes(j), 'XData'), get(boxes(j), 'YData'), colors(j,:), ...
          'FaceAlpha', 0.5, 'EdgeColor', colors(j,:), 'LineWidth',1.5);
end
medians = findobj(gca, 'Tag', 'Median');
for j = 1:length(medians)
    set(medians(j), 'Color', 'k', 'LineWidth', 2);
end
outliers = findobj(gca, 'Tag', 'Outliers');
for j = 1:length(outliers)
    set(outliers(j), 'Marker', '.', 'MarkerEdgeColor', [0.4, 0.4, 0.4], 'MarkerSize', 8);
end
grid off;
set(gca, 'LooseInset', get(gca, 'TightInset'));
ylabel('Iteration', 'FontSize',12);
set(gca, 'FontSize',12, 'LineWidth',1.5);