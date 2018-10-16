function [ x , y ] = pdm2xy( pnts )

if isvector( pnts )
    pnts = pnts( : );
end

x = pnts( 1 : 2 : end , : );
y = pnts( 2 : 2 : end , : );
