# RX 算法

RX(Reed-Xiaoli)算法是高光谱异常检测里面最经典的算法。其原理是假设背景服从多元Guass分布，然后利用GLRT来构造检测器，最后的检测器形式和马氏距离完全一致，并且该检测器具有CFAR性质。

最早的文献

- Reed, I. S., & Yu, X. (1990). Adaptive Multiple-Band CFAR Detection of an Optical Pattern with Unknown Spectral Distribution.


# 全局和局部
RX检测器的变体很多，包括但不限于Kernel-RX，SSRX，Iteration-RX等等，相关文献都会提及，这里只考虑最简单的全局RX（GRX）和局部RX（LRX）。

全局RX很简单，先计算出全局均值和协方差矩阵后，逐像素计算与均值的马氏距离即可得到得分矩阵。





