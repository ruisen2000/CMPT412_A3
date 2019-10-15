% A test script using templeCoords.mat
%
% Write your code here
%
clear;
datadir = '../data';
data = load(sprintf('%s/%s', datadir, 'someCorresp.mat'));
img1 = imread(sprintf('%s/%s', datadir, 'im1.png'));
img2 = imread(sprintf('%s/%s', datadir, 'im2.png'));

M = data.M;
pts1 = data.pts1;
pts2 = data.pts2;

s1 = pts1(1:9, :);
s2 = pts2(1:9, :);

F = eightpoint(pts1, pts2, M);


%displayEpipolarF(img1, img2, F);

s1 = cart2hom(s1);
s2 = cart2hom(s2);
diag(s2*F*s1');

%p = epipolarCorrespondence(img1, img2, F, pts1);

epipolarMatchGUI(img1, img2, F);

% save extrinsic parameters for dense reconstruction
%save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
