function [ output ] = interpolationGenerique( x, y, showGraph )
%INTERPOLATION_GENERIQUE Interpolation Generique
%   Calcul la courbe en tout point
syms t
if length(x) ~= length(y)
    disp(['x = ' mat2str(x')]); disp(['y = ' mat2str(y')])
    error('Les matrices donnees ne sont pas de meme taille!')
end

% Calcul de la matrice phi ------------------------------------------------
for i = length(x):-1:1
    phi(:,i) = x.^(i-1);
end

% Extrapolation des coefficients -----------------------------------------
C = phi\y;
output = 0;
for n = 1:length(C)
    output = output + C(n).*t.^(n-1);
end

% Dessin des graphiques (si showGraph == 1) -------------------------------
if showGraph == 1
    t = (0:.5:x(end))';
    figure
    plot(x, y, '*b'); hold on
    plot(t, subs(output), 'r')
    title(['Interpolation generique (degree ' num2str(length(C)) ')'])
    xlabel('x'); ylabel('y')
end


end

