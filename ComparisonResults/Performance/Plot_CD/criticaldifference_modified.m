function [cd_vals, ax] = criticaldifference_modified(name, s, labels, alpha, ax)
% CRITICALDIFFERENCE_MODIFIED - Draw a simplified Critical Difference diagram
%   [CD_VALS, AX] = CRITICALDIFFERENCE_MODIFIED(NAME, S, LABELS, ALPHA, AX)
%
% Inputs:
%   NAME   - Figure name (string, used for saving if a new figure is created)
%   S      - (N×K) score matrix (N datasets × K algorithms)
%   LABELS - 1×K cell array of algorithm names
%   ALPHA  - Significance level(s); can be scalar or vector (e.g., 0.1 or [0.1, 0.05])
%   AX     - (Optional) target axes handle. If not provided or empty, a new figure+axes is created.
%
% Outputs:
%   CD_VALS - Critical Difference value(s) for each ALPHA
%   AX      - The axes on which the CD diagram is drawn
%
% NOTE: If AX is given, no separate figure is saved (unless you explicitly do so).
%       Otherwise, the function creates a new figure named NAME and saves it as NAME.fig.

%% ------------------- 0. Parse inputs -------------------
if nargin < 4 || isempty(alpha)
    alpha = 0.1;  % Default alpha
end
if ~iscell(alpha)
    if numel(alpha) > 1
        alpha = num2cell(alpha);
    else
        alpha = {alpha};
    end
end

% Check if user provided an axes handle
newFigureFlag = false;  % if we create a new figure or not
if nargin < 5 || isempty(ax) || ~ishandle(ax)
    % Create a new figure + axes
    f = figure('Name', name, 'Color', 'w', 'Visible', 'off');
    set(f, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.6, 0.3]);
    ax = axes('Parent', f, 'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold', 'LineWidth', 1.5);
    newFigureFlag = true;
else
    % Use existing axes
    f = ancestor(ax, 'figure'); % get the parent figure
    set(f, 'Color', 'w');       % just ensure background is white
    if ~isempty(name)
        set(f, 'Name', name);   % optionally name the figure
    end
end

