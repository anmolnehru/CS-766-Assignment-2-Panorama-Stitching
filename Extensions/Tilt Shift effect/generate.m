% Generate Gaussian or Laplacian pyramid
% Implemented by: Rosaleena Mohanty

function [ pyr ] = generate( img, type, level )

pyr = cell(1,level);
pyr{1} = im2double(img);
for p = 2:level
	pyr{p} = reduction(pyr{p-1});
end
if strcmp(type,'gauss'), return; end

for p = level-1:-1:1 % adjust the image size
	osz = size(pyr{p+1})*2-1;
	pyr{p} = pyr{p}(1:osz(1),1:osz(2),:);
end

for p = 1:level-1
	pyr{p} = pyr{p}-expansion(pyr{p+1});
end

end