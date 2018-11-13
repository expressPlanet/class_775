function dx2 = deriv2( x , sigma )

in = ( 1 : numel( x ) );
in = in( : ) - mean( in );

% exp( -x ^ 2 / 2 / sigma ^ 2 )
% -x / sigma^2 * exp( - )
% -1 / sigma^2 + x.^ 2 / sigma ^ 4 * exp( - )

dG2 = ( in .^ 2 / sigma ^ 4 - 1 / sigma ^ 2 ) .* ...
    exp( -in .^ 2 / ( 2 * sigma ^ 2 ) );

N = floor( numel( x ) / 2 ) + 1;

dG2Freq = fft( circshift( dG2 , N ) , [] , 1 );

dx2 = ifft2( fft( x( : ) ) .* dG2Freq , 'symmetric' );