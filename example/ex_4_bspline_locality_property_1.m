num_curve_points = 1000;
knot_vector = [0 0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1 1];
degree = 4;
control_points = [0.1 0.1; 0.3 0.4; 0.1 0.6; 0.3 0.9; 0.5 0.3; 0.8 0.9; 0.9 0.6; 0.85 0.3; 0.9 0.1; 1 0];

% Set the figure window for drawing plots.
fig = figure('Name', 'Locality Property 1', 'NumberTitle', 'off');
hold on;grid on;
xlabel('X'); ylabel('Y'); title('Locality Property 1');
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

% Control point modification.
control_point_mod = 5;
control_points(control_point_mod, :) = [0.5 0.6];

% Plot control points and control polygon of the modified curve.
plot(control_points(:, 1), control_points(:, 2), '-.o', ...
     'color', '#EDB120', 'MarkerEdgeColor', 'k', 'MarkerSize', 10);

% Calculate and plot the modified B-Spline curve.
curve = bspline_deboor(degree, knot_vector, control_points');
plot(curve(1, :), curve(2, :), '--', 'linewidth', 3, 'color', 'blue');

% Plot lines for highlighting the modified interval.
left_line = bspline_deboor(degree,knot_vector,control_points', knot_vector(control_point_mod));
right_line = bspline_deboor(degree,knot_vector,control_points', knot_vector(control_point_mod+degree+1));
plot([left_line(1) left_line(1)], [0 1], 'k', 'linewidth', 2)
plot([right_line(1) right_line(1)], [0 1], 'k', 'linewidth', 2)


legend({'Control Points', 'Original Control Polygon', ...
        'Original B-Spline Curve', 'Modified Control Polygon', ...
        'Modified B-Spline Curve'}, 'Location', ...
        'south');