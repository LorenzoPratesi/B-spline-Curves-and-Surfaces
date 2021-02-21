%plot inline -w 1200 -h 1500
T = readtable('dataCOVID_all.csv');
[G, id] = findgroups(T.region);

tiledlayout(7,3)

% setup
d=4;
nknots = 10;

offset = 55; % just for plotting purpose, start date is 25 feb = (1 Jan) + 55 days

for i = 1:length(id)
    g = T(string(T.region)==id{i}, :);
    
    x = (offset:1:size(g,1)+offset-1)';
    y = g.deaths;
    y(y<0) = 0;
    
    %knots = linspace(0, size(g,1), nknots);
    knots = build_knot_vector(d, nknots);
    [y_fit, ~] = bs_least_square(x, y, d, knots);
    
    ax=nexttile;
    title(ax,id{i})
    hold on;grid on;
    plot(x, y, '.', 'DisplayName', 'data', 'color', '#7DC0EB'); 
    plot(x, y_fit, 'linewidth', 2.5);
    datetick('x','mmm')
end