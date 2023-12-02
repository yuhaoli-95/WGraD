function [x] = Cell_Init_x (xmin,xmax,n,q)% #coder
%--------------------------------------------------------------------------
%Copyright (c) 2015 by Saber Elsayed
%Cell based initialization
%--------------------------------------------------------------------------
%Author information
%Saber Elsayed
%UNiversity of New South Wales Canberra
%s.elsayed@adfa.edu.au
%--------------------------------------------------------------------------
% n              - number of variables
% xmin and xmax  - lower and upper boundaries
% p              - number of points needed
% q    - number of partitions per axis

%Output:
%InitialPoints - points in the starting design

% example
% clear all
% n=3;
% xmin = ones(1,n);
% xmax =  3*ones(1,n);
% q=2;
% [x] = Cell_Init_x (xmin,xmax,n,q)
% scatter(x(:,1), x(:,2))
%--------------------------------------------------------------------------

scale_p= (xmax-xmin)./q;
% x=nan ((n+1)*(q^2+1) + n^2-1,n);
x=inf((q+1)*(n*q+1),n);
S=zeros(q+1,n);
S(1,:)=xmin;
for i=1:n
    for j= 2: q
        S(j,i) =   S(j-1,i)+ scale_p(1,i);
    end
end
S(q+1,:)=xmax;
p=0;
done = zeros(1,q+1);
for k=1 : q+1
    for j=n:-1:1
        for r=1:q+1
            if  k==r  && done(k)==0
                done(k)=1;
                 p=p+1;
                x(p,:)=S(k,:);
                x(p,j)=S(r,j);
            elseif  k==r &&  done(k)==1
                r=r+1;
            elseif  k~=r 
                  p=p+1;
                x(p,:)=S(k,:);
                x(p,j)=S(r,j);
             end
            
        end
    end
end

end
