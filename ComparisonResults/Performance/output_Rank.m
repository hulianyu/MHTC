function ranks = output_Rank(s)
    [N, k] = size(s);
    [S, r] = sort(s', 'descend');
    idx = k * repmat(0:N-1, k, 1)' + r'; 
    R = repmat(1:k, N, 1);
    S = S';
    
    for i = 1:N
        for j = 1:k
            tie_index = (S(i,j) == S(i,:));
            R(i, tie_index) = mean(R(i, tie_index));
        end
    end
    r(idx) = R;
    r = r'; 
    ranks = r;
end