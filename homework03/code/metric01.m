function val = metric01( y , thetaRot , thetaTrue , ~ )

% Find the index of the maximum
[ ~ , ind ] = max( y( : ) );

% Compare that angle to the true angle
val = thetaRot( ind ) - thetaTrue;