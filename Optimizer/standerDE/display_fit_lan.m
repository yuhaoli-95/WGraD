function display_fit_lan(min_value, max_value, param)
t = min_value : 0.5 : max_value;
[X, Y] = meshgrid(t);
for i = 1:length(X)
    for j = 1:length(X)
        Z(i, j) = DE_programming_testFun([X(i, j), Y(i, j)],param);
    end
end
mesh(X, Y, Z);
end