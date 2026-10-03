# Hugo + GitHub Pages 个人网站

基于 **Hugo 0.167.0 + PaperMod + GitHub Pages** 的静态网站，包含个人主页、About、Publications、News 时间线和 Markdown 博客。无需数据库；内容以文件保存，推送到 `main` 后由 GitHub Actions 自动构建并部署。

## 搭建过程概览

1. 使用 Hugo 组织 Markdown 内容，并以 Git 子模块引入 PaperMod 主题。
2. 在 `hugo.yaml` 配置站点信息、导航和博客选项。
3. 自定义首页模板与 CSS，加入研究方向、News 和最近文章。
4. 用 YAML 数据管理 News 和 Publications，便于追加内容。
5. 配置 GitHub Actions：检出源码与主题 → 安装 Hugo → 构建静态页面 → 部署到 GitHub Pages。

## 搭建与发布教程

### 1. 获取工程并本地预览

准备 Git 和 Windows PowerShell，然后执行：

```powershell
git clone --recurse-submodules https://github.com/168yyds/168yyds.github.io.git personal-site
cd personal-site
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\preview.ps1
```

首次运行会下载固定版本 Hugo、核对 SHA-256，并将工具安装到本工程的 `.tools/`。打开 [本地预览](http://localhost:1313/)，按 `Ctrl+C` 结束。预览包含草稿。

如果主题没有下载完整，执行：

```powershell
git submodule update --init --recursive
```

### 2. 修改网站内容

| 文件 | 用途 |
| --- | --- |
| `hugo.yaml` | 网站标题、作者、说明、网址、导航 |
| `content/_index.md` | 主页介绍 |
| `content/about.md` | About 页面 |
| `layouts/_partials/index_profile.html` | 首页结构、研究方向 |
| `data/news.yaml` | News 时间线 |
| `content/posts/<文章目录>/index.md` | Markdown 博客 |
| `data/publications.yaml` | Publications 条目 |
| `static/publications/` | 公开的海报 PDF 与预览图片 |
| `assets/css/extended/` | 自定义样式 |

如果用于搭建自己的站点，请替换上述个人内容、图标，并把 `hugo.yaml` 的 `baseURL` 改为 `https://<username>.github.io/`；`<username>` 替换为你的 GitHub 用户名。

### 3. 首次发布到 GitHub Pages

已有本仓库的维护者可直接按后面的“提交更新”操作。复用工程搭建自己的站点时：

1. 创建公开的空仓库，名称为 `<username>.github.io`，不要初始化 README、.gitignore 或 License。
2. 在本地工程目录执行以下命令，将远程地址替换为新仓库：

```powershell
git remote set-url origin "https://github.com/<username>/<username>.github.io.git"
git add .
git commit -m "Configure personal website"
git push -u origin main
```

如 Git 提示缺少提交身份，先配置 `git config user.name "Your Name"` 和 `git config user.email "your-email@example.com"`，再提交；推送时按提示完成 GitHub 登录。

3. 在仓库 **Settings → Pages → Build and deployment → Source** 选择 **GitHub Actions**。
4. 在 **Actions → Build and deploy website → Run workflow** 选择 `main` 并运行。本工程已有工作流，无需另选模板。
5. 等待 `build` 和 `deploy` 均成功，访问 `https://<username>.github.io/`。

若首次推送触发的运行因尚未启用 Pages 而失败，完成第 3 步后重新运行即可。配置方法见 [GitHub Pages 官方文档](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)。

## 更新主页 News

编辑 `data/news.yaml`，在现有列表中新增一条记录：

```yaml
- date: "2026-10-03"
  display_date: Oct 2026
  title: "New research note"
  text: "A new **research note** is available on the blog."
  link: /posts/my-first-note/
  link_text: Read the note
  draft: false
```

- `date`：排序日期，格式为 `YYYY-MM-DD`；页面按日期倒序排列。
- `display_date`：可选的显示日期，不填则自动显示月份和年份。
- `title`、`text`：标题和正文；正文支持 Markdown 链接与加粗。
- `link`、`link_text`：可选的跳转地址与按钮文字；站内地址以 `/` 开头。
- `draft: true`：暂时隐藏；准备公开时改为 `false`。

首页显示最近 **5 条**，`/news/` 显示全部记录，无需手动修改首页模板。News 不会自动隐藏未来日期，因此计划中的记录可先设置为草稿。

## 发布 Markdown 博客

### 1. 创建文章目录

每篇文章使用一个目录，将正文与图片放在一起：

```text
content/posts/my-first-note/
├── index.md
└── diagram.png
```

也可在首次预览安装好 Hugo 后，用命令创建正文模板：

```powershell
.\.tools\hugo\hugo.exe new content posts/my-first-note/index.md
```

### 2. 编写正文

`index.md` 顶部的 YAML 用于设置文章信息，下面写 Markdown：

```markdown
---
title: "My first research note"
date: 2026-10-03T10:00:00+08:00
summary: "A short introduction to this note."
draft: true
---

## Introduction

Write your content here.

- A key idea
- Another observation

![Diagram description](diagram.png)
```

文章路径为 `/posts/my-first-note/`。`title` 是标题，`summary` 是列表摘要；将示例日期替换为实际发布日期。

### 3. 预览并发布

运行预览脚本检查排版。确认后把 `draft` 改为 `false`，再提交并推送。生产构建会排除草稿和未来日期文章；即使 `draft: false`，未来日期文章仍不会立即上线。

修改已发布文章时，直接编辑对应 `index.md`，再提交更新即可。Markdown 语法支持标题、列表、链接、图片、表格和代码块；公式渲染需另行配置。

## 提交更新

在工程目录执行：

```powershell
git add .
git commit -m "Update website content"
git push
```

推送到 `main` 会自动触发部署，在仓库 **Actions** 查看结果。若曾在 GitHub 网页直接编辑文件，应在本地修改前运行 `git pull --ff-only` 同步。

小幅更新也可直接在 GitHub 打开 `data/news.yaml` 或博客文件，点击编辑按钮，修改后提交到 `main`；新增博客可通过 **Add file → Create new file** 创建 `content/posts/<文章目录>/index.md`，同样会触发部署。

## 构建与资源说明

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

生产输出位于 `public/`，构建时会清理已撤下的旧文件。`public/`、`.tools/` 和预览日志均已被 Git 忽略，上传的是网站源码，GitHub Actions 负责生成页面。

Publications 当前只提供海报。只有准备公开的资料才放入 `static/`；撤下资料时应同时删除数据字段和对应公开文件。

参考：[Hugo](https://gohugo.io/) · [PaperMod](https://github.com/adityatelange/hugo-PaperMod) · [Hugo 文章信息配置](https://gohugo.io/content-management/front-matter/)。
