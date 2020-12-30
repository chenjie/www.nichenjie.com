---
title: AWS 静态网站“完美”搭建方案
categories: programming
tags: aws s3 cloudfront
date: 2019-11-16T14:08:49-05:00
published: true
toc: true
---

本文介绍了使用 AWS S3, CloudFront, Certificate Manager 以及 Route 53 的一种“完美”静态免费 SSL/HTTPS 网站部署方案。它的特点有安全，响应速度快，高可用（High availability），高可扩展性（High scalability）以及高数据可用性（Data availability）。除此之外还具备负载均衡（Load balancing），容灾（Disaster Recovery），内容分发（CDN / Content Delivery）的能力。

感谢你点击并浏览本文，希望这篇文章/教程对你有所帮助。如果你不想听我 BB，可以直接跳转到 `部署教程`。

## 注意

本文讨论的范畴仅仅是**静态**网站（static website），例如 Jekyll, Hugo 等，换句话说网站只包含静态内容（html, css, js）。如果你在寻找像 WordPress 那种有 PHP 后端且有数据库连接的动态网站部署方案，那么抱歉，本文讨论的方案并不适合你，动态网站的搭建一般需要 AWS EC2 以及/或 RDS 服务。

## 博客配置详情

本文会以[此 Jekyll 博客](https://github.com/chenjie/www.nichenjie.com)的搭建和部署为例，你可以随便点击页面上的链接🔗来测试此方案的效果，具体详细参数/说明：

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

## 部署方案讨论

为了控制本文的篇幅长度，关于不同网站部署方案的讨论，请移步至[这篇文章]({% post_url 2019-11-14-ways-to-deploy-a-website %})。

## 动机

我最近一直在研究 AWS 相关服务，目的有两个，一个是帮 G 部署可以横向自由扩展（has horizontal scalability）的 Moodle，另一个是将其应用到工作上，因为 Crowdmark 的生产环境也是部署在 AWS 上的。最开始的时候这个博客是部署在免费的 GitHub Pages 上，它有免费的 SSL 证书，用 Travis CI 部署起来也相当方便，`.travis.yml` deployment code snippet 如下：

```
deploy:
- provider: pages
  skip-cleanup: true
  github-token: "$GITHUB_TOKEN"
  keep-history: true
  on:
    branch: master
```

但是开发后发现 GH Pages 不支持其他自定义主题，比如这个博客正在使用的 [Minimal Mistakes](https://mademistakes.com/work/minimal-mistakes-jekyll-theme/)，正巧的是当时阿里云给我的学生特惠批下来了，于是乎就开始着手把博客部署到 ECS (等同于 AWS 中的 EC2) 上。所以在好一段时间里，我的网站都是部署在阿里云美西硅谷的 ECS 上的。因为博客是静态编译的，所以迁移工程相对简单，只需要搞定一点 Ops 的东西就 ok 了，完整 `.travis.yml` 设置如下：

```
language: ruby
rvm:
- 2.4.1
addons:
  apt:
    packages:
    - libcurl4-openssl-dev
cache: bundler
before_install:
- sudo update-ca-certificates
install:
- bundle install
before_script:
- chmod +x ./script/cibuild
script: "./script/cibuild"
branches:
  only:
  - master
env:
  global:
  - NOKOGIRI_USE_SYSTEM_LIBRARIES=true
  - JEKYLL_ENV=production
sudo: false
before_deploy:
- openssl aes-256-cbc -K $encrypted_209f5601644c_key -iv $encrypted_209f5601644c_iv
  -in deploy_rsa.enc -out deploy_rsa -d
- eval "$(ssh-agent -s)"
- chmod 600 ./deploy\_rsa
- ssh-add ./deploy\_rsa
- echo -e "Host $DEPLOY_HOST\n\tPort $DEPLOY_HOST_SSH_PORT\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
deploy:
- provider: script
  skip_cleanup: true
  script: rsync -rqz --delete-after _site/ $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_DIRECTORY
  on:
    branch: master
```

这里我稍微解释一下，第一步我在 ECS 上装好了 nginx，然后配置了虚拟主机，因为我这台服务器上还挂了别的网站。然后我选择了使用 `rsync` 部署静态文件，顾名思义 `rsync` 可以帮你同步两个文件夹，这就省去了我先删除，然后再 `scp` 的过程。上面 `.travis.yml` 中的 `before_deploy` 部分都在 set up ssh key，这样的话每次部署就不需要输入密码了。

每次编译、检查加部署大约需要2分钟的时间，其实我对这个时间还是挺满意的，可是迁移完之后国内用户浏览的体验并没有得到很大的提升，可能是因为服务器在美西的关系，然后用的是学生乞丐版套餐。我后来尝试加了个 Cloudflare 免费的 CDN，效果甚微（PS. Cloudflare CDN 和别家的 CDN 有些不同，它需要你改域名的 nameserver），这个结果意料之中把，毕竟天下没有免费的午餐，一番折腾过后果断花了 12 两银子把域名从 GoDaddy 转到了 AWS Route 53。

## 部署教程

### Step 1. 创建并配置 S3 桶

如果你想让 `www.nichenjie.com` 跳转到 `nichenjie.com`，那么就跟我一样创建两个 Bucket，分别命名为 `www.nichenjie.com` 和 `nichenjie.com`，如图：

![S3 Buckets](/mdres/posts/2019/11/s3-buckets.png)

记得将两个桶的 `Block all public access` 设置为 `Off`，然后都打开 `Static website hosting`，将其中一个桶设置跳转到主网站桶，如果你不需要跳转的话，那么这里创建一个桶就够了，后面把 CloudFront distribution 的 `CNAME` 设置为两个。**重要：**记住主桶 `Static website hosting` 中的 `Endpoint` URL，我这里是 `http://nichenjie.com.s3-website.ca-central-1.amazonaws.com`，后面会使用到。

### Step 2. 配置 CloudFront CDN

**重要：**Origin Domain Name 不能在下拉菜单中选择！那样有可能会不支持 `https`，或出现权限问题。这个地方需要输入上面那个 S3 中带 `.s3-website.` 的 `Endpoint`，例如 `http://nichenjie.com.s3-website.ca-central-1.amazonaws.com`.

**重要：**Default Root Object 需要设为 `index.html`.

如果你上面只创建了一个桶，那么这里只需要创建一个 Distribution，然后它的 `CNAME` 为 `www.nichenjie.com` 和 `nichenjie.com`。如果你跟我一样是两个桶的话，`CNAME` 分别指向两个桶。使用 `CNAME` 需要开启 `https` 协议，你可以到 AWS Certificate Manager (ACM) 中申请免费的 SSL 证书，申请成功后在 `Custom SSL Certificate` 中选择相应证书即可。小技巧：SSL Certificate 可以添加多个域名，也可以用泛域名，例如我申请的证书涵盖了 apex domain `nichenjie.com` 以及所有的子域名 `*.nichenjie.com`，这样今后在 `ELB` 或者其他 CloudFront Distro 中也可以使用该证书，只要有它们有同样的根域名。

Cache Behavior Settings 这边我推荐 `Redirect HTTP to HTTPS`，打开 `Compress Objects Automatically`，也就是说在传输之前 CF 会用 `gzip` 的方式压缩内容。

具体配置详情，可以参考截图：

![CloudFront General](/mdres/posts/2019/11/cf1.png)

![CloudFront Origins](/mdres/posts/2019/11/cf2.png)

![CloudFront Cache Behavior Settings 1](/mdres/posts/2019/11/cf3.png)

![CloudFront Cache Behavior Settings 2](/mdres/posts/2019/11/cf4.png)

### Step 3. 还有一丢丢配置

在主桶的 Bucket Policy 中加入如下代码：

```
{
    "Sid": "2",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::<你主桶的名字>/*"
}
```

加了这段规则之后，你的主桶上就会出现 `Public` 的标签。

最后，我们需要在 Route 53 中添加 A记录 ALIAS 规则分别把 `www.nichenjie.com` 和 `nichenjie.com` 指向相对应的 CloudFront Distribution 即可，配置如下：

![Apex domain name](/mdres/posts/2019/11/r53_1.png)

![Subdomain name](/mdres/posts/2019/11/r53_2.png)

### Step 4. Travis CI 自动部署

这里可以参考我现在的 `.travis.yml` 配置，你可以在[这里](https://github.com/chenjie/www.nichenjie.com/blob/master/.travis.yml)找到，主要就是以下代码：

```
before_deploy:
  - pip install --user awscli
  - export PATH=$PATH:$HOME/.local/bin
  - chmod +x script/empty-bucket.sh
  - script/empty-bucket.sh

deploy:
  - provider: s3
    access_key_id: "$AWS_ACCESS_KEY_ID"
    secret_access_key: "$AWS_SECRET_ACCESS_KEY"
    bucket: nichenjie.com
    skip_cleanup: true
    region: ca-central-1
    local_dir: _site
    cache_control: "public, max-age=3600"

after_deploy:
  - chmod +x script/invalidate-cache.sh
  - script/invalidate-cache.sh
```

script/empty-bucket.sh:

```
#!/usr/bin/env bash
set -e # halt script on error

aws s3 rm s3://nichenjie.com --recursive --region ca-central-1
```

script/invalidate-cache.sh:

```
#!/usr/bin/env bash
set -e # halt script on error

aws cloudfront create-invalidation --distribution-id E3U0JG8KK5Y4U6 --paths "/*"
```

简单解释一下，每次我 Push 代码到我的 GitHub Repo 会 trigger CI，CI 用 Jekyll 编译我的静态博客，然后在检查完我博客中所有链接都没 `404` 后执行 `before_deploy`，这步包括安装 `aws-cli` 和清空主桶。在这些都执行完之后，deploy script 会被 trigger，将所有 `_site` 文件夹底下的文件都上传至我主桶的根目录，并且将 `metadata` 中的 `cache_control` 设定为 `public, max-age=3600`，缓存有助于降低 CF outgoing 流量以及 s3 的请求（PUT, GET等）费用。最后的最后，做一次 CF cache invalidation 来把更新数据 propagate 到所有全球的边缘（edge）服务器中。

## 大功告成

Enjoy! 如果你有什么问题，欢迎在评论区中让我知道，你也可以直接在我的 [GitHub Repo](https://github.com/chenjie/www.nichenjie.com) 中 Open Issue 或者 PR. Thanks for reading till the end!