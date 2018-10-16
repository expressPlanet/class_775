

% Set the random seed
rng( 101 );

% Number of eigenvalues to use from training
N = 5;

pdm = load( 'correctpdms.mat' );
fName = fieldnames( pdm );
pdm.pdms = pdm.( fName{ 1 } );

x = pdm.pdms( 1 : 2 : end , : );
y = pdm.pdms( 2 : 2 : end , : );

doPlot = ~true;
if ( doPlot )
    for nn = 1 : size( x , 2 )
        figure;
        plot( x( : , nn ) , y( : , nn ) , '.' )
    end
end

ind = randperm( min( size( data ) ) );
trainInd = ind( 1 : 24 );
testInd  = ind( 25 : end );

trainX = pdm.pdms( : , trainInd );
testX  = pdm.pdms( : ,  testInd );


data = trainX;
dataMean = mean( data , 2 );
data = data - dataMean;

[ U , S ] = svd( data );

% Construct the eigenvalues from the singular values
lambda = abs( diag( S ) .^ 2 );

% Keep the eigenvalues/vectors
U = U( : , 1 : N );
lambda = lambda( 1 : N );

eigData = U' * data;