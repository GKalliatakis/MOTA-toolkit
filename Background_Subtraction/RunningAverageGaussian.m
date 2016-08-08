%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% Running Average Gaussian (RGA) Approach
% ----------------------
% Background Subtraction
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all


%%%%% LOAD THE IMAGES
%=======================

% Give image directory and extension
 %imPath = 'car'; imExt = 'jpg';
imPath = 'highway/input'; imExt = 'jpg';

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
    ImSeq(:,:,i) = rgb2gray(imread(imgname)); % load image
end
disp(' ... OK!');

%% Initialization
threshold=2.5;
alpha=0.01;
mean_image=ImSeq(:,:,1);  %current
sigma_image=2*ones(size(ImSeq(:,:,1))); %initialize sigma to 2 for all pixels
aviobj = avifile('RunningAverageGaussian.avi','compression','None');% to create an .avi from image sequence
fig=figure;

%% Update Loop
for k = 2:NumImages
  I = ImSeq(:,:,k); %get current image
  
  %update the mean image
  mean_image=alpha*I+(1-alpha)*mean_image;

  
  %update the sigma image
  d=abs(I-mean_image);
  sigma_image=alpha*d.^2+(1-alpha)*sigma_image;
  
  %detect foreground
  foreground=d>threshold*sqrt(sigma_image);
  
%   
% se = strel('square', 2); %erosion to improve image
% foreground = imerode(foreground, se);


  
  
  
        label_img = logical(foreground); % getting label image
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
         xc(k) = center(1);
         yc(k) = center(2);
         

  
  
  
  
  subplot(2,2,1)
  imshow(I,[]);
  title('Current Frame');
  
   subplot(2,2,2)
   imshow(mat2gray(mean_image));
   title('Estimated background');
  
  
  subplot(2,2,3)
  imshow(foreground,[]);
  title('Detected Moving Object');
   
   subplot(2,2,4)
   imshow(ImSeq(:,:,k),[]);
   title('Moving Object with Bounding Box ');        

   rectangle('Position',bounding_boxb,'EdgeColor','r','LineWidth',2);
   hold on
   plot(xc(k),yc(k),'bx','LineWidth',1);

   
  pause(0.25);
      F = getframe(fig);
    aviobj = addframe(aviobj,F);

end
  aviobj = close(aviobj);



   



























