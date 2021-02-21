clear all; close all;
% Illustrates B-spline basis functions.
t = [1, 1, 2, 3, 4, 5, 6, 6];  % knot vector
k = 4; % degree of the spline basis

title('B-Spline Base');
xlabel('X');ylabel('Y');
hold all; grid on;

% Calculate and plot curves for the elements of the base using 
% Cox-de Boor recursion formula.
for j = 0 : numel(t) - k - 1
    [y, x] = bspline_basis(j, k, t);
    
    ordinal = iptnum2ordinal(j+1);
    plot(x, y, 'linewidth', 2, 'DisplayName', [upper(ordinal(1)), ordinal(2:min(end)) ' Base']);
end

legend('Location', 'best');