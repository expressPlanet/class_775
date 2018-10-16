function [ dImX , dImY ] = deriv( im , sigma )

x = ( 1 : size( im , 1 ) );
x = x( : ) - mean( x );

y = ( 1 : size( im , 2 ) );
y = y( : ) - mean( y );

dGaussX = ( -x / sigma .^ 2 ) .* exp( -x .^ 2 / ( 2 * sigma ^ 2 ) );
dGaussY = ( -y / sigma .^ 2 ) .* exp( -y .^ 2 / ( 2 * sigma ^ 2 ) );

imF = fft2( im );

% Overkill to get in and check phasing
Nx = floor( numel( x ) / 2 );
Ny = floor( numel( y ) / 2 );

dGaussXFreq = fft( circshift( dGaussX , Nx ) , [] , 1 );
dGaussYFreq = fft( circshift( dGaussY , Ny ) , [] , 1 );

dImX = ifft2( imF .* dGaussXFreq   );
dImY = ifft2( imF .* dGaussYFreq.' );