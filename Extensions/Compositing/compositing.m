% Compositing: Insert a part of an image into another
% D = target image, 
% new1 = source image, to be inserted into D
% Implemented by: Rosaleena Mohanty

clc;
close all;
clear all;

%% Read the target image
D = imread('1.jpg');
D_r = D(:,:,1);D_g = D(:,:,2);D_b = D(:,:,3);
figure(1), imshow(D); title('BG Image');

%% Create the region of interest where the new image is to be inserted
BW = roipoly(D);
figure(1), imshow(BW)
bw = uint8(BW);
nbw = uint8(~bw);

%% Create target image mask
for i = 1 : 3
    bg(:,:) = D(:,:,i).*nbw;
end
figure, imshow(bg); title('Background');

BG = zeros(size(bg,1),size(bg,2),3);
for i = 1 : size(bg,1)
    for j = 1 : size(bg,2)
        if bg(i,j) ~= 0
           BG(i,j,1)=D_r(i,j);
           BG(i,j,2)=D_g(i,j);
           BG(i,j,3)=D_b(i,j);
        end
    end
end
figure, imshow(uint8(BG)); title('Background - with color');

%% Read the source image to be inserted

new1 = imread('2.jpg');
new1 = imresize(new1,[size(D,1) size(D,2)]);

% Perform translation, rotation or transformation as per requirement
new2 = imtranslate(new1,[200,00]); %200,0 for canvas, 0,-30 for hotballoon
new2_r = new2(:,:,1);new2_g = new2(:,:,2);new2_b = new2(:,:,3);

figure, imshow(new1); title('To be inserted'); 
figure, imshow(new2); title('Translated');

%% Form the target image mask
for i = 1 : 3
     fg(:,:) = new2(:,:,i).*bw;
end
figure, imshow(fg);

FG = zeros(size(fg,1),size(fg,2),3);
for i = 1 : size(fg,1)
    for j = 1 : size(fg,2)
        if fg(i,j) ~= 0
           FG(i,j,1)=new2_r(i,j);
           FG(i,j,2)=new2_g(i,j);
           FG(i,j,3)=new2_b(i,j);
        end
    end
end
figure, imshow(uint8(FG)); 

%% Final image: Source image inserted into the target image
figure, imshow(uint8(FG)+uint8(BG));

