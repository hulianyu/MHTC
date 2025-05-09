function pi = Het2Hom_Clustering(X,K,nominal_num,ordinal_num)
% seed_fixed_at = 999; % fix seed point at 999 to ensure reproducibility
pm.no_nom_att = nominal_num;
pm.no_ord_att = ordinal_num; % the number of ordinal attribute, the default value is half of all attributes
pm.no_num_att = 0;
[ pm.n , pm.d ] = size( X );
pm.k = K;
pm.no_values=[];
for t = 1 : pm.d
    pm.no_values( t ) = length( unique( X( : , t ) ) );
end
% rand( 'seed' , seed_fixed_at );
[ dis_matrix , x_coded , pm ] = prjct_rprst( X , pm );
pi = h2h_learn( x_coded, pm, dis_matrix );
end
