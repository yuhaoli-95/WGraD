function plot_Landscape(para, if_sample, if_mesh, ifGraph)
if ifGraph
    Dim         = para.Dim;
    lb          = para.lb;
    ub          = para.ub;
    d           = 500;
    %%
    if Dim == 1
        hold on
        x = linspace(lb, ub, d);
        y = zeros(size(x));
        for i=1:length(x)
            y(i) = fitness(x(i), para); % fitness evaluation
        end
        plot(x, y);xlabel('X');ylabel('Fitness');%title(['CEC2013 Niche Benchmark FuncID: ',num2str(para.FuncID), '  # of sample: ', num2str(para.SamNum)]);
        if if_sample
            plot(para.sampledata(:, 1), para.sampledata(:, 2), 'r.');
        end
        %     saveas(gcf, [folder_name, '\graph\Func', num2str(FuncID), '.fig']);
        %     saveas(gcf, [folder_name, '\graph\Func', num2str(FuncID), '.bmp']);
    elseif Dim == 2
        hold on
        g_x = gridsamp([lb(1) lb(2);ub(1) ub(2)], d);
        P_F = zeros(length(g_x), 1);
        for i = 1 : length(g_x(:,1))
            P_F(i) = fitness(g_x(i, :), para);
        end
        X1 = reshape(g_x(:,1), d, d);
        X2 = reshape(g_x(:,2), size(X1));
        P_F = reshape(P_F, size(X1));
        if if_mesh
            mesh(X1,X2,P_F);
            if if_sample
                plot3(para.sampledata(:, 1), para.sampledata(:, 2), para.sampledata(:, 3), 'O');
            end
        else
            contour(X1,X2,P_F);
            if if_sample
                plot(para.sampledata(:, 1), para.sampledata(:, 2), 'bo', 'MarkerSize', 5);
            end
        end
        xlabel('X1');ylabel('X2');zlabel('Fitness');%title(['CEC2013 Niche Benchmark FuncID: ',num2str(para.FuncID)]);
        %     saveas(gcf, [folder_name, '\graph\Func', num2str(FuncID), '.fig']);
        %     saveas(gcf, [folder_name, '\graph\Func', num2str(FuncID), '.bmp']);
    else
        error('Dim NOT EQUAL 1 OR 2!!');
    end
end
end