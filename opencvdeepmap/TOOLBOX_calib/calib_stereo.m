% calib_stereo
% Script for Calibrating a stereo rig (two cameras, internal and external calibration):
%
% It is assumed that the two cameras (left and right) have been calibrated with the pattern at the same 3D locations, and the same points
% on the pattern (select the same grid points). Therefore, in particular, the same number of images were used to calibrate both cameras.
% The two calibration result files must have been saved under Calib_Results_left.mat and Calib_Results_right.mat prior to running this script.
% This script is not fully documented, therefore use it at your own risks. However, it should be rather straighforward to run.
%
% INPUT: Calib_Results_left.mat, Calib_Results_right.mat -> Generated by the standard calibration toolbox on the two cameras individually)
% OUTPUT: Calib_Results_stereo.mat -> The saved result after global stereo calibration
% 
% Main result variables stored in Calib_Results_stereo.mat:
% om, R, T: relative rotation and translation of the right camera wrt the left camera
% fc_left, cc_left, kc_left, alpha_c_left, KK_left: New intrinsic parameters of the left camera
% fc_right, cc_right, kc_right, alpha_c_right, KK_right: New intrinsic parameters of the right camera
% 
% Both sets of intrinsic parameters are equivalent to the classical {fc,cc,kc,alpha_c,KK} described online at:
% http://www.vision.caltech.edu/bouguetj/calib_doc/parameters.html
%
% Note: If you do not want to recompute the intinsic parameters, through stereo calibration you may want to set
% recompute_intrinsic_right and recompute_intrinsic_left to zero. Default: 1
%
% Definition of the extrinsic parameters: R and om are related through the rodrigues formula (R=rodrigues(om)).
% Consider a point P of coordinates XL and XR in the left and right camera reference frames respectively.
% XL and XR are related to each other through the following rigid motion transformation:
% XR = R * XL + T
% R and T (or equivalently om and T) fully describe the relative displacement of the two cameras.
%
%
% If the Warning message "Disabling view kk - Reason: the left and right images are found inconsistent" is encountered, that probably
% means that for the kkth pair of images, the left and right images are found to have captured the calibration pattern at two
% different locations in space. That means that the two views are not consistent, and therefore cannot be used for stereo calibration.
% When capturing your images, make sure that you do not move the calibration pattern between capturing the left and the right images.
% The pattwern can (and should) be moved in space only between two sets of (left,right) images.
% Another reason for inconsistency is that you selected a different set of points on the pattern when running the separate calibrations
% (leading to the two files Calib_Results_left.mat and Calib_Results_left.mat). Make sure that the same points are selected in the
% two separate calibration. In other words, the points need to correspond.

% (c) Jean-Yves Bouguet - Intel Corporation
% October 25, 2001 -- Last updated April 12, 2002


fprintf(1,'\n\nStereo Calibration script (for more info, try help calib_stereo)\n\n');

if (exist('Calib_Results_new_left.mat')~=2)|(exist('Calib_Results_new_rigth.mat')~=2),
    fprintf(1,'Error: Need the left and right calibration files Calib_Results_left.mat and Calib_Results_right.mat to run stereo calibration\n');
    return;
end;

if ~exist('recompute_intrinsic_right'),
    recompute_intrinsic_right = 1;
end;


if ~exist('recompute_intrinsic_left'),
    recompute_intrinsic_left = 1;
end;

fprintf(1,'Loading the left camera calibration result file Calib_Results_left.mat...\n');

clear calib_name

load Calib_Results_left;

fc_left = fc;
cc_left = cc;
kc_left = kc;
alpha_c_left = alpha_c;
KK_left = KK;

if exist('calib_name'),
    calib_name_left = calib_name;
    format_image_left = format_image;
    type_numbering_left = type_numbering;
    image_numbers_left = image_numbers;
    N_slots_left = N_slots;
else
    calib_name_left = '';
    format_image_left = '';
    type_numbering_left = '';
    image_numbers_left = '';
    N_slots_left = '';
end;

    
X_left = [];


om_left_list = [];
T_left_list = [];

