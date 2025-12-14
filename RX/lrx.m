function S = lrx(cube, inner, outer)
% 双窗口 LRX（局部 Reed-Xiaoli）异常检测，外环作为训练样本
% 输入：
%   cube  : (H, W, C) 高光谱立方体
%   inner : 内窗口大小（奇数，>=1，默认 3）
%   outer : 外窗口大小（奇数，>inner，默认 7）
% 输出：
%   S     : (H, W) 局部异常得分（马氏距离平方），训练样本为外窗口的环区域（outer-inner）

if nargin < 2 || isempty(inner), inner = 3; end
if nargin < 3 || isempty(outer), outer = 7; end

% 保证为奇数并且 outer > inner
if mod(inner,2)==0, inner = inner+1; end
if mod(outer,2)==0, outer = outer+1; end
if outer <= inner, outer = inner + 2; if mod(outer,2)==0, outer = outer+1; end, end

cube = double(cube);
[H, W, C] = size(cube);
S = zeros(H, W);
r_in  = floor(inner/2);
r_out = floor(outer/2);

for i = 1:H
    % 外窗口边界（行）
    i1o = max(1, i - r_out); i2o = min(H, i + r_out);
    for j = 1:W
        % 外窗口边界（列）
        j1o = max(1, j - r_out); j2o = min(W, j + r_out);

        % 内窗口边界（行列），并裁剪到图像边界
        i1i = max(1, i - r_in);  i2i = min(H, i + r_in);
        j1i = max(1, j - r_in);  j2i = min(W, j + r_in);

        % 提取外窗口 patch
        patch = cube(i1o:i2o, j1o:j2o, :);
        ho = size(patch,1); wo = size(patch,2);

        % 将内窗口坐标转换为相对于外窗口 patch 的索引范围
        i1i_rel = i1i - i1o + 1; i2i_rel = i2i - i1o + 1;
        j1i_rel = j1i - j1o + 1; j2i_rel = j2i - j1o + 1;
        % 保证在 patch 范围内
        i1i_rel = max(1, i1i_rel); i2i_rel = min(ho, i2i_rel);
        j1i_rel = max(1, j1i_rel); j2i_rel = min(wo, j2i_rel);

        % 构造环形掩码：外窗口为真，内窗口置为假
        mask = true(ho, wo);
        mask(i1i_rel:i2i_rel, j1i_rel:j2i_rel) = false;

        % 将外环样本拉直为谱矩阵
        X = reshape(patch, [], C);
        Xring = X(mask(:), :);

        % 当环样本不足时，跳过（得分保持为 0）
        if size(Xring,1) < 2
            continue;
        end

        mu = mean(Xring, 1);
        Sigma = cov(Xring);
        Sinv = pinv(Sigma);
        x = reshape(cube(i, j, :), 1, C);
        S(i, j) = (x - mu) * Sinv * (x - mu)';
    end
end
end