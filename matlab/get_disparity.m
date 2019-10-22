function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
w = round((windowSize - 1) / 2);
dispM = zeros(size(im1));

[r,c] = size(im1);

for i = w+1:r-w 
    for j = w+1:c-w
        min = inf;
        for d = -maxDisp:maxDisp            
            if j-w-d < 1 || j+w-d > c
                continue;
            else                
                I1 = int16(im1(i-w:i+w, j-w:j+w));
                I2 = int16(im2(i-w:i+w, j-w-d:j+w-d));                
                
                if all(I1, 'all') == false || all(I2, 'all') == false
                    continue;
                end
                diff = (int16(im1(i-w:i+w, j-w:j+w)) - int16(im2(i-w:i+w, j-w-d:j+w-d))).^2;
                %diff = abs((int16(im1(i-w:i+w, j-w:j+w)) - int16(im2(i-w:i+w, j-w-d:j+w-d))));                
                    
           end

            dist = sum(diff, 'all');
            if dist < min
                min = dist;
            end            
            
        end
        dispM(i,j) = min;
    end
end
    