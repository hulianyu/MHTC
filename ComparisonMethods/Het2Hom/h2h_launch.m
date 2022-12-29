
% prepare k cluster descriptors M and attribute weights W for launching h2h learning

function [modes,weights] = h2h_launch(x,pm,dis_matrix)
% M generation
modes( 1 , : ) = x( randperm( pm.n , 1 ) , 1 : pm.d );
no_initial_mode = 1;
while no_initial_mode ~= pm.k
    no_initial_mode = no_initial_mode + 1;
    modes( no_initial_mode , : ) = x( randperm( pm.n , 1 ) , 1 : pm.d );
    if sum ( sum( modes == modes( no_initial_mode , : ) , 2 ) == pm.d ) ~= 1
        no_initial_mode = no_initial_mode - 1;
    end
end
if pm.no_num_att == 0 % if x is a categorical data set, adjust M for better objects' distribution representation
    loop_stop = 0;
    no_loop=0;
    partition_old = zeros( pm.n , 1 );
    adjust_cluster=ones(1,pm.k)/pm.k;
    freq_cluster=zeros(1,pm.k);
    while loop_stop == 0 && no_loop<=50
        partition_new = zeros( pm.n , 1 );
        no_loop = no_loop + 1;
        dis_obj_modes = zeros( 1 , pm.k );
        for i = 1 : pm.n
            for j = 1 : pm.k
                dis_sub = zeros( 1 , pm.d );
                for t = 1 : pm.d-pm.no_num_att
                    if pm.no_nom_att*pm.no_ord_att~=0 % exist mixed attributes
                        if pm.pbr_rcd(t)~=0 % adjust contribution according to the number of generated sub-attributes
                            div_time=sum(pm.pbr_rcd==pm.pbr_rcd(t));
                        else
                            div_time=1;
                        end
                        dis_sub( t ) = dis_matrix{ t }( x( i , t ) , modes( j , t ) )^2/div_time;
                    else % pure case
                        dis_sub( t ) = dis_matrix{ t }( x( i , t ) , modes( j , t ) )^2;
                    end
                end
                dis_obj_modes( j ) = sum( dis_sub )*adjust_cluster(j); % penalize clusters with too many objects
            end % so as to facilitate a thorough detection of the overall objects' distribution
            [ ~ , partition_new( i ) ] = min( dis_obj_modes );
            freq_cluster(partition_new( i ))=freq_cluster(partition_new( i ))+1;
        end
        if sum( sum( abs( partition_new - partition_old ) ) ) == 0
            loop_stop = 1;
        else %update cluster descriptors
            adjust_cluster=freq_cluster/sum(freq_cluster);
            partition_old = partition_new;
            for c = 1 : pm.k
                x_sub = x( partition_new == c , : );
                if isempty( x_sub ) ==0
                    for t = 1 : pm.d
                        mode_cand_dist = zeros( 1 , pm.no_values( t ) );
                        modes_dct = zeros( 1 , pm.no_values( t ) );
                        sta = tabulate( x_sub( : , t ) );
                        sta_vct = sta( : , 3 )' / 100;
                        modes_dct( 1 : length( sta_vct ) ) = sta_vct;
                        for m = 1 : pm.no_values( t )
                            mode_cand_dist( m ) = ...
                                sum( dis_matrix{ t }( m , : ) .* modes_dct );
                        end
                        [ ~ , modes( c , t ) ] = min( mode_cand_dist );
                    end
                end
            end
        end
    end
end
% W initialization
weights=ones(1,pm.d);
if pm.no_nom_att*pm.no_ord_att~=0 || pm.no_nom_att*pm.no_num_att~=0 % for mixed data
    for i=1:max(pm.pbr_rcd)
        weights(pm.pbr_rcd==i)=weights(pm.pbr_rcd==i)/sum(weights(pm.pbr_rcd==i));
    end
    weights=weights/sum(length(pm.cw));
else % for categorical data
    weights=ones(1,pm.d)/pm.d;
end

