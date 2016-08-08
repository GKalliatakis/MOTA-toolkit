%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% ----------------------
% Mean SHIFT
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function weights = compute_weights(imPatch, qTarget, pCurrent, Nbins)
% The outputs are the weight mask weights for the gradient ascent

imPatchSizeOfx=size(imPatch,1);
imPatchSizeOfy=size(imPatch,2);
binsize = 256/Nbins;
weights = zeros(imPatchSizeOfx,imPatchSizeOfy);

    for i=1:imPatchSizeOfx
        for j=1:imPatchSizeOfy        

            
              index= floor(imPatch(i,j)/binsize)+1;

              weights(i,j) = weights(i,j)+ sqrt(qTarget(index)/pCurrent(index));

        end
    end

end



