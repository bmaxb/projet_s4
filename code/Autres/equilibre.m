clc; clear; close all;

% Constantes --------------------------------------------------------------
g = 9.81;               % m/s^2
r_ABC = 95.2;           % mm 
m_sphere = 0.008;             % kg +/- 0.2g
m_plaque = 0.425; 	    % kg +/- 10g
m_ps = m_sphere + m_plaque;            % kg
Jxy = 1169.1;           % kg*mm^2 +/- 0.2kg*mm^2
b_E1 = 13.029359254409743;
R_bobine = 3.6;         % en ohm


% Variables d'etat (au choix, changer la valeur ici) ----------------------
Z0_eq = 0;
Ys_eq = 0;
Xs_eq = 0;

%variables d'etat à l'équilibre (pas d'impact sur les équations ci-dessous-
phi_eq = 0;         theta_eq = 0;        w_phi_eq = 0;        v_sy_eq = 0; 
w_theta_eq = 0;     v_z_eq = 0;          v_sx_eq = 0; 
ZA_eq = Z0_eq;      ZB_eq = Z0_eq;       ZC_eq = Z0_eq;

% Forces a l'equilibre ----------------------------------------------------
Fc_eq = (m_sphere*g*Ys_eq/cosd(30) - m_ps*g*r_ABC + m_sphere*g*Ys_eq*tand(30) + m_sphere*g*Xs_eq)/(2*r_ABC + 2*r_ABC*sind(30));
Fb_eq = Fc_eq - (m_sphere*g*Ys_eq/(r_ABC*cosd(30)));
Fa_eq = -Fb_eq - Fc_eq - m_ps*g;

% Courants a l'equilibre --------------------------------------------------

%syms As0 As1 As2 As3 Ae0 Ae1 Ae2 Ae3

Ae0 = 1.3463; Ae1 = 349.0774; Ae2 = 1450.3848; Ae3 = 703344.2113;
As0 = -0.22862; As1 = 176.4976; As2 = -16589.0203; As3 = 767085.5302;

Fsa_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);
Fsb_eq = Fsa_eq;
Fsc_eq = Fsb_eq;

denom_Ae_1 = Ae0 + Ae1*Z0_eq + Ae2*Z0_eq^2 + Ae3*Z0_eq^3;

k1 = (Fa_eq - Fsa_eq) * denom_Ae_1;
k2 = (Fb_eq - Fsb_eq) * denom_Ae_1;
k3 = (Fc_eq - Fsc_eq) * denom_Ae_1;

k0_Ia = @(Ia) (Ia^2 + b_E1 * abs(Ia)) * sign(Ia) - k1;
k0_Ib = @(Ib) (Ib^2 + b_E1 * abs(Ib)) * sign(Ib) - k2;
k0_Ic = @(Ic) (Ic^2 + b_E1 * abs(Ic)) * sign(Ic) - k3;

Ia_eq = fsolve(k0_Ia, 0);
Ib_eq = fsolve(k0_Ib, 0);
Ic_eq = fsolve(k0_Ic, 0);

Va_eq = R_bobine * Ia_eq;
Vb_eq = R_bobine * Ib_eq;
Vc_eq = R_bobine * Ic_eq;

disp(['Courant Ia en équilibre = ', num2str(Ia_eq)])
disp(['Courant Ib en équilibre = ', num2str(Ib_eq)])
disp(['Courant Ic en équilibre = ', num2str(Ic_eq)])

disp(['Tension Va en équilibre = ', num2str(Va_eq)])
disp(['Tension Vb en équilibre = ', num2str(Vb_eq)])
disp(['Tension Vc en équilibre = ', num2str(Vc_eq)])













