

clear all

imPath = fullfile( pwd , 'images' );

k = 25;    % The order of the fan
sigma = 2; % The blurring std

nAngles = 1e3+1; % The number of testing angles

A = [ 1 , 1000 , 1000 , -500 ];
B = [ 0 ,    0 , 1000 , 1000 ];

x = ( 1 : 128 );
x = x - mean( x( : ) );
y = x;

[ xg , yg ] = ndgrid( x , y );


theta0 = 2 * pi * 0.25 / k;
theta = atan2( yg , xg );

thetaN = -3 * theta0;
idealFan  = makeFan( theta ,      0 , k , sigma );
rotp25Fan = makeFan( theta , theta0 , k , sigma );
rotn75Fan = makeFan( theta , thetaN , k , sigma );

%
fig0 = figure( 'WindowStyle' , 'Normal' );
ax0  = axes( 'Parent' , fig0 );
pc = pcolor( xg , yg , idealFan , 'Parent' , ax0 );
pc.FaceAlpha = 0.75;
xlabel( ax0 , 'x' );
ylabel( ax0 , 'y' );
title(  ax0 , 'Reference Image' );
fan0 = 'ref';

figP = figure( 'WindowStyle' , 'Normal' );
axP  = axes( 'Parent' , figP );
pc = pcolor( xg , yg , rotp25Fan , 'Parent' , axP );
pc.FaceAlpha = 0.75;
xlabel( axP , 'x' );
ylabel( axP , 'y' );
title(  axP , '25 deg. Rotation Up' );
fanP = '25u';

figN = figure( 'WindowStyle' , 'Normal' );
axN  = axes( 'Parent' , figN );
pc = pcolor( xg , yg , rotn75Fan , 'Parent' , axN );
pc.FaceAlpha = 0.75;
xlabel( axN , 'x' );
ylabel( axN , 'y' );
title(  axN , '75 deg. Rotation Down' );
fanN = '75d';

print( fig0 , fullfile( imPath , sprintf( 'fan_%s.png' , fan0 ) ) , ...
    '-dpng' , '-r216' );
print( figP , fullfile( imPath , sprintf( 'fan_%s.png' , fanP ) ) , ...
    '-dpng' , '-r216' );
print( figN , fullfile( imPath , sprintf( 'fan_%s.png' , fanN ) ) , ...
    '-dpng' , '-r216' );

saveas( fig0 , fullfile( imPath, sprintf( 'fan_%s.fig' , fan0 ) ), 'fig' );
saveas( fig0 , fullfile( imPath, sprintf( 'fan_%s.fig' , fanP ) ), 'fig' );
saveas( fig0 , fullfile( imPath, sprintf( 'fan_%s.fig' , fanN ) ), 'fig' );
%}

%%
thetaRot = linspace( -1 , 1 , nAngles ) * pi / 2;

thetaTest = thetaN;

ang = NaN( 3 , numel( A ) );
metric  = cell( numel( A ) , 1 );
measure = metric;
for nn = 1 : numel( A )
    [ metric{ nn } , measure{ nn } ] = testFan( ...
        A( nn ) * rotp25Fan + B( nn ) , ...
        theta , thetaRot , theta0 , thetaTest , k , sigma );
    
    [ ~ , ind ] = max( measure{ nn } , [] , 1 );
    ang( : , nn ) = thetaRot( ind );
    
    fig = figure( 'WindowStyle' , 'Normal' );
    ax  = axes( 'Parent' , fig );
    plot( thetaRot , measure{ nn } , 'Parent' , ax );
    title( ax , sprintf( ...
        'A=%d, B=%d, \\theta=(%.2f,%.2f,%.2f), \\theta_0=%.2f' , ...
        A( nn ) , B( nn ) , ang( : , nn ) , theta0 ) );
    xlabel( ax , '\theta [rad]' );
    ylabel( ax , 'Normalized Match' )
    
    legend( 'Metric 1' , 'Metric 2' , 'Metric 3' );
end

% print( fig , '-dpng' , '-r216' , ...
%     fullfile( imPath , 'exampleMatch.png' ) );
% saveas( fig , fullfile( imPath , 'exampleMatch.fig' ) , 'fig' );
































