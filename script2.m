clc; close all; clearvars

figure; hold on;

% Reading and plotting gray scaled image
img = imread("./img/kahvi9.jpg");
img_gray = make_gray_image(img, 80);

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

cm_lower_b = max(rows);
cm_upper_b = min(rows);
h_total = cm_lower_b-cm_upper_b;

% Upper search boundary for searching side boundaries
cm_lower_sb = round(cm_upper_b + 0.9*h_total);

% Lower search boundary
cm_upper_sb = round(cm_lower_b - 0.05*h_total);

% Middle point for search
x_middle = x_min + round((x_max-x_min)/2);

% Determining the right boundary of the coffee machine
i = x_middle;
cm_right_b = 0;
while 1
    black_pixels = length(find(img_gray(cm_lower_sb:cm_upper_sb, i) < 50));
    if black_pixels > 0.8*(cm_upper_sb-cm_lower_sb)
        cm_right_b = i;
        break
    end
    i = i+1;
    if i == x_max
        break
    end
end

% Defining button left/right boundaries and left boundary for coffee
% machine
i = x_middle;
btn_left_b = -1; btn_right_b = -1; cm_left_b = -1;
at_btn = false;
while 1
    black_pixels = length(find(img_gray(cm_lower_sb:cm_upper_sb, i) < 50));
    
    if black_pixels > 0.7*(cm_upper_sb-cm_lower_sb) && btn_left_b > 0
        cm_left_b = i;
        break
    end
    if black_pixels > 0.7*(cm_upper_sb-cm_lower_sb) && ~at_btn
        at_btn = true;
        btn_right_b = i;
    end
    if black_pixels < 0.2*(cm_upper_sb-cm_lower_sb) && at_btn
        at_btn = false;
        btn_left_b = i;
    end

    i = i-1;
    if i==0
        break
    end
end

% Coffee machine corner coordinates
cm_corners = [cm_left_b cm_upper_b ; cm_left_b cm_lower_b ;...
    cm_right_b cm_lower_b ; cm_right_b cm_upper_b];

% Creates the boundary box for coffee machine
plot_boundaries(cm_corners, 'red')

% Defining upper boundary of the power button
i0 = round(0.5*(cm_upper_sb+cm_lower_sb));
btn_upper_b = 0;
for i = i0:-1:0
    black_pixels = length(find(img_gray(i, btn_left_b:btn_right_b) < 50));
    if black_pixels < 0.5*(btn_right_b-btn_left_b)
        btn_upper_b = i;
        break
    end
end

btn_lower_b = round(btn_upper_b + 0.45*(btn_right_b-btn_left_b));

btn_corners = [btn_left_b btn_upper_b ; btn_left_b btn_lower_b ;...
    btn_right_b btn_lower_b ; btn_right_b btn_upper_b];

plot_boundaries(btn_corners,'blue')

cp_upper_b = round(cm_upper_b + 0.55*(cm_lower_b-cm_upper_b));
cp_lower_b = round(cm_lower_b - 0.18*(cm_lower_b-cm_upper_b));

cp_left_b = round(cm_left_b + 0.53*(cm_right_b-cm_left_b));
cp_left_mb = round(cm_left_b + 0.65*(cm_right_b-cm_left_b));
cp_right_b = round(cm_right_b - 0.15*(cm_right_b-cm_left_b));
cp_right_mb = round(cm_right_b - 0.26*(cm_right_b-cm_left_b));

cp1_corners = [cp_left_b cp_upper_b ; cp_left_b cp_lower_b ;...
    cp_left_mb cp_lower_b ; cp_left_mb cp_upper_b];
cp2_corners = [cp_right_mb cp_upper_b ; cp_right_mb cp_lower_b ;...
    cp_right_b cp_lower_b ; cp_right_b cp_upper_b];
cp_corners = [cp_left_b cp_upper_b ; cp_left_b cp_lower_b ;...
    cp_right_b cp_lower_b ; cp_right_b cp_upper_b];

plot_boundaries(cp1_corners, 'g')
plot_boundaries(cp2_corners, 'g')

bl_cp = min([calculate_blackness_level(cp1_corners,img_gray) calculate_blackness_level(cp1_corners,img_gray)])
bl_btn = calculate_blackness_level(btn_corners,img_gray)

%   FUNCTIONS

function [] = plot_boundaries(c, color)

    rectangle('Position',[c(1,:) c(3,1)-c(2,1)...
    c(2,2)-c(1,2)], 'EdgeColor',color, 'LineWidth',2)

end

function [BL] = calculate_blackness_level(corners, img_gray)

    BL = 0;
    for i = corners(1,1):corners(3,1)
        BL = BL + length(find(img_gray(corners(1,2):corners(2,2),i) < 50));
    end
    BL = BL/(length(corners(1,1):corners(3,1))*length(corners(1,2):corners(2,2)));

end

function [img_gray] = make_gray_image(img, thre)

    threshold = thre;

    img_gray = rgb2gray(img);
    img_gray(find(img_gray > threshold)) = 255;
    img_gray(find(img_gray < threshold + 1)) = 0;

end