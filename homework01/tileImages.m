

thisPath = fileparts( mfilename( 'fullpath' ) );

numCirc = [ 1 , 3 , 7 , 13 , 17 ]; % 
snr     = [ -20 , 00 , 20 , 60 ];  % dB (power)
blur    = [ 01 , 07 , 15 , 25 ];   % pixels

[ circg , snrg , blurg ] = ndgrid( numCirc , snr , blur );

fig = figure( ...
    'WindowStyle' , 'Normal' , ...
    'Position'    , [ 30 , 58 , 1777 , 879 ] , ...
    'ColorMap'    , gray );

cnt = 1;
imNum = 1;
for nn = 1 : numel( circg )
    
    if ( snrg( nn ) < 0 )
        s = sprintf( '-%02d' , abs( snrg( nn ) ) );
    else
        s = sprintf( '%02d' , abs( snrg( nn ) ) );
    end
    
    fileName = fullfile( thisPath , 'images' , ...
        sprintf( 'output_n%02d_s%s_b%02d' , ...
        circg( nn ) , s , blurg( nn ) ) );
    
    uiopen( [ fileName , '.fig' ] , 1 );
    pause( 0.1 );
    ax0 = gca;
    
    ax = subplot( 4 , 5 , cnt , 'Parent' , fig );
    axis( ax , 'tight' );
    axis( ax , 'ij' );
    
    ax.XTickLabel = {};
    ax.YTickLabel = {};
    
    ax.Title.String = ax0.Title.String{ 2 };
    if ( mod( cnt , 5 ) == 1 )
        n = snr( ceil( cnt / 5 ) );
        if ( n < 0 )
            s = sprintf( '-%02d' , abs( n ) );
        else
            s = sprintf( '%02d' , abs( n ) );
        end
        ylabel( ax , sprintf( 'SNR: %s' , s ) );
    end
    
    copyobj( ax0.Children , ax );
    delete( ax0.Parent );
    
    if ( cnt == 20 )
        fName = sprintf( 'tiledBlur%02d' , blur( imNum ) );
        
        print( fig , '-dpng' , '-r216' , fullfile( thisPath , ...
            'images' , [ fName , '.png' ] ) );
        saveas( fig , fullfile( thisPath , ...
            'images' , [ fName , '.fig' ] ) , 'fig' );
        
        imNum = imNum + 1;
        cnt = 0;
    end
    
    cnt = cnt + 1;
end
