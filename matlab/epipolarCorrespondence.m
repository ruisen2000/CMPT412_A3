function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

[r,c] = size(im2);
pts1 = cart2hom(pts1);


l = F * pts1';
s = sqrt(l(1)^2+l(2)^2);
if s==0
    error('Zero line vector in epipolarCorrespondance');
end
l = l/s;

[~,nlines] = size(l);
% each column of l is a line

x = 2:c-1;
pts2 = [];

% for every epipolar line, find the points on the line by finding the y value for
% all x values in range of the image width
for i = 1:nlines
    ep_line = l(:,i);  
    y = round((-ep_line(1)*x - ep_line(3)) / ep_line(2));
    coords = [x; y]';  % convert to Nx2 matrix, remove entries on the border.  
    coords((coords(:,2) == 1),:) = [];
    coords((coords(:,2) == r),:) = [];
    
    % for each point, get the surrounding 8 pixels and build a vector
    [n_pts, ~] = size(coords); 
    min_distance = inf;
    point = [-1 -1];  % the matching point for the current epipolar line

    for j = 1:n_pts
        x_img = coords(j,2);  % x coordinate in cartesian is column in image coordinates
        y_img = coords(j,1);
        v1 = im1(x_img-1:x_img+1, y_img-1:y_img+1);
        v1 = v1';
        v1 = v1(:);
        v2 = im2(x_img-1:x_img+1, y_img-1:y_img+1);
        v2 = v2';
        v2 = v2(:);
        distance = sqrt(sum((v2 - v1) .^ 2));
        if distance < min_distance
            min_distance = distance;
            point = [y_img x_img];
        end        
    end
    pts2 = [pts2; point];
end
    