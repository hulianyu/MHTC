
% implement Het2Hom learning

function ptt_new = h2h_learn( x, pm, dis_mtx )

[modes,weights] = h2h_launch(x,pm,dis_mtx); % M and W in the paper
eta=0.05/pm.n; % \eta in the paper
error=zeros(1,5000); % value of objective function
theta=0; % \theta in the paper
no_iter=0; % number of iteration
is_conv = 0; % convergence indicator
ptt_new=zeros( pm.n , 1 ); % partition result
while is_conv==0
    loop_stop = 0;
    no_loop=0;
    ptt_old = zeros( pm.n , 1 ); % partition result, used for judging convergence
    while loop_stop == 0
        no_iter=no_iter+1;
        ptt_new = zeros( pm.n , 1 );
        no_loop = no_loop + 1;
        dis_obj_modes = zeros( 1 , pm.k );
        for i = 1 : pm.n % fix W and M, compute Q
            for j = 1 : pm.k
                dis_sub = zeros( 1 , pm.d );
                for t = 1 : pm.d - pm.no_num_att
                    dis_sub( t ) = dis_mtx{ t }( x( i , t ) , modes( j , t ) );
                end
                for t = pm.d - pm.no_num_att + 1 : pm.d
                    dis_sub( t ) = abs( x( i , t ) - modes( j , t ) );
                end
                % dis_obj_modes( j ) = sum( dis_sub .* weights); % for pure categorical case
                dis_obj_modes( j ) = sum( dis_sub .^2 .* weights); % for mixed case with numerical attributes
            end
            [ error_sub , ptt_new( i ) ] = min( dis_obj_modes );
            error(no_iter)=error(no_iter)+error_sub;
        end
        if sum( sum( abs( ptt_new - ptt_old ) ) ) == 0
            loop_stop = 1;
        else % fix W and Q, compute M
            ptt_old = ptt_new;
            for c = 1 : pm.k
                x_sub = x( ptt_new == c , : );
                if isempty( x_sub ) ==0
                    for t = 1 : pm.d - pm.no_num_att % compute on nominal and ordinal attributes
                        mode_cand_dist = zeros( 1 , pm.no_values( t ) );
                        modes_dct = zeros( 1 , pm.no_values( t ) );
                        sta = tabulate( x_sub( : , t ) );
                        sta_vct = sta( : , 3 )' / 100;
                        modes_dct( 1 : length( sta_vct ) ) = sta_vct;
                        for m = 1 : pm.no_values( t )
                            mode_cand_dist( m ) = ...
                                sum( dis_mtx{ t }( m , : ) .* modes_dct );
                        end
                        [ ~ , modes( c , t ) ] = min( mode_cand_dist );
                    end
                    modes( c , pm.d - pm.no_num_att + 1 : pm.d ) = ... % compute on numerical attributes
                        mean( x_sub( : , pm.d - pm.no_num_att + 1 : pm.d ) );
                end
            end
        end
    end
    % fix W and Q, compute W
    err_ct=zeros(pm.d,pm.k); % error counter, a matrix recording the error caused by different attributes and clusters
    for i=1:pm.n
        for j=1:pm.d-pm.no_num_att
            err_ct(j,ptt_new(i)) = err_ct(j,ptt_new(i))+dis_mtx{j}(x( i , j ),modes( ptt_new(i) , j ))^2;
        end
        for j=pm.d-pm.no_num_att+1:pm.d
            err_ct(j,ptt_new(i)) = err_ct(j,ptt_new(i))+(x( i , j )-modes( ptt_new(i) , j ))^2;
        end
    end
    err_ct_att=sum(err_ct,2); % attribute-wise error counter, denominator of Eq.(10) in the paper
    err_sim=zeros(pm.d,1); % similarity between the present weight and the rest in terms of contributed error
    for i=1:max(pm.pbr_rcd) % for each newly generated group of sub-attributes
        wt_list=find(pm.pbr_rcd==i); % list of weights attending selection
        err_ct(wt_list,:)=err_ct(wt_list,:)./sum(err_ct(wt_list,:));
        for j=1:length(wt_list) % for each weights attending selection
            err_sim(wt_list(j))=sum(sum(abs(err_ct(wt_list,:)-err_ct(wt_list(j),:))));
        end
    end    
    wt_slct=(err_sim./err_ct_att)'; % obtain weight selector
    for i=1:max(pm.pbr_rcd)
        wt_list=find(pm.pbr_rcd==i);
        [~,b]=min(wt_slct(wt_list));
        wt_list(b)=[];
        err_ct_att(wt_list)=0;
    end
    weights_change=err_ct_att'*eta;
    weights=max(weights-weights_change,0);
    weights(pm.pbr_rcd==0)=1/sum(length(pm.cw));
    for i=1:max(pm.pbr_rcd)
        weights(pm.pbr_rcd==i)=(weights(pm.pbr_rcd==i)/sum(weights(pm.pbr_rcd==i)))/sum(length(pm.cw));
    end
    if abs(theta-error(no_iter))/theta<0.001
        is_conv = 1;
    else
        theta=error(no_iter);
    end
end
end
