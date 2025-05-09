clearvars
addpath([cd '/']);
addpath([cd '/CaseStudy']);
addpath([cd '/Datasets']);
addpath([cd '/Evaluation']);
addpath([cd '/ComparisonResults/pvalue']); % Contains output_combined_pval.m
%% house-votes
filename = char('house-votes');
rowNames = {'Hv'};
attribute_name = {'handicapped-infants','water-project-cost-sharing',...
    'adoption-of-the-budget-resolution','physician-fee-freeze',...
    'el-salvador-aid','religious-groups-in-schools',...
    'anti-satellite-test-ban','aid-to-nicaraguan-contras',...
    'mx-missile','immigration',...
    'synfuels-corporation-cutback','education-spending',...
    'superfund-right-to-sue','crime',...
    'sduty-free-exports','export-administration-act-south-africa'};
for I=1:1
    disp(I);
    X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
    X = X_data(:,2:end); %Data set
    GT = X_data(:,1); %Ground Truth 
    K = length(unique(GT));
    [N,M] = size(X);
    r = floor(M/2);
    rng(I,'twister'); % Generate Random Numbers That Are Repeatable
    pi0 = randi([1 K],N,1);
    [~,pi,~] = Refinement_Chi(X,pi0);
    [chi,pvs] = chi_squared_test_show(X,pi);
    [chi_GT,pvs_GT] = chi_squared_test_show(X,GT);
    % evaluate the metrics (average)
    Metric_MHTC = ClusteringMeasure(GT, pi); 
end

