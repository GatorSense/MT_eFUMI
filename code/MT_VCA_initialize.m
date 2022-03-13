function [E,P]=MT_VCA_initialize(X,labels,parameters)

% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   parameters - struct - parameter structure which can be set using the EF_parameters() function
%   labels - binary the same size as input data, indicates positive bag with logical '1'
%
% Outputs:
%   E - Initial Endmembers value, d by M+1, M accounts for the number of background endmembers
%   P - Initial Proportion Values, M+1 by N

T=parameters.T;%No. of initial background endmembers
M=parameters.M;%No. of initial background endmembers
index_plus=find(labels);%find positive index
index_minus=find(labels==0);%find negative index
N=size(X,2);
X_plus=X(:,index_plus);%extract positive data
X_minus=X(:,index_minus);%extract negative data
N_plus=size(X_plus,2);% total No. of data in positive bags
N_minus=size(X_minus,2);% total No. of data in negative bags


%E initialization

E_minus=VCA(X_minus,'Endmembers',M);% VCA to extract background endmembers
P_plus_unmix=keep_E_update_P(X_plus,E_minus,1);%unmix X_plus use E_minus
syn_X_plus=E_minus*P_plus_unmix;%calculate synthetic X_plus
unmix_diff=sqrt(sum((X_plus-syn_X_plus).^2,1));% calculate difference between real and synthetic
[~,idx_et]=sort(unmix_diff,'descend');%find the one unmixed worst by E_minus
E_T=X_plus(:,idx_et(1:T));


E=[E_T E_minus];



%%%P initialization
P=zeros(T+M,N);
P_plus=ones(T+M,N_plus)*(1/(M+T));%use mean value to initialize proportion velues according labels
P_minus=ones(M,N_minus)*(1/M);
P(:,index_plus)=P_plus;
P(:,index_minus)=[zeros(T,N_minus);P_minus];

end



function [P]=keep_E_update_P(Inputdata,E,flag)


% given endmembers and solve proportions with or without sum to one  constraint
%
%
% Inputs:
%   InputData: double,Nxd or NxMxd matrix, dimensionality d for each feature vector
%   E: given endmembers
%   flag: 0 without sum to one constraint, 1 with sum to one constraint
%
% Outputs:
%   P: proportion values
%   
%   
%
%
% Author: Changzhe Jiao
% Contact: cjr25@mail.missouri.edu
%%

X=double(Inputdata);
flag_Data=0;

if length(size(X))==3
    flag_Data=1;
    X=EF_reshape(X);
end


P=P_Update_KE(X,E,flag);




end
%%

function [P]=P_Update_KE(X,E,flag)

M=size(E,2);
N=size(X,2);

if M>1
    Eps=1e-8;
    DP=Eps*eye(M,M);
    U=pinv(E'*E+DP);
    V=E'*X;
    if flag==0
        P=U*V;
    elseif flag==1
        P=U*(V+ones(M,1)*((1-ones(1,M)*U*V)/(ones(1,M)*U*ones(M,1))));
    end
    Z=P<0;
    while (sum(sum(Z))>0)
        ZZ = unique(Z', 'rows', 'first')';
        for i=1:size(ZZ,2)
            if(sum(ZZ(:,i)))>0
                eLocs=find(1-ZZ(:,i));
                rZZi=repmat(ZZ(:,i),1,N);
                inds=all(Z==rZZi, 1);
                P_temp=P_Update_KE(X(:,inds),E(:,eLocs),flag);
                P_temp2=zeros(size(ZZ,1),sum(inds));
                P_temp2(eLocs,:)=P_temp;
                P(:,inds)=P_temp2;
            end
        end
    Z=P<0;
    end
else

    P=ones(M,N);

end

end



            



            


    

