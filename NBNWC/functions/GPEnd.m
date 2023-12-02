function [EndCodition, X_train, Y_train] = GPEnd(TMax, tolerance, tolerancegp, array, X_train, X, Y_train, fitnessX, U)
EndCodition = 0;
if length(array) > TMax
    if array(end - TMax + 1 : end) < tolerance
        X_train = X;%[X_train; X];
        Y_train = fitnessX;%[Y_train; fitnessX];
        %%
        %
        d_X_train = max(X_train) - min(X_train);
        X_mintrain = min(X_train);
        X_minmaxtrain = (X_train - X_mintrain) ./ (d_X_train);
        %
        d_Y_train = max(Y_train) - min(Y_train);
        Y_mintrain = min(Y_train);
        Y_minmaxtrain = (Y_train - Y_mintrain) ./ (d_Y_train);
        %
        X_test = (U - X_mintrain) ./ (d_X_train);
        %
        index = [];
        for Dith = 1 : length(X_minmaxtrain(1, :))
            if isnan(X_minmaxtrain(:, Dith))
                index = [index, Dith];
            end
        end
        X_minmaxtrain(:, index) = [];
        X_test(:, index) = [];
        %
        gprMdl = fitrgp(X_minmaxtrain, Y_minmaxtrain, 'SigmaLowerBound', 0.2, 'Standardize', true);
        [ymu, ys] = predict(gprMdl, X_test);
        %
        Ymu_test = ymu .* d_Y_train + Y_mintrain;
        Ys_test = ys .* d_Y_train;
        %
        Temp = Ymu_test + 3 * Ys_test;
        if (max(Temp) - max(fitnessX)) < tolerancegp
            EndCodition = 3;
        else
            aaa = 1;
        end
    else
        X_train = [];
        Y_train = [];
    end
end
end