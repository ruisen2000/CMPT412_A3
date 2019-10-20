function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
w = round(windowSize - 1) / 2;
dispM = zeros(size(im1));

[r,c] = size(im1);
paddingTop = w;
paddingSide = w;
paddedImg1 = padarray(im1, [paddingTop, paddingSide],'replicate','post');
paddedImg1 = padarray(paddedImg1, [paddingTop, paddingSide],'replicate','pre');
paddedImg2 = padarray(im2, [paddingTop, paddingSide],'replicate','post');
paddedImg2 = padarray(paddedImg2, [paddingTop, paddingSide],'replicate','pre');  


for i = 1:r    
    for j = 1:c
        min = inf;
        for d = 0:maxDisp            
            if j-d < 1
                break
            else
                diff = (int16(paddedImg1(i:i+2*w, j:j+2*w)) - int16(paddedImg2(i:i+2*w, j-d:j+2*w-d))).^2;
                    if (i > 300 & i < 350) & (j > 140 & j < 180)
                        x1 = paddedImg1(i:i+2*w, j:j+2*w)
                        y1 = paddedImg2(i:i+2*w, j-d:j+2*w-d)
                        diff
                        dist = sum(diff, 'all')
                    end
            end

            dist = sum(diff, 'all');
            if dist < min
                min = dist;
            end            
            
        end
        dispM(i,j) = min;
    end
end
    