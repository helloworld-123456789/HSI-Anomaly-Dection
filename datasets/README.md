# 数据集信息说明

本目录包含用于高光谱异常检测的多个数据集。上传的数据集包含原始数据及mat格式数据结构说明,太大的数据集附下载地址。

## 1. Airport-Beach-Urban (ABU)
位于 `datasets/Airport-Beach-Urban (ABU)/`

**每个mat文件中，包含data和map两个变量，前者表示原始的三维HSI数据，后者表示真实地物标签（异常是1，背景是0）。**

该数据集包含三个主要场景：
- **Airport (机场场景)**：包含4个场景（Airport-1 至 Airport-4）。背景主要为机场跑道、停机坪等。异常目标通常为飞机或其他小型物体。

---

![Airport Dataset](Airport-Beach-Urban%20(ABU)/Airport%20Dataset.png)

---

- **Beach (海滩场景)**：包含4个场景（Beach-1 至 Beach-4）。背景包含沙滩、水域等自然背景。异常目标可能为人工物体或特定地物。

---

![Beach Dataset](Airport-Beach-Urban%20(ABU)/Beach%20Dataset.png)

---

- **Urban (城市场景)**：包含5个场景（Urban-1 至 Urban-5）。覆盖城市环境，包含建筑物、道路、植被等。异常目标是与背景显著不同的对象。

---

![Urban Dataset](Airport-Beach-Urban%20(ABU)/Urban%20Dataset.png)

---


## 2. Nuance Cri
位于 `datasets/Nuance Cri/`

- **传感器**：Nuance Cri 高光谱传感器。
- **场景**：草地上的岩石。
- **尺寸**：400×400 像素。
- **光谱**：保留 46 个波段（光谱分辨率 10 nm）。
- **异常目标**：位于不同位置的十块石头。
- **文件说明**：`Cri.mat` 包含变量 "data"（3D数据立方体）和 "map"（地面真值图）。

---

![Nuance Cri Dataset](Nuance%20Cri/Cri_Dataset.png)

---


## 3. Pavia Centre (PaviaC)
位于 `datasets/PaviaC/`

- **场景**：意大利帕维亚中心 (Pavia Centre)。
- **传感器**：ROSIS。
- **文件**：
    - `PaviaC.mat`：高光谱数据。
    - `PaviaC_gt.mat`：地面真值 (Ground Truth)。

## 4. Pavia University (PaviaU)
位于 `datasets/PaviaU/`

- **场景**：意大利帕维亚大学 (Pavia University)。
- **传感器**：ROSIS。
- **文件**：
    - `PaviaU.mat`：高光谱数据。
    - `PaviaU_gt.mat`：地面真值 (Ground Truth)。
