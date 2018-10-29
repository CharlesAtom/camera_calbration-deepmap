% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 809.528382959441730 ; 823.635141668650590 ];

%-- Principal point:
cc = [ 297.308217048353410 ; 270.010033810050170 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.027427163381090 ; 0.742644168769007 ; 0.006526707989360 ; -0.004557063127161 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 2.288458108403613 ; 2.386193025960774 ];

%-- Principal point uncertainty:
cc_error = [ 3.472801696740860 ; 3.157326787647464 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.020943649025215 ; 0.216002693094152 ; 0.001663397111391 ; 0.001771682714682 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 20;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -2.169456e+00 ; -2.159890e+00 ; -3.219312e-01 ];
Tc_1  = [ -1.085467e+02 ; -1.137584e+02 ; 5.474546e+02 ];
omc_error_1 = [ 3.906120e-03 ; 4.242831e-03 ; 7.749535e-03 ];
Tc_error_1  = [ 2.394977e+00 ; 2.120061e+00 ; 1.814001e+00 ];

%-- Image #2:
omc_2 = [ -1.900949e+00 ; -1.910765e+00 ; -8.022401e-01 ];
Tc_2  = [ -1.055587e+02 ; -1.205704e+02 ; 5.457578e+02 ];
omc_error_2 = [ 2.698027e-03 ; 3.975535e-03 ; 5.719259e-03 ];
Tc_error_2  = [ 2.398476e+00 ; 2.111063e+00 ; 1.887540e+00 ];

%-- Image #3:
omc_3 = [ 2.044403e+00 ; 1.888907e+00 ; -4.566126e-01 ];
Tc_3  = [ -1.019482e+02 ; -1.250603e+02 ; 6.099723e+02 ];
omc_error_3 = [ 2.891964e-03 ; 3.914876e-03 ; 6.407676e-03 ];
Tc_error_3  = [ 2.656681e+00 ; 2.343789e+00 ; 1.809873e+00 ];

%-- Image #4:
omc_4 = [ -1.968856e+00 ; -2.004226e+00 ; 8.870639e-01 ];
Tc_4  = [ -8.011458e+01 ; -1.094944e+02 ; 6.812481e+02 ];
omc_error_4 = [ 4.424680e-03 ; 2.508507e-03 ; 6.077840e-03 ];
Tc_error_4  = [ 2.960626e+00 ; 2.613881e+00 ; 1.831196e+00 ];

%-- Image #5:
omc_5 = [ 1.984494e+00 ; 1.723343e+00 ; 7.098503e-01 ];
Tc_5  = [ -8.883919e+01 ; -9.566358e+01 ; 5.192005e+02 ];
omc_error_5 = [ 4.173310e-03 ; 2.909483e-03 ; 5.433456e-03 ];
Tc_error_5  = [ 2.261589e+00 ; 1.998855e+00 ; 1.821403e+00 ];

%-- Image #6:
omc_6 = [ 1.990583e+00 ; 1.684958e+00 ; -3.877881e-01 ];
Tc_6  = [ -1.016640e+02 ; -9.645272e+01 ; 6.059971e+02 ];
omc_error_6 = [ 3.120193e-03 ; 3.684345e-03 ; 5.833414e-03 ];
Tc_error_6  = [ 2.622472e+00 ; 2.323421e+00 ; 1.798641e+00 ];

%-- Image #7:
omc_7 = [ NaN ; NaN ; NaN ];
Tc_7  = [ NaN ; NaN ; NaN ];
omc_error_7 = [ NaN ; NaN ; NaN ];
Tc_error_7  = [ NaN ; NaN ; NaN ];

%-- Image #8:
omc_8 = [ -1.855124e+00 ; -1.874009e+00 ; -1.052433e+00 ];
Tc_8  = [ -1.187102e+02 ; -8.695227e+01 ; 4.732437e+02 ];
omc_error_8 = [ 2.638276e-03 ; 4.125954e-03 ; 5.554104e-03 ];
Tc_error_8  = [ 2.073366e+00 ; 1.839852e+00 ; 1.731477e+00 ];

%-- Image #9:
omc_9 = [ 2.135587e+00 ; 1.949107e+00 ; -2.979394e-01 ];
Tc_9  = [ -1.149677e+02 ; -1.219965e+02 ; 5.808417e+02 ];
omc_error_9 = [ 3.098155e-03 ; 3.887857e-03 ; 6.906705e-03 ];
Tc_error_9  = [ 2.527627e+00 ; 2.235719e+00 ; 1.803120e+00 ];

