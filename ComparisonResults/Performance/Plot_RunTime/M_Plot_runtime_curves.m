%% Plot N_Increaseing_RuntimeComparison
load('M_Increaseing_RuntimeComparison.mat')
M_Increaseing_mean = [mean(Runtime_MHTC,1);
                      mean(Runtime_CU,1);
                      mean(Runtime_CDC_DR,1);
                      mean(Runtime_CDE,1);
                      mean(Runtime_HDNDW,1);
                      mean(Runtime_COForest,1);
                      mean(Runtime_SigDT,1);];

sampleSizes = 1e4:1e4:1e5;  
xAxis = 1:length(sampleSizes);  
algo_list   = {'K-MHTC','CU','CDC\_DR','CDE','HD-NDW','COForest','SigDT'};
markerList  = {'h','p','o','^','<','d','d'};
colors      = [1       1       0;          % Gold
    0       0.4470  0.7410;     % Blue
    0       0.4470  0.7410;     % Blue
    1       0.6     0;          % Orange
    0.8500  0.3250  0.0980;     % Red
    1       0.6     0;          % Orange
    0       0.4470  0.7410];    % Blue

markerSize  = 120;            
markerEdgeW = 0.5;             
lineW       = 1.0;              
lightGray   = [0.5 0.5 0.5];      
figure;
hold on;

lineHandles = gobjects(length(algo_list),1);
scatterHandles = gobjects(length(algo_list),1);
for i = 1:length(algo_list)
    % 
    nonZeroIdx = M_Increaseing_mean(i,:) ~= 0;
    % 
    if any(nonZeroIdx)
        % 
        lineHandles(i) = plot(xAxis(nonZeroIdx), M_Increaseing_mean(i, nonZeroIdx), ...
            'LineWidth', lineW, ...
            'Color', lightGray, ...
            'HandleVisibility', 'off');
        % 
        scatterHandles(i) = scatter(xAxis(nonZeroIdx), M_Increaseing_mean(i, nonZeroIdx), ...
            markerSize, ...
            markerList{i}, ...
            'MarkerEdgeColor', 'k', ...        
            'MarkerFaceColor', colors(i, :), ...
            'LineWidth', markerEdgeW, ...
            'DisplayName', algo_list{i});
    end
end
% 
if ~isempty(lineHandles(1))
    uistack(lineHandles(1), 'top');
end
if ~isempty(scatterHandles(1))
    uistack(scatterHandles(1), 'top');
end
hold off;
% 
minY = min(M_Increaseing_mean(M_Increaseing_mean~=0));
% 
% xlabel('M', 'FontSize', 14, 'FontWeight', 'bold');
% xlabel('M (\times10^2)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('$\textbf{\textit{M}} (\times10^2)$', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('Execution Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 12);
grid on;
xlim([1 length(sampleSizes)]);
ylim([minY 801]);  % 
set(gca, 'FontSize', 14, 'LineWidth', 1);
box on;
axis square;