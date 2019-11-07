---
title: Powerful KaTeX
excerpt: "Yet another KaTeX render demo"
categories: machine-learning
last_modified_at: 2019-02-15T19:32:34+08:00
---

## Repeating fractions

$$
    \frac{1}{\Bigl(\sqrt{\phi \sqrt{5}}-\phi\Bigr) e^{\frac25 \pi}} \equiv 1+\frac{e^{-2\pi}} {1+\frac{e^{-4\pi}} {1+\frac{e^{-6\pi}} {1+\frac{e^{-8\pi}} {1+\cdots} } } }
$$

## Summation notation

$$
    \left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)
$$

## Sum of a Series

$$
    \begin{aligned}
    \sum_{i=1}^{k+1}i &= \left(\sum_{i=1}^{k}i\right) +(k+1) \\
        &= \frac{k(k+1)}{2}+k+1 \\
        &= \left(\sum_{i=1}^{k}i\right) +(k+1) \\
        &= \frac{k(k+1)}{2}+k+1 \\
        &= \frac{k(k+1)+2(k+1)}{2} \\
        &= \frac{(k+1)(k+2)}{2} \\
        &= \frac{(k+1)((k+1)+1)}{2}
    \end{aligned}
$$

## Product notation

$$
    1 +  \frac{q^2}{(1-q)}+\frac{q^6}{(1-q)(1-q^2)}+\cdots = \prod_{j=0}^{\infty}\frac{1}{(1-q^{5j+2})(1-q^{5j+3})},\text{ for }\lvert q\rvert < 1.
$$

## Calculus

$$
    \int u \frac{dv}{dx}\,dx=uv-\int \frac{du}{dx}v\,dx
$$

## Cross Product

$$
    \mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
    \mathbf{i} & \mathbf{j} & \mathbf{k} \\[2pt]
    \frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\[4pt]
    \frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0
    \end{vmatrix}
$$

## Matrices

$$
    \begin{pmatrix}
    a_{11} & a_{12} & a_{13}\\ 
    a_{21} & a_{22} & a_{23}\\ 
    a_{31} & a_{32} & a_{33}
    \end{pmatrix}
$$

$$
    \begin{bmatrix} 0 & \cdots & 0 \\ \vdots & \ddots & \vdots \\ 0 & \cdots & 0 \end{bmatrix}
$$

## Case definitions

$$
    f(n) = \begin{cases} \frac{n}{2}, & \text{if } n\text{ is even} \\ 3n+1, & \text{if } n\text{ is odd} \end{cases}
$$