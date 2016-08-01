close all; clear; clc

modeles = {'JBobfusc_Asserprof'; 'nonlineaire';'nonlineaire_plaque'; 'JBobfusc'};
figure
hold on
% Position à l'équilibre de la sphère (pour tests statiques)
sig = 0;            % Présence (1) ou non (0) de la sphère
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
z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*0.015];
Aydes     = [t_des, [0 3 0 1  2  3 0 -1 1]'*pi/180];
Axdes     = [t_des, [0 0 0 0  0  0 0 0 0]'*pi/180];
tfin = 50;

%initialisation
% bancEssaiConstantes
% bancessai_ini  %faites tous vos calculs de modele ici
Decouplage

%Calcul des compensateurs
%iniCTL_ver4    %Calculez vos compensateurs ici
close all;
for modele_num = 1:2
    %simulation
    open_system(['DYNctl_ver4_etud_' modeles{modele_num}])
    set_param(['DYNctl_ver4_etud_' modeles{modele_num}],'AlgebraicLoopSolver','LineSearch')
    sim(['DYNctl_ver4_etud_' modeles{modele_num}])


    if strcmp(modeles{modele_num}, 'JBobfusc_Asserprof')
        figure(1)
        for graph = 1:4
            subplot(2,2,graph); hold on; plot(tsim, ynonlineaire_profAprof(:,graph+6))
        end
        figure(2)
        for graph = 1:3
            subplot(1,3,graph); hold on; plot(tsim, ynonlineaire_profAprof(:,graph+16))
        end
    elseif strcmp(modeles{modele_num}, 'nonlineaire')
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

output_plaque_bille=[ynonlineaire_60hz(:,7),ynonlineaire_60hz(:,8),ynonlineaire_60hz(:,1),ynonlineaire_60hz(:,2)];
csvwrite('plaque_bille_blender',output_plaque_bille);
    
if sig==0
    open_system(['DYNctl_ver4_etud_' modeles{3}])
    set_param(['DYNctl_ver4_etud_' modeles{3}],'AlgebraicLoopSolver','LineSearch')
    sim(['DYNctl_ver4_etud_' modeles{3}])
    
    figure(3)
    plot(tsim, ynonlineaire_plaque(:,1)*180/pi)
    hold on
    plot(tsim, ynonlineaire_plaque(:,2)*180/pi)
    title('Angle phi et theta (control plaque)');
    legend('Phi','Theta')
    
    output_plaque=[ynonlineaire_plaque_60hz(:,7),ynonlineaire_plaque_60hz(:,8),ynonlineaire_plaque_60hz(:,1),ynonlineaire_plaque_60hz(:,2)];
    csvwrite('plaque_blender',output_plaque);
end