function [y,x] = bspline_basis(j,n,t,x)
% B-spline basis function value B(j,n) at x.
%
% Input arguments:
% j:
%    interval index, 0 =< j < numel(t)-n
% n:
%    B-spline order (2 for linear, 3 for quadratic, etc.)
% t:
%    knot vector
% x (optional):
%    value where the basis function is to be evaluated
%
% Output arguments:
% y:
%    B-spline basis function value, nonzero for a knot span of n

validateattributes(j, {'numeric'}, {'nonnegative','integer','scalar'});
validateattributes(n, {'numeric'}, {'positive','integer','scalar'});
validateattributes(t, {'numeric'}, {'real','vector'});
assert(all( t(2:end)-t(1:end-1) >= 0 ), ...
    'Knot vector values should be nondecreasing.');
if nargin < 4
    x = linspace(t(1), t(end), 1000);  % allocate points uniformly
else
    validateattributes(x, {'numeric'}, {'real','vector'});
end
assert(0 <= j && j < numel(t)-n, ...
    'Invalid interval index j = %d, expected 0 =< j < %d (0 =< j < numel(t)-n).', j, numel(t)-n);

y = bspline_basis_recurrence(j,n,t,x);

function y = bspline_basis_recurrence(i,r,t,t_star)

y = zeros(size(t_star));
if r > 1
    N_1 = bspline_basis(i,r-1,t,t_star);
    omega1_num = t_star - t(i+1);
    omega1_den = t(i+r) - t(i+1);
    
    if omega1_den ~= 0  % indeterminate forms 0/0 are deemed to be zero
        y = y + N_1.*(omega1_num./omega1_den);
    end
    
    N_2 = bspline_basis(i+1,r-1,t,t_star);
    omega2_num = t(i+r+1) - t_star;
    omega2_den = t(i+r+1) - t(i+1+1);
    
    if omega2_den ~= 0
        y = y + N_2.*(omega2_num./omega2_den);
    end
    
elseif t(i+2) < t(end)  % treat last element of knot vector as a special case
    y(t(i+1) <= t_star & t_star < t(i+2)) = 1;
else
    y(t(i+1) <= t_star) = 1;
end