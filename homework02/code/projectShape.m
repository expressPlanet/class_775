function [ testPntsN , aN ] = projectShape( testPnts , U , lambda , clip )

assert( isreal( clip ) );

clip = abs( clip );

% Project the data into the subspace and clip the coefficients
aN = U' * testPnts ./ sqrt( lambda );
aN( aN < -clip ) = -clip;
aN( aN >  clip ) =  clip;

% Project the subspace back into the original space
testPntsN = U * ( aN .* sqrt( lambda ) );