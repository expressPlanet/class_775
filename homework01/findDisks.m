function [ accumulator ] = findDisks( imag , params )

pool = gcp( 'nocreate' );
numWorkers = [ pool.NumWorkers , 0 ];
numWorkers = numWorkers( 1 );

% Hardcoded error bounds
errTheta = pi / 6;

[ dImagX , dImagY ] = deriv( imag , params.sigma );

gradMag = hypot( dImagX , dImagY );
gradAng = atan2( dImagY , dImagX );

if ( params.intensity == 1 )
    % Reverse the direction of the gradient
    gradAng = gradAng + pi;
    gradAng( gradAng > pi ) = gradAng( gradAng > pi ) - 2 * pi;
else
    % Do nothing
end

gradVot = normcdf( ( gradMag - params.thresh ) / ( 2 * params.std .^ 2 ) );

theta0 = linspace( -pi , pi , 1e3 );
theta0( end ) = [];

% We're going to check many points about some radius, just in case we miss
% exactly where the circle should fall
rad = params.radius + [ -1 , 0 , 1 ].';

xPix = rad .* cos( theta0 );
yPix = rad .* sin( theta0 );

pix0 = unique( round( cat( 2 , ...
    xPix( : ) , yPix( : ) ) ) , 'rows' , 'stable' );
theta0 = atan2( pix0( : , 2 ) , pix0( : , 1 ) );
% theta gives us an idea of the direction we need for each pixel

Nx = size( imag , 1 );
Ny = size( imag , 2 );

accumulator = 0 * imag;
parfor ( xx = 1 : Nx , numWorkers )
    for yy = 1 : Ny
        
        pix = pix0 + [ xx , yy ];
        tf = ~( any( pix < 1 , 2 ) | ...
            ( pix( : , 1 ) > Nx ) | ...
            ( pix( : , 2 ) > Ny ) );
        
        theta = theta0( tf ); %#ok<PFBNS>
        pix   = pix(    tf , : );
        
        ind = sub2ind( [ Nx , Ny ] , pix( : , 1 ) , pix( : , 2 ) );
        
        voter = gradVot( ind ); %#ok<PFBNS>
        angle = gradAng( ind ); %#ok<PFBNS>
        
        canVote = ...
            ( abs( theta( : ) - angle( : ) ) <= errTheta ) | ...
            ( abs( theta( : ) - angle( : ) + 2 * pi ) <= errTheta );
        
        accumulator( xx , yy ) = mean( voter( canVote ) );
        
    end
end

accumulator = imgaussfilt( accumulator , params.parzenLen );

% TODO:
% Find the points that represent the centers of the circle
% Remove that point and all adjacent points
% Repeat
% keyboard
% diskCenters = findCenters( accumulator , numCirc );