function X=DE_programming_Cross_border_inspecte(X,param)
Xmin                     = param.Xmin;
Xmax                     = param.Xmax;
for i=1:length(X(:,1))
    for j=1:length(X(1,:))
        if(X(i,j)<Xmin(j))
            X(i,j)=Xmax(j)-abs(mod((X(i,j)-Xmin(j)),(Xmax(j)-Xmin(j))));
        elseif(X(i,j)>Xmax(j))
            X(i,j)=Xmin(j)+abs(mod((Xmin(j)-X(i,j)),(Xmax(j)-Xmin(j))));
        end
    end
end
end