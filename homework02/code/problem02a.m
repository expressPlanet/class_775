
addpath( '/home/bendecm2/Class/775/homework01' );

% pdm = load( 'pdms.mat' );
% allPnts = pdm.pdms;
% findCenter = true;

pdm = load( 'correctpdms.mat' );
allPnts = pdm.correctpdms;
findCenter = ~false;

img = load( 'greyimages.mat' );
allInt  = img.greyimages;

clear pdm img

% Set the random seed (for repeatability)
rng( 101 );

per    = 0.75; % The train/test split
N      = 5;    % The number of eigenvalues to use
clip   = 2.5;
sigma  = 05;   % Derivative width
thresh = 1500;

[ x , y ] = pdm2xy( allPnts );
meanX = NaN( size( allPnts , 2 ) , 1 );
meanY = meanX;
for nn = 1 : size( allPnts , 2 )
    meanX( nn ) = mean( x( : , nn ) );
    x( : , nn ) = x( : , nn ) - meanX( nn );
    
    meanY( nn ) = mean( y( : , nn ) );
    y( : , nn ) = y( : , nn ) - meanY( nn );
    
    d = cat( 1 , x( : , nn ).' , y( : , nn ).' );
    [ rot , lam ] = eig( d * d' );
    
    dRot = -rot' * d;
    
    x( : , nn ) = dRot( 2 , : ).';
    y( : , nn ) = dRot( 1 , : ).';
end
allPnts = xy2pdm( x , y );

% Split the data into a training set and a test set
[ trainPnts , testPnts , trainInt , testInt , ~ , meanX , ~ , meanY ] = ...
    splitSet( per , allPnts ,  allInt , meanX.' , meanY.' );

[ ~ , ind ] = pdmSort( trainPnts( : , 2 ) );
[ x , y ] = pdm2xy( trainPnts );
trainPnts = xy2pdm( x( ind , : ) , y( ind , : ) );

[ x , y ] = pdm2xy( testPnts );
testPnts  = xy2pdm( x( ind , : ) , y( ind , : ) );

% Get the mean and eigenvectors of the training data
[ trainMean , U , lambda ] = getEigenspace( trainPnts );

% Only keep the given eigenspace
U = U( : , 1 : 5 );
lambda = lambda( 1 : 5 );


[ testPntsN , testCoefN ] = projectShape( testPnts-trainMean , U , lambda , clip );

testPntsN = testPntsN + trainMean;

pntNormal = getPntNormal( testPntsN );

[ x , y ] = pdm2xy( ( testPntsN ) );
K = 1;
figure;
plot( x( : , K ) , y( : , K ) , '.' );
hold all
quiver( x( : , K ) , y( : , K ) , ...
    pntNormal( : , 1 , K ) , pntNormal( : , 2 , K ) );


testInt = reshape( testInt , 256 , 256 , size( testInt , 2 ) );

[ dImgX , dImgY ] = derivGrey( testInt , sigma );

%%

center0 = trainMean;

[ xBar , yBar ] = pdm2xy( trainMean );

for kk = 1 : size( testInt , 3 )
    figure( 'Colormap' , gray );
    imagesc( ( 1 : 256 ) , ( 1 : 256 ) , testInt( : , : , kk ) );
    hold all
    
    if ( findCenter )
        [ exc , eyc ] = estimateCenter( testInt( : , : , kk ) , 1400 , 2000 );
        
        [ xt , yt ] = pdm2xy( center0 );
        
        center = xy2pdm( xt + exc , yt + eyc );
    else
        center = center0;
    end
    
    center = xy2pdm( x( : , kk ) + xBar + meanX( kk ) , ...
        y( : , kk ) + yBar + meanY( kk ) );
    [ xStart , yStart ] = pdm2xy( center );
    
    plot( xStart , yStart , 'y .' );
    plot( mean( center( 1 : 2 : end ) ) , mean( center( 2 : 2 : end ) ) , 'm x' );
    
    [ x0 , y0 ] = asm02( testInt( : , : , kk ) , ...
        center , U , lambda , sigma );
    
    plot( x0 , y0 , 'c x' );
end


