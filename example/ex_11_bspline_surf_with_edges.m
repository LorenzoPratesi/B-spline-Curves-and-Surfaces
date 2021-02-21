control_grid_x = [1 2 3; 1 2 4; 1 2 4];
control_grid_y = [4 6 4; 3 5 2; 3 2 1];
control_grid_z = [2 2 2; 2 4 2; 2 5 3];
order_1 = 3;
order_2 = 3;
knot_vector_1 = [zeros(1, order_1), ones(1, order_1)];
knot_vector_2 = [zeros(1, order_2), ones(1, order_2)];
num_steps = 50;

% Initialization of the two basis matrices and steps to plot the surface.
steps_1 = linspace(knot_vector_1(order_1), knot_vector_1(end-order_1+1), num_steps);
steps_2 = linspace(knot_vector_2(order_2), knot_vector_2(end-order_2+1), num_steps);
num_base1_elements = length(knot_vector_1) - order_1;
num_base2_elements = length(knot_vector_2) - order_2; 
first_base = zeros(num_steps, num_base1_elements);
second_base = zeros(num_steps, num_base2_elements);

% Calcualte the first B-Spline base.
for i = 1 : num_steps
    for j = 1 : num_base1_elements
        first_base(i, j) = bspline_basis(j-1, order_1, knot_vector_1, steps_1(i));
    end
end

% Calcualte the second B-Spline base.
for i = 1 : num_steps
    for j = 1 : num_base2_elements
        second_base(i, j) = bspline_basis(j-1, order_2, knot_vector_2, steps_1(i));
    end
end

% Set the figure window for drawing plots.
fig = figure('Name', 'B-Spline Surface with Tensor Product', 'NumberTitle', 'off');
fig.Position(3:4) = [800 600];
movegui(fig, 'center');

% Calculate tensor product and plot the B-Spline surface.
second_base_t = transpose(second_base);
surf_x = first_base * control_grid_x * second_base_t;
surf_y = first_base * control_grid_y * second_base_t;
surf_z = first_base * control_grid_z * second_base_t;
surf(surf_x , surf_y , surf_z, 'FaceAlpha', 0.8); shading flat; s.EdgeColor = 'none';
hold on; grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('B-Spline Surface with Tensor Product and Edge Curves');
axes = gca;

% Plot the control grid of the B-Spline surface.
pol_plot = plot3(control_grid_x, control_grid_y, control_grid_z, 'b.--', 'linewidth', 2, 'MarkerSize', 25); 
plot3(control_grid_x', control_grid_y', control_grid_z', 'b--', 'linewidth', 2);

% Plot edge curves and legend.
set(axes, 'ColorOrder', circshift(get(gca, 'ColorOrder'), -1))
edge_curve1_plot = plot3(surf_x(1, :), surf_y(1, :), surf_z(1, :),  'linewidth', 3);
edge_curve2_plot = plot3(surf_x(:, 1), surf_y(:, 1), surf_z(:, 1),  'linewidth', 3);
edge_curve3_plot = plot3(surf_x(end, :), surf_y(end, :),  surf_z(end, :), 'linewidth', 3);
edge_curve4_plot = plot3(surf_x(:, end), surf_y(:, end),  surf_z(:, end), 'linewidth', 3);
axis tight;
axis equal;
legend([pol_plot(1) edge_curve1_plot edge_curve2_plot edge_curve3_plot ...
        edge_curve4_plot], {'Control Grid', 'First Edge Curve', ...
        'Second Edge Curve', 'Third Edge Curve', 'Fourth Edge Curve'}, ...
        'Location', 'best');
