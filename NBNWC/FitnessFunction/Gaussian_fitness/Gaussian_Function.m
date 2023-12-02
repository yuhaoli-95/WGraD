function y = Gaussian_Function(X, FuncID, ff_min, ff_max)
[position_xy,radius] = retuen_circle_position(FuncID);
position_xy = (position_xy + 0.5) * (ff_max - ff_min);
radius = radius * (ff_max - ff_min);
%%
d = 2;
sigema = radius/d;
var = (sigema)^2;
si = [var 0;0 var;];
mu = position_xy;
%%
y = 0;
for k=1:length(position_xy(:,1))
    y = y + mvnpdf(X ,mu(k,:),si);
end
% error('The index of test functions are only defined for index=1-29. 1-28:cec 2013 | 29:unimodal | 30:multi-modal');
end