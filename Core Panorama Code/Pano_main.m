%This is the main start file, it takes as in input the directory where all
%the images are stored and sticthes them to generate the panorama
%--------------------------------------------------------------------------
%   Author: Anmol Mohanty
%   CS 766 - Assignment 2 | Panorama
%--------------------------------------------------------------------------

%%

inDir='data_images';
srcFiles = dir(strcat(inDir,'/*.jpg'));  

%keyboard;    

[~,order] = sortFiles({srcFiles.name});
srcFiles = srcFiles(order);
    
count=0;
mkdir('final_panorama_images');

%%
    for i = 1:2:length(srcFiles) % stitch 2 files at once in a loop until all files done
            count=count+1;
            temp=i+1;         
            if(temp<=length(srcFiles))
            inFilename1 = strcat(inDir,'/',srcFiles(i).name); % absorb the 2 file  names
           % keyboard;
            inFilename2 = strcat(inDir,'/',srcFiles(i+1).name);
         
           %keyboard;
            im1 = imread(inFilename1);
            %break;
            %count=count+1;
            im2 = imread(inFilename2);
           %keyboard;
         
            end
           %keyboard;          
            
       %end    
        
%% Debugging purposes
%fshowA=figure;
%subA1=subplot(2,2,1); imshow(im1);
%subA2=subplot(2,2,2); imshow(im2);
%movegui(fshowA, 'northwest');

%fshowH=figure;
%subH1=subplot(2,2,1); imshow(im1);
%subH2=subplot(2,2,2); imshow(im2);
%movegui(fshowH, 'northeast');
%keyboard;

%%
%Camera Parameters
f=782.05069;
k1=-0.22892;
k2=0.27797;

im1c = cy_proj_simple(im1, f, k1, k2);
im2c = cy_proj_simple(im2, f, k1, k2);

%% sift features | Core SUFTMatch algo
%keyboard
[pts1 pts2] = SIFTmatch( im1c, im2c, 1, 0 );

%keyboard


%% ransac affine %% 2 options were considered, RANSAC affine and homography
[im2_TA, best_ptsA] = ransac( pts2, pts1, 'aff_lsq', 3 );
%showbestpts(subA2, subA1, best_ptsA); % For debug, please don't enable

%% ransac homography | Optionally can be enabled, advanced than affine
%figure(fshowA);
% [im2_TH, best_ptsH] = ransac( pts2, pts1, 'proj_svd', 5 );
showbestpts(subH2, subH1, best_ptsH);
%figure(fshowH);


%% stitch 
[im_stitchedA, stitched_maskA, im1TA, im2TA] = stitch(im1, im2, im2_TA);
%%


%%
%Debug
%figure(fshowA);
%subplot(2,2,3); imshow(im1TA);
%subplot(2,2,4); imshow(im2TA);

% fA=figure;
% axis off;
% movegui(fA, 'west');
%imshow(im_stitchedA);
imwrite(im_stitchedA,strcat('final_panorama_images/',num2str(count),'.JPG')); % Write the stiched files

end
