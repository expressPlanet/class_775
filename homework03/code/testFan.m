function [ metric , measure ] = testFan( targetFan , theta , ...
    thetaRot , thetaTrue , thetaTest , k , sigma )

pool = gcp( 'nocreate' );
numWorkers = [ pool.NumWorkers , 0 ];
numWorkers = numWorkers( 1 );

measure = NaN( numel( thetaRot ) , 3 , 'like' , targetFan );
parfor ( tt = 1 : numel( thetaRot ) , numWorkers )
% for tt = 1 : numel( thetaRot )
    testFan = makeFan( theta , thetaRot( tt ) , k , sigma );
    
    measure( tt , : ) = cat( 2 , ...
        measure01( targetFan , testFan ) , ...
        measure02( targetFan , testFan ) , ...
        measure03( targetFan , testFan ) );
    
end

measure( : , 2 ) = measure( : , 2 ) / max( measure( : , 2 ) );
measure( : , 3 ) = 1 - measure( : , 3 ) / max( measure( : , 3 ) );

metric = NaN( 3 , 3 , 'like' , measure );
for nn = 1 : 3
    
    metric( 1 , nn ) = metric01( measure( : , nn ) , thetaRot , ...
        thetaTrue , thetaTest );
    metric( 2 , nn ) = metric02( measure( : , nn ) , thetaRot , ...
        thetaTrue , thetaTest );
    metric( 3 , nn ) = metric03( measure( : , nn ) , thetaRot , ...
        thetaTrue , thetaTest );
    
end
