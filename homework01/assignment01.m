
thisPath = fileparts( mfilename( 'fullpath' ) );
% mkdir( fullfile( thisPath , 'images' ) );

imSize  = [ 512 , 512 ];       % pixels
numCirc = 03;                  % 
radRng  = [ 25 , 25 ];         % pixels
snr     = 0100;                % dB (power)
blur    = 05;                  % pixels
intRng  = [ -1 , -1. ];        % Relative (zero centric)
xRng    = [ 1 , imSize( 1 ) ]; % pixels
yRng    = [ 1 , imSize( 2 ) ]; % pixels


% imag = double( imread( 'pout.tif' ) );
[ imag , centers , radii ] = generateCircles( ...
    imSize , numCirc , radRng , snr , blur , intRng , xRng , yRng );

[ dImagX , dImagY ] = deriv( imag , 5 );

params.sigma     = 05; 
params.radius    = 25; % pixels
params.intensity = -1; % or -1 (light on dark or vice versa)
params.parzenLen = 05; % pixels
params.thresh    = 01; 
params.std       = 01; % width of the "sigmoid"
params.scale     = 01; 

figure( 'Colormap' , gray );
ax( 1 , 1 ) = subplot( 2 , 2 , 1 );
imagesc( imag );
title( ax( 1 , 1 ) , 'Input' );

ax( 2 , 1 ) = subplot( 2 , 2 , 3 );
imagesc( dImagX );
title( ax( 2 , 1 ) , 'x-Derivative' );

ax( 2 , 2 ) = subplot( 2 , 2 , 4 );
imagesc( dImagY );
title( ax( 2 , 2 ) , 'y-Derivative' );


diskCenters = findDisks2( imag , params );

ax( 1 , 2 ) = subplot( 2 , 2 , 2 );
hold all
im = imagesc( diskCenters );
title( ax( 1 , 2 ) , 'Output + Truth' );

plot( centers( : , 2 ) , centers( : , 1 ) , 'm o' , ...
    'Parent' , ax( 1 , 2 ) );

tmp = axis( ax( 1 , 1 ) );
axis( ax( 1 , 2 ) , tmp );
axis( ax( 1 , 2 ) , 'ij' );

[ centersBar , diskCentersBar ] = findCenter( ...
    diskCenters , params , numCirc );

plot( centersBar( : , 2 ) , centersBar( : , 1 ) , 'c x' , ...
    'Parent' , ax( 1 , 2 ) );

plot( centersBar( : , 2 ) , centersBar( : , 1 ) , 'c x' , ...
    'Parent' , ax( 1 , 1 ) );


%%


params.sigma     = 05; 
params.radius    = 25; % pixels
params.intensity = 01; % or -1 (light on dark or vice versa)
params.parzenLen = 05; % pixels
params.thresh    = 01; 
params.std       = 01; % width of the "sigmoid"
params.scale     = 01; 


imSize  = [ 512 , 512 ];           % pixels
radRng  = [ 25 , 25 ];             % pixels
intRng  = [ 1.0 , 1.0 ];           % Relative (zero centric)
r       = 2 * max( radRng );
xRng    = [ r , imSize( 1 ) - r ]; % pixels
yRng    = [ r , imSize( 2 ) - r ]; % pixels

numCirc = [ 1 , 3 , 7 , 13 , 17 ]; % 
snr     = [ -20 , 00 , 20 , 60 ];  % dB (power)
blur    = [ 01 , 07 , 15 , 25 ];   % pixels

[ circg , snrg , blurg ] = ndgrid( numCirc , snr , blur );


for nn = 1 : numel( circg )
    
    if ( snrg( nn ) < 0 )
        s = sprintf( '-%02d' , abs( snrg( nn ) ) );
    else
        s = sprintf( '%02d' , abs( snrg( nn ) ) );
    end
    
    fileName = fullfile( thisPath , 'images' , ...
        sprintf( 'output_n%02d_s%s_b%02d' , ...
        circg( nn ) , s , blurg( nn ) ) );
    
    if exist( [ fileName , '.png' ] , 'file' ) && ...
            exist( [ fileName , '.fig' ] , 'file' )
        continue;
    end
    
    [ imag , centers , radii ] = generateCircles( ...
        imSize , circg( nn ) , radRng , snrg( nn ) , blurg( nn ) , ...
        intRng , xRng , yRng );
    
    diskCenters = findDisks2( imag , params );
    centersBar  = findCenter( diskCenters , params , circg( nn ) );
    
    fig = figure( ...
        'WindowStyle' , 'Normal' , ...
        'Position'    , [ 50 , 50 , 512 , 384 ] , ...
        'Colormap'    , gray );
    ax  = axes( 'Parent' , fig );
    im  = imagesc( imag' , 'Parent' , ax );
    
    cb = colorbar( 'peer' , ax );
    delete( cb );
    
    pl( 1 ) = plot( centers( : , 1 ) , centers( : , 2 ) , 'm o' , ...
        'Parent' , ax );
    pl( 2 ) = plot( centersBar( : , 1 ) , centersBar( : , 2 ) , 'c x' , ...
        'Parent' , ax );
    
    err = sqrt( mean( min( sum( ( centers - permute( ...
        centersBar , [ 3 , 2 , 1 ] ) ) .^ 2 , 2 ) , [] , 3 ) , 1 ) );
    
    title( ax , sprintf( ...
        'NumCirc: %02d SNR: %s Blur: %02d\nPixel Error=%.1f' , ...
        circg( nn ) , s , blurg( nn ) , err ) );
    
    print( fig , '-r216' , '-dpng' , [ fileName , '.png' ] );
    saveas( fig , [ fileName , '.fig' ] , 'fig' );
    close( fig );
    
    pause( 1.0 );
end










