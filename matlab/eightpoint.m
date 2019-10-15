function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
A = [];

centroid1 = [mean(pts1(:,1)), mean(pts1(:,2))];
centroid2 = [mean(pts2(:,1)), mean(pts2(:,2))];
shiftMatrix1 = [1 0 -centroid1(1); 0 1 -centroid1(2); 0 0 1];
shiftMatrix2 = [1 0 -centroid2(1); 0 1 -centroid2(2); 0 0 1];

T_scale = diag([1/M,1/M,1]);

pts1 = cart2hom(pts1)';
pts2 = cart2hom(pts2)';

transform1 = T_scale * shiftMatrix1;
transform2 = T_scale * shiftMatrix2;

pts1 = transform1*pts1;
pts1 = hom2cart(pts1');
pts2 = transform2*pts2;
pts2 = hom2cart(pts2');


% Build A matrix
[r,c] = size(pts1);

for i = 1:r
    x = pts1(i, 1);
    y = pts1(i, 2);
    x_p = pts2(i,1);
    y_p = pts2(i,2);

    next = [x*x_p, x*y_p, x, y*x_p, y*y_p, y, x_p, y_p, 1]; 
    A = [A; next];        
end

% use SVD to solve for F.   F is the column of V with the smallest singular
% value.
[U,S,V] = svd(A);
F = V(:, end);
F = vec2mat(F, 3);
[U,S,V] = svd(F);

% Replace the smallest singular value with 0 to force F to rank 2, then
% reconstruct F
S(9) = 0;
F = U*S*V';

F = refineF(F, pts1, pts2);
F = transform2'*F*transform1;


