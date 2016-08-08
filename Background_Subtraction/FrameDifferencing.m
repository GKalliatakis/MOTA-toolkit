%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% Frame Differencing (FD) Approach
% ----------------------
% Background Subtraction
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all
%%

%%%%% LOAD THE IMAGES
%=======================

% Give image directory and extension
% imPath = 'car'; imExt = 'jpg';
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
current_img = imread(imgname);
VIDEO_WIDTH = size(current_img,2);
VIDEO_HEIGHT = size(current_img,1);

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    %ImSeq(:,:,i) = imread(imgname);% load image for car sequence
    ImSeq(:,:,i) = rgb2gray(imread(imgname));% load image for car sequence
end
disp(' ... OK!');


%%%%% INITIALIZE THE TRACKER : BACKGROUND SUBTRACTION
%=======================

% HERE YOU HAVE TO INITIALIZE YOUR TRACKER WITH THE POSITION OF THE OBJECT IN THE FIRST FRAME

% DESCRIBE HERE YOUR BACKGROUND SUBTRACTION METHOD !
disp('Performing Background Subtraction Using Frame Differencing...');




aviobj = avifile('FrameDifferencingHighway.avi','compression','None'); % to create an .avi from image sequence
fig=figure;

%% Frame Differencing
% option 1
% T = 45;
% 
%  for i = 11:NumImages;
% 	I = ImSeq(:,:,i); % current image
%  	B = median(ImSeq(:,:,i-10:i-1),3); % current background
% 	D = abs(I-B); % difference
%     
% %     se = strel('square', 5);
% %     D = imclose(D, se);
%     
%     
% 	Ob = D > T; %threshold
% 	imshow(Ob,[]);
% 
%     
%         subplot(2,2,1)
%         imshow(ImSeq(:,:,i),[]);
%         title('Current Frame'); 
%         
%         estimated_background=mat2gray(B);
%         subplot(2,2,2)
%         imshow(estimated_background);
%         title('Estimated background');
%         
%         
%         label_img = logical(Ob); % getting label image
%         prop = regionprops(label_img,'basic'); % Getting properties of image
%         [pr pc] = size(prop);
%         
%             % Getting lowest area around object
%           for pc = 1:pr
%             if prop(pc).Area > prop(1).Area
%                temp_img = prop(1);
%                prop(1) = prop(pc);
%                prop(pc) = temp_img;
%             end 
%          end
%     
%     
%          % Getting bounding box
%          bounding_boxb = prop(1).BoundingBox;
%          xcorner = bounding_boxb(1);
%          ycorner = bounding_boxb(2);
%          x_width = bounding_boxb(3);
%          y_width = bounding_boxb(4);
%          center = prop(1).Centroid;
%          xc(i) = center(1);
%          yc(i) = center(2);
%         
%          subplot(2,2,4)
%          imshow(ImSeq(:,:,i),[]);
%          title('Moving Object with Bounding Box ');
%          hold on
%         
% 
%          rectangle('Position',bounding_boxb,'EdgeColor','r','LineWidth',2);
%          hold on
%          plot(xc(i),yc(i),'bx','LineWidth',1);
%         
%         
%         subplot(2,2,3)
%         imshow(mat2gray(Ob),[]);
%         title('Detected Moving Object');
% 	    pause(0.25);
%         
% 
%     F = getframe(fig);
%     aviobj = addframe(aviobj,F);
%     
%              
%  end
% aviobj = close(aviobj);

 
 
 

%%
% option 2
threshold = 45;
background_img = ImSeq(:,:,1);

% s=0;
% for k=1:470
%     bb = median(ImSeq(:,:,k),3); 
%     s=bb+s;
% end
% aa=s/470;
% imshow(aa,[]);


a = 0.1;
for i = 2:NumImages
        current_img = ImSeq(:,:,i);
        %fig=figure;
        hold on
        subplot(2,2,1)
        imshow(ImSeq(:,:,i),[]);
        title('Current Frame'); 
        difference_img = abs(current_img-background_img);
%         
        se = strel('square', 5);
        difference_img = imclose(difference_img, se);
        
        Ob = difference_img > threshold;

        %update estimated background
         for j = 1:VIDEO_WIDTH*VIDEO_HEIGHT
             if (Ob(j) == 1)
                background_img(j) = a*current_img(j) + (1-a)*background_img(j);
             
             else
                 background_img(j) = background_img(j);

             end     

         end
         
         estimated_background=mat2gray(background_img);
         subplot(2,2,2)
         imshow(estimated_background);
         title('Estimated background');

        
        label_img = logical(Ob); % getting label image
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
        
         subplot(2,2,4)
         imshow(ImSeq(:,:,i),[]);
         title('Moving Object with Bounding Box ');
         hold on
        

         rectangle('Position',bounding_boxb,'EdgeColor','r','LineWidth',2);
         hold on
         plot(xc(i),yc(i),'bx','LineWidth',1);
        
        
        subplot(2,2,3)
        imshow(mat2gray(Ob),[]);
        title('Detected Moving Object');
        
        pause(0.25);
      F = getframe(fig);
    aviobj = addframe(aviobj,F);

end

aviobj = close(aviobj);

%%
disp(' ... OK!');




