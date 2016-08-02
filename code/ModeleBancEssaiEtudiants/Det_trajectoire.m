
%trajectoire-----------------------------
traj=[0, 1, 1.5, 2, 3, 4;
    0 0.25 0.5 1 1.25 1.5]';

%trajectoire interpolée
[Pi Ltr E Vr Traj tt Tab_banc_essai]=trajectoire(traj,0.1,1);
