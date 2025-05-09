% Bonferroni-Dunn (BD) Critical Values Calculation in MATLAB
clc; clear; close all;

% Define significance levels
alpha_values = [0.10, 0.05, 0.01]; 

% Define number of comparisons k (1 to 20)
k_values = 1:20;

% Preallocate matrix to store critical values
critical_values = zeros(length(k_values), length(alpha_values));

% Compute critical values
for i = 1:length(alpha_values)
    alpha = alpha_values(i);
    for j = 1:length(k_values)
        k = k_values(j);
        % Compute critical value using inverse normal distribution
        critical_values(j, i) = norminv(1 - (alpha / (2 * k)));
    end
end

% Display results as a table
disp('Bonferroni-Dunn Critical Values Table:')
fprintf('   k  |  α = 0.10  |  α = 0.05  |  α = 0.01\n');
fprintf('---------------------------------------------\n');
for j = 1:length(k_values)
    fprintf(' %3d  |  %8.3f  |  %8.3f  |  %8.3f\n', k_values(j), critical_values(j, 1), critical_values(j, 2), critical_values(j, 3));
end
