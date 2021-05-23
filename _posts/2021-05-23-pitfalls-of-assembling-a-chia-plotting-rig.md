---
title: 如何组装一台平衡高效的 Chia P图机（避坑指南）
categories: diary
tags: 日常小记
date: 2021-05-23T17:08:49-04:00
toc: true
---

P 图是奇亚币的农场主们首先需要考虑的问题，在短期内 P 图会成为限制全网占用空间上升速度的主要瓶颈，或者简单来说就是在短期内 P 图的速度决定了你“挖”奇亚币的速度，而从长期来看（如果 Chia 能活到那一天的话），硬盘容量将会成为最终的瓶颈。

# 用词解释

为了方便朋友们理解我的意思，我在这里先解释一下我的一些 Chia 用词习惯：

1. Chia 就是奇亚币，它是一个加密货币，也有人称之为 Chia coin
1. P 图就是 Plotting 或者 Creating plots，[官方 GUI](https://github.com/Chia-Network/chia-blockchain-gui/blob/74c480767032a80872e933fac07631a7ae1fcb96/src/locales/zh-CN/messages.po#L83) 中把这个翻译为「开垦农田」
1. “挖”奇亚币分为两步，第一步是 P 图（开垦农田），第二步是 Farming (耕种农田)，你只有在第二步才有可能获得奇亚币的奖励
1. 3P, 4P, nP 意思就是说同时并发开垦 3 块，4 块，n 块农田

# 最优情况

组装一台高效 P 图机的核心是平衡二字，你不希望某一个硬件成为你 P 图性能的瓶颈，以下是 P 一张 k32 图 (101.3 GiB) 所需要的资源（假设你使用 SSD 作为临时目录）：

* 两个 CPU **线程** (Threads)
    - 对于支持超线程技术 (Hyper-Threading) 的 Intel CPU 来说，这相当于**一个核心**
    - 对于支持 SMT 的 AMD CPU 来说，这也相当于**一个核心**
    - CPU 单核性能越高，P 图速度越快

* 3389 MiB ≈ 3.55 GB 内存，可以简单记为 4 GB 内存
    - 增加内存对 P 图速度好像没什么提升
    - 内存频率 3000 MHz 左右就足够了，再高对 P 图速度好像也没什么提升

    > Efficient plotting of k=32 with 2 threads is now possible with buffer size of **3389 MiB** in bitfield mode by shrinking entry sizes to reduce memory and IO usage.
    > 
    Source: [https://github.com/Chia-Network/chiapos/releases/tag/1.0.1](https://github.com/Chia-Network/chiapos/releases/tag/1.0.1)

* 239 GiB (256.6 GB) SSD 的临时空间，实测可能需要更多，所以这里留点余量，可以简单记为 300 GB 的固态空间
    > Source: [https://github.com/Chia-Network/chia-blockchain/wiki/k-sizes#storage-requirements](https://github.com/Chia-Network/chia-blockchain/wiki/k-sizes#storage-requirements)

* 固态 200 MB/s 的连续写入速度 (Sequential write speed)
    - 在这个最优情况下，P 一张 k32 只需要 4-5 小时左右。实测如果保证 300 MB/s，那么就可以将 P 图时间缩短到 3 小时 50 分钟。

* 消耗固态 1.8 TiBW ≈ 1.98 TBW 的耐久度
    > TBW, or terabytes written, is generally how SSD drive life is measured. **One k32 writes 1.8TiB in non-bitfield mode** and 1.6 TiB with bitfield enabled.  
    > 
    Source: [https://www.chia.net/2021/02/22/plotting-basics.html](https://www.chia.net/2021/02/22/plotting-basics.html)

# 举例说明

你需要按照上述最优情况的比例去搭配你的硬件，如果你还是不太明白，可以看下面几个例子：

1. 案例一是我好几年前配的台式机

    ```
    CPU: Intel i7-7700K，默频 4.2 GHz，睿频 4.5 GHz, 四核八线程
    内存: 4*8 GB 海盗船 DDR4，XMP 超频到 3000 MHz
    SSD:
      - Intel 600p 256 GB M.2 NVMe TLC SSD - 系统盘
      - Intel 660p 2 TB M.2 NVMe QLC SSD - Chia 临时目录
    机械: Toshiba N300 12TB NAS CMR 7200 RPM
    ```

    ✅ 这台机子 CPU 的单核性能比较高，适合 P 图用，内存频率也 ok。  
    ❌ 这个配置的问题是 CPU 核心数和内存没有搭配好，四核配 16 GB 内存就足够了，因为 CPU 最多也只能支持同时 P 四张 k32 的图，多余的 16 GB 内存就浪费了。这配置还有一个问题就是用作 Chia 临时目录的 660p SSD，QLC 颗粒连续写入速度很低并且 TBW 也很低，不适合用作临时盘，而且之前说了目前的瓶颈在 CPU 上，最多开 4P，那么临时盘只要 1.2 TB 就够了，这里 2 TB 没有什么大问题。如果你的配置瓶颈是 3P 的话，临时盘 SSD 只需要 1 TB 就够了。You get the idea.

1. 案例二是最近朋友为 P 图特意配的机子

    ```
    CPU: AMD 3970X，默频 3.7 GHz，睿频 4.5 GHz, 32 核 64 线程
    内存: 8*16 GB DDR4，XMP 超频到 3000 MHz
    SSD: WD_BLACK SN750 NVMe 3D NAND TLC SSD 2*2 TB
    机械: Seagate IronWolf 5*12TB NAS 7200 RPM
    ```

    ✅ 这个配置就比案例一的更均衡了，CPU 核心和内存比例正好 1:4，SSD 选的是 3D NAND TLC 颗粒，2 TB 的耐久度有 1200 TBW，持续写入速度也能保持在 1600 MB/s 左右，一张 SSD 6P I/O 不会成为瓶颈，2 TB 的容量也能支持同时开 6P。

# 需要注意的一些坑

1. 固态要买 M.2 版型 (Form factor) NVMe 接口 (Interface) 的 SSD，不要选 2.5 英寸的 SATA SSD 或者 M.2 版型 SATA 接口的 SSD，因为 SATA 接口的实际最高速度只有 550 MB/s，这会给并发开垦带来瓶颈，况且 NVMe SSD 和 SATA SSD 现在价格也差不多。

1. 不要把系统盘作为开垦的临时目录，因为一旦系统盘写报废了就没法正常开机进系统了。正确的做法应该是选一个小的 SSD 作为系统盘（大概 128 GB 或者 256 GB），如果你不想占用 M.2 槽位的话，完全可以用 2.5 英寸的 SATA SSD 作为系统盘。

1. 机械硬盘要选择能支持 24\*7 不间断工作的，NAS 盘或者监控盘会比企业盘要便宜一些。尽量选择 10 TB 以上的，这样连续写入速度会比较快，也可以在相同容量下节省主板的 SATA 口。我不推荐用外置硬盘，因为它们不是为 24\*7 工作而设计的，后续故障可能会比较多，不过如果你愿意折腾，并且外置硬盘价格美丽还是可以考虑的。

1. 选择固态不能单单看突发写入速度 (Burst write speed) 或者官网标称的连续写入速度或 PCIe 接口速度，关键要看 Sustained sequential write speed (也被称作 Sequential steady state write speed) 指标，如下图：

    ![Sequential steady state write workload](/mdres/posts/2021/sustained-sequential-write-speed.jpg)

    图片来源：tomshardware.com

    图片中每个 SSD 前 100 GB 左右基本都是最快的，因为它们都有 SLC 缓存，而 Chia P 图的过程需要对固态写入 TB 级别的数据，所以 SLC 缓存的速度并不能真实地反应 P 图的速度，这就是为什么有些盘标称快，但是实际 P 下来很慢的缘故了。这个 Sustained sequential write speed 通常就是 SSD 在 P 图上的 I/O 瓶颈，不建议用 QLC 颗粒的固态 P 图（像案例一），因为 QLC 固态在 SLC 缓存用尽之后写入速度只有 170 MB/s 左右，而且 TBW 很低。推荐用 TLC 或者 MLC 的固态做临时盘，他们一般速度和 TBW 都比 QLC 盘更高一些。需要注意的是 TLC 盘之间也是有差异的，一般 TBW 越高，持续写入速度就越低，比如像这里的希捷 FireCuda 520，2 TB 的有 3600 TBW，但是持续写入速度稳定之后只有 600 MB/s 左右，这就不太适合 P 盘，总之还是这两个字，平衡！