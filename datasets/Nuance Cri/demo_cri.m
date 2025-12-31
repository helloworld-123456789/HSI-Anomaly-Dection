% 展示Cri数据

clc; clear; close all;

% 获取当前脚本所在目录
data_dir = fileparts(mfilename('fullpath'));
if isempty(data_dir)
    data_dir = pwd;
end

filename = 'Cri.mat';
full_path = fullfile(data_dir, filename);

if exist(full_path, 'file')
    % 加载数据
    loaded_data = load(full_path);
    
    % 获取图像数据
    if isfield(loaded_data, 'data')
        img_data = loaded_data.data;
    else
        vars = fieldnames(loaded_data);
        img_data = loaded_data.(vars{1});
    end
    
    % 获取 Ground Truth 数据
    if isfield(loaded_data, 'map')
        gt_data = loaded_data.map;
    else
        gt_data = [];
        warning('Ground truth "map" not found in %s', filename);
    end
    
    [H, W, B] = size(img_data);
    
    % 生成伪彩色图
    % 由于缺乏具体的波长信息，这里根据波段数均匀选取三个波段作为 R, G, B
    % 假设波段覆盖可见光区域
    r_idx = round(B * 0.66);
    g_idx = round(B * 0.5);
    b_idx = round(B * 0.33);
    
    % 提取 RGB 波段
    rgb_img = img_data(:, :, [r_idx, g_idx, b_idx]);
    
    % 归一化到 0-1 (Min-Max Normalization)
    rgb_img = double(rgb_img);
    min_val = min(rgb_img(:));
    max_val = max(rgb_img(:));
    if max_val > min_val
        rgb_img = (rgb_img - min_val) ./ (max_val - min_val);
    end
    
    % 创建 Figure
    figure('Name', 'Nuance Cri Dataset', 'NumberTitle', 'off', 'Color', 'w');
    
    % 绘制原图 (RGB)
    subplot(1, 2, 1);
    imshow(rgb_img);
    title('Nuance Cri (RGB)', 'Interpreter', 'none');
    
    % 绘制 Ground Truth (GT)
    subplot(1, 2, 2);
    if ~isempty(gt_data)
        imshow(gt_data, []);
        title('Ground Truth', 'Interpreter', 'none');
        colormap(gca, 'gray');
    else
        axis off;
        text(0.5, 0.5, 'No GT', 'HorizontalAlignment', 'center');
    end
    
    % 添加总标题
    sgtitle('Nuance Cri Dataset Overview');
    
    % 保存图像
    save_path = fullfile(data_dir, 'Cri_Dataset.png');
    saveas(gcf, save_path);
    fprintf('Saved %s\n', save_path);
    
else
    warning('File not found: %s', filename);
end

% fprintf('Cri 数据集图像已显示并保存。\n');
