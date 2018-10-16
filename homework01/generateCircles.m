function [ img , center , r , inten ] = generateCircles( imSize , ...
    numCirc , radius , snr , blur , varargin )

if ( nargin == 6 )
    intensity = 1;
    xRange    = [ 1 , imSize( 1 ) ];
    yRange    = [ 1 , imSize( 2 ) ];
elseif ( nargin == 7 )
    intensity = varargin{ 1 };
    xRange    = [ 1 , imSize( 1 ) ];
    yRange    = [ 1 , imSize( 2 ) ];
elseif ( nargin == 8 )
    intensity = varargin{ 1 };
    xRange    = varargin{ 2 };
    yRange    = [ 1 , imSize( 2 ) ];
elseif ( nargin == 9 )
    intensity = varargin{ 1 };
    xRange    = varargin{ 2 };
    yRange    = varargin{ 3 };
else
    error( 'Unexpected number of inputs.' );
end

minRadius = radius( 1 );
if ( numel( radius ) == 2 )
    maxRadius = radius( 2 );
else
    maxRadius = radius( 1 );
end

minInten = intensity( 1 );
if ( numel( intensity ) == 2 )
    maxInten = intensity( 2 );
else
    maxInten = intensity( 1 );
end
inten = ( maxInten - minInten ) * rand( numCirc ) + minInten;

img = zeros( imSize , 'single' );

x = ( 1 : imSize( 1 ) );
% x = x( : ) - mean( x( : ) );

y = ( 1 : imSize( 2 ) );
% y = y( : ) - mean( y( : ) );

[ x , y ] = ndgrid( x , y );

xc = randi( xRange( 2 ) - xRange( 1 ) , numCirc , 1 ) + xRange( 1 );
yc = randi( yRange( 2 ) - yRange( 1 ) , numCirc , 1 ) + yRange( 1 );
r  = rand( numCirc , 1 ) * ( maxRadius - minRadius ) + minRadius;
for nn = 1 : numCirc
    
    % Get the radial distances centered around a random pixel
    rad = hypot( x - xc( nn ) , y - yc( nn ) );
    
    % Find all the pixels within a random range
    tf = ( rad <= r( nn ) );
    
    img( tf ) = inten( nn );
    
end

img = imgaussfilt( img , blur );

noisePower = 10 ^ ( -snr / 20 );
img = img + noisePower * randn( imSize );

center = cat( 2 , xc , yc );