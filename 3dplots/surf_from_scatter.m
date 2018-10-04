%% Making Surface Plots From Scatter Data
% How do you turn a collection of XYZ triplets into a surface plot? This is
% the most frequently asked 3D plotting question that I got when I was in
% Tech Support.

%% Load the data

% load seamount
% who -file seamount
filename = '20180910001145data';
my_data = csvread(strcat(filename,'.txt'));
t = my_data(:,1);
d = my_data(:,2);
x = my_data(:,3);
y = my_data(:,4);
z = my_data(:,6);

x = x(1:10:end); 
y = y(1:10:end);
z = z(1:10:end);

% plot3(x,y,z)
xv = linspace(min(x),max(x),100);
yv = linspace(min(y),max(y),100);
[X,Y] = meshgrid(xv,yv);
Z = griddata(x,y,z,X,Y);
% Z(Z==0) = NaN;
% Z(isnan(Z)) = 0;
% Z = Z ./ max(Z(:));
surf(X,Y,Z);

hold on;
plot(x,y)
zlabel('\textbf{Intensity}', 'Interpreter', 'Latex',...
       'FontSize',13,'FontWeight','bold')
ylabel('\textbf{y in metres}', 'Interpreter', 'Latex',...
       'FontSize',13,'FontWeight','bold')
xlabel('\textbf{x in metres}', 'Interpreter', 'Latex',...
       'FontSize',13,'FontWeight','bold')
view(270,0)
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,strcat(filename,'-2d-270'),'-dpdf')

% Z(isnan(Z)) = 0;
% imshow(Z)

% figure;
% mesh(X,Y,Z);
% line(x,y,zeros(size(x)))
% xlim([-1.1 1.1])
% ylim([-1.1 1.1])
% zlim([0 max(z)])
% grid on
% %
% % The problem is that the data is made up of individual (x,y,z)
% % measurements. It isn't laid out on a rectilinear grid, which is what the
% % SURF command expects. A simple plot command isn't very useful.
% 
% plot3(x,y,z,'.-')
% 
% %% Little triangles
% % The solution is to use Delaunay triangulation. Let's look at some
% % info about the "tri" variable.
% 
% tri = delaunay(x,y);
% plot(x,y,'.')
% 
% %%
% % How many triangles are there?
% 
% [r,c] = size(tri);
% disp(r)
% 
% %% Plot it with TRISURF
% 
% h = trisurf(tri, x, y, z);
% axis vis3d
% 
% %% Clean it up
% 
% axis off
% l = light('Position',[-50 -15 29])
% set(gca,'CameraPosition',[208 -50 7687])
% lighting phong
% shading interp
% colorbar EastOutside
