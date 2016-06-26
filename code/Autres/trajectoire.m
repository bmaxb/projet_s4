clc;
clear all;
close all;

function [Pi Ltr E Vr Traj tt Tab_banc_essai] = interpolationGenerique(Ni, v_ab, Ts)

X = Ni(:,1);
Y = Ni(:,2);
M = 101;

%% 1 - Calcul des coefficients d'interpolation
Coef = interpolationGenerique(X, Y, 0.01, 0);

%% 2 - Calcul de la longueur de la trajectoire 
dx = (max(X)-min(X))/M;
X_M = min(X):dx:(max(X)-dx);    % Vecteur position X en M points

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
g = sqrt(1 + dy.^2);
L = trapz(X_M, g)

%% 3 - Calcul de l'erreur d'integration

% Calcul des coefficients pour la derivee seconde 
Coef_d2 = [];
for i = 2:length(Coef_d1)
    Coef_d2 = [Coef_d2 (i-1)*Coef_d1(i)];
end

% Calcul de la derivee de l'interpolation de Y
ddy = 0;
for i = 1:length(Coef_d2)
    ddy = ddy + Coef_d2(i).*X_M.^(i-1);
end

% Calcul de l'erreur
Err = dy.*ddy/g

%% 4 - Calcul de l'echantillonnage des points

L_M = [X(1)];
for i = 1:length(X_M)   
    L_M2 = L_M(i)-(Y_vals(i)/dy(i))  
    L_M = [L_M  L_M2];
end


%% 5 - Calcul des points 
X_t = min(X): Ts : max(X);
Y_t = 0;
for i = 1:length(Coef)
    Y_t = Y_t + Coef(i).*X_t.^(i-1);
end

%% 6 - Affichage de la trajectoire
figure()
plot(X_t, Y_t);
hold on;
grid on;
plot(X, Y, '*r');
plot(A, 'm');
axis([min(X)-2 max(X)+2 min(Y)-2 max(Y)+2]);
title('Trajectoire du train');
xlabel('Position en x (m)');
ylabel('Position en y (m)');

%% Sortie
Pi = Coef;
Ltr = [X_M' L_M'];
E = Err;
Vr 
Traj = [X_t' Y_t'];
tt 
Tab_banc_essai = [];