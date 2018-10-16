function plotPdm( pnts )

[ x , y ] = pdm2xy( pnts );
for nn = 1 : size( pnts , 2 )
    
    figure;
    plot( x( : , nn ) , y( : , nn ) );
end