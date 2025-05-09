function [node, num_node, pi] = Sig_divide(X, Q, num_node, pi)
node = createNode(X(:,1), [], [], [], []); % Create a new node
[min_pval, best_pi, best_m, best_cat] = find_ts_mq(X, Q);
num_node = num_node + 1;
% *Alpha* Ref: Webb G I, Petitjean F.
% A multiple test correction for streams and cascades of statistical hypothesis tests [KDD' 16].
if num_node ~= 1 && min_pval > 0.01 / (Q^num_node)
    pi(end) = pi(end)+1; % Record the cluster number
    pi(node.objs) = pi(end);  % Assign a leaf to a cluster
    return;
end
% Recursively apply Binary_divide to the left and right sub-arrays
X_left = X(best_pi == 1, :);
X_right = X(best_pi == 2, :);
node.pval = min_pval;
node.category = [best_m, best_cat];
[node.left, num_node, pi] = Sig_divide(X_left, Q, num_node, pi);
[node.right, num_node, pi] = Sig_divide(X_right, Q, num_node, pi);
end
