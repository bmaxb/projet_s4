% Constantes
g = 9.81;					   % m/s^2
m_plaque = 0.425; 	 % kg +/- 10g
m_sphere = 0.008; 	 % kg +/- 0.2g
r_sphere = 3.9/1000; % m +/- 0.1mm

R_bobine = 3.6; 		 % Ohms % à vérifier!
L_bobine = 115; 		 % mH

b_E1 = 13.029359254409743;

% Variables symbolique

% 13 variables d'état
d_phi = diff(phi);
d_theta = diff(theta);
d_Z = diff(z);
d2_phi = (Rabc*cos(30)*(Fc-Fb)) / Ixy;
d2_theta = (Rabc*(Fa - Fb*sin(30) - Fc*sin(30))) / Ixy;
d2_Z = (Fa + Fb + Fc + m_plaque*g) / m_plaque;
d_Xs = diff(Xs);
d_Ys = diff(Ys);
d2_Xs = (-g*theta) / 1.4;
d2_Ys = (g*phi) / 1.4;
d_Ia = Va/L_bobine - (R_bobine/L_bobine)*Ia;
d_Ib = Vb/L_bobine - (R_bobine/L_bobine)*Ib;
d_Ic = Vc/L_bobine - (R_bobine/L_bobine)*Ic;

% 
%x = pinv([d_phi, d_theta, d_Z, d2_phi, d2_theta, d2_Z, d_Xs, d_Ys, d2_Xs, d2_Ys, d_Ia, d_Ib, d_Ic]);
%