% Initialisation des valeurs et des matrices ------------------------------
matrices_syms

% Variables a l'etat d'equilibre ------------------------------------------
phi = 0;
theta = 0;
Z = 0.015;
xs = 0;
ys = 0;

% Calcul du courant à l'équilibre -----------------------------------------
disp('Calcul des valeurs de courants a l''équilibre...')
[Ia_eq, Ib_eq, Ic_eq] = solve([subs(d2_phi) == 0, subs(d2_theta) == 0, subs(d2_Z) == 0], [Ia, Ib, Ic]);
clc;

% Valeur à l'equilibre ----------------------------------------------------
[w_phi_eq, w_theta_eq, v_z_eq, v_sx_eq, v_sy_eq] = deal(0);
phi_eq = phi;
theta_eq = theta;
Z0_eq = Z; 
xs_eq = xs;
ys_eq = ys;

ZD_eq = Z0_eq + YD*phi_eq - XD*theta_eq;
ZE_eq = Z0_eq - XE*theta_eq;
ZF_eq = Z0_eq + YF*phi_eq - XF*theta_eq;

Va_eq = Ia_eq*R_bobine;
Vb_eq = Ib_eq*R_bobine;
Vc_eq = Ic_eq*R_bobine;

% Pour la substition des matrices------------------------------------------
Ia = Ia_eq; Ib = Ib_eq; Ic = Ic_eq;
Va = Va_eq; Vb = Vb_eq; Vc = Vc_eq;

disp('Valeurs des courants/tension a l''équilibre: ')
disp(['Ia = ' num2str(double(Ia_eq)) ' A'])
disp(['Ib = ' num2str(double(Ib_eq)) ' A'])
disp(['Ic = ' num2str(double(Ic_eq)) ' A'])
disp(['Va = ' num2str(double(Va_eq)) ' V'])
disp(['Vb = ' num2str(double(Vb_eq)) ' V'])
disp(['Vc = ' num2str(double(Vc_eq)) ' V'])

disp(' ')
A = double(subs(A));
B = double(subs(B));
C = double(subs(C));
D = double(subs(D));
disp('Substitution des matrices ABCD à l''équilibre terminé!')

% Force à l'équilibre -----------------------------------------------------
FC_eq = (m_sphere*g*ys_eq/cosd(30) - m_ps*g*r_ABC + m_sphere*g*ys_eq*tand(30) + m_sphere*g*xs_eq)/(3*r_ABC);
FB_eq = FC_eq - (m_sphere*g*ys_eq/(r_ABC*cosd(30)));
FA_eq = -FB_eq - FC_eq - m_ps*g;

% syms phi theta Z w_phi w_theta v_z xs ys v_sx v_sy Ia Ib Ic Va Vb Vc real
% delta_x = [phi-phi_eq, theta-theta_eq, Z-Z0_eq, w_phi-w_phi_eq, w_theta-w_theta_eq, v_z-v_z_eq, xs-xs_eq, ys-ys_eq, v_sx-v_sx_eq, v_sy-v_sy_eq, Ia-Ia_eq, Ib-Ib_eq, Ic-Ic_eq]';
% delta_u = [Va-Va_eq, Vb-Vb_eq, Vc-Vc_eq]';
% 
% delta_x_p = A*delta_x+B*delta_u;
% delta_y = C*delta_x+D*delta_u;