%% ------------------- 1. Convert scores to ranks -------------------
[N, k] = size(s);
[S, r] = sort(s', 'descend');
idx = k * repmat(0:N-1, k, 1)' + r'; 
R = repmat(1:k, N, 1);
S = S';

% Deal with ties by averaging ranks
for i = 1:N
    for j = 1:k
        tie_index = (S(i,j) == S(i,:));
        R(i,tie_index) = mean(R(i,tie_index));
    end
end

r(idx) = R;  
r = r';               % R(i, j) = rank of j-th algo on i-th dataset
avg_ranks = mean(r, 1);
[sorted_ranks, sorted_idx] = sort(avg_ranks);
sorted_labels = labels(sorted_idx);

%% ------------------- 2. Compute CD values -------------------
cd_vals = zeros(1, numel(alpha));
for a = 1:numel(alpha)
    alpha_val = alpha{a};
    qalpha = getQalpha_BD(alpha_val, k);
    cd_vals(a) = qalpha * sqrt(k*(k+1)/(6*N));
end

%% ------------------- 3. Setup the axes -------------------
hold(ax, 'on');
set(ax, 'Box', 'off', 'YColor', 'none', 'XAxisLocation', 'top', 'TickDir', 'out');
xlim(ax, [1, k]);
set(ax, 'XTick', 1:k);
%xlabel(ax, 'Rank', 'FontSize', 14, 'FontWeight', 'bold');
ylim(ax, [-0.2, 0.05]); 

%% ------------------- 4. Assign marker+color & plot algorithms -------------------
markerList = {'h', 'p', 'o', 's', 'o', 's', '^', 'v', '<', 'd', 'd', 'p'}; 
colors = [1 1 0;         
          0 0.4470 0.7410;
          0.8500 0.3250 0.0980;
          1 0.6 0;        
          0 0.4470 0.7410;
          0.8500 0.3250 0.0980; 
          1 0.6 0;        
          0 0.4470 0.7410; 
          0.8500 0.3250 0.0980; 
          1 0.6 0;        
          0 0.4470 0.7410; 
          0.8500 0.3250 0.0980];  
markerForAlgo = cell(1, k);
colorForAlgo  = zeros(k, 3);
for algo_i = 1:k
    shapeIdx = mod(algo_i-1, length(markerList)) + 1;
    colorIdx = mod(algo_i-1, size(colors, 1)) + 1;
    markerForAlgo{algo_i} = markerList{shapeIdx};
    colorForAlgo(algo_i,:) = colors(colorIdx,:);
end

threshold = 0.01; 
offsetStep = 0.02;
usedPositions = zeros(0,2); 
hPlots = gobjects(k,1);
legendLabelsWithRank = cell(1, k);

for i = 1:k
    realIdx = sorted_idx(i);
    xVal = sorted_ranks(i);
    yVal = -0.05;
    while any(abs(usedPositions(:,1) - xVal) < threshold & abs(usedPositions(:,2) - yVal) < threshold)
        yVal = yVal - offsetStep;
    end
    usedPositions = [usedPositions; [xVal, yVal]];

    thisMarker = markerForAlgo{realIdx};
    thisColor  = colorForAlgo(realIdx, :);
    hPlots(i) = plot(ax, xVal, yVal, 'Marker', thisMarker, 'MarkerSize', 12, ...
        'MarkerFaceColor', thisColor, 'MarkerEdgeColor', 'k', 'LineStyle', 'none');
    % line(ax, [xVal, xVal], [yVal, 0], 'Color', [0.3, 0.3, 0.3], 'LineStyle', '--', 'LineWidth', 1.5);

    legendLabelsWithRank{i} = sprintf('%s (%.2f)', sorted_labels{i}, sorted_ranks(i));
end

legend(ax, hPlots, legendLabelsWithRank, 'Location', 'northeastoutside', 'FontSize', 10, 'FontWeight', 'bold');
legend(ax, 'boxoff');

%% ------------------- 5. Plot CD intervals -------------------

capSize = 0.01; 

% (1) CD interval for the first rank (drawn at the bottom)
baseY_bottom = -0.1;    
deltaY_bottom = 0.02;   
first_rank = sorted_ranks(1);
for a = 1:numel(alpha)
    cd_val = cd_vals(a);
    yPos_bottom = baseY_bottom - (a-1)*deltaY_bottom;
    
    line(ax, [first_rank, first_rank + cd_val], [yPos_bottom, yPos_bottom], ...
        'Color', 'k', 'LineWidth', 2, 'HandleVisibility','off', 'LineStyle','-');
    line(ax, [first_rank, first_rank], [yPos_bottom - capSize, yPos_bottom + capSize], ...
        'Color', 'k', 'LineWidth', 2, 'HandleVisibility','off');
    line(ax, [first_rank + cd_val, first_rank + cd_val], [yPos_bottom - capSize, yPos_bottom + capSize], ...
        'Color', 'k', 'LineWidth', 2, 'HandleVisibility','off');
    text(ax, (first_rank + (first_rank + cd_val))/2, yPos_bottom - 0.02, ...
        sprintf('CD = %.2f', cd_val), 'HorizontalAlignment', 'center', ...
        'FontSize', 10, 'FontWeight', 'bold', 'Parent', ax);
end

% (2) CD interval for the last rank (drawn at the top)
% baseY_top = 0.005;  
baseY_top = 0;  
deltaY_top = 0.02;   
last_rank = sorted_ranks(end); 
for a = 1:numel(alpha)
    cd_val = cd_vals(a);
    yPos_top = baseY_top + (a-1)*deltaY_top;
    
    line(ax, [last_rank - cd_val, last_rank], [yPos_top, yPos_top], ...
        'Color', 'k', 'LineWidth', 2, 'HandleVisibility','off', 'LineStyle','-');
    line(ax, [last_rank - cd_val, last_rank - cd_val], [yPos_top - capSize, yPos_top + capSize], ...
        'Color', 'k', 'LineWidth', 2, 'HandleVisibility','off');
    line(ax, [last_rank, last_rank], [yPos_top - capSize, yPos_top + capSize], ...
        'Color', 'k', 'LineWidth', 2, 'HandleVisibility','off');
    text(ax, (last_rank - cd_val + last_rank)/2, yPos_top + 0.02, ...
        sprintf('CD = %.2f', cd_val), 'HorizontalAlignment', 'center', ...
        'FontSize', 10, 'FontWeight', 'bold', 'Parent', ax);
end

hold(ax, 'off');

%% ------------------- 6. If new figure was created, save it -------------------
if newFigureFlag
    savefig(f, [name '.fig']);
    set(f, 'Visible', 'on');
end

end

%% ------------------ Subfunction: Bonferroni-Dunn qalpha ------------------
function qval = getQalpha_BD(alpha, k)
if ~ismember(alpha, [0.01, 0.05, 0.1])
    error('alpha must be 0.01, 0.05, or 0.1');
end
if alpha == 0.01
    qtable = [0.000 2.576 2.807 2.935 3.023 3.090 3.144 3.189 3.227 3.261 ...
              3.291 3.317 3.341 3.364 3.384 3.403 3.421 3.437 3.452 3.467 3.481];
elseif alpha == 0.05
    qtable = [0.000 1.960 2.241 2.394 2.498 2.576 2.638 2.690 2.734 2.773 ...
              2.807 2.838 2.865 2.891 2.914 2.935 2.955 2.974 2.991 3.008 3.023];
else % alpha == 0.1
    qtable = [0.000 1.645 1.960 2.128 2.241 2.326 2.394 2.450 2.498 2.539 ...
              2.576 2.609 2.638 2.665 2.690 2.713 2.734 2.754 2.773 2.790 2.807];
end

if k <= 20
    qval = qtable(k);
else
    qval = qtable(end);
    warning('Number of algorithms k exceeds table range; using the largest tabulated value.');
end
end
