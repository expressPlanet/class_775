function [ dImagX , dImagY ] = derivGrey( testInt , sigma )

testInt = double( testInt );

dImagX = testInt;
dImagY = testInt;

for mm = 1 : size( testInt , 3 )
    [ dImagX( : , : , mm ) , dImagY( : , : , mm ) ] = ...
        deriv( testInt( : , : , mm ) , sigma );
end