for kk = 1:n_ima,
   
   if active_images(kk),
      
      eval(['Xkk = X_' num2str(kk) ';']);
      eval(['omckk = omc_' num2str(kk) ';']);
      eval(['Rckk = Rc_' num2str(kk) ';']);
      eval(['Tckk = Tc_' num2str(kk) ';']);
      
      N = size(Xkk,2);
      
      Xckk = Rckk * Xkk  + Tckk*ones(1,N);
      
      X_left = [X_left Xckk];

      om_left_list = [om_left_list omckk];
      
      T_left_list = [T_left_list Tckk];
      
  end;
end;



fprintf(1,'Loading the right camera calibration result file Calib_Results_right.mat...\n');

clear calib_name

load Calib_Results_right;

fc_right = fc;
cc_right = cc;
kc_right = kc;
alpha_c_right = alpha_c;
KK_right = KK;

if exist('calib_name'),
    calib_name_right = calib_name;
    format_image_right = format_image;
    type_numbering_right = type_numbering;
    image_numbers_right = image_numbers;
    N_slots_right = N_slots;
else
    calib_name_right = '';
    format_image_right = '';
    type_numbering_right = '';
    image_numbers_right = '';
    N_slots_right = '';
end;

X_right = [];

om_right_list = [];
T_right_list = [];

for kk = 1:n_ima,
   
   if active_images(kk),
      
      eval(['Xkk = X_' num2str(kk) ';']);
      eval(['omckk = omc_' num2str(kk) ';']);
      eval(['Rckk = Rc_' num2str(kk) ';']);
      eval(['Tckk = Tc_' num2str(kk) ';']);
      
      N = size(Xkk,2);
      
      Xckk = Rckk * Xkk  + Tckk*ones(1,N);
      
      X_right = [X_right Xckk];
      
      om_right_list = [om_right_list omckk];
      T_right_list = [T_right_list Tckk];
      
   end;
end;




om_ref_list = [];
T_ref_list = [];
for ii = 1:length(om_left_list),
    % Align the structure from the first view:
    R_ref = rodrigues(om_right_list(:,ii)) * rodrigues(om_left_list(:,ii))';
    T_ref = T_right_list(:,ii) - R_ref * T_left_list(:,ii);
    om_ref = rodrigues(R_ref);
    om_ref_list = [om_ref_list om_ref];
    T_ref_list = [T_ref_list T_ref];
end;


