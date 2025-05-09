function pi_random = Random_partition_rate(pi,alpha)
pi_random = pi;
N = length(pi);
t = ceil(N*alpha);
% Generate a local randomized labels: randperm(t)
shuffled_indices = randperm(N, t);
indices = sort(shuffled_indices);
pi_random(indices) = pi(shuffled_indices);
end