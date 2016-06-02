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
As0 = -0.22862;
As1 = 176.4976;
As2 = -16589.0203;
As3 = 767085.5302;
Fsa_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);
Fsb_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);
Fsc_eq = -1 / (As0 + As1*Z0_eq + As2*Z0_eq^2 + As3*Z0_eq^3);

Ae0_1 = 1.3463;
Ae1_1 = 349.0774;
Ae2_1 = 1450.3848;
Ae3_1 = 703344.2113;

Ae0_2 = 1.3334;
Ae1_2 = 362.2141;
Ae2_2 = 2183.4014 ;
Ae3_2 = 705425.2882;

sgn_ik = 1;
denom_Ae_1 = Ae0_1 + Ae1_1*Z0_eq + Ae2_1*Z0_eq^2 + Ae3_1*Z0_eq^3;
denom_Ae_2 = Ae0_2 + Ae1_2*Z0_eq + Ae2_2*Z0_eq^2 + Ae3_2*Z0_eq^3;

a = sgn_ik;
b = b_E1;
c = (Fa_eq - Fsa_eq) * denom_Ae_1 * sgn_ik;

p = [a b c];
r = roots(p)