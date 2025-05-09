function p = simplifiedNormcdf(x)
% Simplified Normal cumulative distribution function (cdf) for the standard normal distribution
% (mean 0, standard deviation 1), evaluated at the values in X. The size of P is the same as the size of X.
z = (x - 0) ./ 1; % Simplification for standard normal distribution
p = 0.5 * erfc(-z ./ sqrt(2));
end
