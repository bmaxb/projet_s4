function [Pf] = position_sphere(R, G, B, Pi)

% Ratio de la dimension de la sphere a Zmin par rapport a Zmax 
ratio_min_max = 21/19;

% Afficher ou non les images RGB
disp_img = 1;
if disp_img == 1
    figure('Name', 'Image RGB');
    subplot(1,3,1);
    imshow(R);
    title('Red');
    subplot(1,3,2);
    imshow(G);
    title('Green');
    subplot(1,3,3);
    imshow(B);
    title('Blue');
end

% Determiner si oui ou non la sphere est presente sur la plaque



end