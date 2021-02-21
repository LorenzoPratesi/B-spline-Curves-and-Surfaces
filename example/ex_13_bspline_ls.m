% setup
d = 3;
 
f = @(x) sin(x) + sin(2*x);
f_err = @(x) f(x) + 0.2 * randn(size(x));
 
xMin = 0;
xMax = 10;
nx = 300;
nknots = 15;
 
x = linspace(xMin, xMax, nx)';
y = f(x);
y_err = f_err(x);
knots = linspace(xMin, xMax, nknots);
knots = build_knot_vector(d,nknots);

 
lambda = 0.05;
% plot
hold on;grid on;
xlabel('X');ylabel('Y');
title('B-Spline Least Square fitting');
plot(x, y_err, '.', 'DisplayName', 'data'); 
%plot(x, y);
    
for d=5:5
    knots = build_knot_vector(d,nknots);
    [y_fit, C] = bs_least_square(x, y_err, d, knots);
    
    plot(C(:, 1), C(:, 2), 'k.', 'MarkerSize', 20);
    plot(C(:, 1), C(:, 2), '-', 'linewidth', 1, 'color', '#0072BD');

    curve = bspline_deboor(d, knots, C');
    plot(curve(1, :), curve(2, :), 'linewidth', 3, 'color', '#D95319');
    
    ordinal = iptnum2ordinal(d);
    %plot(x, y_fit, 'linewidth', 1.5, 'DisplayName', [upper(ordinal(1)), ordinal(2:min(end)) ' order']);
end

% plot(x, y - y_fit);

% stat
aver = sum(y)/nx;
rrmse = sqrt(sum((y - y_fit).^2)/nx) / aver * 100;

legend('Location', 'best');