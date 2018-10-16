function [ r , imag ] = findCenter( imag , params , numCirc )


if ( numCirc < 1 )
    r = zeros( 0 , 2 , 'like' , imag );
    return;
end

[ ~ , i ]   = max( imag( : ) );
[ xi , yi ] = ind2sub( size( imag ) , i );
r0          = [ xi , yi ];
[ xg , yg ] = ndgrid( 1 : size( imag , 1 ) , 1 : size( imag , 2 ) );

stamp = ( hypot( xg - xi , yg - yi ) < params.radius );
imag( stamp ) = 0;

[ r , imag ] = findCenter( imag , params , numCirc - 1 );

r = cat( 1 , r0 , r );