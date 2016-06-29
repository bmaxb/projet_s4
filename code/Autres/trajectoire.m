%% Fonction trajectoire
% Ni        coordonnees intermediaires xi (colonne 1) et yi (colonne 2) en metres, a interpoler pour la trajectoire du point 1 au point N
% v_ab      vitesse vAB, en m/s, voulue constante sur la trajectoire
% Ts        periode d’echantillonnage Ts, en secondes, des points a calculer
function [Pi Ltr E Vr Traj tt Tab_banc_essai] = trajectoire(Ni, v_ab, Ts)

X = Ni(:,1);
Y = Ni(:,2);
M = 101;

%% 1 - Calcul des coefficients d'interpolation
Coef = interpolationGenerique(X, Y, 0.01, 0);

%% 2 - Calcul de la longueur de la trajectoire avec M points
dx = (max(X)-min(X))/M;
X_M = min(X):dx:(max(X)-dx);    % Vecteur position X en M points

% Calcul des valeurs interpollees de Y
Y_M = 0;
for i = 1:length(Coef)
    Y_M = Y_M + Coef(i).*X_M.^(i-1);
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
L_M = [0];
for i = 1:length(X_M)-1
    L_M2 = L_M(i) + trapz([X_M(i) X_M(i+1)], [g(i) g(i+1)]);
    L_M = [L_M  L_M2];
end
L = L_M(end);

%% 3 - Calcul de l'erreur d'integration

% Calcul des coefficients pour la derivee seconde 
Coef_d2 = [];
for i = 2:length(Coef_d1)
    Coef_d2 = [Coef_d2 (i-1)*Coef_d1(i)];
end

% Calcul de la derivee seconde de l'interpolation de Y
ddy = 0;
for i = 1:length(Coef_d2)
    ddy = ddy + Coef_d2(i).*X_M.^(i-1);
end

% Calcul de l'erreur
Err = dy.*ddy/g;

%% 4 - Calcul de l'echantillonnage des points

% Calcul de la vitesse reelle
O = ceil(L/(Ts*v_ab));
Vr = (L/(O*Ts));

% Calcul des coordonnees en x correspondant aux distances constantes
%% PARTIE A FINALISER...
dL = L/O;
X_O = [X(1)];

for i = 1:O
    a = X_O(i);
    b = a + dL;
    
    disp(['b: ' num2str(b)]);
    
    for j = 1:100
        
        dy_a = 0;
        for k = 1:length(Coef_d1)
            dy_a = dy_a + Coef_d1(k).*a.^(k-1);
        end  
        
        dy_b = 0;
        for k = 1:length(Coef_d1)
            dy_b = dy_b + Coef_d1(k).*b.^(k-1);
        end
    
        F_b = dL - trapz([a b], [sqrt(1 + (dy_a)^2) sqrt(1 + (dy_b)^2)]);
        dF_b = 0 - sqrt(1 + (dy_b)^2); 
        
        b = a - F_b/dF_b;
        disp(['b: ' num2str(b)]);
        pause;
    end
end

%% 5 - Calcul des points 
Y_O = 0;
for i = 1:length(Coef)
    Y_O = Y_O + Coef(i).*X_O.^(i-1);
end

%% 6 - Affichage de la trajectoire
figure()
plot(X_O, Y_O);
hold on;
grid on;
plot(X, Y, '*r');
axis([min(X)-2 max(X)+2 min(Y)-2 max(Y)+2]);
title('Trajectoire du train');
xlabel('Position en x (m)');
ylabel('Position en y (m)');

%% Sortie
Pi = Coef;              % coefficients du polynome d’interpolation 
Ltr = [X_M' L_M'];      % matrice contenant la longueur cumulative de la trajectoire aux M points du calcul
E = Err;                % erreur d’integration de la longueur totale 
Vr;                     % vitesse reelle utilisee dans le calcul de l’interpolation 
Traj = [X_O' Y_O'];     % coordonnées interpolees de la trajectoire
tt = L/Vr;              % temps total requis pour parcourir la trajectoire
Tab_banc_essai = [];    % tableau de format à définir pour transmettre la trajectoire au banc d’essai 