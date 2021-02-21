function res = build_knot_vector(p, n)
res = zeros(n+2*p-2, 1);
for i=p:n+p-1
    res(i) = (i-p)/(n-1);
end
for i=n+p-1:n+2*p-2
    res(i) = 1;
end
end