% Retrive inputs.
p_x = [1 2 3; 1 2 4; 1 2 4];
p_y = [4 6 4; 3 5 2; 3 2 1];
p_z = [2 2 2; 2 4 2; 2 5 3];
order_1 = 3;
order_2 = 3;
knot_vector_1 = [zeros(1, order_1), ones(1, order_1)];
knot_vector_2 = [zeros(1, order_2), ones(1, order_2)];
num_steps = 50;
  
control_points = [reshape(p_x', [], 1), reshape(p_y', [], 1), reshape(p_z', [], 1)];

% Initialization of the two basis matrices and steps to plot the surface.
steps_1 = linspace(knot_vector_1(order_1), knot_vector_1(end-order_1+1),num_steps);
steps_2 = linspace(knot_vector_2(order_2), knot_vector_2(end-order_2+1),num_steps);

% Calculate with de boor every point of the B-Spline surface.
surface_points = zeros(num_steps*num_steps, 3);
count = 1;
for i = 1 : num_steps
    for j = 1 : num_steps
        % n times de Boor algorithm to calculate n points.
        n = length(knot_vector_1) - order_1;
        m = length(knot_vector_2) - order_2;
        Q = zeros(n, 3);
        for k = 1 : n
            Q(k, :) =  bspline_deboor(order_2, knot_vector_2, control_points(m*(k-1)+1: m*k, :)', steps_2(j));
        end
        
        % de Boor algorithm on Q to calculate the final surface point.
        surface_points(count, :) = bspline_deboor(order_1, knot_vector_1, Q', steps_1(i));
        count = count + 1;
    end
end

% Set the figure window for drawing plots.
figure('Name', 'B-Spline Surface with De Boor', 'NumberTitle', 'off');

% Plot the b-spline surface.
surface_matrix_x = reshape(surface_points(:, 1), num_steps, num_steps).';
surface_matrix_y = reshape(surface_points(:, 2), num_steps, num_steps).';
surface_matrix_z = reshape(surface_points(:, 3), num_steps, num_steps).';
surf(surface_matrix_x, surface_matrix_y, surface_matrix_z, 'FaceAlpha', 0.8); shading flat; s.EdgeColor = 'none';
hold on; grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('B-Spline Surface with De Boor');

% Puts control points in three matrices (control grid).
control_grid_x = reshape(control_points(:, 1), order_1, order_2).';
control_grid_y = reshape(control_points(:, 2), order_1, order_2).';
control_grid_z = reshape(control_points(:, 3), order_1, order_2).';

% Plot the control grid of the B-Spline surface.
pol_plot = plot3(control_grid_x, control_grid_y, control_grid_z, 'b.--', 'linewidth', 2, 'MarkerSize', 25); 
plot3(control_grid_x.', control_grid_y.', control_grid_z.', 'b--', 'linewidth', 2);
axis tight; axis equal;
legend(pol_plot(1), {'Control Grid'}, 'Location', 'best');
