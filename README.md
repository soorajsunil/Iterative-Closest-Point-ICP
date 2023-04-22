# ICP
**Iterative closest point (ICP) for 2D laser scan matching** \
This repo is a Matlab version of the python notebook: https://nbviewer.org/github/niosus/notebooks/blob/master/icp.ipynb

## Contents:
- **Data generation/loading**
- **ICP using Singular Value Decomposition (SVD)**
- **ICP using Least Squares (point-to-point correspondences)**
- **ICP using Least Squares (point-to-plane correspondences)**

## **Data generation/loading**
For sample data, one can either simulate data points or load scans of real-world lidar data.  
```
demo_data_simulation.m 
demo_lidar_scans.m
```
<p float="left">
<img src="plots/demo_simulated_data.bmp" width="400" height="300"> 
<img src="plots/demo_lidar_data.bmp" width="400" height="300"> 
</p>

## **ICP - singular value decomposition (SVD)** 
```
demo_ICP_SVD.m
```
<p float="left">
<img src="plots/gifs/correspondences_svd.gif" width="400" height="300"> 
<img src="plots/gifs/correspondences_svd_lidar.gif" width="400" height="300"> 
</p>

## **ICP - least squares (point-to-point)** 
```
demo_lCP_LS.m
```
<p float="left">
<img src="plots/gifs/correspondences_ls.gif" width="400" height="300"> 
<img src="plots/gifs/correspondences_ls_lidar.gif" width="400" height="300"> 
</p>


## **ICP - least squares (point-to-plane)** 
``` 
demo_ICP_LS_normal.m
```
<p float="left">
<img src="plots/gifs/correspondences_ls_normal.gif" width="400" height="300"> 
<img src="plots/gifs/correspondences_ls_normal_lidar.gif" width="400" height="300"> 
</p>
