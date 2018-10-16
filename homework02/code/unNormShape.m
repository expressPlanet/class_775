function outPnts = unNormShape( normPnts , meanPnt , rot )

assert( isvector( normPnts ) );
assert( isvector( meanPnt  ) );
assert( ismatrix( rot ) );

outPnts = rot * reshape( normPnts , 2 , [] ) + meanPnt;
outPnts = outPnts( : );