function outPnts = projShape( inPnts , meanPnts , U , lambda , clip )

assert( isreal( clip ) )
clip = abs( clip );

[ normPnts , meanPnt , rot ] = normShape( inPnts );

normPnts = normPnts - meanPnts;

eigPnts = U' * normPnts;

alpha = eigPnts ./ sqrt( lambda );
alpha( alpha < -clip ) = -clip;
alpha( alpha >  clip ) =  clip;

clipPnts = U * ( alpha .* sqrt( lambda ) );

outPnts = unNormShape( clipPnts + meanPnts , meanPnt , rot );