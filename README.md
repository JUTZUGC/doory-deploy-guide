# Doory 一键部署指南

> 第三方部署指南 · 非 Doory 官方仓库。官方项目：[shaongitbd/doory](https://github.com/shaongitbd/doory)
> 内容来自官方文档（2026-10-30）。项目迭代快，请以[官方文档](https://github.com/shaongitbd/doory#self-host-it)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 海报、社媒图、邀请函、简历、PPT 都能在浏览器里改，导出 PNG/PDF/MP4，服务端跑在你自己机器上。

⚠️ 需要 Docker 与 Compose v2，默认端口 8080。首次 `--build` 会编译前后端并下载无头 Chromium 与 ffmpeg，镜像体积较大、耗时取决于网络；不想等可以把 `INSTALL_CHROMIUM` / `INSTALL_FFMPEG` 设为 false。新站点默认没有模板与字体，需要手动导入一次。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/doory-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会检查 Docker Compose，克隆仓库、生成随机密钥写进 .env，再构建并启动整套服务，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:8080](http://127.0.0.1:8080)，按官方引导完成初始化配置。

## Doory 是什么？

Doory 是开源的在浏览器里做海报、社媒图、简历和 PPT，导出 PNG/PDF/MP4，不订阅也能自托管（协议：Attribution Assurance License，<img src="https://img.shields.io/github/stars/shaongitbd/doory?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

自托管的浏览器设计编辑器：模板或空白画布起稿，文字、图形、图片、动效都能改，支持多页与图层，导出 PNG、JPG、SVG、PDF、MP4、GIF，还能分享链接做实时协作。

- 开箱即用：不用注册账号，游客直接开始设计
- 导出格式全：PNG、JPG、SVG、PDF、MP4、WebM、GIF
- 动效与音频：入场/退场动画、页面过渡、音乐与音效
- 协作：分享链接可查看、评论或编辑，支持实时共同编辑
- 自带 MCP：让 Claude、Cursor 等客户端直接改设计稿
- 完全自托管：数据留在自己的机器上，没有付费墙

（来源：[官方仓库](https://github.com/shaongitbd/doory)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 1 | . |
| 导 | 出 |
| 自 | 带 |
| 支 | 持 |
| 完 | 全 |
| 无 | 需 |

| 需要注意 | 说明 |
|---|---|
| 需 | 要 |
| 模 | 板 |
| 首 | 次 |
| 许 | 可 |
| 项 | 目 |

> 以上基于官方文档与社区反馈整理（2026-10-30），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/shaongitbd/doory.git
cd doory
cp .env.example .env
sed -i "s|^DJANGO_SECRET_KEY=.*|DJANGO_SECRET_KEY=$(openssl rand -base64 48)|; s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$(openssl rand -hex 16)|" .env
docker compose up -d --build
echo "已启动：http://127.0.0.1:8080"
```

启动后浏览器访问 [http://127.0.0.1:8080](http://127.0.0.1:8080)（管理面板）。（来源：[https://github.com/shaongitbd/doory#self-host-it](https://github.com/shaongitbd/doory#self-host-it)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 与 docs/self-hosting/docker.md 确认 Compose 部署、端口 8080、必需环境变量 | 已核对 2026-10-30 |
| .env.example 确认 SITE_URL / DJANGO_SECRET_KEY / POSTGRES_PASSWORD 三个必填项 | 已核对 2026-10-30 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-10-30 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-30 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

Doory 自带一个 MCP server（服务路径 `/mcp`，默认关闭，需要开 `COMPOSE_PROFILES=mcp`）；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-30）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\doory-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 第一次使用

1. 打开 http://127.0.0.1:8080
2. 从模板或空白页新建一个设计，改文字、换图、加动效
3. Share 菜单里导出 PNG / PDF / MP4
4. 需要后台管理时创建管理员：

```bash
docker compose exec api python manage.py createsuperuser
```

## 导入起步内容

新站点没有模板、字体和图标，按需执行：

```bash
docker compose exec api python manage.py seed_gallery
docker compose exec api python manage.py sync_element_packs
docker compose exec api python manage.py sync_fonts
docker compose exec api python manage.py seed_templates
```

## 可选服务

在 `.env` 里设 `COMPOSE_PROFILES=mcp,redis` 再 `docker compose up -d`，可启用 MCP 与 Redis。

## 停止与数据

```bash
docker compose down      # 停止，保留数据
docker compose down -v   # 停止并删除数据
```

## 注意

- 默认以 0.0.0.0 暴露 8080；只在本机用可把 `WEB_BIND` 改成 127.0.0.1
- 公网访问请加反向代理与 TLS，并把 `SECURE_SSL_REDIRECT`、`SECURE_COOKIES` 打开
- `DJANGO_SECRET_KEY` 换掉会让所有人掉登录
- 许可证是 Attribution Assurance License，二次分发要保留署名

## 常见坑

- docker compose 不可用：升级 Docker Desktop，确认 v2 子命令
- 端口 8080 被占：改 .env 里的 WEB_PORT，或先停占用进程
- 启动后 API unhealthy：首次构建会下载 Chromium/ffmpeg，耐心等或关掉这两个开关
- 页面没有模板和图标：按上面命令导入一次起步内容
- 数据库密码报错：POSTGRES_PASSWORD 只用字母和数字，它会拼进 DATABASE_URL
- 管理员建不了：createsuperuser 要在 api 容器里跑，且栈已启动
- 公网访问异常：检查 SITE_URL、DJANGO_ALLOWED_HOSTS 与反代的 X-Forwarded-For

## 免责声明

本仓库为第三方指南，与 Doory 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-30），项目迭代快，请以[官方文档](https://github.com/shaongitbd/doory#self-host-it)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
