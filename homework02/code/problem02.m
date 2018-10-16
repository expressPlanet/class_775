
addpath( '/home/bendecm2/Class/775/homework01' );

% pdm = load( 'pdms.mat' );
% allPnts = pdm.pdms;
% xc = 128;
% yc = 150;
% findCenter = true;

pdm = load( 'correctpdms.mat' );
allPnts = pdm.correctpdms;
xc = 0;
yc = 0;
findCenter = false;

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

% Split the data into a training set and a test set
[ trainPnts , testPnts , trainInt , testInt ] = splitSet( per , ...
    allPnts ,  allInt );

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

x = x + xc;
y = y + yc;

center = trainMean;
center( 1 : 2 : end ) = trainMean( 1 : 2 : end ) + xc;
center( 2 : 2 : end ) = trainMean( 2 : 2 : end ) + yc;

for kk = 1 : size( testInt , 3 )
    
    
    if ( findCenter )
        [ exc , eyc ] = estimateCenter( testInt( : , : , kk ) , 1400 , 2000 );
        
        x( : , kk ) = x( : , kk ) - xc + exc;
        y( : , kk ) = y( : , kk ) - yc + eyc;
        
        center( 1 : 2 : end ) = center( 1 : 2 : end ) - xc + exc;
        center( 2 : 2 : end ) = center( 2 : 2 : end ) - yc + eyc;
    end
    
    figure( 'Colormap' , gray );
    imagesc( ( 1 : 256 ) , ( 1 : 256 ) , testInt( : , : , kk ) );
    hold all
    plot( x( : , kk ) , y( : , kk ) , 'y .' );
    plot( mean( center( 1 : 2 : end ) ) , mean( center( 2 : 2 : end ) ) , 'm x' );
    
    [ x0 , y0 ] = asm( testInt( : , : , kk ) , ...
        x( : , kk ) , y( : , kk ) , ...
        center , U , lambda , sigma );
    
    plot( x0 , y0 , 'c x' );
end


