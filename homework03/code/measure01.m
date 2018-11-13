function val = measure01( x , xHat )

val = normxcorr2( x , xHat );

val = max( val( : ) );