% Projet S4
% Equipe P5
bancEssaiConstantes

% Variables symbolique ----------------------------------------------------
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

% Forces electromagnetiques -----------------------------------------------
Zk = @(xk, yk) Z - xk*theta + yk*phi;
Fe = @(ik, zk) ((ik^2 + b_E1*abs(ik))*sign(ik)) / (ae(1) + ae(2)*zk + ae(3)*zk^2 + ae(4)*zk^3);
Fs = @(zk) (-1) / (as(1) + as(2)*zk + as(3)*zk^2 + as(4)*zk^3);

FA = Fe(Ia, Zk(XA, YA)) + Fs(Zk(XA, YA));
FB = Fe(Ib, Zk(XB, YB)) + Fs(Zk(XB, YB));
FC = Fe(Ic, Zk(XC, YC)) + Fs(Zk(XC, YC));

% Version linéaire du modèle des actionneurs ------------------------------
% *le d représante un delta
syms Ix XX YX dIx dZ dtheta dphi
FX = Fe(Ix, Zk(XX, YX)) + Fs(Zk(XX, YX));
dFX_Ix = diff(FX,Ix);
dFX_Z = diff(FX,Z);
dFX_theta = diff(FX,theta);
dFX_phi = diff(FX,phi);
dFX = dFX_Ix*dIx + dFX_Z*dZ + dFX_theta*dtheta + dFX_phi*dphi;

% 13 equations ------------------------------------------------------------
d_phi = w_phi;
d_theta = w_theta;
d_Z = v_z;
d2_phi = (rABC*cosd(30)*(FB - FC) + mS*g*ys) / Ixy;
d2_theta = -(rABC*(FA - (FB + FC)*sind(30)) + mS*g*xs) / Ixy;
d2_Z = (FA + FB + FC + mtot*g) / mtot;
d_Xs = v_sx;
d_Ys = v_sy;
d2_Xs = (-g*theta) / 1.4;
d2_Ys = (g*phi) / 1.4;
d_Ia = (Va - R_bobine*Ia) / L_bobine;
d_Ib = (Vb - R_bobine*Ib) / L_bobine;
d_Ic = (Vc - R_bobine*Ic) / L_bobine;

EQ = [d_phi d_theta d_Z d2_phi d2_theta d2_Z d_Xs d_Ys d2_Xs d2_Ys d_Ia d_Ib d_Ic];

% Creation du systeme lineaire --------------------------------------------
clc; disp('Calcul de la matrice A...')
A = sym('A', [13 13]);
for i = 1:13
    for j = 1:13
        A(i, j) = diff(EQ(i), X(j));
    end
end

clc; disp('Calcul de la matrice B...')
B = sym('B', [13 3]);
for i = 1:13
    for j = 1:3
        B(i, j) = diff(EQ(i), V(j));
    end
end

clc; disp('Calcul de la matrice C...')
C = sym('C', [7 13]);
for i = 1:7
    for j = 1:13
        C(i, j) = diff(Y(i), X(j));
    end
end

D = zeros(7, 3);

clc; disp('Matrices A, B, C and D complété!')
