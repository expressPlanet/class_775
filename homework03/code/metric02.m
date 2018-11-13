function val = metric02( y , thetaRot , thetaTrue , thetaTest )

[ ~ , trueInd ] = min( abs( thetaRot - thetaTrue ) );
[ ~ , testInd ] = min( abs( thetaRot - thetaTest ) );

% The metric is the difference between the two values at the true and test
% location
val = ( y( testInd ) - y( trueInd ) ) / y( trueInd );

% TODO:
% Should we really be doing this based on knowing the truth and knowing the
% test angles?
% Or, should we find the first max and then the next max?