function [it,chi] = Convergence_Refinement_CU(X,pi)
[N,M] = size(X);
K = max(pi); % label k = 1:K
[~,chi0_pi,NK0,OC0] = Elements_CU(X,pi);
change = N;
it = zeros(1,2); % record the iteration
chi_pi = zeros(K,K);
NK = zeros(K,K);
OC = cell(K,1);
while change~=0
    it(1,1) = it(1,1)+1;
    change = 0;
    for oi = 1:N
        x = X(oi,:);
        this_k = pi(oi);
        chi_pi(this_k,:) = chi0_pi;
        NK(this_k,:) = NK0;
        [chi00_pi,NK00,OC00] = Update_CU_A(chi0_pi,NK0,OC0,x,this_k);
        for k = 1:K
            if k~=this_k
                [chi_pi(k,:),NK(k,:),OC{k,1}] = Update_CU_B(chi00_pi,NK00,OC00,x,k);
            end
        end
        chi_pi_list = sum(chi_pi,2);
%       N*sum(chi_pi)-N*M
        [~,mk] = max(chi_pi_list);
        if this_k~=mk
            change = change+1;
            it(1,2) = it(1,2)+1;
            chi0_pi = chi_pi(mk,:);
            pi(oi) = mk;
            NK0 = NK(mk,:);
            OC0 = OC{mk,1};
        end
    end
end
chi = N*sum(chi0_pi)-N*M;
end

function [chi,chi_pi,NK,OC] = Elements_CU(X,pi)
% show the computing elements of chi
[N,M] = size(X);
K = max(pi); % k = 1:K
Tm = zeros(M,K);
OC = cell(M,1);
NK = sum(pi==1:K);
for m=1:M
    Xm = X(:,m);
    Q = max(Xm);
    oc = zeros(Q,K);
    for k=1:K
        set = Xm(pi==k);
        oc(:,k) = sum(set==1:Q)';  
    end
    OC{m,1} = oc;
    nq = sum(oc,2);
    Tm(m,:) = sum((oc.^2)./repmat(nq,1,K),1);
end
chi_pi = sum(Tm,1)./NK;
chi = N*sum(chi_pi)-N*M;
end

function [chi_new_pi,NK,OC] = Update_CU_A(chi_old_pi,NK,OC,x,a)
% Update chi-squared statistic locally.
M = length(x);
chi_new_pi = chi_old_pi;
nka = NK(a);
NK(a) = nka-1;
delta = 0;
for m = 1:M
    q = x(m);
    N_qa = OC{m,1}(q,a);
    OC{m,1}(q,a) = N_qa-1;
    delta = delta + (-2*N_qa+1); % -(N_qa)^2+(N_qa-1)^2
end
chi_new_pi(1,a) = chi_new_pi(1,a)*(nka/NK(a))+ delta/NK(a);
end

function [chi_new_pi,NK,OC] = Update_CU_B(chi_old_pi,NK,OC,x,b)
% Update chi-squared statistic locally.
M = length(x);
chi_new_pi = chi_old_pi;
nkb = NK(b);
NK(b) = NK(b)+1;
delta = 0;
for m = 1:M
    q = x(m);
    N_qb = OC{m,1}(q,b);
    OC{m,1}(q,b) = N_qb+1;
    delta = delta + ((2*N_qb+1)); % -(N_qa)^2+(N_qa+1)^2
end
chi_new_pi(1,b) = chi_new_pi(1,b)*(nkb/NK(b)) + delta/NK(b);
end