function [C,t_star] = bspline_deboor(degree,knot_vector,control_points,t_star)
% Evaluate explicit B-spline at specified locations.
%
% Input arguments:
% n:
%    B-spline order (2 for linear, 3 for quadratic, etc.)
% t:
%    knot vector
% P:
%    control points, typically 2-by-m, 3-by-m or 4-by-m (for weights)
% u (optional):
%    values where the B-spline is to be evaluated, or a positive
%    integer to set the number of points to automatically allocate
%
% Output arguments:
% C:
%    points of the B-spline curve

validateattributes(degree, {'numeric'}, {'positive','integer','scalar'});
d = degree-1;  % B-spline polynomial degree (1 for linear, 2 for quadratic, etc.)
validateattributes(knot_vector, {'numeric'}, {'real','vector'});
assert(all( knot_vector(2:end)-knot_vector(1:end-1) >= 0 ), 'bspline:deboor:InvalidArgumentValue', ...
    'Knot vector values should be nondecreasing.');
validateattributes(control_points, {'numeric'}, {'real','2d'});
nctrl = numel(knot_vector)-(d+1);
assert(size(control_points,2) == nctrl, 'bspline:deboor:DimensionMismatch', ...
    'Invalid number of control points, %d given, %d required.', size(control_points,2), nctrl);
if nargin < 4
    t_star = linspace(knot_vector(d+1), knot_vector(end-d), 10*size(control_points,2));  % allocate points uniformly
elseif isscalar(t_star) && t_star > 1
    validateattributes(t_star, {'numeric'}, {'positive','integer','scalar'});
    t_star = linspace(knot_vector(d+1), knot_vector(end-d), t_star);  % allocate points uniformly
else
    validateattributes(t_star, {'numeric'}, {'real','vector'});
    assert(all( t_star >= knot_vector(d+1) & t_star <= knot_vector(end-d) ), 'bspline:deboor:InvalidArgumentValue', ...
        'Value outside permitted knot vector value range.');
end

m = size(control_points,1);  % dimension of control points
knot_vector = knot_vector(:).';     % knot sequence
t_star = t_star(:);

% Calculate multiplicity of t_star in the knot vector (0<=s<=degree+1)
S = sum(bsxfun(@eq, t_star, knot_vector), 2);  

% Find index of knot interval that contains t_star.
I = bspline_deboor_interval(t_star,knot_vector);

P_ir = zeros(m,d+1,d+1);
a_ir = zeros(d+1,d+1);

C = zeros(size(control_points,1), numel(t_star));
for j = 1 : numel(t_star)
    u = t_star(j);
    s = S(j);
    ix = I(j);
    P_ir(:) = 0;
    a_ir(:) = 0;
    
    % identify d+1 relevant control points
    P_ir(:, (ix-d):(ix-s), 1) = control_points(:, (ix-d):(ix-s));
    h = d - s;
    
    if h > 0
        % de Boor recursion formula
        for r = 1 : h
            q = ix-1;
            for i = (q-d+r) : (q-s)
                a_ir(i+1,r+1) = (u-knot_vector(i+1)) / (knot_vector(i+d-r+1+1)-knot_vector(i+1));
                P_ir(:,i+1,r+1) = (1-a_ir(i+1,r+1)) * P_ir(:,i,r) + a_ir(i+1,r+1) * P_ir(:,i+1,r);
            end
        end
        C(:,j) = P_ir(:,ix-s,d-s+1);  % extract value from triangular computation scheme
    elseif ix == numel(knot_vector)  % last control point is a special case
        C(:,j) = control_points(:,end);
    else
        C(:,j) = control_points(:,ix-d);
    end
end

function ix = bspline_deboor_interval(t_star,knot_vector)
% Index of knot in knot sequence not less than the value of u.
% If knot has multiplicity greater than 1, the highest index is returned.

i = bsxfun(@ge, t_star, knot_vector) & bsxfun(@lt, t_star, [knot_vector(2:end) 2*knot_vector(end)]);  % indicator of knot interval in which u is
[row,col] = find(i);
[row,ind] = sort(row);  %#ok<ASGLU> % restore original order of data points
ix = col(ind);