%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% ----------------------
% Mean SHIFT
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [imPatch] = extract_image_patch_center_size(I, ROI_Center, ROI_Width, ROI_Height)
% % This function extract an image patch in image I given the center and size of the ROI
% 
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);

y = ROI_Center(2)-ROI_Height/2;
x = ROI_Center(1)-ROI_Width/2;

r2 = round(min(VIDEO_HEIGHT, y+ROI_Height+1));
c2 = round(min(VIDEO_WIDTH, x+ROI_Width+1));
r = round(max(y, 1));
c = round(max(x, 1));
imPatch = I(r:r2, c:c2, :);
end