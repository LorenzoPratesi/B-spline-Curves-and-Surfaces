% Illustrates B-spline basis functions.
t = [0 0 0 0 0 0 1 1 1 1 1 1];  % knot vector
k = 6; % degree of the spline basis

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