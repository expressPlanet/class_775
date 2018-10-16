function [ xc , yc ] = estimateCenter( testInt , thresh01 , thresh02 )


xc = NaN( 1 , size( testInt , 3 ) );
yc = xc;

for nn = 1 : size( testInt , 3 )
    tmp = testInt( : , : , nn );
    
    tmp( tmp <  thresh01 ) = 0;
    tmp( tmp >= thresh02 ) = 0;
    tmp( tmp ~= 0 ) = 1;
    
    [ i , j ] = find( medfilt2( tmp , [ 3 , 3 ] ) );
    
    xc( nn ) = mean( j );
    yc( nn ) = mean( i );
end