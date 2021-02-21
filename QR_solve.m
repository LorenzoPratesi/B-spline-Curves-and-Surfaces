function [fit] = QR_solve(A, b)

[houseQ, houseR] = qr(A);

householdery = houseQ' * b;

% Perform backward substitution
% Store the dimensions of the upper triangular U
[m,n]=size(houseR);

% Initiate the zero colum vector
fit=zeros(m,1);

% Iterate over the rows
for j=m:-1:1
    % Compute the j-th entry of x
    fit(j) = (householdery(j) - houseR(j, :)*fit) / houseR(j, j);
end

end

