clc; close all; clearvars

figure; hold on;

img = imread("kahvi.jpg");
img_gray = make_gray_image(img);

b = coffee_boundaries(img_gray)
%analyse_images(paths);

function [img_gray] = make_gray_image(img)

    img_gray = rgb2gray(img);
    img_gray(find(img_gray > 50)) = 255;

end

function [boundaries] = coffee_boundaries(img_gray)

    [h, w] = size(img_gray);

    area = .5;
    x_min = round(.5*area*h);
    x_max = h-x_min;

    
    % Calculating the boundary box of the coffee machine
    
    rows =[]; columns = [];
    values = [];
    % Top and bottom
    for i = 1:h
        values = [values; length(find(img_gray(i,x_min:x_max) < 50))];
        if length(find(img_gray(i,x_min:x_max) < 50)) > 0.1*w
            rows = [rows ; i];
        end
    end
    values

    y_max = max(rows)
    y_min = min(rows)
    h_total = y_max-y_min;

    hold on
    imshow(img_gray)
    yline(y_min, 'r')
    yline(y_max, 'r')

    % Left and right
    for i = 1:w
        if length(find(img_gray(y_min+round(0.9*h_total):y_max,i) < 50)) > 50
            columns = [columns ; i];
        end
    end

    boundaries = [min(columns), max(columns), min(rows), max(rows)];

end

function [] = analyse_images(paths)

    for i = 1:length(paths)
    subplot(length(paths),1,i)
    [BL, img, pot_pos, coffee_pos, state, button_pos] = analyse(paths(i));
    imshow(img); axis('on', 'image')
    rectangle('Position',pot_pos, 'EdgeColor',"b", LineWidth=1)
    rectangle('Position', coffee_pos, 'EdgeColor',"r", LineWidth=1)
    rectangle('Position', button_pos, 'EdgeColor',"g", LineWidth=1)
    title("Coffee Coefficient: " + num2str(BL) + " | Power: " + num2str(state))
    end

end

function [bl, img, pot_pos, coffee_pos, state, button_pos] = analyse(path_name)
    img = imread(path_name);
    img_gray = rgb2gray(img);
    img_gray(find(img_gray > 50)) = 255;
    
    [h, w] = size(img_gray);
    
    % Calculating the boundary box of the coffee machine
    
    rows =[]; columns = [];
    % Top and bottom
    for i = 1:h
        if length(find(img_gray(i,:) < 50)) > 50
            rows = [rows ; i];
        end
    end

    y_max = max(rows); y_min = min(rows); h_total = y_max-y_min;

    % Left and right
    for i = 1:w
        if length(find(img_gray(y_min+round(0.9*h_total):y_max,i) < 50)) > 50
            columns = [columns ; i];
        end
    end


    
    
    cor = [min(columns), max(columns), min(rows), max(rows)];
    coffee_pos = [cor(1), cor(3), cor(2)-cor(1), cor(4)-cor(3)];
    
    % Analyse the power state
    [state, button_pos] = power_state(img_gray,cor);
    
    % Calculating the boundary box of the coffee pot
    a = [0.51 0.54 0.3 0.3];
    pot_pos = [round(a(1)*(cor(2)+cor(1))),...
        round(a(2)*(cor(4)+cor(3))),...
        round(a(3)*(cor(2)-cor(1))),...
        round(a(4)*(cor(4)-cor(3)))];
    hold on
    
    bl = 0;
    for i = pot_pos(1):pot_pos(1)+pot_pos(3)
        bl = bl + length(find(img_gray(pot_pos(2):pot_pos(2)+pot_pos(4),i) < 50));
    end
    bl = bl / (pot_pos(3)*pot_pos(4));
end

function [state, button_pos] = power_state(img_gray, pos)
    
    %imshow(img_gray)
    a = [0.145 0.87 0.08 0.07];
    button_pos = [...
        round(pos(1) + a(1)*(pos(2)-pos(1))), ...
        round(pos(3) + a(2)*(pos(4)-pos(3))), ...
        round(a(3)*(pos(2)-pos(1))), ...
        round(a(4)*(pos(4)-pos(3)))];
    %rectangle('Position',button_pos, 'LineWidth',1, 'EdgeColor','red')
    bl = 0;
    for i = button_pos(1):button_pos(1)+button_pos(3)
        bl = bl + length(find(img_gray(button_pos(2):button_pos(2)+button_pos(4),i) > 50));
    end
    state = bl / (button_pos(3)*button_pos(4));

end