%plot inline -w 900 -h 600
% Get the order of the B-Spline curve.

% Set the figure window for drawing plots.
k = 4;
px = [35 19 15 10 5 2 3 16 19 30 35 19 15];
py = [ 6  8  8  9 9 8 5  7  5  5  6  8  8];
m = (length(px)-k)-1;
knots = -k/m : 1/m : (k+m)/m;

hold on; grid on;
xlabel('X');
ylabel('Y');
title('Closed B-Spline');
xlim([min(px)-2 max(px)+2]);
ylim([min(py)-2 max(py)+2]);

plot(px, py, 'k.', 'MarkerSize', 20);
plot(px, py, 'o-', 'linewidth', 1, 'color', '#0072BD');

curve = bspline_deboor(k, knots, [px; py]);

for i = 1:k-1
    plot(px(i), py(i), 'ro-', 'markersize', 8, 'MarkerFaceColor','r');
end

plot(curve(1, :), curve(2, :), 'linewidth', 3, 'color', '#D95319');

legend({'Control Point', 'Control Polygon','New added control points', 'B-Spline Curve'}, 'Location', 'best');