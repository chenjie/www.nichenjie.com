---
title: AWS 静态网站“完美”搭建方案
categories: programming
tags: aws s3 cloudfront
date: 2019-11-13T20:16:49-05:00
excerpt: 本文介绍了使用 AWS S3, CloudFront, Certificate Manager 以及 Route 53 的一种“完美”静态免费 SSL/HTTPS 网站部署方案。它的特点有安全，响应速度快，高可用（High availability），高可扩展性（High scalability）以及高数据可用性（Data availability）。除此之外还具备负载均衡（Load balancing），容灾（Disaster Recovery），内容分发（CDN / Content Delivery）的能力。
published: false
---

感谢你点击并浏览本文，希望这篇文章/教程对你有所帮助。

## 注意

本文讨论的范畴仅仅是**静态**网站（static website），例如 Jekyll, Hugo 等，换句话说网站只包含静态内容（html, css, js）。如果你在寻找像 WordPress 那种有 PHP 后端且有数据库连接的动态网站部署方案，那么抱歉，本文讨论的方案并不适合你，动态网站的搭建一般需要 AWS EC2 以及/或 RDS 服务。

## 🏋️‍🌰

本文会以[此 Jekyll 博客](https://github.com/jellycsc/JellyBlog-Travis-CI)的搭建和部署为例，你可以随便点击页面上的链接🔗来测试此方案的效果，具体详细参数/说明：
```
Ruby: 2.6.5
Jekyll: 3.5
AWS S3 Bucket Region: Canada (Central)
域名托管：已从 GoDaddy 转到 AWS Route 53 ($12)
SSL 证书：AWS Certificate Manager
CDN: AWS CloudFront ALL Edge Locations （使用全球所有边缘服务器）
CI: Travis CI （包含从自动化测试，搭建到部署）
SCM: Git(Hub)
```

## 优劣

静态网站部署有很多很多种方案，我尝试过/踩过坑可以参考[这篇文章]({% post_url 2019-11-14-ways-to-deploy-a-website.md %})。

## 动机