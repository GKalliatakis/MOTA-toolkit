%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% Eigen Background (EB) Approach
% ----------------------
% Background Subtraction
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

%% LOAD THE IMAGES
%=======================

% Give image directory and extension
%imPath = 'car'; imExt = 'jpg';
imPath = 'highway'; imExt = 'jpg';

% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname);
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);


ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    image = imread(imgname);
    image=rgb2gray(image);
    image = im2double(image);
    
    b(i,:) = image(:);
    ImSeq(:,:,i) = image;
    fprintf('Remaining Images: %d\n', NumImages-i);
end
disp(' ... OK!');

%%
aviobj = avifile('EigenBackgroundHighway.avi','compression','None');
fig=figure;
c = b';
mean = sum(b)/NumImages; % Calculating mean image
meanim = reshape(mean,VIDEO_HEIGHT,VIDEO_WIDTH); % Mean image
pause(0.25);
subplot(2,3,1)
imshow(meanim);
title('Mean Image');

%The mean-normalized image vectors are then put as column of a matrix X:
for i = 1:NumImages
    
    X(:,i) = c(:,i) - mean';
    fprintf('Remaining Images: %d\n', NumImages-i);
end

% calculate SVD (taking svds in order to save memory and take only 6 columns)
[U S V] = svds(X); %U & V are orthogonal matrices and S is diagonal matrix with singular values, in decreasing order, in its diagonal.
Uk = U(:,2); 
size_of_img = ImSeq(:,:,1);
[rows,cols] = size(size_of_img);
T = 0.15; % Thresholding 


%%
for i = 1:400
input = ImSeq(:,:,i);
input = input(:);
p = Uk'*(input - mean');
y_bar = Uk * p + mean'; % Projecting image onto the reduced subspace as
im = reshape(y_bar,rows,cols);
pause(0.5);
subplot(2,3,2)
imshow(mat2gray(im),[]);
title('Projected Image');


diff = abs(input-y_bar);
diffre = reshape(diff,rows,cols);
pause(0.25);
subplot(2,3,4)
imshow(mat2gray(diffre),[]);
title('Difference of input and projected image');


%by computing and thresholding the absolute difference between the input image and the projected image, 
%we can detect moving objects in the scene:
%diff(diff > T) = 0;
diffThresholded=diff > T;
Tdiff = reshape(diffThresholded,rows,cols);

pause(0.25);
subplot(2,3,5)
imshow(mat2gray(Tdiff),[]);
title('Difference of input and projected image with threshold');



currentimg = double(ImSeq(:,:,i));
diffimg = zeros(VIDEO_WIDTH,VIDEO_HEIGHT);
diffimg = (abs(currentimg-meanim)>T); % Difference between current image and eigenbackground image


        label_img = logical(diffimg); % getting label image
        prop = regionprops(label_img,'basic'); % Getting properties of image
        [pr pc] = size(prop);
        
            % Getting lowest area around object
          for pc = 1:pr
            if prop(pc).Area > prop(1).Area
               temp_img = prop(1);
               prop(1) = prop(pc);
               prop(pc) = temp_img;
            end 
         end
    
    
         % Getting bounding box
         bounding_boxb = prop(1).BoundingBox;
         xcorner = bounding_boxb(1);
         ycorner = bounding_boxb(2);
         x_width = bounding_boxb(3);
         y_width = bounding_boxb(4);
         center = prop(1).Centroid;
         xc(i) = center(1);
         yc(i) = center(2);
        
         subplot(2,3,6)
         imshow(ImSeq(:,:,i),[]);
         title('Moving Object with Bounding Box ');
         hold on
        

         rectangle('Position',bounding_boxb,'EdgeColor','r','LineWidth',2);
         hold on
         plot(xc(i),yc(i),'bx','LineWidth',1);
         pause(0.25);
         F = getframe(fig);
         aviobj = addframe(aviobj,F);


end
 aviobj = close(aviobj);

































