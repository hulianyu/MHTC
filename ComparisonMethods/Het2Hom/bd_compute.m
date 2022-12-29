
% base distance computation

function dis_matrix = bd_compute( x , pm )
% initialize distance matrix for each categorical attribute
dis_matrix = cell( 1 , pm.d - pm.no_num_att ); 
for t = 1 : pm.d - pm.no_num_att 
    dis_matrix{ t } = zeros( pm.no_values( t ) ); 
end
% prepare conditional probability distributions (cpds) 
cpd = cell( 1 , pm.d - pm.no_num_att ); 
for t = 1 : pm.d - pm.no_num_att % for each categorical attribute a^t
    cpd{ t } = cell( pm.no_values( t ) , pm.d );
    for m = 1 : pm.no_values( t ) % for each possible value of a^t
        locate_x_tm = x( : , t ) == m; 
        no_x_tm = sum( locate_x_tm );
        for r = 1 : pm.d - pm.no_num_att % if a^r is a categorical attribute
            cpd{ t }{ m , r } = zeros( 1 , pm.no_values( r ) );
            for g = 1 : pm.no_values( r ) % for each possible value of a^r
                cpd{ t }{ m , r } ( g ) = sum( x( locate_x_tm , r ) == g );
            end
            cpd{ t }{ m , r } = cpd{ t }{ m , r } / no_x_tm;
        end
        for r = pm.d - pm.no_num_att + 1 : pm.d % if a^r is a numerical attribute
            cpd{ t }{ m , r } = zeros( 1 , 5 ); % divide into 5 intervals for obtain cpds
            for s = [ 0.2, 0.4, 0.6, 0.8 ] % the more the intervals, the more reasonable, set 5 here to balance the efficiency
                cpd{ t }{ m , r }( s * 5 ) = sum( ( x( locate_x_tm , r ) >= s - 0.2 ) .* ( x( locate_x_tm , r ) < s ) );
            end
            cpd{ t }{ m , r }( 5 ) = no_x_tm - sum( cpd{ t }{ m , r } );
            cpd{ t }{ m , r } = cpd{ t }{ m , r } / no_x_tm;
        end
    end
end
% compute distance matrix for a nominal a^t
for t = 1 : pm.no_nom_att 
    for m = 1 : pm.no_values( t ) - 1
        for h = m + 1 : pm.no_values( t )
            cost_relate = zeros( 1 , pm.d );
            for r = 1 : pm.no_nom_att % nominal case
                diff_relate = cpd{ t }{ h , r } - cpd{ t }{ m , r };
                cost_relate( r ) = sum( abs( diff_relate ) ) / 2;
            end
            for r = pm.no_nom_att + 1 : pm.d - pm.no_num_att % ordinal case
                diff_relate = cpd{ t }{ h , r } - cpd{ t }{ m , r };
                for s = 1 : pm.no_values( r ) - 1
                    cost_relate( r ) = cost_relate( r ) + abs( diff_relate( s ) );
                    diff_relate( s + 1 ) = diff_relate( s ) + diff_relate( s + 1 );
                end
                cost_relate( r ) = cost_relate( r ) / ( pm.no_values( r ) - 1 );
            end
            for r = pm.d - pm.no_num_att + 1 : pm.d % numerical case
                diff_relate = cpd{ t }{ h , r } - cpd{ t }{ m , r };
                for s = 1 : 4
                    cost_relate( r ) = cost_relate( r ) + abs( diff_relate( s ) );
                    diff_relate( s + 1 ) = diff_relate( s ) + diff_relate( s + 1 );
                end
                cost_relate( r ) = cost_relate( r ) / 4;
            end
            dis_matrix{ t }( m , h ) = mean( cost_relate );
            dis_matrix{ t }( h , m ) = dis_matrix{ t }( m , h );
        end
    end
end
% compute distance matrix for an ordinal a^t
for t = pm.no_nom_att + 1 : pm.d - pm.no_num_att 
    dist_vct = zeros( 1 , pm.no_values( t ) - 1 ); % store ordinal distances in a vector form
    for m = 1 : pm.no_values( t ) - 1
        cost_relate = zeros( 1 , pm.d );
        for r = 1 : pm.no_nom_att % nominal case
            diff_relate = cpd{ t }{ m + 1 , r } - cpd{ t }{ m , r };
            cost_relate( r ) = ( sum( abs( diff_relate ) ) / 2 );
        end
        for r = pm.no_nom_att + 1 : pm.d - pm.no_num_att % ordinal case
            diff_relate = cpd{ t }{ m + 1 , r } - cpd{ t }{ m , r };
            for s = 1 : pm.no_values( r ) - 1
                cost_relate( r ) = cost_relate( r ) + abs( diff_relate( s ) );
                diff_relate( s + 1 ) = diff_relate( s ) + diff_relate( s + 1 );
            end
            cost_relate( r ) = cost_relate( r ) / ( pm.no_values( r ) - 1 );
        end
        for r = pm.d - pm.no_num_att + 1 : pm.d % numerical case
            diff_relate = cpd{ t }{ m + 1 , r } - cpd{ t }{ m , r };
            for s = 1 : 4
                cost_relate( r ) = cost_relate( r ) + abs( diff_relate( s ) );
                diff_relate( s + 1 ) = diff_relate( s ) + diff_relate( s + 1 );
            end
            cost_relate( r ) = cost_relate( r ) / 4;
        end
        dist_vct( m ) = mean( cost_relate );
    end
    for m = 1 : pm.no_values( t ) - 1 % convert vector form into matrix form
        for h = m + 1 : pm.no_values( t )
            dis_matrix{ t }( m , h ) = sum( dist_vct( m : h - 1 ) );
            dis_matrix{ t }( h , m ) = dis_matrix{ t }( m , h );
        end
    end
    dis_matrix{ t } = dis_matrix{ t } / max( max( dis_matrix{ t } ) );
end
















