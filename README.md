# MT_eFUMI
**Functions of multiple instances for sub-pixel target characterization
in hyperspectral imagery**

_Changzhe Jiao and Alina Zare_

___

If you use this code, please cite it as:

Changzhe Jiao & Alina Zare. (2022, March 13). GatorSense/MT_eFUMI: Initial release (Version v1.0). Zenodo. http://doi.org/10.5281/zenodo.3727217 

[![DOI](https://zenodo.org/badge/126838417.svg)](https://zenodo.org/badge/latestdoi/126838417)

The associated papers for this repo are: 

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
% Inputs:
%   Inputdata: hyperspectral image data, can be both in data cube and linear data, will be normalized later
%   labels: binary the same size as input data, indicates positive bag with logical '1'
%   parameters: struct - parameter structure which can be set using the EF_parameters() function
```

## Outputs
```
% Outputs:
%   E: Endmembers, d by M+1, M accounts for the number of background endmembers
%   P: Proportion Values, M+1 by N
%   Prob_Z: Final probability to indicate the probability of points in positive to be real target 
```

## Parameters
The parameters can be set in the following function:

```MT_parameters.m```

The parameters is a MATLAB structure with the following fields:
```
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
```

## Inventory

* Note: some of the functions from the Hyperspectral_Data_Simulation are used to run the demo. Check out the repo here: [[`Hyperspectral_Data_Simulation Repository`](https://github.com/GatorSense/Hyperspectral_Data_Simulation)]

```
https://github.com/GatorSense/Multi-Target-MI-ACE_SMF

└── root dir
    ├── LICENSE  //MIT license
    ├── README.md  //this file
    └── algorithm  //algorithm functions
        ├── evalObjectiveFunction.m //evaluates the objective function given a candidate target signature
        ├── evalObjectiveFunctionLookup.m //evaluates the objective function for initialization using a precomputed similarity matrix of data
        ├── miTargets.m  //runs algorithm
        ├── optimizeTargets.m  //optimizes target signatures
        └── setParameters.m  //sets parameters for algorithm
        └── detectors  //algorithm functions
            ├── ace_det.m  //compute ACE
            └── smf_det.m  //compute SMF
    └── exampleMain  //template for your own development
        ├── bagData.m  //template to bag data
        ├── bagHyperspectral.m //code that bags example data
        ├── example_data.csv // csv containing example hyperspectral data
        ├── splitTrainTest.m // code that split example data into training and validation using KFold cross validation
        ├── roc_example_results.fig //matlab figure displaying roc results from example data
        └── examplePFT.m  //template to set up data and run algorithm
        ├── parameters.m  //set parameters for simulation demo
        └── exampleSimulate.m  //run simulation demo	        
```



## License

This source code is licensed under the license found in the [`LICENSE`](LICENSE) file in the root directory of this source tree.

This product is Copyright (c) 2019 J. Bocinsky and A. Zare. All rights reserved.

## <a name="Citing"></a>Citing Multi-target eFUMI

If you use the MICI clasifier fusion and regression algorithms, please cite the following references using the following entries.

**Plain Text:**

X. Du and A. Zare, "Multiple Instance Choquet Integral Classifier Fusion and Regression for Remote Sensing Applications," in IEEE Transactions on Geoscience and Remote Sensing, vol. 57, no. 5, pp. 2741-2753, May 2019. doi: 10.1109/TGRS.2018.2876687

X. Du, A. Zare, J. M. Keller and D. T. Anderson, "Multiple Instance Choquet integral for classifier fusion," 2016 IEEE Congress on Evolutionary Computation (CEC), Vancouver, BC, 2016, pp. 1054-1061. doi: 10.1109/CEC.2016.7743905

**BibTex:**
```
@ARTICLE{du2018multiple,
author={X. Du and A. Zare},
journal={IEEE Transactions on Geoscience and Remote Sensing},
title={Multiple Instance Choquet Integral Classifier Fusion and Regression for Remote Sensing Applications},
year={2018},
volume={57},
number={5},
pages={2741-2753}, 
month={May},
doi={10.1109/TGRS.2018.2876687}
}
```
```
@INPROCEEDINGS{du2016multiple,
author={X. Du and A. Zare and J. M. Keller and D. T. Anderson},
booktitle={IEEE Congress on Evolutionary Computation (CEC)},
title={Multiple Instance Choquet integral for classifier fusion},
year={2016},
volume={},
number={},
pages={1054-1061},
doi={10.1109/CEC.2016.7743905},
month={July}
}
```

## License

This source code is licensed under the license found in the [`LICENSE`](LICENSE) file in the root directory of this source tree.

This product is Copyright (c) 2019 W. Yu, W. Xu and A. Zare. All rights reserved.

## Citing MIL U-NET
If you use the MIL U-Net algorithm or code, please cite using the following reference entries.

__Plain Text:__
G. Yu, W. Xu and A. Zare, "Weakly Supervised Image Segmentation with Multiple Instance Learning Neural Networks," version 1.0, November, 2019.  Available: https://github.com/GatorSense/MIL_UNet

__BibTex:__
```
@misc{yu2019mil_unet,
    author       = {Guohao Yu and Weihuang Xu and Alina Zare},
    title        = {Weakly Supervised Image Segmentation with Multiple Instance Learning Neural Networks},
    month        = {Nov},
    year         = {2019},
    version      = {1.0},
    url          = {https://github.com/GatorSense/MIL_UNet}
    }
```



## Related Work

Also check out our Multiple Instance Multi-Resolution Fusion (MIMRF) algorithm for multi-resolution fusion!


[[`arXiv`](https://arxiv.org/abs/1805.00930)]

[[`GitHub Code Repository`](https://github.com/GatorSense/MIMRF)]

## Further Questions

For any questions, please contact:

Alina Zare

Email Address: azare@ece.ufl.edu

University of Florida, Department of Electrical and Computer Engineering



