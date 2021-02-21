% Retrive inputs.
order_1 = 5;
order_2 = 5;
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
fig = figure('Name', 'B-Spline Surface Base', 'NumberTitle', 'off');
fig.Position(3:4) = [800 600];
movegui(fig, 'center');

% Plot the B-Spline surface.
for i = 1 : num_base1_elements
    for j = 1 : num_base2_elements
        Z = first_base(:, i) * transpose(second_base(:, j));
        surf(steps_1 , steps_2 , Z, 'FaceAlpha', 0.8); shading flat; s.EdgeColor = 'none';
        hold on;
    end
end
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('B-Spline Surface Base');

