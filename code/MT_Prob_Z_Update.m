function [Prob_Z]=MT_Prob_Z_Update(X,P,E,labels,parameters)

% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   P - Proportion value calculated from the previous iteration M+1 by N;
%   E - Endmember matrix calculated from the previous iteration d by M+1;
%   labels - binary the same size as input data, indicates positive bag with logical '1'
%   parameters - struct - parameter structure which can be set using the EF_parameters() function
%   flag - method to get probability

% Outputs:

%   Prob_Z - probability to indicate the probability of points in positive to be real target 2 by N.
%---Prob_Z(1,:) denotes the probability of this points is background points, Prob_Z(2,:) denotes the probability of this points is target points



T=parameters.T;%No. of initial background endmembers
E_T=E(:,1:T);
E_minus=E(:,T+1:end);%extract background endmembers
M=size(E_minus,2);%No. of initial background endmembers

N=size(X,2);% total number of data
Prob_Z=zeros(2, N);
index_plus=find(labels); %find positive index
index_minus=find(labels==0);%find negative index



    
Prob_Z(1,index_plus)=exp(-parameters.beta*(sum((X(:,index_plus)-E_minus*P(T+1:end,index_plus)).^2)));% use euclidean distance as error
    


    
Prob_Z(2,index_plus)=1-Prob_Z(1,index_plus);


Prob_Z(1,index_minus)=1;
Prob_Z(2,index_minus)=0;

end



