%% Fonction trajectoire
% Ni        coordonnees intermediaires xi (colonne 1) et yi (colonne 2) en metres, a interpoler pour la trajectoire du point 1 au point N
% v_ab      vitesse vAB, en m/s, voulue constante sur la trajectoire
% Ts        periode d’echantillonnage Ts, en secondes, des points a calculer
function [Pi Ltr E Vr Traj tt Tab_banc_essai] = trajectoire(Ni, v_ab, Ts)

X = Ni(:,1);
Y = Ni(:,2);
M = 101;  % 101 points dans les calculs

%% 1 - Calcul des coefficients d'interpolation
Coef = polyfit(X, Y, length(X) - 1);

%% 2 - Calcul de la longueur de la trajectoire avec M points
X_M = linspace(X(1), X(end), M);    % Vecteur position X en M points

% Calcul des valeurs interpollees de Y
Y_M = polyval(Coef, X_M);

% Calcul des coefficients derives 
Coef_d1 = polyder(Coef);

% Calcul de la derivee de l'interpolation de Y
dy = polyval(Coef_d1, X_M);

% Calcul de la longueur de la trajectoire avec la methode des trapezes
g = sqrt(1 + dy.^2);
h = (X_M(end) - X_M(1)) / (2 * length(g));

[L, Ltr] = itsATrap(g, X_M(1),X_M(end));

L1 = trapz(X_M, g);

%% 3 - Calcul de l'erreur d'integration
h = L / 101;
diffG = diff(g);

% Calcul de l'erreur
Err = ((h^2) / 12) * (diffG(end) - diffG(1));

%% 4 - Calcul de l'echantillonnage des points

% Calcul de la vitesse reelle
O = abs(ceil(L/(Ts*v_ab)));
Vr = (L/(O*Ts));

% Calcul des coordonnees en x correspondant aux distances constantes
dL = L/O;
X_O = [X(1)];

for i = 1:O
    b = X_O(i);
    distance = dL*i;
    
    xx = linspace(X(1),b,1000);
    yy = polyval(Coef_d1,xx);
    g = (1+yy.^2).^(0.5);
    f = itsATrap(g, X(1), b) - distance;
    
    yy = polyval(Coef_d1,b);
    fprime = sqrt(1+yy^2);
    max_inter = 0;
    
    while(abs(f) >= 1e-5) && (max_inter < 50)
        b = b - f /fprime;
        
        xx = linspace(X(1),b,1000);
        yy = polyval(Coef_d1,xx);
        g = (1+yy.^2).^(0.5);
        f = itsATrap(g, X(1), b) - distance;

        yy = polyval(Coef_d1,b);
        fprime = sqrt(1+yy^2);
        max_inter = max_inter + 1;
    end  
    X_O = [X_O b];
end

%% 5 - Calcul des points 
Y_O = polyval(Coef, X_O);

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
hold on
%plot(X_O', Y_O', 'o')

%% Sortie
Pi = Coef;              % coefficients du polynome d’interpolation 
Ltr = Ltr;
%Ltr = [X_M' L_M'];      % matrice contenant la longueur cumulative de la trajectoire aux M points du calcul
E = Err;                % erreur d’integration de la longueur totale 
Vr;                     % vitesse reelle utilisee dans le calcul de l’interpolation 
Traj = [X_O' Y_O'];     % coordonnées interpolees de la trajectoire
tt = L/Vr;              % temps total requis pour parcourir la trajectoire
Tab_banc_essai = [];    % tableau de format à définir pour transmettre la trajectoire au banc d’essai 