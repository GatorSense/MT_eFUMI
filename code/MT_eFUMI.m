function [E, P, Prob_Z, E_initial,obj_func]=MT_eFUMI(Inputdata,labels,parameters)

% Inputs:
%   Inputdata - hyperspectral image data, can be both in data cube and linear data, will be normalized later
%   parameters - struct - parameter structure which can be set using the EF_parameters() function
%   labels - binary the same size as input data, indicates positive bag with logical '1'
%
% Outputs:
%   E - Endmembers, d by M+1, M accounts for the number of background endmembers
%   P - Proportion Values, M+1 by N
%   Prob_Z - Final probability to indicate the probability of points in positive to be real target 

flag_Data=0;%flag to indicate data size 0: dxN reshaped data, 1: MxNxd, unreshaped hyperspectral data cube
Inputdata=double(Inputdata);


if length(size(Inputdata))==3
    flag_Data=1;
    Inputdata_reshape=EF_reshape(Inputdata);%reshape data into dxN
    labels=reshape(labels,1,size(Inputdata_reshape,2));% reshape label into 1xN
    X=Inputdata_reshape;
else
    X=Inputdata;
end


T=parameters.T;
M=parameters.M;%No. of initial background endmembers
d=size(X,1);% data dimensions
N=size(X,2);% total number of data
index_plus=find(labels); %find positive index
index_minus=find(labels==0);%find negative index
X_plus=X(:,index_plus);%extract positive data
X_minus=X(:,index_minus);%extract negative data
N_plus=size(X_plus,2);% total No. of data in positive bags
N_minus=size(X_minus,2);% total No. of data in negative bags
w=parameters.alpha*(N_minus/N_plus);% weight for points from positive bags
W_plus=w*ones(1,N_plus);% weight line for points from positive bags
W_minus=ones(1,N_minus);% weight line for points from negative bags
W(index_plus)=W_plus;%W is the weight row for entire data
W(index_minus)=W_minus;%W is the weight row for entire data


%initialize
[E_initial,P]=MT_VCA_initialize(X,labels,parameters);% use VCA to initialize
% [E_initial,P]=EFKM_initialize(X,labels,parameters);% use k-means to initialize
% [E_initial,P]=EF_initialize(X,labels,parameters);% use random value to initialize 

E=E_initial;

obj_func=inf;
Cond=inf;

for i=1:parameters.iterationCap
    
%E-step
    Prob_Z=MT_Prob_Z_Update(X,P,E,labels,parameters);
    
%M-step
    %update P
    P_old=P;
    gamma_vecs=[zeros(T,1);(parameters.gammaconst./(sum(P_old(T+1:end,:),2)))];% get gamma coefficients for each background endmember
    P=MT_P_Update(X,E,Prob_Z,labels,parameters,gamma_vecs);

    %update E
    E_old=E;
    E=MT_E_Update(X,P,Prob_Z,labels,parameters);
    
    
    %Condition Update        
    obj_func_old=obj_func;
    [Cond, obj_func]=MT_Cond_Update(X,P,E,Prob_Z,W,obj_func_old,parameters,gamma_vecs);
    
    fprintf(['Iteration ' num2str(i) '\n']);
    fprintf(['Obj_Func=' num2str(obj_func) '\n']);
    fprintf(['Cond=' num2str(Cond) '\n' '\n']);
    
    if abs(Cond)<parameters.changeThresh %if the change in objective function is smaller than set threshold
        break;
    end
    
    %prune unnecessary endmember
    
    P_backgr=P(T+1:end,:);% extract proportion values for background endmembers 
    pruneIndex=max(P_backgr,[],2)<parameters.endmemberPruneThreshold;%find endmember eligible to prune
    P([false(T,1); pruneIndex],:)=[];%prune proportion values corresponding to endmember eligible to prune
    E(:,[false(T,1); pruneIndex])=[];%prune unnecessary endmember

end
if flag_Data==1
    EF_viewresults(Inputdata,P);%if the original data is in form of hyperspectral data cube, show final proportion map
end
end