%plot inline -w 900 -h 800
%% setup
degree = 4;

errAbs = .5;
err = @(s, a, b) a + (b-a).*rand(s);
%f = @(x, y) cos(10*(x.^2+y)).*sin(10*(x+y.^2));
f = @(x, y) log(4*x.^2+y.^2);
f_err = @(x, y) f(x, y) + err(size(x), -errAbs/2, errAbs/2);

xMin = -3;
xMax = 3;
yMin = -10;
yMax = 10;
nx = 100;
ny = 100;
nknots_x = 24;
nknots_y = 24;

x = linspace(xMin, xMax, nx)';
y = linspace(yMin, yMax, ny)';

[x, y] = meshgrid(x, y);
x = reshape(x, [numel(x) 1]);
y = reshape(y, [numel(y) 1]);

z = f(x, y);
z_err = f_err(x, y);
knots_x = linspace(xMin, xMax, nknots_x);
knots_y = linspace(yMin, yMax, nknots_y);

%% fit
[z_fit, C] = bs_least_square_2(x, y, z_err, degree, knots_x, knots_y);

%% plot
x = reshape(x, [nx, ny]);
y = reshape(y, [nx, ny]);
z = reshape(z, [nx, ny]);
z_err = reshape(z_err, [nx, ny]);
z_fit = reshape(z_fit, [nx, ny]);

figure;
plot3(x,y,z_err,'b.', 'MarkerSize', 1);
title('B-Spline surface Least Square fitting');
xlabel('X');ylabel('Y');zlabel('Z');
hold on;grid on;
surf(x,y,z_fit,'FaceAlpha', 0.8); shading flat; s.EdgeColor = 'none';

% Plot the control grid of the B-Spline surface.
%plot3(C(:,1), C(:,2), C(:,3), 'r.--', 'MarkerSize', 10); 

%% stat
aver = sum(sum(z))/nx/ny;
rrmse = sqrt(sum(sum((z - z_fit).^2)) / nx / ny) / aver * 100;
