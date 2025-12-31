clc;
clear;

% 导入数据和真实地物标签
load('PaviaU.mat');
data=paviaU;
load('PaviaU_gt.mat');
map=paviaU_gt;

% 提取导入数据维度
[height,width,num_bands]=size(data);

% 结合采集信息，设置波段的范围
start_wl = 430;
end_wl = 860;
wavelengths = linspace(start_wl, end_wl, num_bands);
% 选出红绿蓝三个波段
red_band = find(abs(wavelengths - 650) == min(abs(wavelengths - 650)), 1); % 红波段
green_band = find(abs(wavelengths - 550) == min(abs(wavelengths - 550)), 1); % 绿波段
blue_band = find(abs(wavelengths - 450) == min(abs(wavelengths - 450)), 1); % 蓝波段
% 高光谱数据的伪彩色图像
rgb_image = data(:, :, [red_band, green_band, blue_band]);
rgb_image = mat2gray(rgb_image);


figure;
subplot(1,2,1);
imshow(rgb_image);
title('false color composite of the images', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);
subplot(1,2,2);
imshow(map);
title('location of the targets', 'FontSize', 12);
xlabel('X (pixels)', 'FontSize', 10);
ylabel('Y (pixels)', 'FontSize', 10);