%% [Plot] Sorted with All Attribute Annotations Rotated 90° (No Legend, Direct Annotation on Dashed Line)
% Assume pvs and pvs_GT are the original p-value vectors,
% and attribute_name is a cell array of original attribute names.
% The p-values are sorted and the attribute names are reordered accordingly.
[sorted_pvs, sort_index] = sort(pvs);
sorted_attribute_name = attribute_name(sort_index);
sorted_pvs_GT = pvs_GT(sort_index);
% Construct data matrix: first row: predicted partition, second row: ground-truth partition
data = [sorted_pvs; sorted_pvs_GT];
figure;
h = bar(data', 'grouped');
xlabel('Multiple voting issues importance ranking', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Single voting issue p-value', 'FontName', 'Arial', 'FontSize', 12);
% No legend is drawn.
nGroups = size(data, 2);
set(gca, 'XTick', 1:nGroups);
ordinalLabels = cell(1, nGroups);
for i = 1:nGroups
    if i == 1
        ordinalLabels{i} = '1st';
    elseif i == 2
        ordinalLabels{i} = '2nd';
    elseif i == 3
        ordinalLabels{i} = '3rd';
    else
        ordinalLabels{i} = sprintf('%dth', i);
    end
end
set(gca, 'XTickLabel', ordinalLabels);
% Set y-axis to logarithmic scale and ensure x-axis ticks cover all attributes.
set(gca, 'YScale', 'log');
nGroups = size(data, 2);
set(gca, 'XTick', 1:nGroups);
% Simplify y-axis ticks to show only major ticks.
set(gca, 'YTick', [1e-70, 1e-40, 1e-10, 1e-2]);
% Draw a horizontal dashed line at y = 0.01 using red color.
% hold on;
darkColor  = [0.3, 0.5, 0.9];    % Dark blue
yline(0.01, '--', 'Color', darkColor, 'LineWidth', 1.5);
% Directly add text on the dashed line.
% Place the text at x = 1 (leftmost group) and y = 0.01,
% using VerticalAlignment 'top' so that the text is drawn below the line,
text(1, 0.01, 'Major disagreement level', 'FontSize', 10, 'FontName', 'Arial', ...
     'Color', darkColor, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
hold off;
% Set overall axis properties (tick direction and font).
set(gca, 'TickDir', 'out', 'FontName', 'Arial', 'FontSize', 12);
% Adjust y-axis lower limit based on the minimum positive p-value to ensure every bar is visible.
min_p = min(data(data > 0));  % Minimum positive p-value
lowerLimit = min_p * 0.5;       % Set lower limit to 50% of min_p
y_limits = ylim;
ylim([lowerLimit, y_limits(2)]);
%% Adjust bar colors and styles
for i = 1:length(h)
    h(i).FaceColor = 'flat';
end
% Default colors for non-special attributes:
% predicted partition (series 1): adjusted dark blue,
% ground-truth partition (series 2): light blue.
darkColor  = [0.3, 0.5, 0.9];    % Dark blue
lightColor = [0.75, 0.75, 0.95];  % Light blue
% Special attributes (example: sorted 15th and 16th) colors:
deepRed  = [0.85, 0.35, 0.35];   % Deep red
lightRed = [0.95, 0.75, 0.75];    % Light red
% Construct color arrays (initially using default blue tones).
colors_dark  = repmat(darkColor, nGroups, 1);
colors_light = repmat(lightColor, nGroups, 1);
if nGroups >= 15
    colors_dark(15, :) = deepRed;
    colors_light(15, :) = lightRed;
end
if nGroups >= 16
    colors_dark(16, :) = deepRed;
    colors_light(16, :) = lightRed;
end
h(1).CData = colors_dark;
h(2).CData = colors_light;
%% Add attribute name annotations (all rotated 90°)
% Attach annotations to the predicted partition (first row) bars.
if isprop(h(1), 'XOffset')
    xPos = h(1).XData + h(1).XOffset;
else
    xPos = h(1).XData;  % If XOffset is not supported, use group centers.
end
for idx = 1:nGroups
    % Calculate the y-coordinate for annotation (placed above the bar using 1.2x offset)
    yAnnotate = data(1, idx) * 1.2;
    if yAnnotate < lowerLimit * 1.2
        yAnnotate = lowerLimit * 1.2;
    end
    text(xPos(idx), yAnnotate, sorted_attribute_name{idx}, ...
         'FontSize', 10, 'FontName', 'Arial', ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'Color', 'k', 'Rotation', 90);
end

%% [Table] percentage of agreement
Cluster1 = X(pi==1,:);
Cluster2 = X(pi==2,:);
first3 = sort_index(1:3);
last3 = sort_index(end-2:end);
first3_att_Cluster1 = Cluster1(:,first3);
first3_att_Cluster2 = Cluster2(:,first3);
last3_att_Cluster1 = Cluster1(:,last3);
last3_att_Cluster2 = Cluster2(:,last3);
nClu1 = height(Cluster1);
nClu2 = height(Cluster2);
%% Att: 5 8 4
mode_list = mode(first3_att_Cluster1);
first_Qualitative_list_cluster1 = [length(find(first3_att_Cluster1(:,1) == mode_list(1)))./nClu1 0 0;...
    0 length(find(first3_att_Cluster1(:,2) == mode_list(2)))./nClu1 0;...
    length(find(first3_att_Cluster1(:,3) == mode_list(3)))./nClu1 0 0];
mode_list = mode(first3_att_Cluster2);
first_Qualitative_list_cluster2 = [0 length(find(first3_att_Cluster2(:,1) == mode_list(1)))./nClu2 0;...
    length(find(first3_att_Cluster2(:,2) == mode_list(2)))./nClu2 0 0;...
     0 length(find(first3_att_Cluster2(:,3) == mode_list(3)))./nClu2 0];
%% Att: 11 2 10
mode_list = mode(last3_att_Cluster1);
last_Qualitative_list_cluster1 = [0 length(find(last3_att_Cluster1(:,1) == mode_list(1)))./nClu1 0;...
    length(find(last3_att_Cluster1(:,2) == mode_list(2)))./nClu1 0 0;...
    length(find(last3_att_Cluster1(:,3) == mode_list(3)))./nClu1 0 0];
mode_list = mode(last3_att_Cluster2);
last_Qualitative_list_cluster2 = [0 length(find(last3_att_Cluster2(:,1) == mode_list(1)))./nClu2 0;...
    length(find(last3_att_Cluster2(:,2) == mode_list(2)))./nClu2 0 0;...
     0 length(find(last3_att_Cluster2(:,3) == mode_list(3)))./nClu2 0];
%% [Table list]
Qualitative_list_republican = [first_Qualitative_list_cluster1; last_Qualitative_list_cluster1];
Qualitative_list_republican = Qualitative_list_republican(:,1:2);
Qualitative_list_democrat = [first_Qualitative_list_cluster2; last_Qualitative_list_cluster2];
Qualitative_list_democrat = Qualitative_list_democrat(:,1:2);

%%
function [chi,p] = chi_squared_test_show(X,pi)
[N,M] = size(X);
k_list = unique(pi);
K = length(k_list);
p = zeros(1,M);
chi = zeros(1,M);
for m=1:M
    Xm = X(:,m);
    Q = length(unique(Xm));
    oc = zeros(Q+1,K+1);% observed counts
    for k=1:K
        for q=1:Q
            set = Xm(pi==k_list(k));
            oc(q,k) = sum(set==q);
        end
    end
    oc(Q+1,:) = sum(oc);
    oc(:,K+1) = sum(oc,2);
    ec = (oc(end,1:end-1).*oc(1:end-1,end))./N;
    oc = oc(1:end-1,1:end-1);
    s = sum(((oc-ec).^2)./ec,'all');% chi-squared statistic
    df = (Q-1)*(K-1);% degrees of freedom
    % p(1,m) = chi2cdf(s,df,'upper');
    p(1,m) = simplifiedChi2cdf(s,df); % 'upper'
    chi(1,m) = s;
end
end