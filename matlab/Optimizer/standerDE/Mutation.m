function [V] = Mutation(X,bestX,param)
F                        = param.F;
mutationStrategy         = param.mutationStrategy;
[NP,gen_num]             = size(X);
V                        = zeros(NP,gen_num);
for i=1:NP
    nrandI=5;
    r=randi([1,NP],1,nrandI);    
    switch mutationStrategy
        case 1
            %mutationStrategy=1:DE/rand/1;
            V(i,:)=X(r(1),:)+F*(X(r(2),:)-X(r(3),:));
        case 2
            %mutationStrategy=2:DE/best/1;
            V(i,:)=bestX+F*(X(r(1),:)-X(r(2),:));
        case 3
            %mutationStrategy=3:DE/rand-to-best/1;
            V(i,:)=X(i,:)+F*(bestX-X(i,:))+F*(X(r(1),:)-X(r(2),:));
        case 4
            %mutationStrategy=4:DE/best/2;
            V(i,:)=bestX+F*(X(r(1),:)-X(r(2),:))+F*(X(r(3),:)-X(r(4),:));
        case 5
            %mutationStrategy=5:DE/rand/2;
            V(i,:)=X(r(1),:)+F*(X(r(2),:)-X(r(3),:))+F*(X(r(4),:)-X(r(5),:));
        otherwise
            error('');
    end
end
