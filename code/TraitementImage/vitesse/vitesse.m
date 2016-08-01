% Calcul la differenciation numerique arriere d ordre N
function vitesse(Fe, positions, N)
    h = 1/Fe;
    x = positions(:, 1);
    y = positions(:, 2);
    temps = 0 : h : (length(x) - 1) * h;
    
    % S'il manque de donnees pour l ordre de differenciation, ramene l'ordre au minimum possible
    if(length(x) < N)
        N = length(x);
    end
    
    % Calcul les derivees d'ordre N
    if N >= 2
        for k = 2 : N
            temp = deriveeArriereOrdreSuperieur(x, y, k);
            deriveesArrieresX(k-1,:) = temp(1, :);
            deriveesArrieresY(k-1,:) = temp(2, :);
        end
    end
    
    % Calcul principal, traite les premiers calculs de vitesse ou
    % l'incrementation est plus petite que l'ordre de differenciation
    vitesseX = 0;
    vitesseY = 0;
    for k = 2 : length(x)
        sumDeriveesArrieresX = 0;
        sumDeriveesArrieresY = 0;
        for n = 2 : N
            sumDeriveesArrieresX = sumDeriveesArrieresX + ((-h)^n / factorial(n)) * deriveesArrieresX(n - 1, k);
            sumDeriveesArrieresY = sumDeriveesArrieresY + ((-h)^n / factorial(n)) * deriveesArrieresY(n - 1, k);
        end
        vitesseX(k) = (x(k) - x(k - 1) + sumDeriveesArrieresX) / h;
        vitesseY(k) = (y(k) - y(k - 1) + sumDeriveesArrieresY) / h;
    end
    
    % Graphiques
    figure;
    hold on;
    title('Vitesse en X');
    xlabel('Temps (s)');
    ylabel('Vitesse (m / s)');
    plot(temps, vitesseX);
    hold off;

    figure;
    hold on;
    title('Vitesse en Y');
    xlabel('Temps (s)');
    ylabel('Vitesse (m / s)');
    plot(temps, vitesseY);
    hold off;
end