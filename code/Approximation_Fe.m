clc
close all
clear all
load('Fe_attraction.mat')

%% Approximation de la force électromagnétique à -1A

% variables
be1 = 13.029359254409743;
Ik = -1;
num = ((Ik)^2 + be1*abs(Ik))*sign(Ik);
Fe_m1A;
y = num./Fe_m1A;    
z_m1A;
dx = [0:0.001:0.04];

% compositioon de la matrice p
phi(:,1) = ones(size(Fe_m1A));
phi(:,2) = z_m1A;
phi(:,3) = z_m1A.^2;
phi(:,4) = z_m1A.^3;

p = [phi(:,1), phi(:,2),phi(:,3), phi(:,4)];


a = pinv(p)*y;
gx = (a(1) + a(2)*dx + a(3)*dx.^2 + a(4)*dx.^3);                % Pour ploter
gx_1 = (a(1) + a(2)*z_m1A + a(3)*z_m1A.^2 + a(4)*z_m1A.^3);      % Pour utiliser dans les erreurs et R

% Graphique de l'apporximation
figure(1);
scatter(z_m1A,num./y);
hold on;
plot(dx,num./gx);
title('Approximation par un terme d''ordre 3 pour Fe à -1A');
xlabel('Position en z de la plaque (m)');
ylabel('Force électromagnétique (N)');
grid on;

% RMS, E, R
ym2 = mean(y);
E = (gx_1-y)'*(gx_1-y)
RMS = rms(gx_1-y)
R = ((gx_1-ym2)'*(gx_1-ym2))./((y-ym2)'*(y-ym2))

% Coefficients
disp('Les coefficients pour -1A')
disp(['ae0: ' num2str(a(1)) '  ae1: ' num2str(a(2))  '  ae3: ' num2str(a(3)) '  ae4:' num2str(a(4))])

%% Approximation de la force électromagnétique à -2A

% variables
Ik2 = -2;
num = ((Ik2)^2 + be1*abs(Ik2))*sign(Ik2);
Fe_m2A;
y2 = num./Fe_m2A;    
z_m2A;
dx2 = [0:0.001:0.04];

% composition de la matrice p
phi2(:,1) = ones(size(Fe_m2A));
phi2(:,2) = z_m2A;
phi2(:,3) = z_m2A.^2;
phi2(:,4) = z_m2A.^3;

p2 = [phi2(:,1), phi2(:,2),phi2(:,3), phi2(:,4)];


a2 = pinv(p2)*y2;
gx2 = (a2(1) + a2(2)*dx2 + a2(3)*dx2.^2 + a2(4)*dx2.^3);                % Pour ploter
gx_2 = (a2(1) + a2(2)*z_m2A + a2(3)*z_m2A.^2 + a2(4)*z_m2A.^3);         % Pour utiliser dans les erreurs et R

% Graphique de l'approximation
figure(2);
scatter(z_m2A,num./y2);
hold on;
plot(dx2,num./gx2);
title('Approximation par un terme d''ordre 3 pour Fe à -2A');
xlabel('Position en z de la plaque (m)');
ylabel('Force électromagnétique (N)');
grid on;

% RMS, E, R
ym2 = mean(y2);
E2 = (gx_2-y2)'*(gx_2-y2)
RMS2 = rms(gx_2-y2)
R2 = ((gx_2-ym2)'*(gx_2-ym2))./((y2-ym2)'*(y2-ym2))


% Coefficients
disp('Les coefficients pour -2A')
disp(['ae0: ' num2str(a2(1)) '  ae1: ' num2str(a2(2))  '  ae3: ' num2str(a2(3)) '  ae4:' num2str(a2(4))])

