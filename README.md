# MT_eFUMI
**Multi-target Extended Functions of Multiple Instances**

_Changzhe Jiao and Alina Zare_

___

If you use this code, please cite it as:

Changzhe Jiao & Alina Zare. (2022, March 13). GatorSense/MT_eFUMI: Initial release (Version v1.0). Zenodo. http://doi.org/10.5281/zenodo.3727217 

[![DOI](https://zenodo.org/badge/126838417.svg)](https://zenodo.org/badge/latestdoi/126838417)

The associated papers for this repository are: 

- C. Jiao and A. Zare, [“Functions of Multiple Instances for Learning Target Signatures,”](https://faculty.eng.ufl.edu/machine-learning/2015/08/jiao2015functions/) IEEE Trans. Geosci. Remote Sens., vol. 53, pp. 4670-4686, Aug. 2015.

- A. Zare and C. Jiao, [“Functions of Multiple Instances for Sub-pixel Target Characterization in Hyperspectral Imagery,”](https://faculty.eng.ufl.edu/machine-learning/2015/05/zare2015functions/) in Proc. SPIE 9472, Algorithms and Technologies for Multispectral, Hyperspectral, and Ultraspectral Imagery XXI, 2015.

In this repository, we provide the papers and code for the Multi-target Extended Functions of Multiple Instances (Multi-target eFUMI) algorithm.

## Installation Prerequisites

This code uses only standard MATLAB packages.

## Cloning

To recursively clone this repository using Git, use the following command:

```
git clone --recursive https://github.com/GatorSense/MT_eFUMI.git
```

## Main Functions

The Multi-target eFUMI algorithm runs using the following function:

```[E, P, Prob_Z, E_initial,obj_func]=MT_eFUMI(Inputdata,labels,parameters);```


## Inputs

```
%% Inputs:
Inputdata    % Hyperspectral image data, can be both in data cube and linear data, will be normalized later
labels       % Binary the same size as input data, indicates positive bag with logical '1'
parameters   % Struct - Parameter structure which can be set using the EF_parameters() function
```

## Outputs
```
%% Outputs:
E            % Endmembers, d by M+1, M accounts for the number of background endmembers
P            % Proportion Values, M+1 by N
Prob_Z       % Final probability to indicate the probability of points in positive to be real target 
```

## Parameters
The parameters for the Multi-target eFUMI algorithm, which are stored as a MATLAB struct, can be set in the following file:

```MT_parameters.m```

The parameters options are:
```
%% Parameters:
u                          % Weight used to trade off between residual error & volume terms, smaller = more weight on error
changeThresh               % Stopping criterion, When change drops below this threshold the algorithm stops
iterationCap               % Iteration cap, used to stop the algorithm
Eps                        % Parameter used to diagonally load some matrices in the code
T                          % Iteration index
M                          % Denote how many background endmembers there are
alpha                      % Coefficient of weight for points from positive bag
gammaconst                 % Larger weight should mean fewer endmembers
flag_E                     % 0, don’t normalize E; 1, normalize E after each iteration when some criteria are satisfied; 2,norm E to 1
endmemberPruneThreshold    % Prune E(:, i) when max(P(i, :))<this threshold
beta                       % Coefficient to scale the distance of current points to the space of background endmembers in calculating Prob_Z 
```

## Inventory

```
https://github.com/GatorSense/MT_eFUMI

└── root dir
    ├── LICENSE    //MIT license
    ├── README.md  //This file
    └── code       //Algorithm functions
        ├── EF_initialization.m         //Initialize endmember and proportion values
        ├── EF_P_Update_no_constraint.m //Update proportions without constraints
        ├── EF_reshape.m                //Reshape hyperspectral data cube MxNxd to dx(M*N)
        ├── EF_viewresults.m            //Display proportion map
        ├── EFKM_initialize.m           //Initialize endmembers and proportions with EFKM
        ├── keep_E_update_P.m           //Solve for proportions given endmembers
        ├── MT_Cond_Update.m            //Find change in objective function
        ├── MT_E_Update.m               //Update proportions
        ├── MT_eFUMI.m                  //Main function for multi-target eFUMI
        ├── MT_P_Update.m               //Update endmembers
        ├── MT_parameters.m             //Parameter file for Multi-target eFUMI
        ├── MT_Prob_Z_Update.m          //Updated Prob Z
        ├── MT_VCA_initialize.m         //Initialize endmembers and proportions with VCA
        ├── normalize.m                 //Normalize the data to [0,1]
        └── VCA.m                       //Runs Vertex Component Analysis
    └── papers  //Associated publications
        ├── Multi-eFUMI.pdf                   //SPIE conference publication
        ├── MultiTargets_eFUMI_derivation.pdf //Mutlti-target eFUMI derivations
        ├── jiao2015functions.pdf             //IEEE TGRS paper
```



## License

This source code is licensed under the license found in the [`LICENSE`](LICENSE) file in the root directory of this source tree.

This product is Copyright (c) 2022 C. Jiao and A. Zare. All rights reserved.

## Citing Multi-target eFUMI

If you use the Multi-target eFUMI algorithm, please cite the following references using the following entries.

__Plain Text:__

- Changzhe Jiao & Alina Zare. (2022, March 13). GatorSense/MT_eFUMI: Initial release (Version v1.0). Zenodo. http://doi.org/10.5281/zenodo.3727217 

- C. Jiao and A. Zare, [“Functions of Multiple Instances for Learning Target Signatures,”](https://faculty.eng.ufl.edu/machine-learning/2015/08/jiao2015functions/) IEEE Trans. Geosci. Remote Sens., vol. 53, pp. 4670-4686, Aug. 2015.

- A. Zare and C. Jiao, [“Functions of Multiple Instances for Sub-pixel Target Characterization in Hyperspectral Imagery,”](https://faculty.eng.ufl.edu/machine-learning/2015/05/zare2015functions/) in Proc. SPIE 9472, Algorithms and Technologies for Multispectral, Hyperspectral, and Ultraspectral Imagery XXI, 2015.

__BibTex:__

```
@misc{jiao2022mtefumi,
    author           = {Changzhe Jiao and Alina Zare},
    title            = {Multi-target Extended Functions of Multiple Instances},
    month            = {March},
    year             = {2022},
    version          = {1.0},
    url              = {https://github.com/GatorSense/MT_eFUMI}
}
```
```
@Article{jiao2015functions,
    Title            = {Functions of Multiple Instances for Learning Target Signatures},
    Author           = {Jiao, Changzhe and Zare, Alina},
    Journal          = {IEEE Trans. Geosci. Remote Sens.},
    Year             = {2015},
    Month            = {Aug.},
    Number           = {8},
    Pages            = {4670-4686},
    Volume           = {53},
    Doi              = {10.1109/TGRS.2015.2406334},
}
```
```
@InProceedings{zare2015functions,
    Title            = {Functions of multiple instances for sub-pixel target characterization in hyperspectral imagery},
    Author           = {Zare, Alina and Jiao, Changzhe},
    Booktitle        = {Proc. SPIE 9472, Algorithms and Technologies for Multispectral, Hyperspectral, and Ultraspectral Imagery XXI},
    Year             = {2015},
    Month            = {May},
    Number           = {947212},
    Volume           = {9472},
    Doi              = {10.1117/12.2176889},
}
```

## Related Work

Also check out our Multi-target Multiple Instance ACE and SMF (Multi-target MI-ACE/SMF) algorithms for hyperspectral target characterization!

[[`FUMI`](https://github.com/GatorSense/FUMI)]

[[`MI-ACE/SMF`](https://github.com/GatorSense/MIACE)]

[[`Multi-target MI-ACE/SMF`](https://github.com/GatorSense/Multi-Target-MI-ACE_SMF)]

## Further Questions

For any questions, please contact:

Alina Zare

Email Address: azare@ece.ufl.edu

University of Florida, Department of Electrical and Computer Engineering



