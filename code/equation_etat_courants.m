clc; clear; close all;

% Constantes --------------------------------------------------------------
g = 9.81;				    % m/s^2
m_plaque = 0.425; 	        % kg +/- 10g
m_sphere = 0.008; 	        % kg +/- 0.2g
m_ps = m_plaque + m_sphere; % kg
r_sphere = 3.9 / 1000;      % m +/- 0.1mm
r_ABC = 95.2 / 1000;        % m, rayon de la plaque par rapport aux actionneurs
r_DEF = 80 / 1000;          % rayon de la plaque par rapport aux points DEF
R_bobine = 3.6; 		    % Ohms % à vérifier!
L_bobine = 115; 		    % mH

b_E1 = 13.029359254409743;

Ixy = 0.0011691; % +/- 0.2 kg*m^2 % Jxy

XA = r_ABC;
YA = 0;
XB = -r_ABC*sind(30);
YB = r_ABC*cosd(30);
XC = XB;
YC = -YB;

% Coordonnees inertielles
XD = r_DEF*sind(30);
YD = r_DEF*cosd(30);
XE = -r_DEF;
YE = 0;
XF = XD;
YF = -YD;

T_DEF = [YD -XD 1;
         YE -XE 1;
         YF -XF 1;];

% Variables symbolique ----------------------------------------------------
ae = sym('ae',[4 1]);
as = sym('as',[4 1]);

% 3 entrees
syms Va Vb Vc;
V = [Va Vb Vc];

% 13 variables d'etats
syms phi theta Z w_phi w_theta v_z xs ys v_sx v_sy Ia Ib Ic
X = [phi theta Z w_phi w_theta v_z xs ys v_sx v_sy Ia Ib Ic];

% 7 sorties
dm_D = Z + YD*phi - XD*theta;
dm_E = Z - XE*theta;
dm_F = Z + YF*phi - XF*theta;
Y = [dm_D dm_E dm_F xs, ys, v_sx, v_sy];

% Linearisation des forces electromagnetiques -----------------------------
Zk = @(xk, yk) Z - xk*theta + yk*phi;
Fe = @(ik, zk) (ik^2+b_E1*abs(ik)*sign(ik)) / (ae(1) + ae(2)*zk + ae(3)*zk^2 + ae(4)*zk^3);
Fs = @(zk) (-1) / (as(1) + as(2)*zk + as(3)*zk^2 + as(4)*zk^3);

FA = Fe(Ia, Zk(XA, YA)) + Fs(Zk(XA, YA));
FB = Fe(Ib, Zk(XB, YB)) + Fs(Zk(XB, YB));
FC = Fe(Ic, Zk(XC, YC)) + Fs(Zk(XC, YC));

% 13 equations ------------------------------------------------------------
d_phi = w_phi;
d_theta = w_theta;
d_Z = v_z;
d2_phi = (r_ABC*cosd(30)*(FB - FC) + m_sphere*g*ys) / Ixy;
d2_theta = (r_ABC*(FA - (FB + FC)*sind(30)) + m_sphere*g*xs) / Ixy;
d2_Z = (FA + FB + FC + m_ps*g) / m_ps;
d_Xs = v_sx;
d_Ys = v_sy;
d2_Xs = (-g*theta) / 1.4;
d2_Ys = (g*phi) / 1.4;
d_Ia = (Va - R_bobine*Ia) / L_bobine;
d_Ib = (Vb - R_bobine*Ib) / L_bobine;
d_Ic = (Vc - R_bobine*Ic) / L_bobine;

EQ = [d_phi d_theta d_Z d2_phi d2_theta d2_Z d_Xs d_Ys d2_Xs d2_Ys d_Ia d_Ib d_Ic];

% Creation du systeme lineaire --------------------------------------------
A = sym('A', [13 13]);
for i = 1:13
    for j = 1:13
        clc; disp(['Calculating A(' num2str(i) ', ' num2str(j) ')...'])
        A(i, j) = diff(EQ(i), X(j));
    end
end

B = sym('B', [13 3]);
for i = 1:13
    for j = 1:3
        clc; disp(['Calculating B(' num2str(i) ', ' num2str(j) ')...'])
        B(i, j) = diff(EQ(i), V(j));
    end
end

C = sym('B', [7 13]);
for i = 1:7
    for j = 1:13
        clc; disp(['Calculating C(' num2str(i) ', ' num2str(j) ')...'])
        C(i, j) = diff(Y(i), X(j));
    end
end

D = zeros(7, 3);

clc; disp('Matrix A, B, C and D completed.')

% Variables a l'etat d'equilibre ------------------------------------------
phi = 0;
theta = 0;
Z = 0;
xs = 0;
ys = 0;

ae1 = 1.3463; ae2 = 349.0774; ae3 = 1450.3848; ae4 = 703344.2113;
as1 = -0.22862; as2 = 176.4976; as3 = -16589.0203; as4 = 767085.5302;

I_eq = solve(subs(FA) == (-m_ps*g)/3, Ia);
disp('Valeurs des courants à l''équilibre (où Ia=Ib=Ic): ')
disp(vpa(I_eq, 6))