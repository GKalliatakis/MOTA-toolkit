%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Moving Object Tracking Algorithms (MOTA) evaluation toolkit 
% 
% ----------------------
% Mean SHIFT
% ----------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function k = compute_bhattacharyya_coefficient(p,q)
k=sum(sqrt(p.*q));
end