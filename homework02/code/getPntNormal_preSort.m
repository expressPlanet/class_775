function pntNormal = getPntNormal( pnts )

[ pnts , sInd ] = pdmSort( pnts );

[ x , y ] = pdm2xy( pnts );

filt = fft( [ 1 , 0 , -1 ].' / 2 , size( x , 1 ) , 1 );
% This is the average of the filter on both sides

xDiff = ifft( fft( x , size( x , 1 ) , 1 ) .* filt , [] , 1 , 'symmetric' );
yDiff = ifft( fft( y , size( x , 1 ) , 1 ) .* filt , [] , 1 , 'symmetric' );

xDiff = circshift( xDiff , -1 );
yDiff = circshift( yDiff , -1 );

for nn = 1 : size( xDiff , 2 )
    xDiff( sInd( : , nn ) , nn ) = xDiff( : , nn );
    yDiff( sInd( : , nn ) , nn ) = yDiff( : , nn );
end

mag = hypot( xDiff , yDiff );
pntNormal = cat( 2 , ...
    permute( -yDiff , [ 1 , 3 , 2 ] ) , ...
    permute(  xDiff , [ 1 , 3 , 2 ] ) ) ./ permute( mag , [ 1 , 3 , 2 ] );