% Robust estimate of the initial value for rotation and translation between the two views:
om = median(om_ref_list')';
T = median(T_ref_list')';




if 0,
    figure(10);
    plot3(X_right(1,:),X_right(2,:),X_right(3,:),'bo');
    hold on;
    [Xr2] = rigid_motion(X_left,om,T);
    plot3(Xr2(1,:),Xr2(2,:),Xr2(3,:),'r+');
    hold off;
    drawnow;
end;


R = rodrigues(om);



% Re-optimize now over all the set of extrinsic unknows (global optimization) and intrinsic parameters:

load Calib_Results_left;

for kk = 1:n_ima,
   if active_images(kk),
      eval(['X_left_'  num2str(kk) ' = X_' num2str(kk) ';']);
      eval(['x_left_'  num2str(kk) ' = x_' num2str(kk) ';']);
      eval(['omc_left_' num2str(kk) ' = omc_' num2str(kk) ';']);
      eval(['Rc_left_' num2str(kk) ' = Rc_' num2str(kk) ';']);
      eval(['Tc_left_' num2str(kk) ' = Tc_' num2str(kk) ';']);
   end;
end;

center_optim_left = center_optim;
est_alpha_left = est_alpha;
est_dist_left = est_dist;
est_fc_left = est_fc;
est_aspect_ratio_left = est_aspect_ratio;
active_images_left = active_images;


load Calib_Results_right;

for kk = 1:n_ima,
   if active_images(kk),
      eval(['X_right_'  num2str(kk) ' = X_' num2str(kk) ';']);
      eval(['x_right_'  num2str(kk) ' = x_' num2str(kk) ';']);
   end;
end;

center_optim_right = center_optim;
est_alpha_right = est_alpha;
est_dist_right = est_dist;
est_fc_right = est_fc;
est_aspect_ratio_right = est_aspect_ratio;
active_images_right = active_images;




if ~recompute_intrinsic_left,
    fprintf(1,'No recomputation of the intrinsic parameters of the left camera (recompute_intrinsic_left = 0)\n');
    center_optim_left = 0;
    est_alpha_left = 0;
    est_dist_left = zeros(5,1);
    est_fc_left = [0;0];
    est_aspect_ratio_left = 1; % just to fix conflicts
end;

if ~recompute_intrinsic_right,
    fprintf(1,'No recomputation of the intrinsic parameters of the right camera (recompute_intrinsic_left = 0)\n');
    center_optim_right = 0;
    est_alpha_right = 0;
    est_dist_right = zeros(5,1);
    est_fc_right = [0;0];
    est_aspect_ratio_right = 1; % just to fix conflicts
end;




threshold = 50; %1e10; %50; 

active_images = active_images_left & active_images_right;

history = [];

fprintf(1,'\nMain stereo calibration optimization procedure - Number of pairs of images: %d\n',length(find(active_images)));
fprintf(1,'Gradient descent iteration: ');
    
for iter = 1:12;
    
    
    fprintf(1,'%d...',iter);
    
    % Jacobian:
    
    J = [];
    e = [];
    
    param = [fc_left;cc_left;alpha_c_left;kc_left;fc_right;cc_right;alpha_c_right;kc_right;om;T];
    
    
    for kk = 1:n_ima,
        
        if active_images(kk),
            
            % Project the structure onto the left view:
            
            eval(['Xckk = X_left_' num2str(kk) ';']);
            eval(['omckk = omc_left_' num2str(kk) ';']);
            eval(['Tckk = Tc_left_' num2str(kk) ';']);
            
            eval(['xlkk = x_left_' num2str(kk) ';']);
            eval(['xrkk = x_right_' num2str(kk) ';']);
            
            param = [param;omckk;Tckk];
            
            % number of points:
            Nckk = size(Xckk,2);
            
            
            Jkk = sparse(4*Nckk,20+(1+n_ima)*6);
            ekk = zeros(4*Nckk,1);
            
            
            if ~est_aspect_ratio_left,
                [xl,dxldomckk,dxldTckk,dxldfl,dxldcl,dxldkl,dxldalphal] = project_points2(Xckk,omckk,Tckk,fc_left(1),cc_left,kc_left,alpha_c_left);
                dxldfl = repmat(dxldfl,[1 2]);
            else
                [xl,dxldomckk,dxldTckk,dxldfl,dxldcl,dxldkl,dxldalphal] = project_points2(Xckk,omckk,Tckk,fc_left,cc_left,kc_left,alpha_c_left);
            end;
        
            
            ekk(1:2*Nckk) = xlkk(:) - xl(:);
            
            Jkk(1:2*Nckk,6*(kk-1)+7+20:6*(kk-1)+7+2+20) = sparse(dxldomckk);
            Jkk(1:2*Nckk,6*(kk-1)+7+3+20:6*(kk-1)+7+5+20) = sparse(dxldTckk);
            
            Jkk(1:2*Nckk,1:2) = sparse(dxldfl);
            Jkk(1:2*Nckk,3:4) = sparse(dxldcl);
            Jkk(1:2*Nckk,5) = sparse(dxldalphal);
            Jkk(1:2*Nckk,6:10) = sparse(dxldkl);
            
            
            % Project the structure onto the right view:
            
            [omr,Tr,domrdomckk,domrdTckk,domrdom,domrdT,dTrdomckk,dTrdTckk,dTrdom,dTrdT] = compose_motion(omckk,Tckk,om,T);
            
            if ~est_aspect_ratio_right,
                [xr,dxrdomr,dxrdTr,dxrdfr,dxrdcr,dxrdkr,dxrdalphar] = project_points2(Xckk,omr,Tr,fc_right(1),cc_right,kc_right,alpha_c_right);
                dxrdfr = repmat(dxrdfr,[1 2]);
            else
                [xr,dxrdomr,dxrdTr,dxrdfr,dxrdcr,dxrdkr,dxrdalphar] = project_points2(Xckk,omr,Tr,fc_right,cc_right,kc_right,alpha_c_right);
            end;
            
            
            ekk(2*Nckk+1:end) = xrkk(:) - xr(:);
            
            
            dxrdom = dxrdomr * domrdom + dxrdTr * dTrdom;
            dxrdT = dxrdomr * domrdT + dxrdTr * dTrdT;
            
            dxrdomckk = dxrdomr * domrdomckk + dxrdTr * dTrdomckk;
            dxrdTckk = dxrdomr * domrdTckk + dxrdTr * dTrdTckk;
            
            
            Jkk(2*Nckk+1:end,1+20:3+20) =  sparse(dxrdom);
            Jkk(2*Nckk+1:end,4+20:6+20) =  sparse(dxrdT);
            
            
            Jkk(2*Nckk+1:end,6*(kk-1)+7+20:6*(kk-1)+7+2+20) = sparse(dxrdomckk);
            Jkk(2*Nckk+1:end,6*(kk-1)+7+3+20:6*(kk-1)+7+5+20) = sparse(dxrdTckk);
            
            Jkk(2*Nckk+1:end,11:12) = sparse(dxrdfr);
            Jkk(2*Nckk+1:end,13:14) = sparse(dxrdcr);
            Jkk(2*Nckk+1:end,15) = sparse(dxrdalphar);
            Jkk(2*Nckk+1:end,16:20) = sparse(dxrdkr);
            
            
            emax = max(abs(ekk));
            
            if emax < threshold,
                
                J = [J;Jkk];
                e = [e;ekk];           
                
            else
                
                fprintf(1,'Disabling view %d - Reason: the left and right images are found inconsistent (try help calib_stereo for more information)\n',kk);
                
                active_images(kk) = 0;
                
            end;
            
        else
            
            param = [param;NaN*ones(6,1)];
            
        end;
        
    end;
    
    history = [history param];
    
    ind_Jac = find([est_fc_left & [1;est_aspect_ratio_left];center_optim_left*ones(2,1);est_alpha_left;est_dist_left;est_fc_right & [1;est_aspect_ratio_right];center_optim_right*ones(2,1);est_alpha_right;est_dist_right;ones(6,1);reshape(ones(6,1)*active_images,6*n_ima,1)]);
    
    ind_active = find(active_images);
    
    J = J(:,ind_Jac);
    J2 = J'*J;
    J2_inv = inv(J2);
    
    param_update = J2_inv*J'*e;
    
    
    param(ind_Jac) = param(ind_Jac) + param_update;
    
    fc_left = param(1:2);
    cc_left = param(3:4);
    alpha_c_left = param(5);
    kc_left = param(6:10);
    fc_right = param(11:12);
    cc_right = param(13:14);
    alpha_c_right = param(15);
    kc_right = param(16:20);
    
    
    if ~est_aspect_ratio_left,
        fc_left(2) = fc_left(1);
    end;
    if ~est_aspect_ratio_right,
        fc_right(2) = fc_right(1);
    end;
    
    
    om = param(1+20:3+20);
    T = param(4+20:6+20);
    
    
    for kk = 1:n_ima;
        
        if active_images(kk),
            
            omckk = param(6*(kk-1)+7+20:6*(kk-1)+7+2+20);
            Tckk = param(6*(kk-1)+7+3+20:6*(kk-1)+7+5+20);
            
            eval(['omc_left_' num2str(kk) ' = omckk;']);
            eval(['Tc_left_' num2str(kk) ' = Tckk;']);
            
        end;
        
    end;
    
    
end;

fprintf(1,'done\n');


history = [history param];

inconsistent_images = ~active_images & (active_images_left & active_images_right);


sigma_x = std(e(:));
param_error = zeros(20 + (1+n_ima)*6,1);
param_error(ind_Jac) =  3*sqrt(full(diag(J2_inv)))*sigma_x;

for kk = 1:n_ima;
    
    if active_images(kk),
        
        omckk_error = param_error(6*(kk-1)+7+20:6*(kk-1)+7+2+20);
        Tckk = param_error(6*(kk-1)+7+3+20:6*(kk-1)+7+5+20);
        
        eval(['omc_left_error_' num2str(kk) ' = omckk;']);
        eval(['Tc_left_error_' num2str(kk) ' = Tckk;']);
        
    else
        
        eval(['omc_left_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['Tc_left_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['omc_left_error_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['Tc_left_error_' num2str(kk) ' = NaN*ones(3,1);']);
        
    end;
    
end;

fc_left_error = param_error(1:2);
cc_left_error = param_error(3:4);
alpha_c_left_error = param_error(5);
kc_left_error = param_error(6:10);
fc_right_error = param_error(11:12);
cc_right_error = param_error(13:14);
alpha_c_right_error = param_error(15);
kc_right_error = param_error(16:20);

if ~est_aspect_ratio_left,
    fc_left_error(2) = fc_left_error(1);
end;
if ~est_aspect_ratio_right,
    fc_right_error(2) = fc_right_error(1);
end;


om_error = param_error(1+20:3+20);
T_error = param_error(4+20:6+20);


KK_left = [fc_left(1) fc_left(1)*alpha_c_left cc_left(1);0 fc_left(2) cc_left(2); 0 0 1];
KK_right = [fc_right(1) fc_right(1)*alpha_c_right cc_right(1);0 fc_right(2) cc_right(2); 0 0 1];


R = rodrigues(om);



fprintf(1,'\n\nIntrinsic parameters of left camera:\n\n');
fprintf(1,'Focal Length:          fc_left = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[fc_left;fc_left_error]);
fprintf(1,'Principal point:       cc_left = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[cc_left;cc_left_error]);
fprintf(1,'Skew:             alpha_c_left = [ %3.5f ] ?[ %3.5f  ]   => angle of pixel axes = %3.5f ?%3.5f degrees\n',[alpha_c_left;alpha_c_left_error],90 - atan(alpha_c_left)*180/pi,atan(alpha_c_left_error)*180/pi);
fprintf(1,'Distortion:            kc_left = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] ?[ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc_left;kc_left_error]);   


fprintf(1,'\n\nIntrinsic parameters of right camera:\n\n');
fprintf(1,'Focal Length:          fc_right = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[fc_right;fc_right_error]);
fprintf(1,'Principal point:       cc_right = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[cc_right;cc_right_error]);
fprintf(1,'Skew:             alpha_c_right = [ %3.5f ] ?[ %3.5f  ]   => angle of pixel axes = %3.5f ?%3.5f degrees\n',[alpha_c_right;alpha_c_right_error],90 - atan(alpha_c_right)*180/pi,atan(alpha_c_right_error)*180/pi);
fprintf(1,'Distortion:            kc_right = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] ?[ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc_right;kc_right_error]);   


fprintf(1,'\n\nExtrinsic parameters (position of right camera wrt left camera):\n\n');
fprintf(1,'Rotation vector:             om = [ %3.5f   %3.5f  %3.5f ] ?[ %3.5f   %3.5f  %3.5f ]\n',[om;om_error]);
fprintf(1,'Translation vector:           T = [ %3.5f   %3.5f  %3.5f ] ?[ %3.5f   %3.5f  %3.5f ]\n',[T;T_error]);


fprintf(1,'\n\nNote: The numerical errors are approximately three times the standard deviations (for reference).\n\n')


fprintf(1,'Saving the stereo calibration results in Calib_Results_stereo.mat\n\n');

string_save = 'save Calib_Results_stereo om R T recompute_intrinsic_right recompute_intrinsic_left calib_name_left format_image_left type_numbering_left image_numbers_left N_slots_left calib_name_right format_image_right type_numbering_right image_numbers_right N_slots_right fc_left cc_left kc_left alpha_c_left KK_left fc_right cc_right kc_right alpha_c_right KK_right active_images dX dY nx ny n_ima active_images_right active_images_left inconsistent_images center_optim_left est_alpha_left est_dist_left est_fc_left est_aspect_ratio_left center_optim_right est_alpha_right est_dist_right est_fc_right est_aspect_ratio_right history param param_error sigma_x om_error T_error fc_left_error cc_left_error kc_left_error alpha_c_left_error fc_right_error cc_right_error kc_right_error alpha_c_right_error';

for kk = 1:n_ima,
    if active_images(kk),
        string_save = [string_save ' X_left_' num2str(kk)  ' omc_left_' num2str(kk) ' Tc_left_' num2str(kk) ' omc_left_error_' num2str(kk) ' Tc_left_error_' num2str(kk)  ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk)];
    end;
end;
eval(string_save);


% Plot the extrinsic parameters:
ext_calib_stereo;

