---
title: "[MAT344] 大学和女友同课是什么体验？"
categories: study
last_modified_at: 2019-11-11
---

在多大学习的最后一学期有幸和 KiKi 女神同课 MAT344 (不是 cs 有点遗憾)，这也是我辅修数学的收官课。这学期 MAT344 的难度较往年提升了不少，Midterm 的画风跟水课完全不沾边。每周 lecture 学生的平均出勤率少于 50%，所以也不难想象 midterm 是有多惨烈了，部分愣头青还去了 math dept 投诉……

![compaints](/mdres/posts/2019/04/compaints.png)

KiKi 女神在 midterm 之前的出勤率低于 50%，而之后的出勤率可谓超神，达到了 99.99%，你猜她唯一没来的那次是因为什么？（睡过了，逃。。）你们再猜，为什么她 midterm 前后出勤率竟有如此大的差距？(Hint: 不是因为 midterm 考砸了)

言归正传：MAT344 这学期的两个 instructor 都非常认真负责，其中 Zachary Wolske 是我 223/224 的 TA，135 的 course instructor (TA coordinator)，就在这样的大环境下，KiKi 和我 midterm 之后奋起直追，希望最后能收获我们满意的结果（final还没出分）。

【2019年11月11日更新】 Final 其实早就出分了，我家这个小仙女不让我说分数，她说谈分伤感情 😛

## Struggles and blocks

### 1. Combination Property

$$
    \binom{n}{k} = \binom{n-1}{k-1} + \binom{n-1}{k}
$$

### 2. Binomial Theorem

$$
    (x+y)^n = \sum_{k=0}^{n} \binom{n}{k} x^{n-k} y^k
$$

### 3. Multinomial Coefficient

How many distinct rearrangements can be made using all of the letters of “BOOKKEEPING”?

$$
    \binom{11}{2,2,2,1,1,1,1,1} = \frac{11!}{2! \cdot 2! \cdot 2!}
$$

### 4. Recursive Formula

Give a recursive formula for the function $g(n)$ that counts the number of ternary strings of length $n$ that do not contain $2002$ as a substring.

$$
    g(n) = 3g(n-1) - g(n-3) + 2g(n-4)
$$

### 5. Another Combination Property

$$
    \binom{n}{0} + \binom{n+1}{1} + ... + \binom{n+k}{k} = \binom{n+k+1}{k}
$$

### 6. Degree Sequence

A *degree sequence* of a graph is a list of the degrees of each vertex. Consider the following lists of six positive integers:

$$
    A = [3,2,2,1,1,1] \\
    B = [5,5,5,4,3,2] \\
    C = [5,5,4,4,3,3] \\
    D = [4,4,2,2,2,2] \\
    E = [3,3,3,3,3,3]
$$

Determine which sequence(s):

(a) cannot be the degree sequence of a graph:  
**Answer**: $B$ cannot be the degree sequence of any graph, because the first three vertices are connected to every other vertex in the graph – in particular, vertex 6. This means that vertex 6 should have degree at least $3$, which it doesn’t.

(b) must be the degree sequence of an eulerian graph:  
**Answer**: $D$ must be the degree sequence of a Eulerian graph because every vertex has even degree.

(c) must be the degree sequence of a hamiltonian graph:  
**Answer**: Degree sequences $C$ and $E$ must be that of a Hamiltonian graph because this graph has six vertices and every vertex has degree at least $\frac{6}{2}$. By Dirac’s theorem, it must have a Hamiltonian circuit.

(d) could be the degree sequence of a tree:  
**Answer**: $A$ could be the degree sequence of a tree because the sum of the degrees is equal to $10$, so the number of edges is $5$, which is equal to the number of vertices minus $1$.

(e) could be the degree sequence of a graph, but cannot be a planar graph:  
**Answer**: None of the graphs satisfy this condition.


### 7. Generating functions

Find the coefficient of $x^n$ in each of the generating functions below.

(a) $\frac{1}{1+4x}$

Generating function:

$$
    \frac{1}{1-(-4x)} = 1 - 4x + 16x^2 - 64x^3 + ... = \sum_{n=0}^{\infty} (-4x)^n
$$

The coefficient of $x^n$ is

$$
    (-4)^n
$$

(b) $\frac{1-x^{14}}{1-x}$

Generating function:

$$
    \sum_{n=0}^{13} x^n = 1 + x + x^2 + ... + x^{13}
$$

Therefore, the sequence corresponding to this generating function is

$$
    a_n = 
    \begin{cases} 
        1, & 0 \le n \le 13\\
        0, & n \ge 14
    \end{cases}
$$

(c) $(1+x^3) \cdot (x^3 + x^4 + x^5 + ...) \cdot (1 + x^5 + x^{10} + ...)$

The general expression of the coefficient ($a_n$) corresponding to $x^n$ is

$$
    a_n = 
    \begin{cases} 
        0, & 0 \le n \le 2\\
        \lfloor \frac{n - 3}{5} \rfloor + \lfloor \frac{n - 6}{5} \rfloor + 2, & n \ge 3
    \end{cases}
$$

### 8. Recurrence Relation

Solve the following linear, homogeneous, degree-2 recurrence relation:

$$
    b_n = 3b_{n-1} + 3b_{n-2}
$$

where $b_1 = 4$ and $b_2 = 15$.

**Answer**:

$$
	b_n = \left(\frac{1}{2} - \frac{5}{2\sqrt{21}}\right) \cdot \left(\frac{3-\sqrt{21}}{2}\right)^n + \left(\frac{1}{2} + \frac{5}{2\sqrt{21}}\right) \cdot \left(\frac{3+\sqrt{21}}{2}\right)^n
$$

where $n \ge 0$ and $n \in \Z$.