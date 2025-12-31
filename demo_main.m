clc; clear; close all;
addpath(genpath(pwd)); % 自动添加所有子文件夹到路径

%% 1. 加载数据
fprintf('Loading Data...\n');
% 假设你有一个 load_data 函数
[X_cube, GT] = load_hyper_data('SanDiego'); 
[H, W, Bands] = size(X_cube);
X_2d = reshape(X_cube, H*W, Bands);

%% 2. 预处理 (归一化是必须的)
% Min-Max Normalization
X_2d = (X_2d - min(X_2d)) ./ (max(X_2d) - min(X_2d));

%% 3. 运行算法 (以 Global RX 为例)
fprintf('Running Global RX...\n');
tic; % 计时开始
det_map_rx = rx_global(X_2d, [H, W]); 
time_rx = toc; % 计时结束

%% 4. 评估结果
fprintf('Calculating AUC...\n');
[fpr, tpr, auc_rx] = calc_auc(det_map_rx(:), GT(:));
fprintf('Global RX AUC: %.4f (Time: %.2fs)\n', auc_rx, time_rx);

%% 5. 绘图
figure;
subplot(1,2,1); imagesc(det_map_rx); title('RX Detection Map'); axis image; colormap jet;
subplot(1,2,2); plot(fpr, tpr, 'LineWidth', 2); title(['ROC Curve (AUC=' num2str(auc_rx) ')']);
grid on;