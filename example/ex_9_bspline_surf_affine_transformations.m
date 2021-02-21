control_grid_x = [4.5 3.5 2.5; 4.5 3.5 2.5; 4.5 3.5 2.5];
control_grid_y = [4.5 4.5 4.5; 3.5 3.5 3.5; 1.5 1.5 1.5];
control_grid_z = [0 0 0; 2.6 2.6 2.6; 0 0 0];
order_1 = 3;
order_2 = 3;
knot_vector_1 = [0 0 0 1 1 1];
knot_vector_2 = [0 0 0 1 1 1];
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
fig = figure('Name', 'Affine Transformations on B-Spline Surface',  'NumberTitle', 'off');
fig.Position(3:4) = [800 600];
movegui(fig, 'center');

% Plot the original B-Spline surface.
second_base_t = transpose(second_base);
surf_x = first_base * control_grid_x * second_base_t;
surf_y = first_base * control_grid_y * second_base_t;
surf_z = first_base * control_grid_z * second_base_t;

origin_surf_plot = surf(surf_x , surf_y , surf_z, 'FaceColor', 'r');
hold on;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Affine Transformations on B-Spline Surfaces');

% Plot the original control grid of the B-Spline surface.
origin_pol_plot = plot3(control_grid_x, control_grid_y, control_grid_z,  'b.--', 'linewidth', 2, 'MarkerSize', 25); 
plot3(control_grid_x.', control_grid_y.', control_grid_z.', 'b--',  'linewidth', 2);

% Tranlation, rotation and scaling transformations.
translation = [4 1 1];
rotation = [cos(pi/2) -sin(pi/2) 0; sin(pi/2) cos(pi/2) 0; 0 0 1];
scaling = [0.8 0 0; 0 0.8 0; 0 0 0.8];

% Transform control points into a single matrix for applying
% transformations (num_control_points x dimensions).
control_points = [reshape(control_grid_x.', [], 1), ...
                  reshape(control_grid_y.', [], 1), ...
                  reshape(control_grid_z.', [], 1)];

% Transformation on control points.
control_points = (control_points*rotation + translation)*scaling;

% Restore control points in three matrices (control grid).
control_grid_x = reshape(control_points(:, 1), order_1, order_2).';
control_grid_y = reshape(control_points(:, 2), order_1, order_2).';
control_grid_z = reshape(control_points(:, 3), order_1, order_2).';

% Plot the transformed B-Spline surface.
surf_x_trans = first_base*control_grid_x*second_base.';
surf_y_trans = first_base*control_grid_y*second_base.';
surf_z_trans = first_base*control_grid_z*second_base.';
trasf_control_plot = surf(surf_x_trans, surf_y_trans, surf_z_trans, 'FaceColor', 'b');

% Plot the control grid of the B-Spline surface.
trasf_pol_plot = plot3(control_grid_x, control_grid_y, control_grid_z, 'r.-', 'linewidth', 2, 'MarkerSize', 25); 
plot3(control_grid_x.', control_grid_y.', control_grid_z.', 'r-', 'linewidth', 2);

% Transform surface points matrices into a single matrix for applying
% transformations (num_control_points x dimensions).
surface_points = [reshape(surf_x.', [], 1), reshape(surf_y.', [], 1), reshape(surf_z.', [], 1)];

% Transformation on surface points.
surface_points = (surface_points*rotation + translation)*scaling;

% Restore surface points in three matrices (surf).
surf_x = reshape(surface_points(:, 1), num_steps, num_steps).';
surf_y = reshape(surface_points(:, 2), num_steps, num_steps).';
surf_z = reshape(surface_points(:, 3), num_steps, num_steps).';

% Plot the transformed B-Spline surface.
trasf_surf_plot = surf(surf_x , surf_y , surf_z, 'FaceAlpha', 0.8); shading flat; s.EdgeColor = 'none';

% Plot the control grid of the B-Spline surface and legend.
trasf_surf_pol_plot = plot3(control_grid_x, control_grid_y, control_grid_z, 'c.--', 'linewidth', 2, 'MarkerSize', 25); 
plot3(control_grid_x.', control_grid_y.', control_grid_z.', 'c--', 'linewidth', 2);
axis tight;
axis equal;
legend([origin_surf_plot origin_pol_plot(1) trasf_control_plot ...
        trasf_pol_plot(1) trasf_surf_plot ...
        trasf_surf_pol_plot(1)], {'Original B-spline Surface', ...
        'Original Control Grid', 'Transformations on Control Points',...
        'First Transf. Control Grid', 'Transformations on Surface', ...
        'Second Transf. Control Grid'}, 'Location', 'best');
