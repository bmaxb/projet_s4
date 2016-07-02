clc;
clear all;
close all;

pkg load image; % Octave

scaleopt = 'coeff';

s1_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/s1.bmp';
s2_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/s2.bmp';
s3_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/s3.bmp';
s4_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/s4.bmp';
s5_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/s5.bmp';
s6_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/s6.bmp';

z_max_v0_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_max_v0.bmp';
z_max_v1_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_max_v1.bmp';
z_max_v2_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_max_v2.bmp';
z_max_v3_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_max_v3.bmp';

z_min_v0_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_min_v0.bmp';
z_min_v1_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_min_v1.bmp';
z_min_v2_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_min_v2.bmp';
z_min_v3_path = 'E:/MaximeBreton/OneDrive/documents/universite/s4/projet/images/calculs/z_min_v3.bmp';


test_sphere(s5_path, z_min_v0_path);
test_sphere(s5_path, z_min_v1_path); 
test_sphere(s5_path, z_min_v2_path); 
test_sphere(s5_path, z_min_v3_path);

