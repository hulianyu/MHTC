
_______________________________________________________General Information___________________________________________________________

This folder provdes the MATLAB code of the paper entitled "Het2Hom: Representation of Heterogeneous Attributes into 
Homogeneous Concept Spaces for Categorical-and-Numerical-Attribute Data Clustering" by Yiqun Zhang, Yiu-ming Cheung*, 
and An Zeng, accepted by the Main Track of the 31st International Joint Conference on Artificial Intelligence and the 25th 
European Conference on Artificial Intelligence.

If you have any enquiries, please contact Dr. Zhang Yiqun (email: yqzhang@gdut.edu.cn) or the corresponding author 
Prof. Cheung Yiu-ming (email: ymc@comp.hkbu.edu.hk).

_________________________________________________________File Information______________________________________________________________

All the folders and files for implementing the proposed Het2Hom algorithm are introduced below:
- Datasets: A folder contains public/benchmark mixed data sets used in the corresponding paper.
- Het2Hom_Iplmt: A folder contains script and functions for implementing the experiments.
   - Het2Hom_Clustering.m: A script to cluster different data sets in Datasets folder using the proposed method.
   - prjct_rprst.m: A function calls bd_compute and pbr to obtain represented data set and corresponding distance matrices. 
   - bd_compute.m: A function for computing the base distances of categorical attributes.
   - pbr.m: A function to implement projection-based representation (i.e., Section 3.1 in the paper, i.e., Step 1 of Algorithm 1).
                based on the computed base distances.
   - h2h_learn.m: A function to implement Het2Hom learning (i.e., Section 3.2 in the paper, i.e., Step 2-15 of Algorithm 1).
   - h2h_launch.m: A function to obtain the cluster descriptors M and weights W for launching Het2Hom learning.
   - Eva_ARI.m: A function for evaluating the clustering performance in terms of adjusted rand index.
- README.txt: This file.

_______________________________________________________Execution Information__________________________________________________________

Just run "Het2Hom_Clustering.m" in folder Het2Hom, then the experimental results will be displayed automatically. 

For detailed settings about the parameters, initialization, etc., please refer to Section 2.1 in the Supplementary Material 
(https://drive.google.com/file/d/1SKNYxutdftgEfDK9CxzZLYkzYet4Jzf8/view?usp=sharing) mentioned in the paper. 

________________________________________________________Citation Information____________________________________________________________

Please cite the paper if the codes are helpful for your research. Citation information is provided below for the convenience of readers.

General citation: 
Yiqun Zhang, Yiu-ming Cheung and An Zeng, "Het2Hom: Representation of Heterogeneous Attributes into Homogeneous 
Concept Spaces for Categorical-and-Numerical-Attribute Data Clustering", Proceedings of the 31st International Joint 
Conference on Artificial Intelligence (IJCAI'2022), Vienna, Austria, July 23-29, 2022.

Latex citation:
@inproceedings{zhang2022het2hom,
  title={Het2Hom: Representation of Heterogeneous Attributes into Homogeneous Concept Spaces for Categorical-and-Numerical-Attribute Data Clustering},
  author={Zhang, Yiqun and Cheung, Yiu-ming and Zeng, An},
  booktitle={Proceedings of the 31st International Joint Conference on Artificial Intelligence},
  year={2022}
}
____________________
All rights reserved.


