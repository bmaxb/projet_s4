% APP 5
% Eric Matte et Ian Lachance
% mate2002, laci2103
function y = dec2Qformat(x, Q)
%UNTITLED2 Summary of this function goes here   
% binary number
n = Q(1);
m = Q(2);
y = [];
for l = 1:length(x(:,1))
    x_line = x(l,:);
    y_line = [];
    for k = 1:length(x_line)
        d2b = fix(rem(x_line(k)*pow2(-(n-1):m),2)); 
        % the inverse transformation
        y_line = [y_line, d2b*pow2(n-1:-1:-m).'];
    end
    y = [y; y_line];
end
end

