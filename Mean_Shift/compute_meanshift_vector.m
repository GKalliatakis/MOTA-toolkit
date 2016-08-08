%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% ----------------------
% Mean SHIFT
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function newCenter = compute_meanshift_vector(imagePatch, ROI_Center, weights)

newCenter = [0 0];
sizeWeights = size(weights);
sizeImagePatch=size(imagePatch);
numer=[];
denom=[];

for i=1 : sizeImagePatch(1)
    for j=1 : sizeImagePatch(2)
        numer=[numer;[i,j]*weights(i,j)];
        denom=[denom;weights(i,j)];
    end
end
localz=round(sum(numer)/sum(denom));
newCenter=localz;
vector=localz-size(imagePatch)/2;
newCenter=round(vector)+ROI_Center;



end
