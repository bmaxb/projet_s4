clc;
clear all;
close all;

%% Constantes
g = 9.81;               % m/s^2
Rabc = 95.2;            % mm 
Ms = 0.008;             % kg +/- 0.2g
Mp = 0.425; 	          % kg +/- 10g
M = Ms + Mp;            % kg
Jxy = 1169.1;           % kg*mm^2 +/- 0.2kg*mm^2
b_E1 = 13.029359254409743;

%% Variables d'etat (au choix, changer la valeur ici) 
Xs_eq = 0;
Ys_eq = 0;
Z0_eq = 0;

%% Forces a l'equilibre
Fc_eq = (Ms*g*Ys_eq/cos(pi/6) - M*g*Rabc + Ms*g*Ys_eq*tan(pi/6) + Ms*g*Xs_eq)/(2*Rabc + 2*Rabc*sin(pi/6));
Fb_eq = Fc_eq - (Ms*g*Ys_eq/(Rabc*cos(pi/6)));
Fa_eq = -Fb_eq - Fc_eq - M*g;

%% Courants a l'equilibre
syms As0 As1 As2 As3 Ae0 Ae1 Ae2 Ae3
sgn_ik = 1;

Fsa_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);
Fsb_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);
Fsc_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);

denom_Ae_1 = Ae0 + Ae1*Z0_eq + Ae2*Z0_eq^2 + Ae3*Z0_eq^3;

I_a = sgn_ik;
I_b = b_E1;
IA_c = (Fa_eq - Fsa_eq) * denom_Ae_1 * sgn_ik;
IB_c = (Fb_eq - Fsb_eq) * denom_Ae_1 * sgn_ik;
IC_c = (Fc_eq - Fsc_eq) * denom_Ae_1 * sgn_ik;

E_Ia_eq = (-I_b + sqrt(I_b^2 - 4*I_a*IA_c))/(2*I_a);
E_Ib_eq = (-I_b + sqrt(I_b^2 - 4*I_a*IB_c))/(2*I_a);
E_Ic_eq = (-I_b + sqrt(I_b^2 - 4*I_a*IC_c))/(2*I_a);