clc;
clear all;
close all;

path_y = '/home/bmax/Downloads/images/statique zmax version 2/bmp/image_0.bmp';
path_n = '/home/bmax/Downloads/image_0.bmp'

A = imread(path_n);
R = A(:,:,1);
G = A(:,:,2);
B = A(:,:,3);
Pi = [-1 -1];

Pf = position_sphere(R, G, B, Pi);

