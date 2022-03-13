function [P]=MT_P_Update(X,E,Prob_Z,labels,parameters,gamma_vecs)

% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   E - Endmember matrix calculated from the previous iteration d by M+1;
%   Prob_Z - probability to indicate the probability of points in positive to be real target 2 by N
%   labels - binary the same size as input data, indicates positive bag with logical '1'
%   parameters - struct - parameter structure which can be set using the EF_arameters() function
%   gamma_vecs - gamma coefficients to promote sparsity

% Outputs:

%   P - Proportion value, M+1 by N;





T=parameters.T;

E_minus=E(:,T+1:end);%extract background endmembers
M=size(E_minus,2);%NO. of current background endmembers
index_plus=find(labels); %find positive index
index_minus=find(labels==0);%find negative index
X_plus=X(:,index_plus);%extract positive data
X_minus=X(:,index_minus);%extract negative data
N_plus=size(X_plus,2);% total No. of data in positive bags
N_minus=size(X_minus,2);% total No. of data in negative bags
w=parameters.alpha*(N_minus/N_plus);% weight for points from positive bags
Prob_Z_plus=Prob_Z(:,index_plus);%probability of points in positive bags
gamma_vecs_minus=gamma_vecs(T+1:end);% gamma coefficients for background endmembers

P_plus=zeros(M+T,N_plus);
for i=1:N_plus
    P_plus(:,i)=get_P_plus(X_plus(:,i), E, Prob_Z_plus(:,i),parameters,gamma_vecs,w,T,M);%update proportion value for points from positive bags individually

end
P_minus=get_P_minus(X_minus,E_minus,parameters,gamma_vecs_minus);% update proportion value for points from negative bags together

P(:,index_plus)=P_plus;
P(:,index_minus)=[zeros(T,N_minus);P_minus];

end



function p=get_P_plus(x, E,Prob_Z_plus,parameters,gamma_vecs,w,T,M)
E_minus=E(:,T+1:end);
d=size(x,1);
a=1/(-w*(1-parameters.u));

if M+T>1
DP=parameters.Eps*eye(M+T,M+T);
U=pinv(Prob_Z_plus(1)*([zeros(d,T) E_minus]'*[zeros(d,T) E_minus])+Prob_Z_plus(2)*(E'*E)+DP);
V=(Prob_Z_plus(1)*[zeros(d,T) E_minus]'+Prob_Z_plus(2)*E');

p=U*(V*x+a*gamma_vecs+ones(M+T,1)*((1-ones(1,M+T)*U*(V*x+a*gamma_vecs))/(ones(1,M+T)*U*ones(M+T,1))));

z=p<0;
if(sum(z)>0)
    locs_plus=find(1-z);%find the location of positive proportion
    M=M-sum(z(T+1:end));
    T=T-sum(z(1:T));
    
    if T~=0 %if the number of target endmembers is non-zero, which means this point is really a positive point, then continue using get_P_plus to calculate its proportion
        p_temp=zeros(length(z),1);
        p_temp(locs_plus)=get_P_plus(x, E(:,locs_plus),Prob_Z_plus,parameters,gamma_vecs(locs_plus),w,T,M);
        p=p_temp;

    else% if the proportion of target endmember is negative, which means this point is a negative point in positive bag, then use get_P_plus_minus to calculate its proportion
        p_temp=zeros(length(z),1);
        p_temp(locs_plus)=get_P_plus_minus(x,E(:,locs_plus),parameters,gamma_vecs(locs_plus));
        p=p_temp;
    end
end
else 
    p=1;
end
    
end




function p=get_P_plus_minus(x,E,parameters,gamma_vecs)
M=size(E,2);
a=-1/(1-parameters.u);
if M>1
    DP=parameters.Eps*eye(M,M);
    U=pinv(E'*E+ DP);
    V=E'*x;
    p=U*(V+a*gamma_vecs+ones(M,1)*((1-ones(1,M)*U*(V+a*gamma_vecs))/(ones(1,M)*U*ones(M,1))));
    z=p<0;
    if(sum(z)>0)
        locs_plus=find(1-z);
        p_temp=zeros(length(z),1);
        p_temp(locs_plus)=get_P_plus_minus(x,E(:,locs_plus),parameters,gamma_vecs(locs_plus));
        p=p_temp;
    end
else
    p=1;
end
end




function P=get_P_minus(X,E,parameters,gamma_vecs_minus)
M=size(E,2);
DP=parameters.Eps*eye(M,M);
N=size(X,2);
a=-1/(1-parameters.u);
if(M>1)
U=pinv(E'*E+ DP);
V=E'*X;
P=U*(V+a*repmat(gamma_vecs_minus,1,N)+ones(M,1)*((1-ones(1,M)*U*(V+a*repmat(gamma_vecs_minus,1,N)))/(ones(1,M)*U*ones(M,1))));
Z=P<0;
if(sum(sum(Z))>0)
    ZZ = unique(Z', 'rows', 'first')';
    for i=1:size(ZZ,2)
        if(sum(ZZ(:,i)))>0
            eLocs=find(1-ZZ(:,i));
            rZZi=repmat(ZZ(:,i),1,N);
            inds=all(Z==rZZi, 1);
            P_temp=get_P_minus(X(:,inds),E(:,eLocs),parameters,gamma_vecs_minus(eLocs));
            P_temp2=zeros(size(ZZ,1),sum(inds));
            P_temp2(eLocs,:)=P_temp;
            P(:,inds)=P_temp2;
        end
    end
end
else 
    P = ones(1,size(X,2));
end
end



            



    