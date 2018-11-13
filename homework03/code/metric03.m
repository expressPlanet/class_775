function val = metric03( y , thetaRot , thetaTrue , ~ )


dy2 = deriv2( y , 0.02 * numel( y ) ); % use a std = 2% of the data
[ ~ , ind ] = min( abs( thetaRot - thetaTrue ) );

val = -dy2( ind );