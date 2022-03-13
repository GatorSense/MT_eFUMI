# MT_eFUMI
**Functions of multiple instances for sub-pixel target characterization
in hyperspectral imagery**

_Changzhe Jiao and Alina Zare_

___

If you use this code, please cite it as:

Changzhe Jiao & Alina Zare. (2022, March 13). GatorSense/MT_eFUMI: Initial release (Version v1.0). Zenodo. http://doi.org/10.5281/zenodo.3727217 

[![DOI](https://zenodo.org/badge/126838417.svg)](https://zenodo.org/badge/latestdoi/126838417)

The associated papers are: 

C. Jiao and A. Zare, [“Functions of Multiple Instances for Learning Target Signatures,”](https://faculty.eng.ufl.edu/machine-learning/2015/08/jiao2015functions/) IEEE Trans. Geosci. Remote Sens., vol. 53, pp. 4670-4686, Aug. 2015.

A. Zare and C. Jiao, [“Functions of Multiple Instances for Sub-pixel Target Characterization in Hyperspectral Imagery,”](https://faculty.eng.ufl.edu/machine-learning/2015/05/zare2015functions/) in Proc. SPIE 9472, Algorithms and Technologies for Multispectral, Hyperspectral, and Ultraspectral Imagery XXI, 2015.

In this repository, we provide the papers and code for the Multi-target Extended Functions of Multiple Instances (Multi-target eFUMI) algorithm.

## Installation Prerequisites

This code uses only standard MATLAB packages.

## Cloning

To recursively clone this repository using Git to include the hyperspectral demo submodule use the following command:

     git clone --recursive https://github.com/GatorSense/Multi-Target-MI-ACE_SMF.git

## Demo and Example

This code has two examples, exampleSimulate.m and examplePFT.m which mirrors experiments #1 and #3 in the paper. Both of these can be found in the exampleMain folder.

## Main Functions

Run the algorithm using the following function:

```results = miTargets(data, parameters);```


## Inputs

    data.dataBags: cell list with positive and negative bags (1xNumBags). Each cell contains a single bag in the form a (numInstances x instanceDimensionality) matrix
        * a positive bag should have at least one positive instance in it
        * a negative bag should consist of all negative instances

    data.labels: labels for dataBags (1xnumBags)
        * the labels should be a row vector with labels corresponding to the 
        * parameters.posLabel and parameters.negLabel where a posLabel corresponds
        * to a positive bag and a negLabel corresponds to a negative bag.
        * The index of the label should match the index of the bag in dataBags

    parameters: call setParameters.m function to set parameters
    

## Parameters
The parameters can be set in the following function:

```setParameters.m```

The parameters is a MATLAB structure with the following fields:
1. methodFlag: Determine similarity method 
     * 0: Spectral Match Filter (SMF)
     * 1: Adaptive Cosine Estimator (ACE)
2. numTargets: Number of initialized targets
3. initType:  Set Initialization method used to obtain initalized targets
     * 1: Searches all positive instances and greedily selects instances that maximize objective.  
     * 2: K-Means clusters positive instances and greedily selects cluster centers that maximize objective.
4. optimize: Determine whether to optimize target signatures
     * 0: Do not optimize target signatures, only returns initialized targets
     * 1: Optimize target signatures using MT MI
5. maxIter: Max number of optimization iterations
6. globalBackgroundFlag: Determines how the background mean and inverse covariance are calcualted
     * 0: mean and cov calculated from all data (positive and negative data)
     * 1: mean and cov calculated from only negative bags
7. posLabel: Label used for positive bags
8. negLabel: Label used for negative bags
9. numClusters: Number of clusters used for K-Means (only affects if initType 2 used)
10. alpha: Uniqueness term weight in objective function
     * set to 0 if you do not want to use the term

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


## <a name="Related Work"></a>Related Work

Also check out our Multiple Instance Multi-Resolution Fusion (MIMRF) algorithm for multi-resolution fusion!


[[`arXiv`](https://arxiv.org/abs/1805.00930)]

[[`GitHub Code Repository`](https://github.com/GatorSense/MIMRF)]



