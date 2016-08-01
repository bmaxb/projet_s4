function name = message_name(m, M)
%MESSAGE_NAME Donne le nom de chacun des messages en fréquence
%   Exemple: pour M=2: F1_L (m=1), F2_L (m=2), F1_H (m=3), F2_H (m=4)
if m <= M
    name = ['F_' num2str(m) '_L'];
else
    name = ['F_' num2str(m-M) '_H'];
end
end

