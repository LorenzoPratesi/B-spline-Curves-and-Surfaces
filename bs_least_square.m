function [fitted, control_points] = bs_least_square_1(x, y, d, knots)
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

XData = [x y];

% discrete parametrization
e = 1;
n = size(XData,1);
u = zeros(n,1);
u(1)=0;

nominator = 0;
denominator = 0;

for j = 1:n-1
    denominator = denominator + (norm(XData(j+1,:)-XData(j,:)))^e;
end

for i = 2:n
    j=i-1;
    nominator = nominator + (norm(XData(j+1,:)-XData(j,:)))^e;
    
    nextU=nominator/denominator;
    u(i)=nextU;
end

% get B-spline basis 

m=numel(u);
B=zeros(m,numel(knots)- d);
for i = 1 : numel(knots)- d
    for j = 1:m
        B(j,i) = bspline_basis(i-1,d,knots, u(j));
    end
end

A = B' * B;

% Estimate control points for x
b = B' * x;
x_fit = QR_solve(A,b);

% Estimate control points for y
b = B' * y;
fitted = QR_solve(A,b);

control_points=[x_fit fitted];

end

