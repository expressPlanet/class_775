function accumulator = findDisks2( imag , params )

sigma = ceil( params.sigma );
[ dImagX , dImagY ] = deriv( imag , sigma );

gradMag = hypot( dImagX , dImagY );
gradAng = atan2( dImagY , dImagX );

if ( params.intensity == 1 )
    % Do nothing
elseif ( params.intensity == -1 )
    % Reverse the direction of the gradient
    gradAng = gradAng + pi;
    gradAng( gradAng > pi ) = gradAng( gradAng > pi ) - 2 * pi;
else
    error( 'Bad intensity parameter.' );
end

gradVot = normcdf( ( gradMag - params.thresh ) / ( 2 * params.std .^ 2 ) );

anul = ( -sigma : sigma );
rad = params.radius + permute( anul , [ 1 , 3 , 2 ] );
% [ -1 , 0 , 1 ] allows for a little bit of slack (each pixel can count up
% to three times)

dx = round( rad .* cos( gradAng ) );
dy = round( rad .* sin( gradAng ) );

[ x , y ] = ndgrid( 1 : size( imag , 1 ) , 1 : size( imag , 2 ) );

x = x + dx;
y = y + dy;

x( x < 1 | x > size( imag , 1 ) ) = NaN;
y( y < 1 | y > size( imag , 2 ) ) = NaN;

ind = sub2ind( size( imag ) , x , y );
ind = ind( ~isnan( ind ) );

accumulator = 0 * imag;
for nn = ind( : ).'
    accumulator( nn ) = accumulator( nn ) + gradVot( nn );
end
