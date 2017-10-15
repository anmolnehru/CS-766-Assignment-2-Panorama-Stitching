% Tilt-shift effect using pyramid blending
% The user has to set the area of interest around the object and blend the
% original image with the blurred one by setting appropriate values of 'v'
% Implemented by: Rosaleena Mohanty

close all;
clear all;
clc;


%% Read input image
a = im2double(imread('bean2.jpg')); %or 'c.jpg'

%Blur Input Image
H = fspecial('disk',20);
b = imfilter(a,H,'replicate');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% UPPER LIMIT
imga = b;
imgb = a;
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);
[M N ~] = size(imga);

v = 322;    %150 for capitol, 322 for bean
level = 1; %5 for capitol, 1 for bean
limga = generate(imga,'lap',level); % the Laplacian pyramid
limgb = generate(imgb,'lap',level);

maska = zeros(size(imga));
maska(1:v,:,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',150,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = reconstruct(limgo);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOWER LIMIT

imga = b;
imgb = imgo;
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);
[M N ~] = size(imga);

v = 781;    % 501 for capitol, 781 for bean
level = 1; % 5 for capitol, 1 for bean
limga = generate(imga,'lap',level); % the Laplacian pyramid
limgb = generate(imgb,'lap',level);

maska = zeros(size(imga));
maska(v:end,:,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',150,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = reconstruct(limgo);
figure,imshow(imgo) % blend by pyramid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LEFT LIMIT

imga = b;
imgb = imgo;
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);
[M N ~] = size(imga);

v = 230;    
level = 1; % 5 for capitol, 1 for bean
limga = generate(imga,'lap',level); % the Laplacian pyramid
limgb = generate(imgb,'lap',level);

maska = zeros(size(imga));
maska(:,1:v,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',150,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = reconstruct(limgo);
figure,imshow(imgo) % blend by pyramid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RIGHT LIMIT
imga = b;
imgb = imgo;
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);
[M N ~] = size(imga);

v = 1580;
level = 1; % 5 for capitol, 1 for bean
limga = generate(imga,'lap',level); % the Laplacian pyramid
limgb = generate(imgb,'lap',level);

maska = zeros(size(imga));
maska(:,v:end,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',150,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = reconstruct(limgo);
figure,imshow(imgo) % blend by pyramid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enhance the saturation values of the final image
HSV = rgb2hsv(imgo);

% "20% more" saturation:
HSV(:, :, 2) = HSV(:, :, 2) * 1.8;
% or add:
% HSV(:, :, 2) = HSV(:, :, 2) + 0.05;
HSV(HSV > 1) = 1;  % Limit values

% Final tilt-shifted image
TS = hsv2rgb(HSV);
figure, imshow(TS);
