function [ sortedPnts , ind ] = pdmSort( pnts )

% This method is not guaranteed to work and is slow but is easy to
% implement
% If the points are spaced too far apart relative to the object thickness,
% the algorithm will break

[ x , y ] = pdm2xy( pnts );
ind = NaN * x;

for nn = 1 : size( x , 2 )
    
    [ x( : , nn ) , y( : , nn ) , ind( : , nn ) ] = ...
        sortEx( x( : , nn ) , y( : , nn ) );
    
end

sortedPnts = xy2pdm( x , y );


%% ------------------------------------------------------------------------
function [ xs , ys , ind ] = sortEx( x , y )

ind = NaN * x;

xs = NaN * x;
ys = xs;

[ ys( 1 ) , ind( 1 ) ] = max( y );
xs( 1 ) = x( ind( 1 ) );

x( ind( 1 ) ) = inf;
y( ind( 1 ) ) = inf;

tmpX = x - xs( 1 );
tmpX( tmpX < 0 ) = inf;

[ ~ , ind( 2 ) ] = min( hypot( tmpX , y - ys( 1 ) ) );

xs( 2 ) = x( ind( 2 ) );
ys( 2 ) = y( ind( 2 ) );

x( ind( 2 ) ) = inf;
y( ind( 2 ) ) = inf;
for mm = 3 : numel( x )
    
    r = hypot( x - xs( mm-1 ) , y - ys( mm-1 ) );
    [ ~ , ind0 ] = min( r );
    ind( mm ) = ind0;
    
    xs( mm ) = x( ind0 );
    x( ind0 ) = inf;
    
    ys( mm ) = y( ind0 );
    y( ind0 ) = inf;
end

% We were doing this in place with reduced list sizes but we couldn't
% easily track the indices