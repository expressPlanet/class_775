

addpath( '/home/bendecm2/Class/775/homework01' );

pdm = load( 'pdms.mat' );
allPnts = pdm.pdms;
findCenter = true;

% pdm = load( 'correctpdms.mat' );
% allPnts = pdm.correctpdms;
% findCenter = ~false;

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
[ trainPnts , testPnts , trainInt , testInt ] = ...
    splitSet( per , allPnts ,  allInt );

% Reshape the data into pages of images
testInt = reshape( testInt , 256 , 256 , size( testInt , 2 ) );

% Make sure the data is sorted
[ ~ , ind ] = pdmSort( trainPnts( : , 2 ) );

[ x , y ] = pdm2xy( trainPnts );
trainPnts = xy2pdm( x( ind , : ) , y( ind , : ) );

[ x , y ] = pdm2xy( testPnts );
testPnts  = xy2pdm( x( ind , : ) , y( ind , : ) );
clear x y

trainPntsNorm = trainPnts;
for aa = 1 : size( trainPnts , 2 )
    [ trainPntsNorm( : , aa ) , ~ , rot ] = normShape( ...
        trainPnts( : , aa ) );
    
end

% Get the mean and eigenvectors of the training data
[ trainMean , U , lambda ] = getEigenspace( trainPntsNorm );

[ xBar , yBar ] = pdm2xy( trainMean );
d = cat( 2 , xBar , yBar ).';
dRot = rot * d;
rotMean = dRot( : );

% trainMean = mean( trainPnts , 2 );

% Only keep the given eigenspace
U = U( : , 1 : N );
lambda = lambda( 1 : N );


for aa = 1 : size( trainPnts , 2 )
    [ x , y ] = pdm2xy( trainPnts( : , aa ) );
    [ xNorm , yNorm ] = pdm2xy( projShape( trainPnts( : , aa ) , ...
        trainMean , U , lambda , clip ) );
    figure;
    plot( x , y , '.' );
    hold all;
    plot( xNorm , yNorm , 'o' );
end
%}


testPntsNorm = testPnts;
for tt = 1 : size( testPnts , 2 )
    
    testPntsNorm( : , tt ) = projShape( testPnts( : , tt ) , ...
        trainMean , U , lambda , clip );
    
    %     plotPdm( testPntsNorm( : , tt ) );
end



testNormalDir = getPntNormal( testPntsNorm );

[ xTest , yTest ] = pdm2xy( testPntsNorm );

ll = 1;
figure;
plot( xTest( : , ll ) , yTest( : , ll ) );
hold all
quiver( xTest( : , ll ) , yTest( : , ll ) , ...
    testNormalDir( : , 1 , ll ) , testNormalDir( : , 2 , ll ) );


[ xBar0 , yBar0 ] = pdm2xy( rotMean );

xBar0 = xBar0 - mean( xBar0 );
yBar0 = yBar0 - mean( yBar0 );

dilX = 1.2;
dilY = 1.2;

theta = -linspace( -pi , pi , size( xBar0 , 1 ) ).';
radius = 50;

% xBar0 = radius * cos( theta );
% yBar0 = radius * sin( theta );


%%
for kk = 1 : size( testInt , 3 )
    
    figure( 'Colormap' , gray );
    imagesc( ( 1 : 256 ) , ( 1 : 256 ) , testInt( : , : , kk ) );
    hold all
    
%     [ xc , yc ] = estimateCenter( testInt( : , : , kk ) , 1400 , 2000 );
    
    xc = 137;
    yc = 138;
    
    keyboard
    
    xBar = dilX * xBar0 + xc;
    yBar = dilY * yBar0 + yc;
    
    start = xy2pdm( xBar , yBar );
    
    plot( xBar , yBar , 'y .' );
    plot(   xc ,   yc , 'm x' );
    
    [ xOut , yOut ] = asm03( start , testInt( : , : , kk ) , ...
        trainMean , U , lambda , sigma , clip );
    
    plot( xOut , yOut , 'c x' );
    
end



























