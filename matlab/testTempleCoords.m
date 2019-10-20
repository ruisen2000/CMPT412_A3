% A test script using templeCoords.mat
%
% Write your code here
%
clear;
datadir = '../data';
data = load(sprintf('%s/%s', datadir, 'someCorresp.mat'));
data2 = load(sprintf('%s/%s', datadir, 'intrinsics.mat'));
img1 = imread(sprintf('%s/%s', datadir, 'im1.png'));
img2 = imread(sprintf('%s/%s', datadir, 'im2.png'));

M = data.M;
pts1 = data.pts1;
pts2 = data.pts2;
K1 = data2.K1;
K2 = data2.K2;

%s1 = pts1(1:9, :);
%s2 = pts2(1:9, :);

F = eightpoint(pts1, pts2, M);
%F = [1.337e-9 -1.0926e-7 2.7701e-6; -7.7548e-8 -4.3356e-10 0.0011; 1.5415e-5 -0.0011 -0.0042]
%F = estimateFundamentalMatrix(pts1,pts2, 'Method','Norm8Point');
%displayEpipolarF(img1, img2, F);
E = essentialMatrix(F, K1, K2);
p_ep = epipolarCorrespondence(img1, img2, F, pts1);

P1 = K1 * [eye(3), zeros(3,1)];
M2s = camera2(E);

for i = 1:4
    P2 = K2*M2s(:,:,i);
    pts3d(:,:,i) = triangulate(P1, pts1, P2, p_ep );
    x_proj = P1*(cart2hom(pts3d(:,:,i))');
    error = mean((abs(hom2cart(x_proj') - pts1)))
    num_negative = sum(pts3d(:,3,i) < 0)
end

plot3(pts3d(:,1,1), pts3d(:,2,1), pts3d(:,3,1), '.')
figure;
plot3(pts3d(:,1,2), pts3d(:,2,2), pts3d(:,3,2), '.')
figure;
plot3(pts3d(:,1,3), pts3d(:,2,3), pts3d(:,3,3), '.')
figure;
plot3(pts3d(:,1,4), pts3d(:,2,4), pts3d(:,3,4), '.')

R1 = eye(3);
t1 = zeros(3,1);
R2 = M2s(:,1:3,2);
t2 = M2s(:,4,2);
%
%epipolarMatchGUI(img1, img2, F);

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
