function parameters= MT_parameters()
    
    parameters.u = 0.01;  %Weight used to trade off between residual error & volume terms, smaller = more weight on error
    parameters.changeThresh = 1e-6; %Stopping criterion, When change drops below this threshold the algorithm stops
    parameters.iterationCap = 500; %Iteration cap, used to stop the algorithm
    parameters.Eps=1e-8; % Parameter used to diagonally load some matrices in the code
    parameters.T=2;
    parameters.M=3;% denote how many background endmembers there are
    parameters.alpha=2; %coefficient of weight for points from positive bag
    parameters.gammaconst=0.01;%Larger weight should mean fewer endmembers
    parameters.flag_E=1;%0, don’t normalize E; 1, normalize E after each iteration when some criteria are satisfied; 2,norm E to 1
    parameters.endmemberPruneThreshold=1e-8;%Prune E(:, i) when max(P(i, :))<this threshold
    parameters.beta=50;%coefficient to scale the distance of current points to the space of background endmembers in calculating Prob_Z 
    
end
