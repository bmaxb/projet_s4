clc;
clear all;
close all;

z_max_v2_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\zmax_v1.rgb';
cropped_path = 'E:\MaximeBreton\OneDrive\Documents\universite\s4\projet\projet_s4\code\Traitement Image\images\cropped.rgb';

image2 = fread(fopen(z_max_v2_path));
image2 = reshape(image2(1:end), [480*3 480]);

crop = image2(1:300,151:250);

imshow(crop(1:3:end, :), [0 255]);
%fid = fopen(cropped_path, 'w');
%fwrite(fid, reshape(crop,[1 100*3*100]));
%fclose(fid)