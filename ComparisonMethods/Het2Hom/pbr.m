
% projection-based representation (pbr)

function [x_coded,pm,dis_mtx] = pbr(x,pm,bd_mtx)

% projection preparation
pm.cw=zeros(1,pm.d); % obtain a vector containing the maximum bd dists of each attribute
for i=1:pm.no_nom_att
    pm.cw(i)=max(max(bd_mtx{i}));
end
for i=pm.no_nom_att+1:pm.d
    pm.cw(i)=1; 
end
pbr_list=(1:pm.no_nom_att).*(pm.no_values(1:pm.no_nom_att)>2); % obtain the list of attributes for pbr
pbr_list(pbr_list==0)=[];
npbr_list=setdiff((1:pm.d-pm.no_num_att),pbr_list); % obtain the list of attributes not attending pbr
num_pbr_att=length(pbr_list); % obtain the number of attributes for representation
num_npbr_att=length(npbr_list); % obtain the number of attributes not for representation
pbr_dis=cell(1,num_pbr_att);
% begin projection
for r=1:num_pbr_att % for each attribute a^r in pbr_list
    num_att_val=pm.no_values(pbr_list(r)); % fetch the number of possible value of a^r
    pbr_dis{r}=cell(1,num_att_val*(num_att_val-1)/2); % initialize pbr distances
    num_new_att=0;
    for v1=1:pm.no_values(pbr_list(r))-1 % for each pair of a^r's possible values v1
        for v2=v1+1:pm.no_values(pbr_list(r)) % and v2
            num_new_att=num_new_att+1;
            d12=bd_mtx{pbr_list(r)}(v1,v2); % fetch base distance between v1 and v2
            plist=setdiff((1:pm.no_values(pbr_list(r))),[v1,v2]); % fetch the projection list of possible values
            pval=zeros(1,pm.no_values(pbr_list(r)));
            pval(v1)=0;
            pval(v2)=d12;
            for vm=plist % for each possible value vm in the plist
                d1m=bd_mtx{pbr_list(r)}(v1,vm);
                d2m=bd_mtx{pbr_list(r)}(v2,vm);
                if d1m>d2m
                    e=(d1m^2-d2m^2+d12^2)/(2*d12); % compute distance between projection point of vm and v1
                    pval(vm)=e; % obtain projected value of vm
                else
                    e=(d2m^2-d1m^2+d12^2)/(2*d12); % compute distance between projection point of vm and v2
                    pval(vm)=bd_mtx{pbr_list(r)}(v1,v2)-e; % obtain projected value of vm
                end
            end
            pval=pval-min(pval); % ensure min(pval) = 0
            for vv1=1:pm.no_values(pbr_list(r))-1 % for each projected value vv1
                for vv2=vv1+1:pm.no_values(pbr_list(r)) % and each projected value vv2
                    pbr_dis{r}{num_new_att}(vv1,vv2)=abs(pval(vv1)-pval(vv2)); % compute the pbr distance matrix
                    pbr_dis{r}{num_new_att}(vv2,vv1)=pbr_dis{r}{num_new_att}(vv1,vv2);
                end
            end
        end
    end
end
% re-organize data set, distance matrices, statistics after pbr
x_pbr=[];
dis_mtx_pbr=[];
no_val_pbr=[];
pbr_rcd=[];
% combine all the attributes and form corresponding dis_mtx after implementing pbr
for r=1:num_pbr_att
    num_new_att=pm.no_values(pbr_list(r))*(pm.no_values(pbr_list(r))-1)/2;
    x_pbr=[x_pbr,repmat(x(:,pbr_list(r)),[1,num_new_att])];
    dis_mtx_pbr=[dis_mtx_pbr,pbr_dis{r}];
    no_val_pbr=[no_val_pbr,ones(1,num_new_att)*pm.no_values(pbr_list(r))];
    pbr_rcd=[pbr_rcd,ones(1,num_new_att)*r];
end
x_ncoded=x(:,[npbr_list,pm.d-pm.no_num_att+1:pm.d]);
dis_mtx_ncoded=bd_mtx(npbr_list); %
no_val_ncoded=pm.no_values(npbr_list);
x_coded=[x_pbr,x_ncoded];
dis_mtx=[dis_mtx_pbr,dis_mtx_ncoded];
pm.no_values=[no_val_pbr,no_val_ncoded];
[~,pm.d]=size(x_coded);
pm.pbr_rcd=[pbr_rcd,zeros(1,num_npbr_att+pm.no_num_att)]; % record the pbr info of attributes
pm.cw_code=zeros(1,pm.d);
for r=1:pm.d-length(npbr_list)-pm.no_num_att
    pm.cw_code(r)=pm.cw(pbr_list(pm.pbr_rcd(r)));
end
pm.cw_code(pm.d-length(npbr_list)+1:pm.d)=1;
% normalize the values of numerical attributes
for r = pm.d - pm.no_num_att + 1 : pm.d
    x_coded( : , r ) = ( x_coded( : , r ) - min( x_coded( : , r ) ) ) / ( max( x_coded( : , r ) ) - min( x_coded( : , r ) ) );
end
