
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
