%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% ----------------------
% Mean SHIFT
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ modifiedHistogram ] = color_distribution(imPatch, Nbins)

imPatchSizeOfx=size(imPatch,1);
imPatchSizeOfy=size(imPatch,2);
kernel = zeros(imPatchSizeOfx,imPatchSizeOfy);


ROI_Center_x=(imPatchSizeOfx+1)/2;
ROI_Center_y=(imPatchSizeOfy+1)/2;

max_dist=sqrt(((ROI_Center_x-1)^2)+((ROI_Center_y-1)^2));


%% create the kernel for the target model
for i=1:imPatchSizeOfx
	for j=1:imPatchSizeOfy
        dist=sqrt(((ROI_Center_x)-i)^2+((ROI_Center_y)-j)^2);
        
        if dist>max_dist
            disp('FOUND ANOTHER MAX DISTANCE ! ! !');
        end
        
        normalized_dist=dist/max_dist;        
        square_normalized_dist=normalized_dist^2;
        kernel(i,j) = Ek(square_normalized_dist);    
	end
end

 


%%
%define binsize
binsize = 256/Nbins;

modifiedHistogram=zeros(1,Nbins);
n=1:Nbins;
%% create weighted histogram

for z=1:Nbins
    count=0;
    for i=1:imPatchSizeOfx
        for j=1:imPatchSizeOfy        
            if ceil(imPatch(i,j)/binsize)==z
                count=count+kernel(i,j);
            end
        end
    end
    
    modifiedHistogram(z)=count;
end

%% Epanechnikov profile function
function epanechnikov_prof_result = Ek(x)
  Cd = pi; 
  d = 2;   %in our case, d = 2.
	
Kx = 0.5*Cd^(-1)*(d + 2)*(1-abs(x)^2);
%Kx =(2*Cd)*(1-x);

  if x < 1
      epanechnikov_prof_result = Kx; 
  else
      epanechnikov_prof_result = 0;
  end
end


end

