function varargout = splitSet( per , varargin )
% [ train01 , test01 , train02 , test02 , ... ] = splitSet( per , set01 ,
%   set02 , ... )
% Randomly split each data set into a training and test set with a training
% set percentage given by per (rounded to the nearest sample). The rounding
% is forced to insure that at least one sample exists in both training and
% testinig.

% Basic checks
assert( nargin > 0 , ...
    'BadNum' , ...
    'Must pass in at least one data set to split.' );
assert( isnumeric( per ) && isreal( per ) && ... % right type
    ( per > 0 ) && ( per < 1 ) , ...             % right range
    'BadTypeValues' , ...
    'Percentage must be a real number between 0 and 1.' );

% Get the number of samples in testing
dataSize = size( varargin{ 1 } , 2 );
T = round( per * dataSize );
T( T == 0 ) = 1;
T( T == dataSize ) = dataSize - 1;

% Generate the random sampling indices
ind = randperm( dataSize );
indTest  = ind( 1 : T );
indTrain = ind( T+1 : end );

% Preallocate the output
varargout = cell( 2 * ( nargin-1 ) , 1 );
for nn = 1 : nargin-1 % loop over data sets
    
    % Split each input the same way
    varargout{ 2*nn-1 } = varargin{ nn }( : , indTest  );
    varargout{ 2*nn   } = varargin{ nn }( : , indTrain );
    
end % loop over data sets (nn)

