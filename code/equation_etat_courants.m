clc;
clear all;
close all;

% Constantes -------------------------------------------------------------
g = 9.81;				  % m/s^2
m_plaque = 0.425; 	      % kg +/- 10g
m_sphere = 0.008; 	      % kg +/- 0.2g
r_sphere = 3.9/1000;      % m +/- 0.1mm
Rabc = 95.2;              % rayon de la plaque par rapport aux actionneurs
Rdef = 80;                % rayon de la plaque par rapport aux points DEF
R_bobine = 3.6; 		  % Ohms % à vérifier!
L_bobine = 115; 		  % mH

b_E1 = 13.029359254409743;

% Variables symbolique ---------------------------------------------------

syms Z XA XB XC YA YB YC Theta Phi ae0 ae1 ae2 ae3 as0 as1 as2 as3 Fa Fb;
syms Ia Ib Ic Va Vb Vc Fc Ixy Xs Ys;

%linearisation des forces electromagnetiques -----------------------------

ZA = (Z - XA * Theta + YA * Phi);
ZB = (Z - XB * Theta + YB * Phi);
ZC = (Z - XC * Theta + YC * Phi);

denumA1 = ae0 + ae1 * ZA + ae2 * ZA^2 + ae3 * ZA^3 ;
denumA2 = as0 + as1 * ZA + as2 * ZA^2 + as3 * ZA^3 ;
denumB1 = ae0 + ae1 * ZB + ae2 * ZB^2 + ae3 * ZB^3 ;
denumB2 = as0 + as1 * ZB + as2 * ZB^2 + as3 * ZB^3 ;
denumC1 = ae0 + ae1 * ZC + ae2 * ZC^2 + ae3 * ZC^3 ;
denumC2 = as0 + as1 * ZC + as2 * ZC^2 + as3 * ZC^3 ;

FeA = expand(denumA1);
FsA = expand(denumA2);
FeB = expand(denumB1);
FsB = expand(denumB2);
FeC = expand(denumC1);
FsC = expand(denumC2);

eqnA1 = 1/FeA;
eqnA2 = -1/FsA;
eqnB1 = 1/FeB;
eqnB2 = -1/FsB;
eqnC1 = 1/FeC;
eqnC2 = -1/FsC;

%dérivées partielles des Fek et Fsk par rapport à Phi, Theta et Z --------

dFeA_Phi = diff(eqnA1, Phi);
dFeA_Theta = diff(eqnA1, Theta);
dFeA_Z = diff(eqnA1, Z);

dFsA_Phi = diff(eqnA2, Phi);
dFsA_Theta = diff(eqnA2, Theta);
dFsA_Z = diff(eqnA2, Z);

dFeB_Phi = diff(eqnB1, Phi);
dFeB_Theta = diff(eqnB1, Theta);
dFeB_Z = diff(eqnB1, Z);

dFsB_Phi = diff(eqnB2, Phi);
dFsB_Theta = diff(eqnB2, Theta);
dFsB_Z = diff(eqnB2, Z);

dFeC_Phi = diff(eqnC1, Phi);
dFeC_Theta = diff(eqnC1, Theta);
dFeC_Z = diff(eqnC1, Z);

dFsC_Phi = diff(eqnC2, Phi);
dFsC_Theta = diff(eqnC2, Theta);
dFsC_Z = diff(eqnC2, Z);

disp('Dérivée partielle de FeA par rapport à Phi = ')
disp(dFeA_Phi)
disp('Dérivée partielle de FeA par rapport à Theta = ')
disp(dFeA_Theta)
disp('Dérivée partielle de FeA par rapport à Z = ')
disp(dFeA_Z)

disp('Dérivée partielle de FsA par rapport à Phi = ')
disp(dFsA_Phi)
disp('Dérivée partielle de FsA par rapport à Theta = ')
disp(dFsA_Theta)
disp('Dérivée partielle de FsA par rapport à Z = ')
disp(dFsA_Z)

disp('Dérivée partielle de FeB par rapport à Phi = ')
disp(dFeB_Phi)
disp('Dérivée partielle de FeB par rapport à Theta = ')
disp(dFeB_Theta)
disp('Dérivée partielle de FeB par rapport à Z = ')
disp(dFeB_Z)

disp('Dérivée partielle de FsB par rapport à Phi = ')
disp(dFsB_Phi)
disp('Dérivée partielle de FsB par rapport à Theta = ')
disp(dFsB_Theta)
disp('Dérivée partielle de FsB par rapport à Z = ')
disp(dFsB_Z)

disp('Dérivée partielle de FeC par rapport à Phi = ')
disp(dFeC_Phi)
disp('Dérivée partielle de FeC par rapport à Theta = ')
disp(dFeC_Theta)
disp('Dérivée partielle de FeC par rapport à Z = ')
disp(dFeC_Z)

disp('Dérivée partielle de FsC par rapport à Phi = ')
disp(dFsC_Phi)
disp('Dérivée partielle de FsC par rapport à Theta = ')
disp(dFsC_Theta)
disp('Dérivée partielle de FsC par rapport à Z = ')
disp(dFsC_Z)


%dérivée des numérateurs pour Fek ----------------------------------------

dFeA_num_Ia = diff(numA, Ia);
dFeB_num_Ib = diff(numB, Ib);
dFeC_num_Ic = diff(numC, Ic);


disp('Dérivée partielle du numérateur de FeA par rapport à Ia = ')
disp(dFeA_num_Ia)
disp('Dérivée partielle du numérateur de FeC par rapport à Ib = ')
disp(dFeB_num_Ib)
disp('Dérivée partielle du numérateur de FeC par rapport à Ic = ')
disp(dFeC_num_Ic)

% 13 variables d'état ----------------------------------------------------

d_phi = diff(Phi);
d_theta = diff(Theta);
d_Z = diff(Z);
d2_phi = (Rabc*cos(30)*(Fc-Fb)) / Ixy;
d2_theta = (Rabc*(Fa - Fb*sin(30) - Fc*sin(30))) / Ixy;
d2_Z = (Fa + Fb + Fc + m_plaque*g) / m_plaque;
d_Xs = diff(Xs);
d_Ys = diff(Ys);
d2_Xs = (-g*Theta) / 1.4;
d2_Ys = (g*Phi) / 1.4;
d_Ia = Va/L_bobine - (R_bobine/L_bobine)*Ia;
d_Ib = Vb/L_bobine - (R_bobine/L_bobine)*Ib;
d_Ic = Vc/L_bobine - (R_bobine/L_bobine)*Ic;

 
%
%x = pinv([d_phi, d_theta, d_Z, d2_phi, d2_theta, d2_Z, d_Xs, d_Ys, d2_Xs, d2_Ys, d_Ia, d_Ib, d_Ic]);
%
%disp(x)








