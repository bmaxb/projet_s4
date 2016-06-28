clc
close all
clear all
load('Fs.mat')

%% Approximation de la force des aimants permanents

% variables
num = -1;
y = num./Fs
z_pos;
dx = [0:0.001:0.04];

% composition de la matrice p
phi(:,1) = ones(size(y));
phi(:,2) = z_pos;
phi(:,3) = z_pos.^2;
phi(:,4) = z_pos.^3;

p = [phi(:,1), phi(:,2),phi(:,3), phi(:,4)];


a = pinv(p)*y;
gx = a(1) + a(2)*dx + a(3)*dx.^2 + a(4)*dx.^3; 
gx1 = a(1) + a(2)*z_pos + a(3)*z_pos.^2 + a(4)*z_pos.^3;

% Graphique de l'approximation
figure(1);
scatter(z_pos,y);
hold on;
plot(dx,gx);
title('Approximation par un terme d''ordre 3 pour Fs');
xlabel('Position en z de la plaque (m)');
ylabel('Force des aimants permanents (N)');
grid on;

% RMS, E, R
ym = mean(y);
E = (gx1-y)'*(gx1-y)
RMS = rms(gx1-y)
R = ((gx1-ym)'*(gx1-ym))./((y-ym)'*(y-ym))

% Coefficients
disp('Les coefficients pour Fs')
disp(['as0: ' num2str(a(1)) '  as1: ' num2str(a(2))  '  as3: ' num2str(a(3)) '  as4:' num2str(a(4))])
