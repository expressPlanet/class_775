function val = measure03( x , xHat )

ii = 1 : 128;
M = 0;

x = x - min( x( : ) );
x = x / max( x( : ) );

xHat = xHat - min( xHat( : ) );
xHat = xHat / max( xHat( : ) );

%{
x = x - mean( x( : ) );
x = x / max( abs( x( : ) ) );

xHat = xHat - mean( xHat( : ) );
xHat = xHat / max( abs( xHat( : ) ) );
%}

tmp = x( ii > M , ii > M );
xSort = sort( tmp( : ) );

tmp = xHat( ii > M , ii > M );
xHatSort = sort( tmp( : ) );

% val = mean( abs( xSort - xHatSort ) .^ 2 );

% return
sc = [ 
    0.47046721 , ...
    1.14111692 , ...
    0.65036500 , ...
    -0.19093442 , ...
    -0.12083221 , ...
    0.0498175 ].' / 2;

wv = flipud( sc );
wv( 2 : 2 : end ) = -wv( 2 : 2 : end );

val = 0;

y    = x    / max( abs( x( : ) ) );
yHat = xHat / max( abs( x( : ) ) );
for nn = 1 : 4 % just use 4 scales
    
    [ val0 , y , yHat ] = xform( y , yHat , sc , wv );
    val = val + val0;
    
end


%% ------------------------------------------------------------------------
function [ err , y , yHat ] = xform( x , xHat , sc , wv )

xFreq    = fft2( x );
xHatFreq = fft2( xHat );

scFreq = fft2( sc , size( x , 1 ) , size( x , 2 ) );
wvFreq = fft2( wv , size( x , 1 ) , size( x , 2 ) );

[ ~ , y , yHat ] = check( xFreq , xHatFreq , scFreq , scFreq.' );

err0 = check( xFreq , xHatFreq , scFreq , wvFreq.' );
err = err0;
err0 = check( xFreq , xHatFreq , wvFreq , scFreq.' );
err = err + err0;
err0 = check( xFreq , xHatFreq , wvFreq , wvFreq.' );
err = err + err0;

% y    = ifft2( y    , 'symmetric' );
% yHat = ifft2( yHat , 'symmetric' );

y    = y(    1 : 2 : end , 1 : 2 : end );
yHat = yHat( 1 : 2 : end , 1 : 2 : end );


%% ------------------------------------------------------------------------
function [ err , y , yHat ] = check( xF , xHatF , f01 , f02 )


y    = ifft2( xF    .* ( f01 .* f02 ) , 'symmetric' );
yHat = ifft2( xHatF .* ( f01 .* f02 ) , 'symmetric' );

yT = y - min( y );
yT = yT ./ max( yT( : ) );

yHt = yHat - min( yHat );
yHt = yHt ./ max( yHt( : ) );

yPrc    = prctile( yT( : )  , ( 10 : 10 : 90 ) );
yHatPrc = prctile( yHt( : ) , ( 10 : 10 : 90 ) );

err = mean( abs( yPrc( : ) - yHatPrc( : ) ) .^ 2 );
