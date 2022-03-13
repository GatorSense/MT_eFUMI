function     [E]=MT_E_Update(X,P,Prob_Z,labels,parameters)


% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   P - Proportion value calculated from the previous iteration, M+1 by N;
%   E_old - Endmember matrix calculated from the previous iteration, d by M+1;
%   Prob_Z - probability to indicate the probability of points in positive to be real target 2 by N
%   labels - binary the same size as input data, indicates positive bag with logical '1'
%   parameters - struct - parameter structure which can be set using the EF_parameters() function
%   flag - method to get E
%   iteration - current iteration number
%   Cond - current change in objective function


% Outputs:

%   E - Endmembers, d by M+1, M accounts for the number of background endmembers


T=parameters.T;

M=size(P,1)-T;% get current number of background endmembers
d=size(X,1);% data dimensions
index_plus=find(labels); %find positive index
index_minus=find(labels==0);%find negative index
X_plus=X(:,index_plus);%extract positive data
X_minus=X(:,index_minus);%extract negative data
N_plus=size(X_plus,2);% total No. of data in positive bags
N_minus=size(X_minus,2);% total No. of data in negative bags
w=parameters.alpha*(N_minus/N_plus);% weight for points from positive bags
P_plus=P(:,index_plus);% proportion value for points in positive bags
P_plus_minus=[zeros(1,N_plus);P_plus(2:end,:)];%proportion value for points from positive bags with zero target proportion
P_minus=P(:,index_minus);% proportion value for points from negative bags
Prob_Z_plus=Prob_Z(:,index_plus);% probability for points from positive bags to be target


U=(repmat(Prob_Z_plus(1,:),M+T,1).*P_plus_minus)';
V=(repmat(Prob_Z_plus(2,:),M+T,1).*P_plus)';
mu=mean(X,2);
DP=parameters.Eps*eye(M+T,M+T);


    

E=((1-parameters.u)*w*(X_plus*U+X_plus*V)+(1-parameters.u)*(X_minus*P_minus')+parameters.u*repmat(mu,1,M+T))*pinv(((1-parameters.u)*w*(P_plus_minus*U+P_plus*V)+(1-parameters.u)*(P_minus*P_minus')+parameters.u+DP));


if parameters.flag_E==1
    E=normalize(E,1);
elseif parameters.flag_E==2
    E=normalize(E,2);
end

end





