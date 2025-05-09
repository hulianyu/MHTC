load('Plot_different_rate_SCS.mat')
dataname = char('Ls','Lc','So','Pe','Ae','Zo','Ps','Hr','Ly','Hd',...
    'Sf','Pt','De','Hv','Bs','Ca','Bc','Mm','Tt','Le','Ce','Ti','Ch','Mu','Nu');
figure('Position',[100,100,1500,900],'Color','w');
t = tiledlayout(3,9, 'TileSpacing','compact','Padding','compact');
for i = 1:2
    ax = nexttile;
    axis(ax, 'off');
end
for I = 1:7
    ax = nexttile;
    X  = all_SCS_Metrics_list{I,1}(:,1);
    Y1 = all_SCS_Metrics_list{I,1}(:,2); % ACC
    Y2 = all_SCS_Metrics_list{I,1}(:,3); % NMI
    Y3 = all_SCS_Metrics_list{I,1}(:,4); % ARI 
    scatter(ax, X, Y1, 20, [0.8500, 0.3250, 0.0980], 'o', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'on');
    scatter(ax, X, Y2, 20, [1, 0.6, 0], '^', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    scatter(ax, X, Y3, 20, [0, 0.4470, 0.7410], 's', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
end
for I = 8:16
    ax = nexttile;
    X  = all_SCS_Metrics_list{I,1}(:,1);
    Y1 = all_SCS_Metrics_list{I,1}(:,2);
    Y2 = all_SCS_Metrics_list{I,1}(:,3);
    Y3 = all_SCS_Metrics_list{I,1}(:,4);
    scatter(ax, X, Y1, 20, [0.8500, 0.3250, 0.0980], 'o', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'on');
    scatter(ax, X, Y2, 20, [1, 0.6, 0], '^', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    scatter(ax, X, Y3, 20, [0, 0.4470, 0.7410], 's', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
end
for I = 17:25
    ax = nexttile;
    X  = all_SCS_Metrics_list{I,1}(:,1);
    Y1 = all_SCS_Metrics_list{I,1}(:,2);
    Y2 = all_SCS_Metrics_list{I,1}(:,3);
    Y3 = all_SCS_Metrics_list{I,1}(:,4);
    scatter(ax, X, Y1, 20, [0.8500, 0.3250, 0.0980], 'o', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'on');
    scatter(ax, X, Y2, 20, [1, 0.6, 0], '^', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    scatter(ax, X, Y3, 20, [0, 0.4470, 0.7410], 's', 'filled', ...
        'MarkerEdgeColor','k','LineWidth',0.5);
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
end