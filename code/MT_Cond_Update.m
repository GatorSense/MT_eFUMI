function [Cond, obj_func]=MT_Cond_Update(X,P,E,Prob_Z,W,obj_func_old,parameters,gamma_vecs)

% Inputs:
%   X - Inputdata, reshaped hyperspectral image treats each pixel as column vector, d by N
%   P - Proportion value calculated from the previous iteration, M+1 by N;
%   E - Endmember matrix calculated from the previous iteration d by M+1;
%   Prob_Z - probability to indicate the probability of points in positive to be real target 2 by N
%   W - weight row for entire data
%   obj_func_old - objective function value of the previous iteration
%   parameters - struct - parameter structure which can be set using the EF_arameters() function
%   gamma_vecs - gamma coefficients to promote sparsity


% Outputs:
%   Cond - current change in objective function
%   obj_func - current objective function value
T=parameters.T;

E_minus=E(:,T+1:end);
M=size(E_minus,2);
P_minus=P(T+1:end,:);
mu=mean(X,2);


obj_func=0.5*(1-parameters.u)*sum(Prob_Z(1,:).*W.*sum((X-E_minus*P_minus).^2))+0.5*(1-parameters.u)*sum(Prob_Z(2,:).*W.*sum((X-E*P).^2))+0.5*parameters.u*sum(sum((E-repmat(mu,1,M+T)).^2))+sum(gamma_vecs.*sum(P,2));

Cond=obj_func_old-obj_func;
end
