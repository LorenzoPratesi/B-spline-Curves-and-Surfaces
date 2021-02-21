num_curve_points = 1000;
knot_vector = [0 0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1 1];
degree = 4;
control_points = [0.1 0.1; 0.3 0.4; 0.1 0.6; 0.3 0.9; 0.5 0.1; 0.8 0.9; 0.9 0.6; 0.9 0.3; 0.8 0.2; 0.7 0.1];

% Set the figure window for drawing plots.
fig = figure('Name', 'Variation Diminiscing', 'NumberTitle', 'off');
fig.Position(3:4) = [800 600];
movegui(fig, 'center');
hold on;
grid on;
xlabel('X');
ylabel('Y');
title('Variation Diminiscing');
axes = gca;
axes.XAxisLocation = 'origin';
axes.YAxisLocation = 'origin';
xlim([0 1]);
ylim([0 1]);

% Plot control points and control polygon of the original curve.
plot(control_points(:, 1), control_points(:, 2), 'k.', 'MarkerSize', 20);
plot(control_points(:, 1), control_points(:, 2), '-', 'linewidth', 1, ...
     'color', '#0072BD');

% Calculate and plot the original B-Spline curve using de Boor algorithm.
curve = bspline_deboor(degree, knot_vector, control_points');
plot(curve(1, :), curve(2, :), 'linewidth', 3, 'color', '#D95319');

% Generate 3 random line to intersect with the curve.
for i=1:3
    y = 0.1 + (0.8-0.1).*rand(1, 2);
    plot([0 1], y, 'k', 'linewidth', 2, 'color', 'b');
end

legend({'Control Points', 'Control Polygon', 'B-Spline Curve', 'Intersecting Lines'}, 'Location', 'best');