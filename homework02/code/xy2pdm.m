function pdm = xy2pdm( x , y )

pdm = zeros( 2 * size( x , 1 ) , size( x , 2 ) );
pdm( 1 : 2 : end , : ) = x;
pdm( 2 : 2 : end , : ) = y;