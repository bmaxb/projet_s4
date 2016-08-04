% Projet S4
% Equipe P5
clc;
clear all;
close all;

pkg load image; % Octave
pkg load signal;

templ_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\templ.rgb';

z_max_v0_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmax_v0.rgb';
z_max_v1_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmax_v1.rgb';
z_max_v2_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmax_v2.rgb';
z_max_v3_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmax_v3.rgb';

z_min_v0_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmin_v0.rgb';
z_min_v1_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmin_v1.rgb';
z_min_v2_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmin_v2.rgb';
z_min_v3_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmin_v3.rgb';

templ = fread(fopen(templ_path));
templ = reshape(templ, [48 48]);

image0 = fread(fopen(z_max_v0_path));
image0 = reshape(image0(1:3:end), [480 480]);
image1 = fread(fopen(z_max_v1_path));
image1 = reshape(image1(1:3:end), [480 480]);
%image2 = fread(fopen(z_max_v2_path));
%image2 = reshape(image2(1:3:end), [480 480]);
%image3 = fread(fopen(z_max_v3_path));
%image3 = reshape(image3(1:3:end), [480 480]);
%
%image4 = fread(fopen(z_min_v0_path));
%image4 = reshape(image4(1:3:end), [480 480]);
%image5 = fread(fopen(z_min_v1_path));
%image5 = reshape(image5(1:3:end), [480 480]);
%image6 = fread(fopen(z_min_v2_path));
%image6 = reshape(image6(1:3:end), [480 480]);
%image7 = fread(fopen(z_min_v3_path));
%image7 = reshape(image7(1:3:end), [480 480]);

t = cputime();

position_sphere(templ, image0, [-1 -1]);
position_sphere(templ, image1, [-1 -1]);
%position_sphere(templ, image2, [-1 -1]);
%position_sphere(templ, image3, [-1 -1]);
%
%position_sphere(templ, image4, [-1 -1]);
%position_sphere(templ, image5, [-1 -1]);
%position_sphere(templ, image6, [-1 -1]);
%position_sphere(templ, image7, [-1 -1]);

total_time = cputime() - t;