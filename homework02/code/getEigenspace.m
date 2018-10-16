function [ trainMean , U , lambda ] = getEigenspace( trainPnts )

trainMean = mean( trainPnts , 2 );

% Get the eigen values/vectors via SVD
[ U , lambda ] = svd( trainPnts - trainMean );
lambda = abs( diag( lambda ) ) .^ 2;