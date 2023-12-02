function return_legend(count, curve_str)
curve_name=cell(count,1);
for i=1:count
    curve_name(i) = curve_str(i);
end
legend_command = ['legend(p, ''', curve_name{1}, ''''];
for i = 2 : count % Construct the command the display a legend
    legend_command = [legend_command, ',''', curve_name{i}, ''''];
end
legend_command = [legend_command, ')'];
eval(legend_command);
end