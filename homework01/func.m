function x = func( x , f )

persistent nn

if isempty( nn )
    nn = 0;
end

if ( nn > 9 )
    nn = 0;
    x = f( x );
    return;
end
nn = nn + 1;

x = ( x + func( f( x ) , f ) );