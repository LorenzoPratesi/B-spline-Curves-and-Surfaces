function [y_fit, err] = bs_least_square(x, y, d, knots, lambda)
% bs_least_square:
%   Implementation of Least Square approximation by using B-Spline basis, 
%   return the fitted curve on data poins [x, y].
% 
% Syntax: [y_fit, err] = bs_least_square(x, y, d, knots, 0.005);
%
% Input:
%   - x: vector of x points.
%   - y: vector of y points.
%   - d: order of the B-Spline base.
%   - knots: knot vector of the B-Spline curve.
%   - lambda: parameter value.
%

t = [repmat(knots(1), [1, d]), knots, repmat(knots(end), [1, d])];

ncoeff = numel(knots) + d - 1;
B = zeros(numel(x), ncoeff);
for j = 1 : ncoeff
    B(:, j) = bspline_basis(j, d, t, x);
end

b = B' * y;
A = B' * B + lambda*eye(ncoeff);

% Compute reduced QR factorization by Householder
[houseQ, houseR] = qr(A);

householdery = houseQ' * b;

% Perform backward substitution
% Store the dimensions of the upper triangular U
[m,n]=size(houseR);

% Initiate the zero colum vector
x_fit=zeros(m,1);

% Iterate over the rows
for j=m:-1:1
    % Compute the j-th entry of x
    x_fit(j) = (householdery(j) - houseR(j, :)*x_fit) / houseR(j, j);
end

% evaluation
y_fit = B * x_fit;

err = abs(A * x_fit - b);

end

