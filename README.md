# CBD-BNU-DMN
In this study, we used resting state fMRI data of 305 children (6.2 to 12.4 years at baseline, F/M=143/162, 491 scans in total), and 61 adults (F/M = 37/24, 18.1-28.8 years of age) from Children School Functions and Brain Development project (CBD, Beijing Cohort). 
We performed development of default-mode network in children.
Here, we provided 6 files:
DMN_mask_child.nii is default-mode network seed regions in MNI space.
DMN_mask_adult_MNI.nii is default-mode network seed regions for children.
matrix_child.mat is a 32*32*491 matrix, which contains DMN functional connectivity by calculating the pairwise Pearson’s correlation coefficient between nodal time courses in 491 children.
matrix_adult.mat is a 32*32*61 matrix, which contains DMN functional connectivity by calculating the pairwise Pearson’s correlation coefficient between nodal time courses in 61 adults.
info_child.mat shows ID, age, sex and meanFD for 491 children.
info_adult.mat shows ID, age, sex and meanFD for 61 adults.

