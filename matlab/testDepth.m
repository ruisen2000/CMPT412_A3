clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');
[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;
[r,c] = size(im1);
[~,cl] = size(rectIL);

rectIL=rectIL(1:r,cl-c+1:cl);
rectIR=rectIR(1:r,1:c);

maxDisp = 125; 
windowSize = 9;
dispM = get_disparity(rectIL, rectIR, maxDisp, windowSize);

% --------------------  get depth map
%dispM(dispM>9000) = 9000;
depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);
%depthM(depthM>600)=0;

% --------------------  Display
figure; imagesc(dispM);axis image;
figure; imagesc(dispM.*(rectIL>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(rectIL>40)); colormap(gray); axis image;
