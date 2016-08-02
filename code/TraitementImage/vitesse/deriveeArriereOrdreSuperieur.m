% Projet S4
% Equipe P5
% Calcul la derivee numerique arriere d'ordre N des tableaux de position
% Backward higher-order differences : https://en.wikipedia.org/wiki/Finite_difference#Higher-order_differences
function derivee = deriveeArriereOrdreSuperieur(x, y, N)
    deriveeX = zeros(1, length(x));
    deriveeY = zeros(1, length(x));
    for k = N + 1 : length(x)
        for i = 0 : N
            nombreBinaire = (factorial(N))/(factorial(i) * factorial(N-i));
            deriveeX(k) = deriveeX(k) + ((-1)^i * nombreBinaire * x(k - i));
            deriveeY(k) = deriveeY(k) + ((-1)^i * nombreBinaire * y(k - i));
        end
    end
    derivee(1,:) = deriveeX(:);
    derivee(2,:) = deriveeY(:);
end