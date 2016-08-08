%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% ----------------------
% Mean SHIFT
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

%% read images
imPath = 'car'; imExt = 'jpg';
%imPath = 'highway/input'; imExt = 'jpg';


%%%%% LOAD THE IMAGES
%=======================
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
    ImSeq(:,:,i) = imread(imgname); % load image
    %ImSeq(:,:,i) = rgb2gray(imread(imgname)); % load image
%    tmp=rgb2hsv(imread(imgname));
 %   ImSeq(:,:,i) = tmp(:,:,1);

    
end
disp(' ... OK!');


%%%%% INITIALIZE THE TRACKER
%=======================

% HERE YOU HAVE TO INITIALIZE YOUR TRACKER WITH THE POSITION OF THE OBJECT IN THE FIRST FRAME

% You can use Background subtraction or a manual initialization!
% For manual initialization use the function imcrop

%tracker initialization with 1st frame
 first_frame=ImSeq(:,:,1);
% first_frame=cat(3,ImSeq_R(:,:,1),ImSeq_G(:,:,1),ImSeq_B(:,:,1));

figure(1);
 %[patch,rect]=imcrop(first_frame); %initialize the tracker manually

[patch,rect]=imcrop(first_frame./255); %initialize the tracker manually
% figure,imshow(patch,[]);


% DEFINE A BOUNDING BOX AROUND THE OBTAINED REGION : this gives the initial state

% Get ROI Parameters


ROI_Center = round([rect(1)+rect(3)/2, rect(2)+rect(4)/2]);
ROI_Width = round(rect(3));
ROI_Height = round(rect(4));



%% MEANSHIFT TRACKING
%=======================

%% FIRST, YOU NEED TO DEFINE THE COLOR MODEL OF THE OBJECT

% compute target object color probability distribution given the center and size of the ROI
% figuimPatch = extract_image_patch_center_size(first_frame, ROI_Center, ROI_Width, ROI_Height);
% figure,imshow(figuimPatch);
imPatch = extract_image_patch_center_size(first_frame, ROI_Center, ROI_Width, ROI_Height);
%figure,imshow(imPatch,[]);

% color distribution in RGB color space
Nbins = 8;
TargetModel = color_distribution(imPatch, Nbins);


%% Mean-Shift Algorithm
prev_center = ROI_Center; % set the location to the previous one 
%figure;
%aviobj = avifile('Football NO local z.avi','compression','None');

for n = 2:NumImages
    
    % get next frame
     I = ImSeq(:,:,n);

    fprintf('Frame: %d out of %d \n',n,NumImages);

    while(1)
    	% STEP 1
    	% calculate the pdf of the previous position
    	imPatch = extract_image_patch_center_size(I, prev_center, ROI_Width, ROI_Height);
    	ColorModel = color_distribution(imPatch, Nbins);

        
    
    	% evaluate the Bhattacharyya coefficient
     	rho_0 = compute_bhattacharyya_coefficient(TargetModel, ColorModel);
    
    	% STEP 2
    	% derive the weights
    	weights = compute_weights(imPatch, TargetModel, ColorModel, Nbins);
    
    	% STEP 3
    	% compute the mean-shift vector
    	% using Epanechnikov kernel, it reduces to a weighted average
        z = compute_meanshift_vector(imPatch, prev_center, weights);
    
    	new_center = z;
            
    	% STEP 4, 5
        %% STEP 4 and 5 should be here !!
        while(1)
            
        imPatch_z = extract_image_patch_center_size(I, new_center, ROI_Width, ROI_Height);
    	ColorModel_z = color_distribution(imPatch_z, Nbins);
        

%% testing code for varying size
%         imPatch_test2=imPatch_z*1.1;
%         imPatch_test3=imPatch_z*0.9;
%         
%         ColorModel_test2 = color_distribution(imPatch_test2, Nbins);
%         ColorModel_test3 = color_distribution(imPatch_test3, Nbins);

%%
    	% evaluate the Bhattacharyya coefficient
     	rho_0_z = compute_bhattacharyya_coefficient(TargetModel, ColorModel_z);
        
        
%         rho_0_test2 = compute_bhattacharyya_coefficient(TargetModel, ColorModel_test2);
%         rho_0_test3 = compute_bhattacharyya_coefficient(TargetModel, ColorModel_test3);
%         
%         Hm=round(-min(-[rho_0_z,rho_0_test2,rho_0_test3]));
%         ROI_Width=round((ROI_Width*0.9)+(0.1*Hm));
%         ROI_Height=round((ROI_Height*0.9)+(0.1*Hm));
        
        %Step 5
        if  rho_0_z >= rho_0
            break
        end
        
        new_center=0.5*(prev_center+new_center);
     
        end
        
        
        %STEP 6
        if norm(new_center-prev_center, 1) < 0.0001
       		break
        end
                
    	prev_center = new_center;

    end
	
% Show your tracking results
figure(1);
hold on,
imshow(I,[]);



% title('TRACKING RESULTS for Kx = 0.5*Cd^(-1)*(d + 2)*(1-abs(x)^2)','fontweight','bold','fontsize',16);
title('TRACKING RESULTS CAR SEQUENCE LOCAL Z','fontweight','bold','fontsize',14);
% hold on
        

newRect=[prev_center(1)-ROI_Width/2,prev_center(2)-ROI_Height/2,ROI_Width,ROI_Height];

rectangle('Position',newRect,'EdgeColor','b','LineWidth',2);
% hold on
plot(new_center(1),new_center(2),'bx','LineWidth',1);

pause(0.01);

% F = getframe(figure(1));
% aviobj = addframe(aviobj,F);
hold off
end
% aviobj = close(aviobj);



