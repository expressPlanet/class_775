function [ x0 , y0 ] = asm( testImg , center0 , U , ...
    lambda , sigma )

[ dImgX , dImgY ] = derivGrey( testImg , sigma );

N = 5;
clip  = 2.5;
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

[ x0 , y0 ] = pdm2xy( center0 );
for ii = 1 : 50
    
    pntNormal = getPntNormal( xy2pdm( x0 , y0 ) );
    
    x = x0 + pntNormal( : , 1 ) * xShift;
    y = y0 + pntNormal( : , 2 ) * yShift;
    
    dx = gIntX( x , y );
    dy = gIntY( x , y );
    
    mag = -dy .* pntNormal( : , 1 ) + dx .* pntNormal( : , 2 );
    
    [ ~ , ind ] = max( -mag , [] , 2 );
    
    for nn = 1 : size( x0 )
        x0( nn ) = ( x0( nn ) + x( nn , ind( nn ) ) ) / 2;
        y0( nn ) = ( y0( nn ) + y( nn , ind( nn ) ) ) / 2;
    end
    
    meanX = mean( x0 );
    meanY = mean( y0 );
    
    x0 = x0 - meanX;
    y0 = y0 - meanY;
    
    d = cat( 2 , x0 , y0 ).';
    [ rot , ~ ] = eig( d * d' );
    dRot = -rot' * d;
    
    x0 = dRot( 2 , : ).';
    y0 = dRot( 1 , : ).';
    
    pnts0 = xy2pdm( x0 , y0 );
    pnts0 = projectShape( pnts0 , U , lambda , clip );
    
%     [ x0 , y0 ] = pdm2xy( pnts0 );
    
    d = reshape( pnts0 , 2 , [] );
    dRot = -rot * d;
    
    x0 = dRot( 2 , : ).';
    y0 = dRot( 1 , : ).';
    
    x0 = x0 + meanX;
    y0 = y0 + meanY;
    
    plot( x0 , y0 , 'm o' )
end
