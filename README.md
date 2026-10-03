# Guangchen Wu / Yichi — personal website

个人主页、About、Publications、News 时间线和 Markdown 博客。使用 Hugo 0.167.0、PaperMod 和 GitHub Pages。

预期线上地址：**https://168yyds.github.io/**。在创建仓库并完成首次部署前，此地址尚未发布。

## 本地预览（Windows）

在这个工程目录打开 PowerShell，执行：

```powershell
.\scripts\preview.ps1
```

首次运行会下载固定版本 Hugo 并核对 SHA-256；只安装到工程内的 `.tools/`，不修改系统 PATH。如果执行策略阻止脚本，可单次运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\preview.ps1
```

打开 http://localhost:1313/ 。预览包含草稿；按 Ctrl+C 结束。

## 修改个人信息

- `content/_index.md`：首页简短介绍。
- `content/about.md`：完整介绍、教育经历和兴趣。
- `layouts/_partials/index_profile.html`：首页布局、姓名、研究方向。
- `hugo.yaml`：导航、作者、站点说明和网址。
- `assets/css/extended/personal.css`：自定义样式。
- `static/favicon.svg`：GW 字母图标。

完整原始介绍已放入 About 页面。示例文章 `content/posts/welcome/index.md` 可以编辑或删除。当前未单独添加联系方式、个人照片或简历；Publications 目前仅展示 ECCE Europe 2026 海报。

## 发布新博客

每篇文章单独一个目录，例如：

```text
content/posts/my-first-note/
├── index.md
└── diagram.png
```

`index.md` 开头写文章信息，下面直接使用 Markdown：

```markdown
---
title: "My first research note"
date: 2026-10-03T10:00:00+08:00
summary: "A short introduction to this note."
draft: true
---

## Introduction

Write your content here.

![Diagram description](diagram.png)
```

本地预览满意后，将 `draft` 改成 `false`。提交并推送到 `main`，GitHub Actions 自动更新线上网站。未来日期文章默认不会发布；需要发布时应使用已经到达的日期。

也可以创建带默认信息的文章：

```powershell
.\.tools\hugo\hugo.exe new content posts/my-first-note/index.md
```

## 首次发布到 GitHub

1. 登录 `168yyds`，创建 **Public** 仓库，名称严格填写 `168yyds.github.io`。保持为空，不勾选 README、.gitignore 或 License。
2. 在本工程目录执行以下命令（Git 可能需要浏览器登录；无需把令牌发给他人）：

```powershell
git add .
git commit -m "Build personal homepage and Markdown blog"
git remote add origin https://github.com/168yyds/168yyds.github.io.git
git push -u origin main
```

如果 Git 提示缺少提交身份，先在本工程内配置 `git config user.name "Guangchen Wu"` 和 `git config user.email "你的 GitHub 提交邮箱"`，再提交。邮箱可以使用 GitHub Settings → Emails 中的 noreply 地址。

3. 在仓库 **Settings → Pages → Build and deployment → Source** 选择 **GitHub Actions**。
4. 在 **Actions → Build and deploy website → Run workflow** 手动触发首次发布。如果此前因尚未启用 Pages 导致自动运行失败，设置后重新运行即可。
5. 工作流成功后访问 https://168yyds.github.io/ 。检查首页、About、博客和手机显示。

`public/`、`.tools/` 等生成文件已被忽略。主题作为 Git 子模块保存，并固定到当前提交。后续重新下载工程时使用：

```powershell
git clone --recurse-submodules https://github.com/168yyds/168yyds.github.io.git
```

## 更新 Publications 和 News

### 添加论文或会议海报

论文信息集中在 `data/publications.yaml`。每篇论文是一条记录；页面按 `date` 倒序排列、按 `year` 分组。把 PDF 和预览图放在 `static/publications/独立目录/`，在数据文件中填写以 `/publications/` 开头的路径。

当前 ECCE Europe 2026 记录包含完整标题、三位作者、会议信息和一页海报，海报 PDF 为提供文件的原样副本。论文正文暂不公开：网站资源目录和构建输出均不包含正文 PDF 或正文页面预览。原始论文仍保存在工程上层目录；先前生成的正文资源保存在被 Git 忽略的 `.tools/private-paper/` 中。作者邮箱没有单独提取到页面。会议时间来自官网；没有添加未经核对的 DOI 或 IEEE Xplore 上线信息。

```yaml
- id: your-paper-id
  type: Conference poster
  title: "Your paper title"
  authors: [Guangchen Wu, Coauthor Name]
  year: 2026
  date: "2026-09-14"
  venue: "Conference name"
  conference_url: "https://example.org/"
  conference_dates: "September 2026"
  location: "City, Country"
  summary: "A short description of the work."
  poster: /publications/your-paper-id/poster.pdf
  poster_pages: 1
  poster_preview: /publications/your-paper-id/poster-preview.webp
```

海报和预览图为可选项：没有对应材料时，删除对应字段即可。预览图建议从 PDF 第一页导出；完整内容通过原版 PDF 链接查看。日后决定公开正文时，再添加 `paper`、`paper_pages` 和 `paper_preview` 字段，并将对应文件放入 `static/`；`type` 可改为 `Conference paper`。暂不公开的文件应保存在网站资源目录之外，仅删除页面链接仍会留下可直接访问的文件。

当前海报提供不依赖浏览器 PDF 插件的页面内阅读功能：`poster_full_image` 指向完整海报预览，点击折叠条即可展开；原版 PDF 保留可选文字和矢量图。可填写 `poster_image_width` 和 `poster_image_height`（像素），帮助预留图片空间。日后公开正文时，可按需用 `paper_images` 列出各页 WebP 图片路径，并填写 `paper_image_width`、`paper_image_height`，启用正文页面内阅读。

### 添加 News 时间线记录

编辑 `data/news.yaml`，添加一条：

```yaml
- date: "2026-10-03"
  display_date: Oct 2026
  title: "Your update title"
  text: "A short update. Markdown links and bold text are supported."
  link: /publications/#your-paper-id
  link_text: "Read more"
  draft: false
```

首页显示最近五条记录，`/news/` 显示全部记录；都按 `date` 倒序排列。`display_date` 可以填写月份或准确日期；`date` 用于排序，必须为 `YYYY-MM-DD`。`link` 和 `link_text` 是可选项。设置 `draft: true` 可暂时隐藏记录。News 数据不会像博客一样自动排除未来日期，因此计划中的通知应明确写明“upcoming”，或先保存为草稿。

首次 ECCE Europe 记录按会议月份显示为 Sep 2026，排序日期使用会议首日，不代表具体报告日或 IEEE Xplore 上线日。

## 本地生产构建

```powershell
.\scripts\build.ps1
```

输出位于 `public/`。此构建会清理已撤下的旧文件，并排除 `draft: true` 的草稿；线上 Actions 使用相同 Hugo 版本。

## 说明

- 网站正文以英文为主，操作说明为中文。
- 不依赖数据库或付费服务。文章写在本地文件中，由 GitHub Pages 提供静态页面。
- 个人资料只采用已提供的介绍，暂未添加未经确认的联系方式和成果。
- 数学公式目前没有配置 MathJax；需要时可以再接入。
- 自动发布配置已提供；实际 GitHub Actions 运行需要创建仓库并启用 Pages 后验证。
- PaperMod 主题遵循其自带 MIT License；保留了 Hugo 和 PaperMod 的页脚署名。

参考：[PaperMod](https://github.com/adityatelange/hugo-PaperMod)、[Hugo 部署文档](https://gohugo.io/host-and-deploy/host-on-github-pages/)。
