function [E,P]=EFKM_initialize(X,labels,parameters)

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
opts=statset('maxiter',500);%set k-means parameter
[Idx,C]=kmeans(X',2*M+1,'Replicates',5,'emptyaction','singleton','options',opts);
Idx=Idx';
C=C';

index=cell(1,2*M+1);
positive_ratio=zeros(1,2*M+1);
for i=1:2*M+1
    index{i}=find(Idx==i);%find the k-means classification results
    positive_ratio(i)=sum(labels(index{i}))/length(index{i});%calculate the proportion of positive points in each classification

end

[~,I]=sort(positive_ratio,'descend');%sort the positive ratio
z=M+1;
locs_plus=I(1:z);
locs_minus=I((z+1):end);
C_plus=C(:,locs_plus);%separate class centers into two parts: positive and negative
C_minus=C(:,locs_minus);

dist=zeros(1,z);
for j=1:z
    dist(j)=sum(sum((repmat(C(:,locs_plus(j)),1,size(C_minus,2))-C_minus).^2));%calculate the distance between the positive center and the negative centers
end

[~,sign]=max(dist);
e_t=C_plus(:,sign);%initial target spectrum is the positive center most far away from the negative centers
E_minus=C_minus;%initial background spectra is the negative centers
E=[e_t E_minus];

if parameters.flag_E==2
    E=normalize(E,2);
end


%%%P initialization
P_plus=ones(M+1,N_plus)*(1/(M+1));%use mean value to initialize proportion velues according labels
P_minus=ones(M,N_minus)*(1/M);
P(:,index_plus)=P_plus;
P(:,index_minus)=[zeros(1,N_minus);P_minus];

end

