function [fes, BestIndi, All] = cmaes(cmaes_para, cluster, fes)
BestIndi = [];
All = [];
CostFunction = @fitness;
nVar    = cmaes_para.Dim;              % Number of Unknown (Decision) Variables
VarSize = [1 nVar];         % Decision Variables Matrix Size
VarMin  = min(cluster(:, 1 : nVar));              % Lower Bound of Decision Variables             cmaes_para.lb
VarMax  = max(cluster(:, 1 : nVar));               % Upper Bound of Decision Variables               cmaes_para.ub
%% CMA-ES Settings
% Population Size (and Number of Offsprings)
lambda = (4+round(3*log(nVar)))*10;
% Number of Parents
mu = round(lambda/2);
% Parent Weights
w = log(mu+0.5)-log(1:mu);
w = w/sum(w);
% Number of Effective Solutions
mu_eff = 1/sum(w.^2);
% Step Size Control Parameters (c_sigma and d_sigma);
sigma0 = 0.3*(VarMax-VarMin);
cs = (mu_eff+2)/(nVar+mu_eff+5);
ds = 1+cs+2*max(sqrt((mu_eff-1)/(nVar+1))-1,0);
ENN = sqrt(nVar)*(1-1/(4*nVar)+1/(21*nVar^2));
% Covariance Update Parameters
cc = (4+mu_eff/nVar)/(4+nVar+2*mu_eff/nVar);
c1 = 2/((nVar+1.3)^2+mu_eff);
alpha_mu = 2;
cmu = min(1-c1,alpha_mu*(mu_eff-2+1/mu_eff)/((nVar+2)^2+alpha_mu*mu_eff/2));
hth = (1.4+2/(nVar+1))*ENN;
% Maximum Number of Iterations
MaxIt = ceil( (cmaes_para.MaxFes - fes) / lambda );
%% Initialization
ps = cell(MaxIt,1);
pc = cell(MaxIt,1);
C = cell(MaxIt,1);
sigma = cell(MaxIt,1);
ps{1} = zeros(VarSize);
pc{1} = zeros(VarSize);
C{1} = eye(nVar);
sigma{1} = sigma0;
empty_individual.Position = [];
empty_individual.Step = [];
empty_individual.Cost = [];
M = repmat(empty_individual,MaxIt,1);
[~, best_index] = max(cluster(:, end));
M(1).Position = cluster(best_index, 1 : nVar); %unifrnd(VarMin,VarMax,VarSize);
M(1).Step = zeros(VarSize);
M(1).Cost = cluster(best_index, end); %CostFunction(M(1).Position);
BestSol = M(1);
BestCost = zeros(MaxIt,1);
FitImprArray = [];
eval(['GMax = ', cmaes_para.stopgeneration, ';']);
tolerance = cmaes_para.tolerance;
%% CMA-ES Main Loop
for g = 1 : MaxIt
    
    % Generate Samples
    pop = repmat(empty_individual,lambda,1);
    for i = 1:lambda
        pop(i).Step = mvnrnd(zeros(VarSize),C{g});
        pop(i).Position = M(g).Position+sigma{g} .* pop(i).Step;        
        [pop(i).Position, pop(i).Cost] = Cross_border_inspecte(pop(i).Position, cmaes_para);
                
        %         pop(i).Cost = CostFunction(pop(i).Position, cmaes_para);
        
        % Update Best Solution Ever Found
        if pop(i).Cost > BestSol.Cost
            BestSol = pop(i);
        end
    end
    
    % Sort Population
    Costs = [pop.Cost];
    [Costs, SortOrder] = sort(Costs, 'descend');
    pop = pop(SortOrder);
    
    % Save Results
    BestCost(g) = BestSol.Cost;
    BestIndi = [BestSol.Position, BestSol.Cost];
    if g == 1
        FitImprArray(g) = BestCost(g) - M(1).Cost;
    else
        FitImprArray(g) = BestCost(g) - BestCost(g - 1);
    end
    
    fes = fes + lambda;
    if fes > cmaes_para.MaxFes
        break;
    end
    
    % Display Results
    %     disp(['Iteration ' num2str(g) ': Best Cost  =  ' num2str(BestCost(g))]);
    
    % Exit At Last Iteration
    if g == MaxIt
        break;
    end
    
    % Update Mean
    M(g+1).Step = 0;
    for j = 1:mu
        M(g+1).Step = M(g+1).Step+w(j)*pop(j).Step;
    end
    M(g+1).Position = M(g).Position+sigma{g} .* M(g+1).Step;
    [M(g+1).Position, M(g+1).Cost] = Cross_border_inspecte(M(g+1).Position, cmaes_para);
    %     M(g+1).Cost = CostFunction(M(g+1).Position, cmaes_para);
    if M(g+1).Cost > BestSol.Cost
        BestSol = M(g+1);
        BestIndi = [BestSol.Position, BestSol.Cost];
    end
    fes = fes + 1;
    
    % Update Step Size
    ps{g+1} = (1-cs)*ps{g}+sqrt(cs*(2-cs)*mu_eff)*M(g+1).Step/chol(C{g})';
    sigma{g+1} = sigma{g} .* exp(cs/ds*(norm(ps{g+1})/ENN-1))^0.3;
    
    % Update Covariance Matrix
    if norm(ps{g+1})/sqrt(1-(1-cs)^(2*(g+1)))<hth
        hs = 1;
    else
        hs = 0;
    end
    delta = (1-hs)*cc*(2-cc);
    pc{g+1} = (1-cc)*pc{g}+hs*sqrt(cc*(2-cc)*mu_eff)*M(g+1).Step;
    C{g+1} = (1-c1-cmu)*C{g}+c1*(pc{g+1}'*pc{g+1}+delta*C{g});
    for j = 1:mu
        C{g+1} = C{g+1}+cmu*w(j)*pop(j).Step'*pop(j).Step;
    end
    
    % If Covariance Matrix is not Positive Defenite or Near Singular
    [V, E] = eig(C{g+1});
    if any(diag(E)<0)
        E = max(E,0);
        C{g+1} = V*E/V;
    end
    
    %%
    if length(FitImprArray) > GMax
        if FitImprArray(end - GMax + 1 : end) < tolerance
            break;
        end
    end
end
end