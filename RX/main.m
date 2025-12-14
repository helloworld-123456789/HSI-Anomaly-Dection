clc;
clear;

load('paviaU.mat');
load('PaviaU_gt.mat');

cube = paviaU;        % H*W*C
[H, W, C] = size(cube);

% 设置第5类金属板作为异常，标签设为1，其余设为0
paviaU_gt = double(paviaU_gt == 5);
gtruth=zeros(size(paviaU_gt));
gtruth = double(paviaU_gt == 5);
map = gtruth;

% 超参数
inner = 3;       % 内窗口（奇数）
outer = 7;       % 外窗口（奇数且>inner）

% 运行 GRX 与 LRX
S_grx = grx(cube);                 % (H,W)
S_lrx = lrx(cube, inner, outer);   % (H,W)

% 计算 ROC（labels=map(:)，scores=得分）
labels = map(:) > 0;

% GRX ROC
scores = S_grx(:);
[~, idx] = sort(scores, 'descend');
y = labels(idx);
P = sum(y==1); N = sum(y==0);
TP = cumsum(y==1); FP = cumsum(y==0);
TPR = TP / P; FPR = FP / N;
fpr_g = [0; FPR]; tpr_g = [0; TPR];
auc_g = trapz(fpr_g, tpr_g);

% LRX ROC
scores = S_lrx(:);
[~, idx] = sort(scores, 'descend');
y = labels(idx);
P = sum(y==1); N = sum(y==0);
TP = cumsum(y==1); FP = cumsum(y==0);
TPR = TP / P; FPR = FP / N;
fpr_l = [0; FPR]; tpr_l = [0; TPR];
auc_l = trapz(fpr_l, tpr_l);

% 绘图
figure('Color','w');
plot(fpr_g, tpr_g, 'r-', 'LineWidth', 1.6); hold on;
plot(fpr_l, tpr_l, 'b-', 'LineWidth', 1.6);
plot([0 1],[0 1],'k--','LineWidth',1);
axis([0 1 0 1]); axis square; grid on;
xlabel('False Positive Rate'); ylabel('True Positive Rate');
title(sprintf('ROC on PaviaU (H=%d,W=%d,C=%d)', H, W, C));
legend({sprintf('GRX (AUC=%.4f)', auc_g), sprintf('LRX (AUC=%.4f)', auc_l), 'Chance'}, 'Location','southeast');
