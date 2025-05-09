function all_clusters = enumerateClusterLabels(N)
    numCombinations = 2^N - 2; 
    all_clusters = [];  
    for i = 1:numCombinations
        binaryStr = dec2bin(i, N);  
        labelVec = binaryStr - '0' + 1;  
        if any(labelVec == 1) && any(labelVec == 2) 
            all_clusters = [all_clusters, labelVec'];  
        end
    end
    all_clusters = all_clusters(:,1:width(all_clusters)/2);
end