addpath([cd '/Datasets']);
addpath([cd '/Simulations']);
filename = char('lenses','lung-cancer','soybean-small','photo-evaluation','assistant-evaluation','zoo','dna-promoter','hayes-roth','lymphography','heart-disease','solar-flare','primary-tumor','dermatology','house-votes',...
    'balance-scale','credit-approval','breast-cancer-wisconsin','mammographic-mass','tic-tac-toe',...
    'lecturer-evaluation','car','titanic','chess','mushroom','nursery');
%% Random_partition_rate
ET = 50;
all_random_pi = cell(20,length(filename));
for partition_rate = 1:20
    disp(partition_rate);
    alpha = partition_rate*0.05;
    for I = 1:length(filename)
        X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
        X = X_data(:,2:end); %Data set
        X_Label = X_data(:,1); %Ground Truth
        random_pi = [];
        for run = 1:ET
            random_pi = [random_pi Random_partition_rate(X_Label,alpha)];
        end
        all_random_pi{partition_rate,I} = random_pi;
    end
end
%% calculate combined pvals 
all_r_median_list = zeros(20,100);
combined_pv_random_list = cell(20,20);
for r_rate = 1:100
    disp(r_rate)
    parfor partition_rate = 1:20
        % disp(partition_rate);
        tmp_rate = [];
        for I = 1:length(filename)
            X_data = load([strtrim(filename(I,:)), '.txt']); %Load a Dataset
            X = X_data(:,2:end); %Data set
            [N,M] = size(X);
            r = floor(M*r_rate*0.01);
            if r<1
                r = 1;
            end
            tmp = [];
            for run = 1:ET
                random_pi = all_random_pi{partition_rate,I}(:,run);
                [~,p] = chi_squared_test(X,random_pi);
                tmp = [tmp rOP_pvals_SETr(p,r)];
            end
            % tmp = median(tmp);
            tmp_rate = [tmp_rate tmp];
        end
        combined_pv_random_list{r_rate,partition_rate} = tmp_rate;
    end
end
for r_rate = 1:100
    combined_pv_random = zeros(20,length(filename)*ET);
    for partition_rate = 1:20
        combined_pv_random(partition_rate,:) = combined_pv_random_list{r_rate,partition_rate};
    end
    all_r_median_list(:,r_rate) = median(combined_pv_random,2);
end

%% combined_pv_random
for r_rate = 50:50
    combined_pv_random = zeros(20,length(filename)*ET);
    for partition_rate = 1:20
        combined_pv_random(partition_rate,:) = combined_pv_random_list{r_rate,partition_rate};
    end
end

%% load('Plot_different_r_combined_pvals.mat')

%% [PLOT] all_r_median_list
x_values = 5:5:100; 
figure('Position', [100, 100, 1200, 600], 'Color', 'w');
hold on;
plot(x_values, all_r_median_list(:, 1:49), 'LineWidth', 1.0, 'Color', [0.95, 0.75, 0.75]);
plot(x_values, all_r_median_list(:, 51:99), 'LineWidth', 1.0, 'Color', [0.75, 0.75, 0.95]);
plot(x_values, all_r_median_list(:, 50), 'LineWidth', 2.0, 'Color', 'k');
plot(x_values, all_r_median_list(:, 100), 'LineWidth', 2.0, 'Color', [0, 0, 0.8]);
set(gca, 'YScale', 'log');
yline(0.01, '--', 'Color', 'k', 'LineWidth', 1.5);
set(gca, 'TickDir', 'out', 'XGrid', 'on', 'YGrid', 'off', ...
    'GridColor', [0.7, 0.7, 0.7], 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1.2);
y_limits = ylim;
ylim([1e-10, y_limits(2)]);
title('\boldmath$r = \lfloor0.01\cdot M\rfloor \to \lfloor0.5\cdot M\rfloor \to M$', 'Interpreter', 'latex', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('% randomized ground-truth partition', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Combined p-value', 'FontSize', 14, 'FontWeight', 'bold');
xticks(5:5:100);
xticklabels(strcat(string(5:5:100)));
axis square;
hold off;

%% [PLOT] combined_pv_random
selected_data = combined_pv_random(1:end, :);
x_labels = strcat(string(5:5:100));
figure('Position', [100, 100, 1200, 600], 'Color', 'w');
boxplot(selected_data', 'Labels', x_labels, 'Symbol', '');
set(gca, 'YScale', 'log');
hold on;
yline(0.01, '--', 'Color', 'k', 'LineWidth', 1.5);
set(gca, 'TickDir', 'out', 'XGrid', 'on', 'YGrid', 'off', ...
    'GridColor', [0.7, 0.7, 0.7], 'FontName', 'Arial', 'FontSize', 12, 'LineWidth', 1.2);
y_limits = ylim;
ylim([1e-10, y_limits(2)]);
title('\boldmath$r = \lfloor0.5\cdot M\rfloor$', 'Interpreter', 'latex', 'FontSize', 14);
xlabel('% randomized ground-truth partition', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Combined p-value', 'FontSize', 14, 'FontWeight', 'bold');
hMedian = findobj(gca, 'tag', 'Median');
set(hMedian, 'LineWidth', 2.0, 'Color', 'k');
hBoxes = findobj(gca, 'Tag', 'Box');
for i = 1:length(hBoxes)
    set(hBoxes(i), 'Color', '[0.33, 0.33, 0.33]','LineWidth', 1);
end
medians = median(selected_data, 2);
plot(1:length(medians), medians, '-k', 'LineWidth', 2);
set(gca, 'Box', 'off');
hold off;
axis square;