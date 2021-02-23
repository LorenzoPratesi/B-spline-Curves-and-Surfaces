% setup
close all;
d = 3;

nx = 1000;
nknots = 20;

r = 12.5; %outer radius
a = 1;    %inner radius
b = 3; %incerement per rev % Jos: changed to see the spiral!!
n = (r - a)./(b); %number  of revolutions
th = 2*n*pi;      %angle
Th = linspace(0,th,nx);
x = (a + b.*Th/(2*pi)).*cos(Th); x=x';
y = (a + b.*Th/(2*pi)).*sin(Th); y=y';

y_err = y + .5 * randn(size(x));
plot(x,y_err, 'ko', 'MarkerSize', 2);hold on;

knots = build_knot_vector(d,nknots);
[y_fit, C] = bs_least_square(x, y_err, d, knots);

plot(C(:, 1), C(:, 2), 'k.', 'MarkerSize', 20);
plot(C(:, 1), C(:, 2), '-', 'linewidth', 1, 'color', '#0072BD');

curve = bspline_deboor(d, knots, C');
plot(curve(1, :), curve(2, :), 'linewidth', 2, 'color', '#D95319');

% stat
aver = sum(y)/nx;
rrmse = sqrt(sum((y - y_fit).^2)/nx) / aver * 100;

legend('Location', 'best');