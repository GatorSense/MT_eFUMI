function [E,P]=EF_initialize(X,labels,parameters)


% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   parameters - struct - parameter structure which can be set using the EF_parameters() function
%   labels - binary the same size as input data, indicates positive bag with logical '1'
%
% Outputs:
%   E - Initial Endmembers value, d by M+1, M accounts for the number of background endmembers
%   P - Initial Proportion Values, M+1 by N

M=parameters.M;%No. of initial background endmembers
index_plus=find(labels);%find positive index
index_minus=find(labels==0);%find negative index
X_plus=X(:,index_plus);%extract positive data
X_minus=X(:,index_minus);%extract negative data
N_plus=size(X_plus,2);% total No. of data in positive bags
N_minus=size(X_minus,2);% total No. of data in negative bags

%E initialization
e_t=mean(X_plus,2);% use the mean of points from positively labeled bags as initial value of e_t
sq=randperm(N_minus);
minus_select=sq(1:M);
E_minus=X_minus(:,minus_select);% randomly select M points from negatively labeled bags as background endmembers
E=[e_t E_minus];

% for i=1:M
%     l=floor(N_minus/M);
%     sq=randperm(N_minus);
%     minus_select=sq(1:l);
%     E_minus(:,i)=mean(X_minus(:,minus_select),2);% randomly select M points from negatively labeled bags as background endmembers
% end

E=[e_t E_minus];







%P initialization
P_plus=ones(M+1,N_plus)*(1/(M+1));%use mean value to initialize proportion values according labels
P_minus=ones(M,N_minus)*(1/M);
P(:,index_plus)=P_plus;
P(:,index_minus)=[zeros(1,N_minus);P_minus];

end