clc; clear; close all; 
% Initialisation des matrices --------------------------------------------- 
MatlabProjet 

% Simulink ---------------------------------------------------------------- 
xi = []; 
open_system('simul_lineaire')
sim('simul_lineaire') 
