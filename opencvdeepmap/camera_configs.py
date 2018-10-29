import cv2
import numpy as np

left_camera_matrix = np.array([[843.69689, 0., 294.91139],
                               [0., 839.58658, 244.02404],
                               [0., 0., 1.]])
left_distortion = np.array([[0.38090,-1.61806,-0.00133,-0.02425,0.00000]])



right_camera_matrix = np.array([[820.98993, 0., 292.32520],
                                [0., 815.54828, 254.30046],
                                [0., 0., 1.]])
right_distortion = np.array([[0.02374,0.38933,0.00109, -0.00664, 0.00000]])

om = np.array([-0.00326,0.01020,-0.00009]) # 旋转关系向量
R = cv2.Rodrigues(om)[0]  # 使用Rodrigues变换将om变换为R
T = np.array([-78.60203,-1.01853,-11.00672]) # 平移关系向量

size = (640, 480) # 图像尺寸

# 进行立体更正
R1, R2, P1, P2, Q, validPixROI1, validPixROI2 = cv2.stereoRectify(left_camera_matrix, left_distortion,
                                                                  right_camera_matrix, right_distortion, size, R,
                                                                  T)
# 计算更正map
left_map1, left_map2 = cv2.initUndistortRectifyMap(left_camera_matrix, left_distortion, R1, P1, size, cv2.CV_16SC2)
right_map1, right_map2 = cv2.initUndistortRectifyMap(right_camera_matrix, right_distortion, R2, P2, size, cv2.CV_16SC2)