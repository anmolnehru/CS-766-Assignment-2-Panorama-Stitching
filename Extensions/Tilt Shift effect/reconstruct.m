% Uses a Laplacian pyramid to reconstruct a image
% Implemented by: Rosaleena Mohanty

function [ img ] = reconstruct( pyr )

for p = length(pyr)-1:-1:1
	pyr{p} = pyr{p}+expansion(pyr{p+1});
end
img = pyr{1};

end

