control_points = [0.1 0.1; 0.3 0.4; 0.1 0.6; 0.3 0.9; 0.5 0.3; 0.8 0.9; 0.9 0.6; 0.9 0.3; 0.8 0.2; 0.7 0.1];
degree = 4;

knot_vector = [0 0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1 1];

% Set the figure window for drawing plots.
fig = figure('Name', 'Strong Convex Hull Property', 'NumberTitle', 'off');
hold on;grid on;
xlabel('X'); ylabel('Y'); title('Strong Convex Hull Property');
axes = gca;
axes.XAxisLocation = 'origin';
axes.YAxisLocation = 'origin';
xlim([0 1]);
ylim([0 1]);

% Plot control points and control polygon of the original curve.
plot(control_points(:, 1), control_points(:, 2), 'kx', 'MarkerSize', 10);
plot(control_points(:, 1), control_points(:, 2), '-', 'linewidth', 1, ...
     'color', '#0072BD');

% Calculate and plot the original B-Spline curve using De Boor algorithm.
curve = bspline_deboor(degree, knot_vector, control_points');
plot(curve(1, :), curve(2, :), 'linewidth', 3, 'color', '#D95319');

[k,av] = convhull(control_points);
plot(control_points(k,1),control_points(k,2), '--', 'linewidth', 2, 'color', '#148A06')

[k,av] = convhull(control_points(end-5+1:end-2,:));
plot(control_points(k+1,1),control_points(k+1,2), '--', 'linewidth', 2, 'color', '#424ADC')

legend({'Control Points', 'Control Polygon', 'B-Spline Curve', 'Convex Hull', 'Strong Convex Hull'});