%Exponential crossover
function [S]=DE_programming_crossover(P,M,param)
CR                       = param.CR;
crossStrategy            = param.crossStrategy;
[NP,Dim]                 = size(P);
switch crossStrategy
    %%
    case 1
        %%
        %crossStrategy=1:binomial crossover
        for i=1:NP
            jRand=round(rand * Dim);
            for j=1:Dim
                a=rand;
                if a<CR||j==jRand
                    S(i,j)=M(i,j);
                else
                    S(i,j)=P(i,j);
                end
            end
        end
    case 2
        %%
        %crossStrategy=2:Exponential crossover
        for i=1:NP
            j=round(rand*Dim);
            S=P;
            S(i,j)=M(i,j);
            j=mod(j+1,Dim);
            L=1;
            for dimIndex = 1:Dim
                if rand > CR
                    break;
                end                
                j=mod(j+1,Dim);
                S(i,j)=M(i,j);
            end
        end
    case 3
        %%
        %crossStrategy=3:one point crossover
        for i=1:NP
            jRand=round(rand * Dim);
            for j=1:Dim
                S(i, :) = [M(i, 1 : jRand) P(i, jRand + 1 : end)];
                
                if j <= jRand
                    S(i,j)=M(i,j);
                else
                    S(i,j)=P(i,j);
                end
            end
        end
    case 4
        %%
        %crossStrategy=4:two point crossover
        for i=1:NP
            j=floor(rand*Dim);
            L=0;
            S=P;
            S(i,j)=M(i,j);
            j=mod(j+1,D);
            L=L+1;
            while(rand<CR&&L<Dim)
                S(i,j)=M(i,j);
                j=mod(j+1,D);
                L=L+1;
            end
        end
    otherwise
        error('Ã»ÓÐËùÖ¸¶¨µÄ½»²æ²ßÂÔ£¬Ç?ÖØÐÂÉè¶¨crossStrategyµÄÖµ');
end
