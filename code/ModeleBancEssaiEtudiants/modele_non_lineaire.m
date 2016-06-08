% Initialisation des matrices ---------------------------------------------
MatlabProjet

% Fonctions ---------------------------------------------------------------
d_Ik = @(Vk, Ik) (Vk/L_bobine)-(R_bobine*Ik/L_bobine);
d2_phi = @(FB, FC, ys) (r_ABC*cosd(30)*(FB - FC) + m_sphere*g*ys) / Ixy;
d2_theta = @(FA, FB, FC, xs) (r_ABC*(FA - (FB + FC)*sind(30)) + m_sphere*g*xs) / Ixy;
d2_Z = @(FA, FB, FC) (FA + FB + FC + m_ps*g) / m_ps;
d2_Xs = @(theta) (-g*theta) / 1.4;
d2_Ys = @(phi) (g*phi) / 1.4;
Fk = @(ik, zk) (((ik^2+b_E1*abs(ik))*sign(ik)) / (ae(1) + ae(2)*zk + ae(3)*zk^2 + ae(4)*zk^3))+(-1) / (as(1) + as(2)*zk + as(3)*zk^2 + as(4)*zk^3);
Zk = @(xk, yk, theta, phi, Z) Z - xk*theta + yk*phi;
dk = @(Z, xk, yk, theta, phi) Z+yk*phi-xk*theta;