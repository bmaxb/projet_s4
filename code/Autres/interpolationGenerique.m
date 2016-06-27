function [Coef] = interpolationGenerique(X, Y, Ts, showGraph)
%INTERPOLATION_GENERIQUE Interpolation Generique

%   Calcul la courbe en tout point
if length(X) ~= length(Y)
    disp(['X = ' mat2str(X')]); disp(['Y = ' mat2str(Y')])
    error('Les matrices donnees ne sont pas de meme taille!')
end

t = min(X):Ts:max(X);

% Calcul de la matrice phi ------------------------------------------------
for i = length(X):-1:1
    phi(:,i) = X.^(i-1);
end

% Extrapolation des coefficients -----------------------------------------
Coef = phi\Y;

% RMS et Correlation pour determiner les coefficients utiles
% Calcul des valeurs
Vals = 0;
for n = 1:length(Coef)
    Vals = Vals + Coef(n).*X.^(n-1);     
    RMS = sqrt(1/length(X) * sum((Vals - Y).^2));
    Corr = sum((Vals - mean(Y)).^2)/sum((Y - mean(Y)).^2);  
    if(Corr == 1)
        break
    end  
end

% Dessin des graphiques (si showGraph == 1) -------------------------------
if showGraph == 1     
    figure
    plot(X, Y, '*b');
    hold on
    plot(t, Vals, 'r')
    title(['Interpolation generique (degree ' num2str(length(Coef)) ')'])
    xlabel('x');
    ylabel('y')
end

end

