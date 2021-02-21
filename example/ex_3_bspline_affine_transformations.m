num_curve_points = 1000;
knot_vector = [0 0 0 0.3 0.6 1 1 1];
degree = 3;
control_points = [0.1 0.3; 0.05 0.5; 0.2 .5; 0.3 0.8; 0.5 0.6];

% Set the figure window for drawing plots.
fig = figure('Name', 'B-spline Affine Transformations', 'NumberTitle', 'off');
hold on; grid on;
xlabel('X');
ylabel('Y');
title(['B-spline Affine Transformations - Translation, Rotation and Scaling']);
axes = gca;
axes.XAxisLocation = 'origin';
axes.YAxisLocation = 'origin';
xlim([0 1]);
ylim([0 1]);

% Calculate the parameter (t) steps for drawing the B-Spline curves.
steps = linspace(knot_vector(degree+1), knot_vector(end-degree), num_curve_points);

% Plot control points and control polygon.
poi_plot = plot(control_points(:, 1), control_points(:, 2), 'k.', 'MarkerSize', 20);
pol_plot = plot(control_points(:, 1), control_points(:, 2), '-', 'linewidth', 1, 'color', '#0072BD');

% Calculate and plot the original B-Spline curve using De Boor algorithm.
curve = bspline_deboor(degree, knot_vector, control_points');
original_curve = curve;
original_curve_plot = plot(curve(1, :), curve(2, :), 'linewidth', 3, 'color', '#D95319');

% Tranlation, rotation and scaling transformations.
translation = [.9 1];
rotation = [cos(pi) -sin(pi); sin(pi) cos(pi)];
scaling = [0.8 0; 0 0.8];

% Transformation on control points.
control_points = (control_points*rotation + translation)*scaling;

% Plot transformed control points and control polygon.
plot(control_points(:, 1), control_points(:, 2), 'k.', 'MarkerSize', 20);
plot(control_points(:, 1), control_points(:, 2), '-', 'linewidth', 1, 'color', '#0072BD');

% Calculate and plot the transformed B-Spline curve on control points.
curve = bspline_deboor(degree, knot_vector, control_points');
trasf_control_plot = plot(curve(1, :), curve(2, :), 'linewidth', 3, 'color', 'blue');

% Plot transformation on B-Spline curve points and legend.
original_curve = (original_curve' * rotation + translation) * scaling;
trasf_curve_plot = plot(original_curve(:, 1), original_curve(:, 2), '--', 'linewidth', 3, 'color', 'yellow');

legend([poi_plot pol_plot original_curve_plot ...
        trasf_control_plot trasf_curve_plot], 'Control Points', ...
        'Control Polygons', 'Original B-Spline Curve', ...
        'Transformations on Control Points', 'Transformations on Curve',...
        'Location', 'southeast');