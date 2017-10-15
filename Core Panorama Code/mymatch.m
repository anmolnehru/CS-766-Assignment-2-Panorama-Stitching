% This function reads two images, finds their SIFT features, and optionally
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the number of matches displayed(optional)
%
% slightly modified version of the source provided by:
% http://www.cs.ubc.ca/spider/lowe/keypoints/siftDemoV4.zip c David Lowe

%--------------------------------------------------------------------------
%   Author: Anmol Mohanty
%   CS 766 - Assignment 2 | Panorama
%--------------------------------------------------------------------------

%Parameters:- Images, Optional argument to show the feature matchings
%true would show the images
%false would hide them

function [loc1,loc2,matchidxs] = mymatch(image1, image2, show)

if nargin < 3
    show=true;
end
%keyboard;
% Find SIFT keypoints for each image
[im1, des1, loc1] = sift(image1);

[im2, des2, loc2] = sift(image2);

% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.

des2t = des2';                          % Precompute matrix transpose

matchidxs=zeros(size(des1,1),1);
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      matchidxs(i) = indx(1);
   end
end
% %keyboard; Enable if you want to see all the SIFT Matches
% if show % Show all the intermediate steps
%    
%     % Create a new image showing the two images side by side.
%     im3 = appendimages(im1,im2);
% 
%     % Show a figure with lines joining the accepted matches.
%     figure('Position', [100 100 size(im3,2) size(im3,1)]);
%     colormap('gray');
%     imagesc(im3);
%     hold on;
%     cols1 = size(im1,2);
%     for i = 1: size(des1,1)
%       if (matchidxs(i) > 0)
%         line([loc1(i,2) loc2(matchidxs(i),2)+cols1], ...
%              [loc1(i,1) loc2(matchidxs(i),1)], 'Color', 'c'); % Connects all the points with cyan lines!
%       end
%     end
% hold off;

%keyboard;
end
num = sum(matchidxs > 0);
fprintf('Found %d matches.\n', num);




