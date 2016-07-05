close all; clear; clc

modeles = cell(4,1);
modeles{1} = 'JBobfusc';
modeles{2} = 'nonlineaire'; 
modeles{3} = 'decouple'; 
modeles{4} = 'lineaire';
figure
hold on
for modele_num = 1:4
    % Position à l'équilibre de la sphère (pour tests statiques)
    xSeq = 0.000;      % Position x de la sphère à l'équilibre en metres
    ySeq = 0.000;      % Position y de la sphère à l'équilibre en metres

    %Point d'opération choisi pour la plaque
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

    %simulation
    open_system(['DYNctl_ver4_etud_' modeles{modele_num}])
    set_param(['DYNctl_ver4_etud_' modeles{modele_num}],'AlgebraicLoopSolver','LineSearch')
    sim(['DYNctl_ver4_etud_' modeles{modele_num}])
    
    if strcmp(modeles{modele_num}, 'JBobfusc') || strcmp(modeles{modele_num}, 'nonlineaire')
        figure(1)
        subplot(2,2,1); hold on; plot(tsim, ynonlineaire(:,7))
        subplot(2,2,2); hold on; plot(tsim, ynonlineaire(:,8))
        subplot(2,2,3); hold on; plot(tsim, ynonlineaire(:,9))
        subplot(2,2,4); hold on; plot(tsim, ynonlineaire(:,10))
        figure(2)
        subplot(1,3,1); hold on; plot(tsim, ynonlineaire(:,17))
        subplot(1,3,2); hold on; plot(tsim, ynonlineaire(:,18))
        subplot(1,3,3); hold on; plot(tsim, ynonlineaire(:,19))
    elseif strcmp(modeles{modele_num}, 'decouple')
        figure(1)
        subplot(2,2,1); hold on; plot(tsim, ydecouple(:,1))
        subplot(2,2,2); hold on; plot(tsim, ydecouple(:,2))
        subplot(2,2,3); hold on; plot(tsim, ydecouple(:,3))
        subplot(2,2,4); hold on; plot(tsim, ydecouple(:,4))
        figure(2)
        subplot(1,3,1); hold on; plot(tsim, ydecouple(:,5))
        subplot(1,3,2); hold on; plot(tsim, ydecouple(:,6))
        subplot(1,3,3); hold on; plot(tsim, ydecouple(:,7))
    elseif strcmp(modeles{modele_num}, 'lineaire')
        figure(1)
        subplot(2,2,1); hold on; plot(tsim, ylineaire(:,1))
        subplot(2,2,2); hold on; plot(tsim, ylineaire(:,2))
        subplot(2,2,3); hold on; plot(tsim, ylineaire(:,3))
        subplot(2,2,4); hold on; plot(tsim, ylineaire(:,4))
        figure(2)
        subplot(1,3,1); hold on; plot(tsim, ylineaire(:,5))
        subplot(1,3,2); hold on; plot(tsim, ylineaire(:,6))
        subplot(1,3,3); hold on; plot(tsim, ylineaire(:,7))
    end
end

figure(1)
subplot(2,2,1); title('Position de la bille en x');
subplot(2,2,2); title('Position de la bille en y');
subplot(2,2,3); title('Vitesse de la bille en x');
subplot(2,2,4); title('Vitesse de la bille en y'); legend(modeles)

figure(2)
subplot(1,3,1); title('Distance au capteur D');
subplot(1,3,2); title('Distance au capteur E');
subplot(1,3,3); title('Distance au capteur F'); legend(modeles)


%plot(tsim, ylineaire(:,1))
%plot(tsim, ynonlineaire(:,7))
%plot(tsim, ydecouple(:,1))

%affichage
%trajectoires