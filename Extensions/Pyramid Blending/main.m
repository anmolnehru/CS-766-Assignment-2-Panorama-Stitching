% Implemented by: Rosaleena Mohanty
% Calls functions that analyze an image at multiple pyramid levels

close all;
clear all;
clc;


%% Read the 2 input images to be blended

imga = im2double(imread('3.jpg'));
imgb = im2double(imread('2.jpg')); 
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);
[M N ~] = size(imga);

% Set the level of blending
v = 500; %230 for apple-orange, 500 for starry sky
level = 6;
limga = generate(imga,'lap',level); % the Laplacian pyramid
limgb = generate(imgb,'lap',level);

% Form the mask
maska = zeros(size(imga));
maska(:,1:v,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',100,15); 
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

% blended pyramid
limgo = cell(1,level); 
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = reconstruct(limgo);
figure,imshow(imgo) 
