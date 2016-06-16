clc;
clear all;
close all;

X = 1:2:12;
Y = [0 7 8 7 9 11];
M = 101;

%% 1 - Calcul des coefficients d'interpolation
Coef = interpolationGenerique(X, Y, 0.01, 0);

%% 2 - Calcul de la longueur de la trajectoire 
X_M = min(X):length(X)/M:max(X);    % Vecteur position X en M points

% Calcul des valeurs interpollees de Y
Y_vals = 0;
for i = 1:length(Coef)
    Y_vals = Y_vals + Coef(i).*X_M.^(i-1);
end

% Calcul des coefficients derives 
Coef_d1 = [];
for i = 2:length(Coef)
    Coef_d1 = [Coef_d1 (i-1)*Coef(i)];
end

% Calcul de la derivee de l'interpolation de Y
dy = 0;
for i = 1:length(Coef_d1)
    dy = dy + Coef_d1(i).*X_M.^(i-1);
end

% Calcul de la longueur de la trajectoire avec la methode des trapezes
g = sqrt(1 + dy.^2)
L = trapz(X_M, g)

%d_g = diff(g);
%d_g2 = (d_y*diff(d_y)) / g;

%Etape 2 avec int�grale directe
%d_y = diff(y);
%g = sqrt(1+(d_y^2));
%g_matlab = matlabFunction(g);
%L = integral(g_matlab, X(1), X(end));