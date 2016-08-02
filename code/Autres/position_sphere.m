% Projet S4
% Equipe P5
%% Fonction servant a determiner la position de la sphere sur la plaque
% img - l'image de la plaque
% R_sphere - Composante rouge du template de la sphere
% Pi - position initiale de la sphere
function [Pf] = position_sphere(img, R_sphere, Pi)

% Taille du template de la sphere
s = size(R_sphere, 1);
s_img = size(img, 1);

% Valeur limite pour une sphere presente sur la plaque
seuil_sphere = 0.55;

% Determiner si oui ou non la sphere est presente sur la plaque
R_img = img(:,:,1);     % Composante rouge de l'image

% Effectuer la correlation croisee normalisee entre la sphere et l'image 
% et trouver le maximum
Corr = real(normxcorr2(R_sphere, R_img));
Corr = Corr(s/2:end-s/2, s/2:end-s/2);
max_corr = max(Corr(:));

% Si le maximum est inferieur au seuil fixe, retourner une position
% negative
if max_corr < seuil_sphere
    Pf = [-1 -1];
    return;
end

% Trouver la position du maximum (la position de la sphere)
[y_max, x_max] = find(Corr==max_corr);

% Afficher ou non le resultat de la correlation
disp_img = 0;
if disp_img == 1
    figure('Name', 'Correlation de la sphere et de l''image');
    surf(Corr);
    view(2);
    shading('flat');
    set(gca,'ydir','reverse')
    title(['Correlation   -   Y: ' num2str(y_max) ' ; X: ' num2str(x_max) ' ; max: ' num2str(max_corr)]);
end

Pf = [x_max (s_img-y_max)];

end