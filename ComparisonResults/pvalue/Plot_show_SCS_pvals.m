%% Average SCS Value by Method
load('Plot_show_SCS.mat');
Method_List = {'Random','GT','K-MHTC','CU','K-modes','Entropy','CDC\_DR','CMS','CDE','Het2Hom','HD-NDW','COForest'};
[sortedSCS, sortIdx] = sort(Plot_List, 'descend');
sortedMethod = Method_List(sortIdx);
%% CDF 
figure;
t = tiledlayout(1,2, 'TileSpacing','compact','Padding','compact');
%% 
nexttile;
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
for i = 1:N
    if strcmp(sortedMethod{i}, 'K-MHTC')
         colors(i,:) = [0.8, 0.4, 0.4];  % muted red
    elseif strcmp(sortedMethod{i}, 'Random')
         colors(i,:) = [0.4, 0.4, 0.8];  % muted blue
    end
end
b.CData = colors;
set(gca, 'XTick', 1:N, 'XTickLabel', sortedMethod, 'FontSize', 15, 'LineWidth', 2, ...
    'Box', 'off', 'FontName', 'Arial', 'TickDir', 'out');
ylabel('Average SCS Value', 'FontSize', 15, 'FontName', 'Arial');
xtickangle(45);
%title('Average SCS Value by Method', 'FontSize', 15, 'FontWeight', 'bold', 'FontName', 'Arial');
%% CDF 
load('Plot_show_pvals.mat') 
nexttile;
hold on;
mainColor    = [146, 211, 177] / 255;  
color_Random = [0.4, 0.4, 0.8];        
color_MHTC   = [0.8, 0.4, 0.4];        
% 1
otherVars = {'combined_pv_CDC_DR', 'combined_pv_CDE', 'combined_pv_CMS', ...
             'combined_pv_HDNDW', 'combined_pv_CU', 'combined_pv_Entropy', ...
             'combined_pv_COForest', 'combined_pv_Het2Hom', 'combined_pv_kmodes', 'combined_pv_GT'};
for i = 1:length(otherVars)
    data = eval(otherVars{i});
    data = data(:);
    [f, x] = ecdf(data);
    plot(x, f, 'Color', mainColor, 'LineWidth', 1, 'HandleVisibility', 'off');
end
% 2
data_random = eval('combined_pv_Random');
data_random = data_random(:);
[f_rand, x_rand] = ecdf(data_random);
h_random = plot(x_rand, f_rand, 'Color', color_Random, 'LineWidth', 3);
% 3
x_uniform = [0, 1];
y_uniform = [0, 1];
h_uniform = plot(x_uniform, y_uniform, 'k--', 'LineWidth', 3);
% 4
data_MHTC = eval('combined_pv_MHTC');
data_MHTC = data_MHTC(:);
[f_MHTC, x_MHTC] = ecdf(data_MHTC);
h_MHTC = plot(x_MHTC, f_MHTC, 'Color', color_MHTC, 'LineWidth', 3);
% 
uistack(h_uniform, 'top');
uistack(h_MHTC, 'top');
% 
xlabel('p-value', 'FontSize', 15, 'FontName', 'Arial');
ylabel('Cumulative frequency', 'FontSize', 15, 'FontName', 'Arial');
xticks(0:0.1:1);
%grid on;
set(gca, 'FontSize', 15, 'LineWidth', 2, 'Box', 'off', 'FontName', 'Arial', 'TickDir', 'out');
% K-MHTC Random Uniform
legend([h_MHTC, h_random, h_uniform], ...
       {'Empirical CDF (K-MHTC)', 'Empirical CDF (Random)', 'Uniform CDF'}, ...
       'Location', 'southeast', 'FontSize', 15);
hold off;