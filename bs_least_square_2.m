function [z_fit, control_points] = bs_least_square_2(x, y, z, d,...
            knots_x, knots_y, lambda)
% bs_least_square:
%   Implementation of Least Square approximation by using B-Spline basis, 
%   return the fitted curve on data poins [x, y].
% 
% Syntax: [y_fit, err] = bs_least_square(x, y, d, knots, 0.005);
%
% Input:
%   - x: vector of x points.
%   - y: vector of y points.    
%   - y: vector of y points.
%   - d: order of the B-Spline base.
%   - knots_x, knots_y: knot vector of the B-Spline curve.
%   - lambda: parameter value.
%

if nargin < 7
	lambda = 0;
end
x = x(:);
y = y(:);
z = z(:);

xmin = knots_x(1);
xmax = knots_x(end);
tx = [repmat(xmin, [1, d]), knots_x, repmat(xmax, [1, d])];

ymin = knots_y(1);
ymax = knots_y(end);
ty = [repmat(ymin, [1, d]), knots_y, repmat(ymax, [1, d])];

ncoeff_x = numel(knots_x) + d - 1;
ncoeff_y = numel(knots_y) + d - 1;
B = zeros(numel(x), ncoeff_x*ncoeff_y);

bspline_x = zeros(numel(x), ncoeff_x);
bspline_y = zeros(numel(x), ncoeff_y);
parfor j = 1 : ncoeff_x
    bspline_x(:, j) = bspline_basis(j-1, d+1, tx, x);
end

parfor k = 1 : ncoeff_y
    bspline_y(:, k) = bspline_basis(k-1, d+1, ty, y);
end

for j = 1 : ncoeff_x
    for k = 1 : ncoeff_y
        B(:, (j - 1)*ncoeff_y + k) = bspline_x(:, j).*bspline_y(:, k);
    end
end

A = B' * B + lambda*eye(ncoeff_x*ncoeff_y);

% Estimate control points for x
b = B' * x;
Cx = QR_solve(A,b);

% Estimate control points for y
b = B' * y;
Cy = QR_solve(A,b);

% Estimate control points for z
b = B' * z;
Cz = QR_solve(A,b);


% evaluation
z_fit = reshape(B * Cz, size(x));

control_points = [Cx Cy Cz];

end