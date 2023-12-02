function [position_xy,radius] = retuen_circle_position(n)
% n=100;
%C:\Users\Lao Li\Desktop\csq_coords
folder_name='C:\Users\Lao Li\Desktop\csq_coords';
folder_name=[folder_name,'\csq_coords\'];
file_name=['csq',num2str(n),'.txt'];
path=[folder_name,file_name];
position_xy=load(path);
position_xy=position_xy(:,2:3);
file_name='csq_inf.txt';
path=[folder_name,file_name];
data=load(path);
index=find(data(:,1)==n);
radius=data(index,2);
end