%-- Image #10:
omc_10 = [ -1.957992e+00 ; -1.999956e+00 ; 9.721928e-01 ];
Tc_10  = [ -8.088960e+01 ; -1.154795e+02 ; 6.656027e+02 ];
omc_error_10 = [ 4.579884e-03 ; 2.402724e-03 ; 6.010509e-03 ];
Tc_error_10  = [ 2.899697e+00 ; 2.556141e+00 ; 1.777559e+00 ];

%-- Image #11:
omc_11 = [ 1.955474e+00 ; 1.643755e+00 ; 3.569076e-01 ];
Tc_11  = [ -1.413268e+02 ; -1.249661e+02 ; 5.505677e+02 ];
omc_error_11 = [ 3.639111e-03 ; 3.387872e-03 ; 5.349487e-03 ];
Tc_error_11  = [ 2.410505e+00 ; 2.136971e+00 ; 1.971681e+00 ];

%-- Image #12:
omc_12 = [ 2.078610e+00 ; 1.455275e+00 ; 5.048546e-01 ];
Tc_12  = [ -1.179840e+02 ; -9.232619e+01 ; 5.396218e+02 ];
omc_error_12 = [ 4.035182e-03 ; 2.934116e-03 ; 5.364978e-03 ];
Tc_error_12  = [ 2.345499e+00 ; 2.083307e+00 ; 1.892956e+00 ];

%-- Image #13:
omc_13 = [ -2.592226e+00 ; -1.459200e+00 ; -1.614126e-01 ];
Tc_13  = [ -1.028943e+02 ; -4.271393e+01 ; 6.412544e+02 ];
omc_error_13 = [ 5.326448e-03 ; 3.538018e-03 ; 8.446515e-03 ];
Tc_error_13  = [ 2.773028e+00 ; 2.456628e+00 ; 1.975597e+00 ];

%-- Image #14:
omc_14 = [ NaN ; NaN ; NaN ];
Tc_14  = [ NaN ; NaN ; NaN ];
omc_error_14 = [ NaN ; NaN ; NaN ];
Tc_error_14  = [ NaN ; NaN ; NaN ];

%-- Image #15:
omc_15 = [ NaN ; NaN ; NaN ];
Tc_15  = [ NaN ; NaN ; NaN ];
omc_error_15 = [ NaN ; NaN ; NaN ];
Tc_error_15  = [ NaN ; NaN ; NaN ];

%-- Image #16:
omc_16 = [ 1.522089e+00 ; 2.264777e+00 ; -1.106312e+00 ];
Tc_16  = [ -6.954064e+01 ; -1.208496e+02 ; 6.471099e+02 ];
omc_error_16 = [ 1.928557e-03 ; 4.711561e-03 ; 5.922798e-03 ];
Tc_error_16  = [ 2.816122e+00 ; 2.491805e+00 ; 1.702300e+00 ];

%-- Image #17:
omc_17 = [ 1.485085e+00 ; 2.305538e+00 ; -1.076849e+00 ];
Tc_17  = [ -8.020924e+01 ; -1.262034e+02 ; 6.522388e+02 ];
omc_error_17 = [ 1.812560e-03 ; 4.751707e-03 ; 5.955807e-03 ];
Tc_error_17  = [ 2.840517e+00 ; 2.515401e+00 ; 1.746948e+00 ];

%-- Image #18:
omc_18 = [ NaN ; NaN ; NaN ];
Tc_18  = [ NaN ; NaN ; NaN ];
omc_error_18 = [ NaN ; NaN ; NaN ];
Tc_error_18  = [ NaN ; NaN ; NaN ];

%-- Image #19:
omc_19 = [ 2.487438e+00 ; 1.785903e+00 ; -4.512122e-01 ];
Tc_19  = [ -1.586516e+02 ; -6.579204e+01 ; 6.181381e+02 ];
omc_error_19 = [ 3.200859e-03 ; 3.545453e-03 ; 7.658771e-03 ];
Tc_error_19  = [ 2.680833e+00 ; 2.393840e+00 ; 1.883081e+00 ];

%-- Image #20:
omc_20 = [ -1.659221e+00 ; -2.626238e+00 ; 4.002532e-01 ];
Tc_20  = [ -1.060745e+02 ; -1.569421e+02 ; 6.224103e+02 ];
omc_error_20 = [ 3.767339e-03 ; 3.954996e-03 ; 7.256573e-03 ];
Tc_error_20  = [ 2.717535e+00 ; 2.403961e+00 ; 1.926127e+00 ];

