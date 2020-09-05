Date: Fall 2019  
Course: Computer Vision  

Given 2D images of an object, reconstruct its 3D structure using sparse reconstruction and dense reconstruction.  

Sparse Reconstruction: Reconstruct the 3D structure using a cloud of points.   Given some matching points on the 2 images, a fundamental matrix between the 2 images is computed
using the 8-point algorithm.  
The epipolar constraint is used to find more point matches, which can be used to triangulate the 3D coordinate of the 2 2D points.  

Dense Reconstruction: A disparity map is computed using dense window matching.  The disparity map is then used to create a depth map.  
