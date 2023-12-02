function plotNetWork(NewCluster, para, if_mesh, FuncID, W, weight, input, output, SampleNum)
for i = 1 : length(NewCluster)
    t = cell2mat(NewCluster(i));
    if para.D == 1
        plot(input(t, 1), output(t, 1), 'O');title(['FuncID: ',num2str(FuncID), ' Weight: ', num2str(weight(W)), '   # of Sample: ', num2str(SampleNum)]);
    elseif para.D == 2
        if if_mesh
            plot3(input(t, 1), input(t, 2),  output(t), 'S', 'Markersize', 10);title(['FuncID: ',num2str(FuncID), ' Weight: ', num2str(weight(W)), '   # of Sample: ', num2str(SampleNum)]);
        else
            plot(input(t, 1), input(t, 2), 'o', 'Markersize', 4);title(['FuncID: ',num2str(FuncID), ' Weight: ', num2str(weight(W)), '   # of Sample: ', num2str(para.SamNum)]);
        end
    end
end
end