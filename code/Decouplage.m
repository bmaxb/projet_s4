close all
clear all
clc

%% Variables

MatlabProjet
I = [Ia Ib Ic]';
V = [Va Vb Vc]';
u = [0 r_ABC*cosd(30) -r_ABC*cosd(30); -r_ABC r_ABC*sind(30) r_ABC*sind(30); 1 1 1 ];
u_inv = inv(u);
decoup_phi = [0 1 0; A(4,1) 0 A(4,11); 0 0 A(11,11)];
decoup_theta = [0 1 0; A(5,2) 0 A(5,12); 0 0 A(12,12)];
decoup_z = [0 1 0; A(6,3) 0 A(6,13); 0 0 A(13,13)];
decoup_phi_in = [0 0 A(11,1)]';
decoup_theta_in = [0 0 A(12,2)]';
decoup_z_in = [0 0 A(13,3)]';
decoup_sp_x = [0 1;0 0];
decoup_sp_y = [0 1;0 0];
decoup_sp_x_in = [0 A(9,2)];
decoup_sp_y_in = [0 A(10,1)];



%% Calculs

disp('La matrice des courants Iphi, Itheta et Iz = ')
I_ang = u*I
disp('La matrice des tensions Vphi, Vtheta et Vz = ')
V_ang = u*V




