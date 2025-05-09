function [Tree_DistMtx,Tree_struct]=TreeStruct_DistMtx(ModeMtx,LctRecFOld,~,NumVal,~,Pm,Val_count)
        Tree_DistMtx=cell(1,Pm.Xwd);  % initialize the distance weights 
        Tree_struct=cell(1,Pm.Xwd);      
        cluster_len_list=zeros(1,Pm.k);
        for j=1:Pm.k
            ClusterLth=length(find(LctRecFOld==j));
            cluster_len_list(j)=ClusterLth;
        end
        for col=1:Pm.Xwd
            p_k=zeros(NumVal(col),Pm.k);
            for k=1:Pm.k
                p_kv=transpose((ModeMtx{k,col}.*cluster_len_list(k))./Val_count{col}); 
%                 disp(p_kv)
                p_k(:,k)=p_kv;
%                 disp(p_k)            
            end
            DistMtx=inf(NumVal(col));
            for v1=1:NumVal(col)
                for v2=v1+1:NumVal(col)
                    DistMtx(v1,v2)=pdist2(p_k(v1,:),p_k(v2,:))*(1/Pm.k); %归一化
%                     disp(pdist2(p_k(v1,:),p_k(v2,:)));
%                     pause
                    DistMtx(v2,v1)=DistMtx(v1,v2);
                end
            end           
%             disp(DistMtx);
            DistMtx(DistMtx==0)=0.00000001;
            A_TreeDistMtx=Order_Tree_construct(DistMtx);
            Tree_DistMtx{col}=A_TreeDistMtx;
        end
end