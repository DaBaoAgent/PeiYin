# 徐艾伦 · 历史口播工业化出品项目

> 历史人物口播视频（动画 + 克隆配音）的工业化生产线：**写稿 → 审核 → 配音 → 归档**，一条流水线批量出片。
> 账号：徐艾伦（动画 + 克隆配音的历史口播号）｜形态：短平快历史人物口播视频

**项目状态**：37 位人物选题已建档，11 篇完成配音（001–011），26 篇待配音（012–037）。

---

## 目录

- [项目简介](#项目简介)
- [目录结构](#目录结构)
- [快速开始](#快速开始)
- [生产管线](#生产管线)
- [人物进度](#人物进度)
- [风格规范](#风格规范)
- [技术栈](#技术栈)
- [Roadmap](#roadmap)
- [已封装为 lishi 技能](#已封装为-lishi-技能)
- [授权说明](#授权说明)

## 项目简介

本项目是一套**可复制的历史口播内容生产线**，核心资产不是单篇视频，而是：

1. **口播稿模板化**：钩子开头 + 分节讲述 + 现代比喻 + 金句 + 固定结尾，每篇 2500~3500 字；
2. **克隆配音参数化**：dabao 克隆音色（GPT-SoVITS v5turbo zero-shot），参数经多轮审核定稿，音色稳定可复现；
3. **批量化**：PowerShell 批量脚本一键跑多篇配音，日志留痕，断点可查；
4. **方法论沉淀**：对标爆款拆解、钩子方案库、AI 味审核清单、误读修正表，随产随积累。

> 为什么能"工业化"：选题标准、写作骨架、配音参数、审核清单全部文档化并随项目版本管理，换人不换产。

## 目录结构

```text
PeiYin/
├── README.md                # 本文件：项目总览
├── .gitignore               # 忽略音视频产物与日志（约 3.5GB，不入库）
├── .gitmodules              # GPT-SoVITS 配音引擎（submodule）
├── GPT-SoVITS/              # 配音引擎：tts_server.py + dabao_tts.py + 音色预设
├── docs/                    # 方法论文档（怎么写稿、怎么配好音）
│   ├── 管线说明.md            # 7 步生产流程 + 工具链 + 已知事项
│   ├── 口播稿规范.md          # 写作骨架与风格红线
│   ├── 配音参数与音色.md       # v3 定稿参数 + 音色审核沿革 + 误读修正表
│   ├── 对标爆款拆解报告.md     # 11 个对标视频的完整拆解
│   ├── 钩子方案库.md          # 18 个开头钩子，任选
│   ├── AI味审核清单.md        # 配音听审清单
│   ├── 参考-旧号风格分析.md    # 旧号（子非秋月）风格分析（反面参考）
│   └── 对标逐字稿/            # 11 个对标视频逐字稿 + ASR 任务映射
├── scripts/                 # 自动化脚本
│   ├── setup.ps1            # 新机器一键初始化（submodule + 权重 + venv + 冒烟测试）
│   ├── run_dabao_batch.ps1  # 批量配音脚本（模板，改任务表即用）
│   └── fetch_all_asr.ps1    # 拉取对标视频 ASR 逐字稿
├── 出稿/                     # 成品交付目录（每集一个文件夹）
│   ├── README.md            # 进度清单与编号规则
│   ├── 0XX_人物名/           # 口播稿.md + 配音.wav + 配音.json + 分段
│   └── @已做/                # 已听审归档的集（001/005/006/007）
├── workdir/                 # TTS 工作目录
│   ├── tts/                 # 全篇纯文本输入 + 合成中间件（wav/json）
│   └── logs/                # 批次日志
├── reference/               # 参考素材（体积大，不入库）
│   ├── 历史对标视频/          # 11 个对标 mp4
│   ├── 子非秋月/             # 旧号素材
│   └── 音色审核/             # v1~v4 音色样音 + v3 参数验证
└── archive/                 # 归档（旧管线与一次性产物）
    ├── 诸葛亮/               # 旧管线：口播稿 + 配音 + 分段
    ├── 早期样稿/             # E1~E3 + 李白样稿 + 旧版管线文档
    ├── 女娲_炎帝_配音_20261024.zip
    ├── email_parts/         # 同一 zip 的邮件分卷（5 卷 + 合并脚本）
    └── 旧批次脚本/           # 20261024 历史批次脚本
```

> 注：整套流程已封装为 agent 技能 `lishi`，安装在本仓库之外：`C:\Users\Administrator\AppData\Local\Doubao\User Data\Default\.doubao\agent_mode\workspace\.user_skills\lishi\`，详见下文「已封装为 lishi 技能」。

## 快速开始

### 环境要求

- Windows 10/11 + PowerShell（Windows PowerShell 5.1 或 PowerShell 7 / `pwsh` 均可）
- Git + Git LFS（模型、参考音色与可选 runtime 走 LFS，约 2.4GB）
- Python 3.11（`py -3.11` 可用；脚本会强制创建 3.11 venv）
- ffmpeg / ffprobe（引擎 `runtime/` 自带或装在 PATH 上）
- GPT-SoVITS submodule（克隆后在 `GPT-SoVITS/`，含 tts_server.py + dabao_tts.py）
- dabao 克隆音色 preset：`GPT-SoVITS/voices/dabao/preset.json`

### 克隆与初始化（新电脑）

```powershell
git clone --recurse-submodules https://github.com/DaBaoAgent/PeiYin.git
cd PeiYin
pwsh -File .\scripts\setup.ps1 -PipIndexUrl https://repo.huaweicloud.com/repository/pypi/simple/
```

`setup.ps1` 会依次完成：初始化 submodule → 校验/拉取 LFS 模型与音色资源 → 创建
`GPT-SoVITS/.venv`（Python 3.11）→ 安装 torch 2.6 CPU 与依赖 → 启动
`tts_server` 做健康检查并真实合成一句（覆盖 ffmpeg / MP3 链路）。没装 `pwsh` 时改用：
`powershell -ExecutionPolicy Bypass -File .\scripts\setup.ps1 -PipIndexUrl https://repo.huaweicloud.com/repository/pypi/simple/`。

- 国内网络访问 GitHub LFS 慢时，可先跳过 LFS 大文件再克隆，由 setup 按需补拉：
  `$env:GIT_LFS_SKIP_SMUDGE="1"; git clone --recurse-submodules https://github.com/DaBaoAgent/PeiYin.git; Remove-Item Env:GIT_LFS_SKIP_SMUDGE`
- 或从已有安装复制权重：
  `pwsh -File .\scripts\setup.ps1 -WeightsFrom D:\GPT-SoVITS`
- pip 镜像按需更换：华为云 `https://repo.huaweicloud.com/repository/pypi/simple/`（推荐）、
  清华 `https://pypi.tuna.tsinghua.edu.cn/simple`、阿里云
  `https://mirrors.aliyun.com/pypi/simple/`。
- torch CPU wheel 默认走交大镜像，失败会自动回退官方源；也可用
  `-TorchIndexUrl https://download.pytorch.org/whl/cpu` 显式指定。
- 老克隆未带 submodule 时，先执行 `git submodule update --init --recursive` 再跑 setup。
- 只想跳过最后的模型加载测试可加 `-SkipSmoke`。

### 1. 写一篇稿

按 `docs/口播稿规范.md` 的七步骨架，产出 `出稿/0XX_人物名/口播稿.md`。

### 2. 转纯文本

去标题/引号/括号，数字写中文，存 `workdir/tts/XX_全篇.txt`。

### 3. 单篇配音

```powershell
GPT-SoVITS\dabao_tts.cmd --text-file <全篇.txt> --out <出稿\0XX_人物名\配音.wav> --force
```

自动完成：切段（≤150 字）→ 逐段合成 → 静音压缩 → 噪声门 → 拼接 → 输出 `配音.wav` + `配音.json` + 分段音频。

### 4. 批量配音

```powershell
cd D:\@kaifa\PeiYin
.\scripts\run_dabao_batch.ps1
```

编辑脚本「任务表」`$jobs` 追加集数即可；日志自动写入 `workdir/logs/`。

### 5. 听审归档

按 `docs/AI味审核清单.md` 听审，通过后整目录移入 `出稿/@已做/`。

## 生产管线

```mermaid
graph LR
    A[选人物<br/>反差优先] --> B[建目录<br/>出稿/0XX_人物名]
    B --> C[写口播稿.md<br/>七步骨架]
    C --> D[转纯文本<br/>workdir/tts]
    D --> E[dabao_tts 配音<br/>v5turbo 参数]
    E --> F[配音.wav + json<br/>+ 分段音频]
    F --> G[听审<br/>AI味审核清单]
    G --> H{通过?}
    H -- 否 --> E
    H -- 是 --> I[归档<br/>出稿/@已做]
```

## 人物进度

> 稿 = `口播稿.md`；配 = `配音.wav`。当前 **11 / 37** 已完成配音。

| 编号 | 人物 | 稿 | 配 | 备注 |
|---|---|---|---|---|
| 001 | 刘秀 | ✅ | ✅ | @已做，v3 重配 |
| 002 | 王阳明 | ✅ | ✅ | 早期短稿版 |
| 003 | 朱元璋 | ✅ | ✅ | 早期短稿版 |
| 004 | 李白 | ✅ | ✅ | 早期短稿版（管线首篇样稿） |
| 005 | 伏羲 | ✅ | ✅ | @已做，旧参数 |
| 006 | 女娲 | ✅ | ✅ | @已做，v3（427s/42段） |
| 007 | 炎帝 | ✅ | ✅ | @已做，v3（385s/40段） |
| 008 | 黄帝 | ✅ | ✅ | v3（332s/33段） |
| 009 | 大禹 | ✅ | ✅ | v3（255s/25段） |
| 010 | 夏桀 | ✅ | ✅ | v3（234s/23段） |
| 011 | 商汤 | ✅ | ✅ | v3（222s/22段） |
| 012 | 商纣王 | ✅ | ⬜ | 待配音 |
| 013 | 周文王 | ✅ | ⬜ | 待配音 |
| 014 | 周武王 | ✅ | ⬜ | 待配音 |
| 015 | 周幽王 | ✅ | ⬜ | 待配音 |
| 016 | 秦始皇 | ✅ | ⬜ | 待配音 |
| 017 | 汉高祖 | ✅ | ⬜ | 待配音 |
| 018 | 汉武帝 | ✅ | ⬜ | 待配音 |
| 019 | 王莽 | ✅ | ⬜ | 待配音 |
| 020 | 曹操 | ✅ | ⬜ | 待配音 |
| 021 | 刘备 | ✅ | ⬜ | 待配音 |
| 022 | 孙权 | ✅ | ⬜ | 待配音 |
| 023 | 宋武帝刘裕 | ✅ | ⬜ | 待配音 |
| 024 | 隋文帝 | ✅ | ⬜ | 待配音 |
| 025 | 隋炀帝 | ✅ | ⬜ | 待配音 |
| 026 | 唐太宗 | ✅ | ⬜ | 待配音 |
| 027 | 武则天 | ✅ | ⬜ | 待配音 |
| 028 | 唐玄宗 | ✅ | ⬜ | 待配音 |
| 029 | 柴荣 | ✅ | ⬜ | 待配音 |
| 030 | 李煜 | ✅ | ⬜ | 待配音 |
| 031 | 宋太祖 | ✅ | ⬜ | 待配音 |
| 032 | 宋仁宗 | ✅ | ⬜ | 待配音 |
| 033 | 成吉思汗 | ✅ | ⬜ | 待配音 |
| 034 | 明成祖 | ✅ | ⬜ | 待配音 |
| 035 | 崇祯帝 | ✅ | ⬜ | 待配音 |
| 036 | 康熙帝 | ✅ | ⬜ | 待配音 |
| 037 | 乾隆帝 | ✅ | ⬜ | 待配音 |

## 风格规范

- **钩子开头**：反常识提问 / 反差人设，第一句让人停下来。
- **现代比喻**：每篇至少 3 个（KPI、源代码、优化、上岸）。
- **金句**：每篇至少 1 句可截图传播。
- **收束**：结尾落到「这跟今天的你有什么关系」。
- **固定结尾**："我是艾伦，遛狗去了，白了个白。"（"拜"读 bái）
- **红线**：不做第一人称历史独白（旧号路线）；不用文学比喻；不超长（2500~3500 字）。

详见 [`docs/口播稿规范.md`](./docs/口播稿规范.md)。

## 技术栈

| 层 | 技术 |
|---|---|
| 配音 | GPT-SoVITS v5turbo（zero-shot）· dabao 克隆音色 |
| 批量 | PowerShell 5.1 / 7 脚本 |
| 文档 | Markdown（GitHub 渲染 Mermaid 管线图） |
| 内容源 | 11 个对标视频逐字稿（ASR）· 历史典籍 |

## Roadmap

- [ ] 完成 012–037 共 26 篇配音（批量脚本已就绪）
- [ ] 建立分镜/动画管线（`docs/` 预留方法论位置）
- [ ] 每集发布后回填「数据表现 → 复盘」，反哺选题与钩子库
- [ ] 可选：音频产物迁移 Git LFS 实现全量版本管理

## 已封装为 lishi 技能

整套生产线已封装为 agent 可执行技能 **lishi**，流程与参数与本文档一致，agent 可一键跑完整条线。

- **技能安装位置（绝对路径）**：`C:\Users\Administrator\AppData\Local\Doubao\User Data\Default\.doubao\agent_mode\workspace\.user_skills\lishi\`
- **触发方式**：agent 命中技能 description 即自动加载——例如"写一篇历史人物口播稿""给某人物跑 dabao 配音""批量配音""口播稿去 AI 味"等说法；技能正文是八步流程的精简命令版，照做即可。
- **references 与 docs/ 的关系**：技能 `references/` 下 5 份方法论文档（管线说明 / 口播稿规范 / AI味审核清单 / 配音参数与音色 / 钩子方案库）是本仓库 `docs/` 的快照副本，内容一致；`docs/` 更新后以仓库为准，可回灌更新技能 references。
- **批量脚本模板**：技能 `scripts/run_dabao_batch.ps1` 与本仓库 `scripts/run_dabao_batch.ps1` 一致；编辑任务表 `$jobs` 后在项目根目录运行，日志落 `workdir/logs/`。

## 授权说明

本项目内容、口播稿与配音产物版权归作者所有。公开仓库中的文档/脚本可按需引用，但**音视频产物与口播稿全文未经授权不得商用**。如需开源协议，请在发布前补充 `LICENSE` 文件。
