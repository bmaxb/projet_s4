
%trajectoire-----------------------------
% traj=[0, 1, 1.5, 2, 3, 4;
%     0 0.25 0.5 1 1.25 1.5]';

load('trajectoire.mat')
%trajectoire interpolée
[Pi Ltr E Vr Traj tt Tab_banc_essai]=trajectoire(NAB,vAB,Ts);
