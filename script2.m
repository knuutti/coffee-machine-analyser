clc; close all; clearvars

figure; hold on;

% Reading and plotting gray scaled image
img = imread("kahvi9.jpg");
img_gray = make_gray_image(img);
imshow(img)
axis('on','image')

% Dimensions of gray scaled image
[h, w] = size(img_gray);

% Defining the boundaries where to search the upper/lower boundaries
% Search area: 80% of the image, centerized
area = .4;
x_min = round(.5*area*w);
x_max = w-x_min;

% Logic for calculating the upper/lower boundaries
% Search from top to bottom: if the row contains certain amount of black
% pixels withing the search boundaries, add the row index to a list. The
% boundaries will then be the smallest and the largest indexes.
rows =[]; columns = [];
% Definition of black pixels: brightness value < 50
for i = 1:h
    black_pixels = length(find(img_gray(i,x_min:x_max) < 50));
    if black_pixels > 0.1*(x_max-x_min)
        rows = [rows ; i];
    end
end

yline(max(rows),'r'); yline(min(rows),'r')

y_max = max(rows);
y_min = min(rows);
h_total = y_max-y_min;

% Upper boundary for searching side boundaries
y_max_lower = round(y_min + 0.9*h_total);
yline(y_max_lower,'g')

% Lower boundary
y_min_upper = round(y_max - 0.05*h_total);
yline(y_min_upper,'g')

% Middle point for search
x_middle = x_min + round((x_max-x_min)/2);
xline(x_middle)

% Determining the right boundary of the coffee machine
i = x_middle;
right_boundary = 0;
while 1
    black_pixels = length(find(img_gray(y_max_lower:y_min_upper, i) < 50));
    if black_pixels > 0.8*(y_min_upper-y_max_lower)
        right_boundary = i;
        break
    end
    i = i+1;
    if i == x_max
        break
    end
end
xline(right_boundary,'r')

% Defining button left/right boundaries and left boundary for coffee
% machine
i = x_middle;
button_lb = -1; button_rb = -1; left_boundary = -1;
at_btn = false;
while 1
    black_pixels = length(find(img_gray(y_max_lower:y_min_upper, i) < 50));
    
    if black_pixels > 0.7*(y_min_upper-y_max_lower) && button_lb > 0
        left_boundary = i;
        break
    end
    if black_pixels > 0.7*(y_min_upper-y_max_lower) && ~at_btn
        at_btn = true;
        button_rb = i;
    end
    if black_pixels < 0.2*(y_min_upper-y_max_lower) && at_btn
        at_btn = false;
        button_lb = i;
    end

    i = i-1;
    if i==0
        break
    end
end

xline(button_lb, 'b')
xline(button_rb, 'b')
xline(left_boundary, 'r')

%%

for i = 1:w
    black_pixels = length(find(img_gray(y_min+round(0.9*h_total):y_max,i) < 50));
    if black_pixels > 50
        columns = [columns ; i];
    end
end

boundaries = [min(columns), max(columns), min(rows), max(rows)];


function [img_gray] = make_gray_image(img)

    img_gray = rgb2gray(img);
    img_gray(find(img_gray > 50)) = 255;

end