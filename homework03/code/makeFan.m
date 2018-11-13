function fan = makeFan( theta , theta0 , k , sigma )

theta = ( theta - theta0 );
fan = cos( k * theta ) ./ ( 1 + abs( theta ) ) .^ 2;
% With this equation, we are double counting radians...

if ( sigma > 0 )
    fan = imgaussfilt( fan , sigma );
end