close all; clear all ;clc

%% Variables

equilibre
I = [Ia Ib Ic]';
V = [Va Vb Vc]';
u = [0 r_ABC*cosd(30) -r_ABC*cosd(30); -r_ABC r_ABC*sind(30) r_ABC*sind(30); 1 1 1 ];
u_inv = inv(u);
decoup_phi = [0 1 0; A(4,1) 0 A(4,11); 0 0 A(11,11)];
decoup_theta = [0 1 0; A(5,2) 0 A(5,12); 0 0 A(12,12)];
decoup_z = [0 1 0; A(6,3) 0 A(6,13); 0 0 A(13,13)];
decoup_phi_in = [0 0 B(11,1)]';
decoup_theta_in = [0 0 B(12,2)]';
decoup_z_in = [0 0 B(13,3)]';
decoup_sp_x = [0 1;0 0];
decoup_sp_y = [0 1;0 0];
decoup_sp_x_in = [0 A(9,2)]';
decoup_sp_y_in = [0 A(10,1)]';
C_sphere = [1 0; 0 1];
D_sphere = [0 0]';
C_plaque = [1 0 0];% ; 0 1 0 ; 0 0 1];
D_plaque = 0;

%% Calculs

disp('La matrice des courants Iphi, Itheta et Iz = ')
I_ang = u*I
disp('La matrice des tensions Vphi, Vtheta et Vz = ')
V_ang = u*V

%% fonctions de transfert de la sphere

[num1,den1] = ss2tf(decoup_sp_x, decoup_sp_x_in, C_sphere, D_sphere);
[num2,den2] = ss2tf(decoup_sp_y, decoup_sp_y_in, C_sphere, D_sphere);

Gsx1 = tf(num1(1,:),den1);
Gsx2 = tf(num1(2,:),den1);
Gsy1 = tf(num2(1,:),den2);
Gsy2 = tf(num2(2,:),den2);

Gs = series(Gsx1,Gsx2);

%% fonctions de transfert de la plaque

[num3,den3] = ss2tf(decoup_phi, decoup_phi_in, C_plaque, D_plaque);
[num4,den4] = ss2tf(decoup_theta, decoup_theta_in, C_plaque, D_plaque);
[num5,den5] = ss2tf(decoup_z, decoup_z_in, C_plaque, D_plaque);

Gp_phi = tf(num3,den3)
Gp_theta = tf(num4,den4)
Gp_z = tf(num5,den5)






