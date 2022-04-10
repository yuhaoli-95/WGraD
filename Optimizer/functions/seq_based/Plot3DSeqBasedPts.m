close all;clear all; clc;
xmaxlim= [100];
xminlim= [-100];
n = 3;
xmin=xminlim(1)*ones(1,n);    xmax=xmaxlim(1)*ones(1,n);
lu=[xmin; xmax];
q=10; % default is 10 - change
hold on
grid on
plot3(-100, -100, -100, 'w.');
plot3(100, 100, 100, 'w.');
view(3);
xlabel('X1');ylabel('X2');zlabel('X3');
[popold_orig] = Cell_Init_x_mex (lu(1, :),lu(2, :),n,q);
for i = 1 : length(popold_orig(:, 1))
    plot3(popold_orig(i, 1), popold_orig(i, 2), popold_orig(i, 3), 'bo');
    %saveas(gcf, ['./fig/', num2str(i), '.bmp']);
    pause(0.1)
end