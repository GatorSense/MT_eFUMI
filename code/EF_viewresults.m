function EF_viewresults(Inputdata,P)

% Inputs:
%   Inputdata - hyperspectral image data, in M by N by d

%
% Outputs:
%   display proportion map


for i=1:size(P,1)
    figure;
    pp=reshape(P(i,:),[size(Inputdata,1),size(Inputdata,2)]);
    imagesc(pp,[0 1]); axis image;title(['Proportion Map of Endmember ', (num2str(i))]);
end
end