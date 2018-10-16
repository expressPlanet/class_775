function [ normPnts , meanPnt , rot ] = normShape( inPnts )

assert( isvector( inPnts ) );

[ x , y ] = pdm2xy( inPnts );

meanX = mean( x );
meanY = mean( y );

meanPnt = cat( 1 , meanX , meanY );

r = cat( 2 , x - meanX , y - meanY ).';

[ rot , ~ ] = eig( r * r' );
rot = fliplr( rot );

rRot = rot' * r;

normPnts = rRot( : );