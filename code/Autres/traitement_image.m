% Projet S4
% Equipe P5
clc;
clear all;
close all;

%pkg load image; % Octave

s_path = 'sphere_template.bmp';

z_max_v0_path = 'Q:/projet_s4/doc/calculs/z_max_v0.bmp';
z_max_v1_path = 'Q:/projet_s4/doc/calculs/z_max_v1.bmp';
z_max_v2_path = 'Q:/projet_s4/doc/calculs/z_max_v2.bmp';
z_max_v3_path = 'Q:/projet_s4/doc/calculs/z_max_v3.bmp';

z_min_v0_path = 'Q:/projet_s4/doc/calculs/z_min_v0.bmp';
z_min_v1_path = 'Q:/projet_s4/doc/calculs/z_min_v1.bmp';
z_min_v2_path = 'Q:/projet_s4/doc/calculs/z_min_v2.bmp';
z_min_v3_path = 'Q:/projet_s4/doc/calculs/z_min_v3.bmp';

s = imread(s_path);
R_sphere = s(:,:,1);

t = cputime();

img = imread(z_max_v1_path);
[Pf] = position_sphere(img, R_sphere, [-1 -1]);

total_time = cputime() - t;