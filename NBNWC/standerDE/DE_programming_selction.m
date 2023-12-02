function [offspring, fitness_off, fitnessU] = DE_programming_selction(X,U,fitnessX,fitnessbestX,bestX,param, LoModal)
[NP,~]       = size(X);
offspring    = zeros(size(X));
fitness_off  = zeros(NP,1);
FuncID       = param.fitness_index;
fitnessU     = zeros(NP,1);
for i = 1 : NP
    Temp = U(i,:);
    fitnessU(i) = DE_programming_testFun(Temp, FuncID);
end

for i=1:NP
    %%
    %maximization
    if fitnessU(i) >= fitnessX(i)
        offspring(i,:) = U(i,:);
        fitness_off(i) = fitnessU(i);
        if fitnessU(i) > fitnessbestX%min solution is best
            bestX = U(i,:);
            fitnessbestX = fitnessU(i);
        end
    else
        offspring(i,:) = X(i,:);
        fitness_off(i) = fitnessX(i);
        if fitnessX(i) > fitnessbestX%min solution is best
            bestX = X(i,:);
            fitnessbestX = fitnessX(i);
        end
    end
end
end
%%
%     if ~isempty(LoModal(1).lb)
%         for LMjth = 1 : length(LoModal)
%             lb = LoModal(LMjth).lb;
%             ub = LoModal(LMjth).ub;
%             %point i is in the LMjth local area
%             if [Temp - lb ub - Temp] > 0
%                 bestX = LoModal(LMjth).bestso(:, 1 : end - 1);
%                 CentreX = mean(X);
%                 Vb = bestX - CentreX;
%                 Vt = Temp - CentreX;
%                 if dot(Vt, Vb)%angle between Vt and Vb < 90
%                     %obtain new sample
%                     unitv = (bestX - Temp) / norm(bestX - Temp) / max(num);
%                     SamPl = repmat(Temp, max(num), 1) + num .* unitv;
%                     ifhill = 1;
%                     for Samplith = 1 : num(end)
%                         count = count + 1;
%                         if DE_programming_testFun(SamPl(Samplith, :), FuncID) < min([fitnessU(i) LoModal(LMjth).bestso(:, end)])
%                             %offspring and Best are in the different hill
%                             ifhill = 0;
%                             break;
%                         end
%                     end
%                     if ifhill
%                         fitnessU(i) = fitnessU(i) - 2 * abs(fitnessU(i));
%                     end
%                 end
%             end
%         end
%     end
