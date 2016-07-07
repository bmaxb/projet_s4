close all; clear; clc

modeles = {'JBobfusc'; 'nonlineaire'; 'decouple'; 'lineaire'};
figure
hold on
% Position � l'�quilibre de la sph�re (pour tests statiques)
xSeq = 0.000;      % Position x de la sph�re � l'�quilibre en metres
ySeq = 0.000;      % Position y de la sph�re � l'�quilibre en metres

%Point d'op�ration choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = .015;            %en metres

%Exemple de trajectoire
t_des     = (0:1:8)'*5;
x_des     = [t_des, [0 0 0.5 1  0 -1 0 1 0]'*0.05];
y_des     = [t_des, [0 0 0 0 -1  0 1 0 0]'*0.05];
z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*.015];
tfin = 50;

%initialisation
% bancEssaiConstantes
% bancessai_ini  %faites tous vos calculs de modele ici
Decouplage

%Calcul des compensateurs
%iniCTL_ver4    %Calculez vos compensateurs ici

for modele_num = 1:4
    %simulation
    open_system(['DYNctl_ver4_etud_' modeles{modele_num}])
    set_param(['DYNctl_ver4_etud_' modeles{modele_num}],'AlgebraicLoopSolver','LineSearch')
    sim(['DYNctl_ver4_etud_' modeles{modele_num}])
    
    if strcmp(modeles{modele_num}, 'JBobfusc') || strcmp(modeles{modele_num}, 'nonlineaire')
        figure(1)
        for graph = 1:4
            subplot(2,2,graph); hold on; plot(tsim, ynonlineaire(:,graph+6))
        end
        figure(2)
        for graph = 1:3
            subplot(1,3,graph); hold on; plot(tsim, ynonlineaire(:,graph+16))
        end
    elseif strcmp(modeles{modele_num}, 'decouple')
        figure(1)
        for graph = 1:4
            subplot(2,2,graph); hold on; plot(tsim, ydecouple(:,graph))
        end
        figure(2)
        for graph = 1:3
            subplot(1,3,graph); hold on; plot(tsim, ydecouple(:,graph+4))
        end
    elseif strcmp(modeles{modele_num}, 'lineaire')
        figure(1)
        for graph = 1:4
            subplot(2,2,graph); hold on; plot(tsim, ylineaire(:,graph))
        end
        figure(2)
        for graph = 1:3
            subplot(1,3,graph); hold on; plot(tsim, ylineaire(:,graph+4))
        end
    end
end


%affichage
%trajectoires
figure(1)
subplot(2,2,1); title('Position de la bille en x');
subplot(2,2,2); title('Position de la bille en y');
subplot(2,2,3); title('Vitesse de la bille en x');
subplot(2,2,4); title('Vitesse de la bille en y'); legend(modeles)

figure(2)
subplot(1,3,1); title('Distance au capteur D');
subplot(1,3,2); title('Distance au capteur E');
subplot(1,3,3); title('Distance au capteur F'); legend(modeles)