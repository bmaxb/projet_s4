%% Fonction servant a determiner la position de la sphere sur la plaque
% img - l'image de la plaque
% R_sphere - Composante rouge du template de la sphere
% Pi - position initiale de la sphere
function [Pf] = position_sphere(templ, image, Pi)

% Normalisation
image = double(image);
templ = double(templ) - mean(templ(:));
    
% Taille du template de la sphere
size_templ = size(templ, 1);
size_image = size(image, 1);

% Valeur limite pour une sphere presente sur la plaque
seuil_sphere = 3500000; 

% Effectuer la correlation croisee normalisee entre la sphere et l'image 
% et trouver le maximum
Corr = flipud(fliplr(real(xcorr2(templ, image))));
Corr = Corr(size_templ/2:end-size_templ/2, size_templ/2:end-size_templ/2);
max_corr = max(Corr(:));

% Si le maximum est inferieur au seuil fixe, retourner une position
% negative
if max_corr < seuil_sphere
    Pf = [-1 -1];
    %return;
end

% Trouver la position du maximum (la position de la sphere)
[y_max, x_max] = find(Corr==max_corr);

y_max = y_max(1);
x_max = x_max(1);

% Afficher ou non le resultat de la correlation
disp_img = 1;
if disp_img == 1
    figure('Name', 'Image originale');
    imshow(image, [0 255]);
    figure('Name', 'Correlation de la sphere et de l''image');
    mesh(Corr);
    view(2);
    shading('flat');
    set(gca,'ydir','reverse')
    title(['Correlation   -   Y: ' num2str(y_max) ' ; X: ' num2str(x_max) ' ; max: ' num2str(max_corr)]);
end

Pf = [x_max y_max];

end