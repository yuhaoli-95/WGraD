function f = fobj(x, pn,n,popsize)
f=zeros(popsize,1);
switch pn;
    case 1
        % Sphere function
        for i=1:popsize
            f(i,1) =sum(x(i,:).^2);
        end
    case 2
        % Schwefwl2.22
        for i=1:popsize
            s = 0;
            product = 1;
            for j = 1 : n
                s = s + abs(x(i,j));
                product = product.* abs(x(i,j));
            end
            f(i,1) = s + product;
        end
    case 3
        % Schwefwl1.2
        for i=1:popsize
            f(i,1) = 0;
            for j = 1 : n
                innersum = 0;
                for jj = 1 : j
                    innersum = innersum + x(i,jj);
                end
                f(i,1) = f(i,1) + innersum^2;
            end
        end
    case 4
        % Schwefwl2.21
        for i=1:popsize
            f(i,1)=max (abs(x(i,:)));
        end
        
    case 5
        %rosenbrock
        for i=1:popsize
            f(i,1) = sum(100*(x(i,2:n)-x(i,1:n-1).^2).^2 + (1-x(i,1:n-1)).^2);
        end
    case 6
        %Step function
        %         for j = 1 : p
        %         x = Population(popindex).chrom(j);
        %         Population(popindex).cost = Population(popindex).cost + (floor(x+0.5))^2;
        %
        for i=1:popsize
            s=0;
            for j=1:n
                s=s+(floor(x(i,j)+0.5)).^2;
            end
            f(i,1)=s;
        end
        %         f(i,1)=sum(floor(x(i,1,:)+0.5).^2);
        
    case 7
        % Noisy Quartic
        for i=1:popsize
            s1=0;
            for j=1:n
                s1=s1+j.*x(i,j).^4;
            end
            f(i,1)=s1+rand;
        end
        
    case 8
        % Schwefwl2.26
        for i=1:popsize
            f(i,1) =-1* sum((x(i,:)).*sin(sqrt(abs(x(i,:)))));%% 418.98288727243369*n
            
        end
    case 9
        %rastring
        for i=1:popsize
            f(i,1) =  sum((x(i,:)).^2 - 10*cos(2*pi*x(i,:))+10);
        end
    case 10
        % Ackley
        
        a = 20; b = 0.2; c = 2*pi;
        for i=1:popsize
%             f(i,1) = -a*exp(-b*sqrt(sum(x(i,:).^2)/n))-exp(sum(cos(c*x(i,:)))/n)+a+exp(1);
            
            s1 = 0; s2 = 0;
            for j=1:n;
                s1 = s1+x(i,j)^2;
                s2 = s2+cos(c*x(i,j));
            end
             f(i,1) = -a*exp(-b*sqrt(1/n*s1))-exp(1/n*s2)+a+exp(1);
            
        end
    case 11
        % Griewank
        for i=1:popsize
            product=1;
          
            s=sum(x(i,:).^2);
            for j=1:n
                product=product.*(cos(x(i,j)/sqrt(j)));
                %             s = s + (x(i,1,j).^2);
            end
            f(i,1) = s* (1/4000) - product +1 ;
        end
        


    case 12
        for i=1:popsize
            a=10;
            k=1000;
            m=4;
            miu= zeros(n,1);
            miu(x(i,:)>a) = k * (x(i,x(i,:)>a)-a).^m;
            miu(x(i,:)<-1*a) = k * (-a - x(i,x(i,:)<(-1*a))).^m;
            
            y=1+ 0.25 * (x(i,:)+1);
            
            f(i,1) = (pi/n) * ((10*sin(pi*y(1))^2) + sum((y(1:n-1)-1).^2 .* (1 + 10*sin(pi*y(2:n)).^2)) + (y(n)-1)^2) + sum(miu);
        end
    case 13
        for i=1:popsize
            a=5;
            k=100;
            m=4;
            miu= zeros(n,1);
            miu(x(i,:)>a) = k * (x(i,x(i,:)>a)-a).^m;
            miu(x(i,:)<-1*a) = k * (-a - x(i,x(i,:)<(-1*a))).^m;
            
            f(i,1) = 0.1 * (sin(3*pi*x(i,1))^2 + sum((x(i,1:n-1)-1).^2 .* (1 + sin(3*pi*x(i,2:n)).^2)) + (x(i,n)-1)^2*(1+sin(2*pi*x(i,n)).^2)) + sum(miu);
        end
end
