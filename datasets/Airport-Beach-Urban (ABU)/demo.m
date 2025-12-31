clc; clear; close all;

% 获取当前脚本所在目录
data_dir = fileparts(mfilename('fullpath'));
if isempty(data_dir)
    data_dir = pwd;
end

% 定义数据集信息结构体
datasets = struct();

% 1. Airport 数据集
datasets(1).name = 'Airport';
datasets(1).files = {'abu-airport-1.mat', 'abu-airport-2.mat', 'abu-airport-3.mat', 'abu-airport-4.mat'};

% 2. Beach 数据集
datasets(2).name = 'Beach';
datasets(2).files = {'abu-beach-1.mat', 'abu-beach-2.mat', 'abu-beach-3.mat', 'abu-beach-4.mat'};

% 3. Urban 数据集
datasets(3).name = 'Urban';
datasets(3).files = {'abu-urban-1.mat', 'abu-urban-2.mat', 'abu-urban-3.mat', 'abu-urban-4.mat', 'abu-urban-5.mat'};

% 循环处理每个数据集类别
for d = 1:length(datasets)
    dataset_name = datasets(d).name;
    file_list = datasets(d).files;
    num_files = length(file_list);
    
    % 创建一个新的 Figure
    figure('Name', [dataset_name ' Dataset'], 'NumberTitle', 'off', 'Color', 'w');
    
    for i = 1:num_files
        filename = file_list{i};
        full_path = fullfile(data_dir, filename);
        
        if exist(full_path, 'file')
            % 加载数据
            loaded_data = load(full_path);
            
            % 获取图像数据
            if isfield(loaded_data, 'data')
                img_data = loaded_data.data;
            else
                % 如果变量名不是 data，尝试获取第一个变量
                vars = fieldnames(loaded_data);
                img_data = loaded_data.(vars{1});
            end
            
            % 获取 Ground Truth 数据
            if isfield(loaded_data, 'map')
                gt_data = loaded_data.map;
            else
                % 尝试查找其他可能的变量名，或者设为空
                gt_data = [];
                warning('Ground truth "map" not found in %s', filename);
            end
            
            [H, W, B] = size(img_data);
            
            % 生成伪彩色图逻辑 (参考 pseudo_color_image.m)
            % 假设波长范围 430-860nm
            start_wl = 430;
            end_wl = 860;
            wavelengths = linspace(start_wl, end_wl, B);
            
            % 寻找最接近 RGB (650, 550, 450 nm) 的波段索引
            [~, r_idx] = min(abs(wavelengths - 650));
            [~, g_idx] = min(abs(wavelengths - 550));
            [~, b_idx] = min(abs(wavelengths - 450));
            
            % 提取 RGB 波段
            rgb_img = img_data(:, :, [r_idx, g_idx, b_idx]);
            
            % 归一化到 0-1 (Min-Max Normalization)
            rgb_img = double(rgb_img); % 确保是 double 类型
            min_val = min(rgb_img(:));
            max_val = max(rgb_img(:));
            if max_val > min_val
                rgb_img = (rgb_img - min_val) ./ (max_val - min_val);
            end
            
            % 绘制原图 (第一行)
            subplot(2, num_files, i);
            imshow(rgb_img);
            title([strrep(filename, '.mat', '') ' (RGB)'], 'Interpreter', 'none');
            
            % 绘制 Ground Truth (第二行)
            subplot(2, num_files, num_files + i);
            if ~isempty(gt_data)
                imshow(gt_data, []);
                title([strrep(filename, '.mat', '') ' (GT)'], 'Interpreter', 'none');
                colormap(gca, 'gray'); % GT 通常用灰度图显示
            else
                axis off;
                text(0.5, 0.5, 'No GT', 'HorizontalAlignment', 'center');
            end
            
        else
            warning('File not found: %s', filename);
        end
    end
    
    % 添加总标题
    try
        sgtitle([dataset_name ' Dataset Overview (Top: RGB, Bottom: GT)']);
    catch
        % 兼容旧版本 MATLAB
        annotation('textbox', [0 0.9 1 0.1], 'String', [dataset_name ' Dataset Overview (Top: RGB, Bottom: GT)'], ...
            'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 14);
    end
    
    % 保存图像
    save_path = fullfile(data_dir, [dataset_name '_Dataset.png']);
    saveas(gcf, save_path);
    fprintf('Saved %s\n', save_path);
end

fprintf('所有图像已显示并保存。\n');