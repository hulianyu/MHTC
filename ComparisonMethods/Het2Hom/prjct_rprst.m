
% 1. compute base distances (in the form of matrix) of each attribute
% 2. perform projection and output the encoded (represented) data set

function [ dis_matrix , x_coded , pm ] = prjct_rprst( x , pm )
dis_matrix_bd = bd_compute( x , pm ); % 1. compute base distances
[ x_coded, pm, dis_matrix ] = pbr( x , pm , dis_matrix_bd ); % 2. projection
end
