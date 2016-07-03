% Initialisation des valeurs à l'équilibre --------------------------------
equilibre

% Comparaison modèle des actionneurs --------------------------------------
% *Fait avec seulement un déplacement en hauteur et non en angle
for Z = 0:0.0001:0.03
    Z0 = Z;
    dZ = Z - Z0_eq;
    syms Ia Ib Ic
    [Ia_eq2, Ib_eq2, Ic_eq2] = solve([subs(d2_phi) == 0, subs(d2_theta) == 0, subs(d2_Z) == 0], [Ia, Ib, Ic]);
    Ix = Ib_eq2;
    dIx = Ix - Ib_eq;
    dphi = 0;
    dtheta = 0;
    XX = XB;
    YX = YB;
    FX = subs(FX);
    % On veut évaluer dFX à l'équilibre
    Z = Z0_eq;
    Ix = Ib_eq;
    dFX = subs(dFX);
    err_lin = 100*abs(dFX/FX); % en %
    
    % Graphique de l'erreur de l'approcimation par rapport à Z
    figure(1)
    plot(Z0, err_lin)
    hold on
end

% Pour avoir err_lin < 10% : si Z_eq = 0, dZ_max = +0.0002
%                            si Z_eq = 0.01, dZ_max = -0.0093, +0.0144
%                            si Z_eq = 0.02, dZ_max = -0.014, +0.0075
% Conclusion : Pour avoir une bonne approximation, dZ doit être petit. On
% remarque que plus Z_eq augmente, plus on peut avoir un grand dZ jusqu'à
% un certain point ou dZ se met à diminuer en fonction de Z_eq.