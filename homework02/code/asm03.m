function [ x0 , y0 ] = asm03( pnts , img , ...
    trainMean , U , lambda , sigma , clip )


[ dImgY , dImgX ] = derivGrey( img , sigma );

N = 5;
shift = ( -N : N );
[ xg , yg ] = ndgrid( ...
    ( 1 : size( dImgX , 1 ) ) , ...
    ( 1 : size( dImgX , 2 ) ) );

% Build the interpolants
gIntX = griddedInterpolant( ...
    xg , ...
    yg , ...
    dImgX , ...
    'linear' , ...
    'nearest' );
gIntY = griddedInterpolant( ...
    xg , ...
    yg , ...
    dImgY , ...
    'linear' , ...
    'nearest' );

[ xShift , yShift ] = ndgrid( shift , shift );
xShift = xShift( : ).';
yShift = yShift( : ).';

% xShift = shift;
% yShift = shift;

[ x0 , y0 ] = pdm2xy( pnts );
for ii = 1 : 10
    
    pntDir = getPntNormal( pnts );
    
    x = x0 + pntDir( : , 1 ) * xShift;
    y = y0 + pntDir( : , 2 ) * yShift;
    
    dx = gIntX( y , x );
    dy = gIntY( y , x );
    
    mag = dx .* pntDir( : , 1 ) + dy .* pntDir( : , 2 );
    
    [ ~ , ind ] = max( -mag , [] , 2 );
    
    x1 = x0;
    y1 = y0;
    for nn = 1 : size( x0 )
        x1( nn ) = ( x0( nn ) + x( nn , ind( nn ) ) ) / 2;
        y1( nn ) = ( y0( nn ) + y( nn , ind( nn ) ) ) / 2;
    end
    
    plot( x1 , y1 , 'm .' );
    pnts = projShape( xy2pdm( x1 , y1 ) , trainMean , U , lambda , clip );
    
    x0 = x1;
    y0 = y1;
    
%     [ x0 , y0 ] = pdm2xy( pnts );
%     x0 = ( x0 + x1 ) / 2;
%     y0 = ( y0 + y1 ) / 2;
    
    
end



































