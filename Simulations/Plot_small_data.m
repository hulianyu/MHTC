%% Add required paths
addpath([cd '/Datasets']);
addpath([cd '/ComparisonResults/pvalue']); % Contains output_combined_pval.m
addpath([cd '/Simulations']);
%% Dataset filenames and display names
filenames = char('house-votes', 'breast-cancer-wisconsin', 'mushroom');
datanames = {'Hv', 'Bc', 'Mu'};  % Display names for the plots
%% Create a figure with 1x3 subplots (Nature-style)
figure('Color', 'w', 'Position', [100, 100, 1200, 400]);
set(groot, 'DefaultAxesFontName', 'Helvetica', 'DefaultAxesFontSize', 10);
%% Process each dataset in a loop
for I = 1:3
    % Load the dataset
    data = load([strtrim(filenames(I, :)), '.txt']);
    X = data(:, 2:end);      % Features
    X_Label = data(:, 1);    % Ground truth labels
    K = numel(unique(X_Label));  % Number of clusters
    r = floor(size(X, 2) / 2);     % Parameter    
    %%% Part 1: select from 2 to 12 per cluster (sample sizes: 4,6,...,24)
    SCS_pv_all = [];
    for select = 2:12
        disp(['Dataset ', num2str(I), ', select = ', num2str(select)]);
        SCS_pv = [];
        % Run 100 trials
        parfor run = 1:100
            X_small = [];
            X_Label_small = [];
            % For each cluster, randomly select "select" samples
            for k = 1:K
                idx = find(X_Label == k);
                selected_idx = idx(randperm(numel(idx), select));
                X_small = [X_small; X(selected_idx, :)];
                X_Label_small = [X_Label_small; repmat(k, select, 1)];
            end
            % Discretize each column (map unique values to indices)
            for col = 1:size(X_small, 2)
                [~, ~, X_small(:, col)] = unique(X_small(:, col));
            end
            % Compute the combined p-value (provided function)
            SCS_pv = [SCS_pv, output_combined_pval(X_small, X_Label_small, r)];
        end
        % Record the count of trials (out of 100) with p-value > 0.01
        SCS_pv_all = [SCS_pv_all, sum(SCS_pv > 0.01)];
    end   
    %%% Part 2: Aggregate select values from 13 to 100 per cluster 
    % (this covers sample sizes from 26 to 200, but here we aggregate them and label as "26–200")
    SCS_pv = [];
    for select = 13:100
        disp(['Dataset ', num2str(I), ', select = ', num2str(select)]);
        parfor run = 1:100
            X_small = [];
            X_Label_small = [];
            for k = 1:K
                idx = find(X_Label == k);
                selected_idx = idx(randperm(numel(idx), select));
                X_small = [X_small; X(selected_idx, :)];
                X_Label_small = [X_Label_small; repmat(k, select, 1)];
            end
            for col = 1:size(X_small, 2)
                [~, ~, X_small(:, col)] = unique(X_small(:, col));
            end
            SCS_pv = [SCS_pv, output_combined_pval(X_small, X_Label_small, r)];
        end
    end
    SCS_pv_all_26 = sum(SCS_pv > 0.01); 
    %%% Combine the two parts for plotting
    % For select = 2:12, sample sizes = (2:12)*2 gives 4,6,...,24.
    % Append one additional aggregated bar at x = 26.
    final_sample_sizes = [ (2:12)*2, 26 ];
    final_error_rates = [ SCS_pv_all, SCS_pv_all_26 ];
    %% Create a subplot for the current dataset
    subplot(1, 3, I);
    bar(final_sample_sizes, final_error_rates, 'FaceColor', [0.95, 0.75, 0.75], 'EdgeColor', 'none');
    set(gca, 'Box', 'off', 'LineWidth', 1);
    grid on;
    % Set x-axis ticks and custom labels
    set(gca, 'XTick', final_sample_sizes);
    xtick_labels = arrayfun(@num2str, (2:12)*2, 'UniformOutput', false);
    xtick_labels{end+1} = '26–200';  % Label for the aggregated bar
    set(gca, 'XTickLabel', xtick_labels);
    xlabel('Samples');
    ylabel('identified as non-significant');
    title(['Sampled from ', datanames{I}], 'FontSize', 12, 'FontWeight', 'Bold');  
    if exist('ytickformat', 'file')
        ytickformat('percentage');
    end
end