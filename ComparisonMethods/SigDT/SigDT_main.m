function pi = SigDT_main(X)
    [N,M] = size(X);
    for m=1:M
        % keep the order in discat
        [~, ~, X(:,m)] = unique(X(:,m), 'stable');
    end
    for m =2:M
        X(:,m) = X(:,m) + max(X(:,m-1));
    end
    Q = max(X(:,M));
    objsID = 1:N;
    X = [objsID' X];
    k = 0;
    pi_Node = zeros(N+1,1);
    [~, ~, pi_Node] = Sig_divide(X,Q,k,pi_Node); 
    pi = pi_Node(1:end-1);
end

%% https://github.com/hulianyu/SigDT
% @article{Hu2025SigDT,
%   title = {Significance-based decision tree for interpretable categorical data clustering},
%   author = {Lianyu Hu and Mudi Jiang and Xinying Liu and Zengyou He},
%   journal = {Information Sciences},
%   volume = {690},
%   pages = {121588},
%   year = {2025},
%   doi = {https://doi.org/10.1016/j.ins.2024.121588}
% }