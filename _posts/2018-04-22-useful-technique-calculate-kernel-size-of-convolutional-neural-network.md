---
title: 计算卷积神经网络 Kernel 大小的技巧
categories: study
last_modified_at: 2018-09-22T19:32:34+08:00
tags: 卷积神经网络
---

今天我来说说一个很有用的公式，参考 Stanford CS231n 课程笔记。[[Link](http://cs231n.github.io/convolutional-networks/#conv)]

公式参数（$W,F,P,S$）：
* $W$ ：输入的每个二维 feature map 大小是 $W\times W$，也就是整个 input 体积是 $W\times W\times N$， 这里 $N$ 代表 input feature map 的数量。
* $F$ ：Kernel 或 Filter 大小为 $F\times F$
* $P$ ：Padding 四周各往外延伸 $P$
* $S$ ：Kernel 或 Filter 移动的步长(stride)为 $S$

那么每个输出的二维 feature map 大小是：

$$(W - F + 2P)/S + 1$$

这个值必须为整数，若为小数则说明这个 Kernel 或 Filter 不适合这个 spatial size 的 input。

## 大小不变

举个常见的例子，ConvNet 中用来保持 output spatial size 不变的 Kernel 或 Filter 组合：

$$F=3, P=1, S=1$$

为什么说它能让输出大小和原来保持不变呢？让我们一起代入公式计算一下：  
$$Output =(W - 3 + 2\cdot 1)/1 + 1 = (W - 1)/1 + 1 = W$$

所以输出的 spatial size 仍然保持 $W$ 不变。

## 大小减半

$$F=4, P=1, S=2$$

所以 $$Output =(W - 4 + 2\cdot 1)/2 + 1 = (W - 2)/2 + 1 = W/2$$