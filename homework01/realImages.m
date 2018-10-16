
colors = [ ...
    0.0000 , 0.4470 , 0.7410 ;
    0.8500 , 0.3250 , 0.0980 ;
    0.9290 , 0.6940 , 0.1250 ;
    0.4940 , 0.1840 , 0.5560 ;
    0.4660 , 0.6740 , 0.1880 ;
    0.3010 , 0.7450 , 0.9330 ;
    0.6350 , 0.0780 , 0.1840 ;
    0.0000 , 0.0000 , 0.0000 ];

realPath = '/home/bendecm2/Class/775/homework01/inputs/';

files = dir( realPath );
files = files( ~[ files.isdir ] );

params.sigma     = 05;
params.radius    = 25; % pixels
params.intensity = -1; % or -1 (light on dark or vice versa)
params.parzenLen = 05; % pixels
params.thresh    = 01;
params.std       = 01; % width of the "sigmoid"
% params.scale     = 01;

% Bubbles radius
ff      = 1;
radius  = [ 25 , 35 , 42 , 50 , 60 , 80 ];
numCirc = [ 02 , 03 , 03 , 01 , 03 , 01 ];
loc     = 'NorthEast';

% Circles radius
% ff      = 2;
% radius  = [ 25 , 35 , 42 , 50 , 58 , 68 , 80 , 95 ];
% numCirc = ones( numel( radius ) , 1 );
% loc     = 'NorthEast';

% Wheels radius
% ff      = 3;
% radius  = [ 20 , 60 , 95 ];
% numCirc = ones( numel( radius ) , 1 );
% loc     = 'SouthEast';

labels = cellfun( @( x ) sprintf( '%02d px' , x ) , num2cell( radius ), ...
    'UniformOutput' , false );

imag0 = imread( fullfile( realPath , files( ff ).name ) );
imag  = double( rgb2gray( imag0 ) ) / 255;

fig = figure( ...
    'WindowStyle' , 'Normal' , ...
    'Position'    , [ 50 , 50 , 512 , 384 ] , ...
    'Colormap'    , gray );
ax  = axes( 'Parent' , fig , 'Nextplot' , 'Add' );
im  = imagesc( imag , 'Parent' , ax );
im.AlphaData = 0.75;


for rr = 1 : numel( radius )
    
    params.radius = radius( rr );
    
    diskCenters = findDisks2( imag , params );
    
    nc = numCirc( rr );
    [ centersBar , diskCentersBar ] = ...
        findCenter( diskCenters , params , nc );
    
    plot( centersBar( : , 2 ) , centersBar( : , 1 ) , 'o' , ...
        'Color' , colors( rr , : ) , 'Parent' , ax );
    
end

legend( labels{ : } , 'Location' , loc );
axis( ax , 'tight' );

ax.XTickLabel = {};
ax.YTickLabel = {};

cb = colorbar( 'peer' , ax );
delete( cb );

[ ~ , name ] = fileparts( files( ff ).name );

fileName = fullfile( pwd , 'images' , 'real' , name );

print(  fig , '-r216' , '-dpng' , [ fileName , '.png' ] );
saveas( fig , [ fileName , '.fig' ] , 'fig' );





















