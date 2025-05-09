load('Convergence_demo.mat') 
dataname = char('Ls','Lc','So','Pe','Ae','Zo','Ps','Hr','Ly','Hd',...
    'Sf','Pt','De','Hv','Bs','Ca','Bc','Mm','Tt','Le','Ce','Ti','Ch','Mu','Nu');

blueColor = [0, 0.4470, 0.7410];
redColor  = [0.8500, 0.3250, 0.0980];

figure('Position',[100,100,1500,900],'Color','w');
t = tiledlayout(3,9, 'TileSpacing','compact','Padding','compact');

for i = 1:2
    ax = nexttile;
    axis(ax, 'off');
end

for I = 1:7
    ax = nexttile;
    hold(ax, 'on');
    for j = 1:50
        y = MHTC_Convergence_curves{I,j};
        x = 0:length(y)-1;  
        plot(ax, x, y, '-', 'Color', [0.9,0.9,0.9], 'LineWidth',1);
    end
    iter_counts = zeros(1,50);
    for j = 1:50
        iter_counts(j) = length(MHTC_Convergence_curves{I,j});
    end
    [~, idx_min] = min(iter_counts);
    [~, idx_max] = max(iter_counts);
    
    y_max = MHTC_Convergence_curves{I, idx_max};
    x_max = 0:length(y_max)-1;
    plot(ax, x_max, y_max, '-o', 'Color', redColor, 'LineWidth', 1.5, ...
         'MarkerSize', 4, 'MarkerFaceColor', redColor);
    y_min = MHTC_Convergence_curves{I, idx_min};
    x_min = 0:length(y_min)-1;
    plot(ax, x_min, y_min, '-o', 'Color', blueColor, 'LineWidth', 1.5, ...
         'MarkerSize', 4, 'MarkerFaceColor', blueColor);
    
    min_iter = length(y_min) - 1;
    max_iter = length(y_max) - 1;
    xticks(ax, unique([0, min_iter, max_iter]));
    xlim(ax, [0, max_iter]);
    
    all_obj = [];
    for j = 1:50
        all_obj = [all_obj, MHTC_Convergence_curves{I,j}];
    end
    y_tick_lower = round(min(all_obj));
    y_tick_upper = round(max(all_obj));
    margin = 0.1 * (y_tick_upper - y_tick_lower);
    ylim(ax, [y_tick_lower - margin, y_tick_upper + margin]);
    yticks(ax, [y_tick_lower, y_tick_upper]);
    
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
    set(ax, 'FontSize',10, 'LineWidth',1);
end

for I = 8:16
    ax = nexttile;
    hold(ax, 'on');
    for j = 1:50
        y = MHTC_Convergence_curves{I,j};
        x = 0:length(y)-1;
        plot(ax, x, y, '-', 'Color', [0.9,0.9,0.9], 'LineWidth',1);
    end
    iter_counts = zeros(1,50);
    for j = 1:50
        iter_counts(j) = length(MHTC_Convergence_curves{I,j});
    end
    [~, idx_min] = min(iter_counts);
    [~, idx_max] = max(iter_counts);
    
    y_max = MHTC_Convergence_curves{I, idx_max};
    x_max = 0:length(y_max)-1;
    plot(ax, x_max, y_max, '-o', 'Color', redColor, 'LineWidth', 1.5, ...
         'MarkerSize', 4, 'MarkerFaceColor', redColor);
    y_min = MHTC_Convergence_curves{I, idx_min};
    x_min = 0:length(y_min)-1;
    plot(ax, x_min, y_min, '-o', 'Color', blueColor, 'LineWidth', 1.5, ...
         'MarkerSize', 4, 'MarkerFaceColor', blueColor);
    
    min_iter = length(y_min) - 1;
    max_iter = length(y_max) - 1;
    xticks(ax, unique([0, min_iter, max_iter]));
    xlim(ax, [0, max_iter]);
    
    all_obj = [];
    for j = 1:50
        all_obj = [all_obj, MHTC_Convergence_curves{I,j}];
    end
    y_tick_lower = round(min(all_obj));
    y_tick_upper = round(max(all_obj));
    margin = 0.1 * (y_tick_upper - y_tick_lower);
    ylim(ax, [y_tick_lower - margin, y_tick_upper + margin]);
    yticks(ax, [y_tick_lower, y_tick_upper]);
    
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
    set(ax, 'FontSize',10, 'LineWidth',1);
end

for I = 17:25
    ax = nexttile;
    hold(ax, 'on');
    for j = 1:50
        y = MHTC_Convergence_curves{I,j};
        x = 0:length(y)-1;
        plot(ax, x, y, '-', 'Color', [0.9,0.9,0.9], 'LineWidth',1);
    end
    iter_counts = zeros(1,50);
    for j = 1:50
        iter_counts(j) = length(MHTC_Convergence_curves{I,j});
    end
    [~, idx_min] = min(iter_counts);
    [~, idx_max] = max(iter_counts);
    
    y_max = MHTC_Convergence_curves{I, idx_max};
    x_max = 0:length(y_max)-1;
    plot(ax, x_max, y_max, '-o', 'Color', redColor, 'LineWidth', 1.5, ...
         'MarkerSize', 4, 'MarkerFaceColor', redColor);
    y_min = MHTC_Convergence_curves{I, idx_min};
    x_min = 0:length(y_min)-1;
    plot(ax, x_min, y_min, '-o', 'Color', blueColor, 'LineWidth', 1.5, ...
         'MarkerSize', 4, 'MarkerFaceColor', blueColor);
    
    min_iter = length(y_min) - 1;
    max_iter = length(y_max) - 1;
    xticks(ax, unique([0, min_iter, max_iter]));
    xlim(ax, [0, max_iter]);
    
    all_obj = [];
    for j = 1:50
        all_obj = [all_obj, MHTC_Convergence_curves{I,j}];
    end
    y_tick_lower = round(min(all_obj));
    y_tick_upper = round(max(all_obj));
    margin = 0.1 * (y_tick_upper - y_tick_lower);
    ylim(ax, [y_tick_lower - margin, y_tick_upper + margin]);
    yticks(ax, [y_tick_lower, y_tick_upper]);
    
    hold(ax, 'off');
    title(ax, strtrim(dataname(I,:)), 'FontSize',10);
    axis(ax, 'square');
    set(ax, 'FontSize',10, 'LineWidth',1);
end
set(gcf, 'Renderer', 'painters');