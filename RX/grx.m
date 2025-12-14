function S = grx(cube)
% GRX（全局 Reed-Xiaoli）异常检测
% 输入：cube 为 (H, W, C) 的高光谱立方体
% 输出：S 为 (H, W) 的异常得分矩阵（马氏距离平方）

[H, W, C] = size(cube);
X = double(reshape(cube, [], C)); % 重塑为 (H*W, C) 的二维矩阵
mu = mean(X, 1); % 计算全局均值
Xc = bsxfun(@minus, X, mu); % 中心化数据
Sigma = cov(X);         % (n-1) 归一化的协方差估计
Sinv  = pinv(Sigma);    % 使用伪逆以防止奇异矩阵

scores = sum((Xc * Sinv) .* Xc, 2); % 计算马氏距离的平方
S = reshape(scores, H, W); % 重塑回 (H, W) 矩阵
end