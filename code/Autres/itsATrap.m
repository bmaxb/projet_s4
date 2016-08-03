function [integrationDeTrapz, Ltr] = itsATrap(g, a, b)
h = (b - a) / (2 * length(g));

Ltr(1,1) = g(1);
total = h * g(1);
Ltr(1,2) = total;

for i = 2:1:length(g)-1
    Ltr(i,1) = g(i);
    total = total + (h * (2 * g(i)));
    Ltr(i,2) = total;
end

j = length(g);
Ltr(j,1) = g(j);
total = total + (h * g(end));
Ltr(j, 2) = total;

integrationDeTrapz = Ltr(end);
end