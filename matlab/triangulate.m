function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%

    [r,~] = size(pts1);
    A = [];
    pts3d = [];

    for i = 1:r

        x = pts1(i,1);
        y = pts1(i,2);
        x_p = pts2(i,1);
        y_p = pts2(i,2);

        A = [y*P1(3,:) - P1(2,:);
            P1(1,:) - x*P1(3,:);
            y_p*P2(3,:) - P2(2,:);
            P2(1,:) - x_p*P2(3,:)];

        [V,D] = eig(A'*A);   
        D = diag(D);
        [~,index] = min(D);  % solution of h is eigenvector with minimum eigenvalue
        X = V(:, index);
        X = hom2cart(X');
        pts3d = [pts3d; X];
    end
    
end