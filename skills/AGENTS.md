# Hermes Agent Skills — 智能体地图

> 本文件是 Hermes Agent 的技能目录。任何智能体在此仓库工作时，应以本文件为入口。
>
> **核心原则：仓库即记录系统。不在仓库里的约束，对智能体不存在。**

---

## 技能速查

### 🏠 系统与平台

| Skill | 用途 |
|-------|------|
| `apple` | macOS 系统操作：iMessage、Reminders、Notes、FindMy、设备追踪 |
| `smart-home` | 控制飞利浦 Hue 智能灯具：开关、亮度、色温、场景 |
| `email` | 通过 himalaya CLI 管理邮件：读写、搜索、组织（IMAP/SMTP） |
| `openhue` | `smart-home` 的底层 CLI，同上 |

### 💻 开发工具

| Skill | 用途 |
|-------|------|
| `github` | GitHub 全套操作：PR、Issue、代码审查、仓库管理（6个子skill） |
| `github-pr-workflow` | PR 生命周期：创建分支→提交→PR→CI→合并 |
| `github-code-review` | 分析 diff，在 PR 上留内联评论 |
| `github-issues` | 创建、管理、搜索 Issue |
| `github-repo-management` | 克隆、创建、Fork、配置仓库 |
| `github-auth` | GitHub 认证：SSH key、HTTPS token、gh CLI |
| `codebase-inspection` | LOC 统计、语言分布、代码 vs 注释比例 |
| `software-development` | 开发流程：plan模式、TDD、系统调试、subagent驱动开发 |
| `plan` | 生成 markdown 计划，写入 `.hermes/plans/`，不执行 |
| `systematic-debugging` | 4步根因分析：问题→分析→验证→修复 |
| `test-driven-development` | 红-绿-重构循环，测试先行 |
| `subagent-driven-development` | 多任务并行执行 + 两阶段审查 |
| `requesting-code-review` | 提交前质量门禁：安全扫描+代码审查 |
| `writing-plans` | 根据需求创建可执行实现计划 |
| `autonomous-ai-agents` | 调度子Agent：Claude Code、Codex、OpenCode |
| `claude-code` | 委托 Claude Code（Anthropic CLI）：功能开发、重构、PR审查 |
| `codex` | 委托 OpenAI Codex CLI：功能开发、批量Issue修复 |
| `opencode` | 委托 OpenCode CLI：长时自主编程会话 |
| `hermes-agent` | Hermes Agent 本身的使用和扩展指南 |
| `hermes-session-debug` | 调试 session 身份问题（SOUL.md 加载异常） |
| `hermes-skills-install-push` | 安装 optional-skills 并推送到 GitHub |
| `skills-audit` | 审计已安装 skills：查漏、查重、验证完整性 |
| `wechat-identity-debug` | 调试微信机器人身份错误 |
| `hermes-debugging` | 调试 Hermes 本身：.pyc 缓存、启动问题 |
| `hermes-openclaw-parallel` | 调试 Hermes 和 OpenClaw 并行问题（二者独立） |
| `devops` | Webhook 订阅管理，触发自动 agent 运行 |
| `webhook-subscriptions` | 同上 |
| `docker-management` | Docker 容器/镜像/网络/Compose 管理、调试、磁盘清理 |
| `mcp` | MCP（Model Context Protocol）客户端：连接外部工具服务器 |
| `mcporter` | MCP CLI 工具：配置、认证、调用 MCP 服务器 |
| `native-mcp` | 内置 MCP 客户端：stdio/HTTP 传输，自动重连 |
| `index-cache` | 索引缓存管理 |
| `inference-sh` | 推理脚本管理 |
| `testing` | CTF 风格多挑战 pytest 项目测试 |

### 🤖 AI / MLOps

| Skill | 用途 |
|-------|------|
| `mlops` | MLOps 工具集总览（大量子skill） |
| `evaluating-llms-harness` | 评测 LLM：MMLU、HumanEval、GSM8K 等 60+ 基准（EleutherAI Harness） |
| `fine-tuning-with-trl` | RLHF 微调：SFT、DPO、PPO/GRPO（TRL 库） |
| `peft-fine-tuning` | LoRA/QLoRA 高效微调（≤1% 参数） |
| `unsloth` | 快速微调：2-5x 提速，50-80% 显存节省 |
| `axolotl` | Axolotl 微调框架：100+ 模型，DPO/KTO/ORPO/GRPO |
| `grpo-rl-training` | GRPO/RL 微调（TRL） |
| `pytorch-fsdp` | PyTorch FSDP 分布式训练：参数分片、混合精度、CPU卸载 |
| `serving-llms-vllm` | vLLM 高吞吐推理服务：PagedAttention、连续批处理 |
| `llama-cpp` | CPU/Apple Silicon/消费级 GPU 运行 LLM（GGUF 量化） |
| `gguf-quantization` | GGUF 格式与 llama.cpp 量化 |
| `outlines` | 结构化生成：保证 JSON/XML/代码格式正确（Pydantic） |
| `guidance` | 受控生成：regex/grammar 约束输出格式 |
| `obliteratus` | 移除 LLM 拒答行为：机制可解释性方法（SAE、LEACE等） |
| `dspy` | DSPy：声明式 AI 系统编程，自动优化提示词 |
| `huggingface-hub` | HuggingFace Hub：模型/数据集搜索、下载、上传 |
| `weights-and-biases` | W&B 实验追踪：实时可视化、超参搜索、模型注册表 |
| `whisper` | Whisper 语音识别：99语言、语音转文字、翻译 |
| `clip` | CLIP 视觉-语言模型：零样本图像分类、图文匹配 |
| `segment-anything-model` | SAM 图像分割：点/框/掩码提示的零样本分割 |
| `stable-diffusion-image-generation` | Stable Diffusion 文生图：图生图、inpainting |
| `audiocraft-audio-generation` | AudioCraft 音频生成：MusicGen 文生音乐、AudioGen 音效 |
| `heartmula` | HeartMuLa 音乐生成（Suno-like）：歌词+标签→完整歌曲 |
| `songsee` | 音频频谱可视化：mel、chroma、MFCC、tempogram |
| `modal-serverless-gpu` | Modal 无服务器 GPU：ML 模型部署、API 服务、批处理 |
| `jupyter-live-kernel` | 活 Jupyter 内核：状态化迭代 Python 执行 |
| `arxiv` | 学术论文搜索：arXiv REST API（免费，无需 Key） |
| `polymarket` | 预测市场数据：市场搜索、价格、订单簿（公开 API） |
| `blogwatcher` | RSS/Atom 博客监控：追踪更新、过滤、阅读状态 |
| `llm-wiki` | Karpathy LLM Wiki：构建持久化知识库、交叉链接检查 |

### 📝 内容与创意

| Skill | 用途 |
|-------|------|
| `creative` | 创意内容生成总览 |
| `ascii-art` | ASCII 艺术：pyfiglet、cowsay、图片转ASCII（571字体） |
| `ascii-video` | ASCII 视频流水线：视频→ASCII、音频可视化、文字动画 |
| `excalidraw` | 手绘风格图表：Excalidraw JSON 格式，架构图、流程图 |
| `manim-video` | 数学动画：3Blue1Brown 风格，技术解释视频 |
| `p5js` | p5.js 交互艺术：生成艺术、数据可视化、网页动画 |
| `popular-web-designs` | 54 种真实网站设计系统：Stripe、Linear、Vercel 等 |
| `songwriting-and-ai-music` | 歌曲创作 + AI 音乐提示词（Suno） |
| `media` | 媒体工具集 |
| `gif-search` | Tenor GIF 搜索：聊天反应 GIF |
| `youtube-content` | YouTube 内容提取：字幕获取、总结、文章改写 |
| `social-media` | 社媒操作 |
| `xitter` | X/Twitter：发帖、读时间线、搜索、点赞、转发 |
| `red-teaming` | 红队攻击：Jailbreak、Prompt注入、安全测试 |
| `godmode` | GODMODE jailbreak 技术：33种注入、ULTRAPLINIAN racing |

### 📚 知识与笔记

| Skill | 用途 |
|-------|------|
| `qmd` | 本地知识库 RAG 搜索：BM25+向量混合检索，离线运行 |
| `duckduckgo-search` | 免费网页搜索：文本/新闻/图片/视频，无需 API Key |
| `domain` | 被动域名侦察：子域名、SSL证书、WHOIS、DNS记录 |
| `note-taking` | 笔记工具 |
| `obsidian` | Obsidian 笔记库：读、搜、创建笔记 |
| `reading-media-project` | 「从容书房」读书自媒体项目会话记录 |
| `jacky-material-handler` | Jacky 参考材料处理流程：读→分类→存档→告知 |
| `blogwatcher` | 博客 RSS 监控（见上） |
| `arxiv` | 论文搜索（见上） |
| `polymarket` | 预测市场（见上） |

### 🏋️ 健康与生活

| Skill | 用途 |
|-------|------|
| `fitness-nutrition` | 健身计划+营养追踪：690+运动（wger）、38万+食物（USDA）、体测计算 |
| `leisure` | 休闲工具 |
| `find-nearby` | 附近地点搜索：餐厅、咖啡馆、药店（OpenStreetMap，无需 Key） |
| `gaming` | 游戏相关 |
| `minecraft-modpack-server` | Minecraft mod 服务器搭建：NeoForge、Java 版本、防火墙 |
| `pokemon-player` | 宝可梦自动游戏：模拟器、RAM 读取、策略决策 |

---

## 任务→技能 对照表

| 任务类型 | 使用 Skill |
|---------|-----------|
| 写代码 / 重构 / PR审查 | `claude-code` / `codex` / `opencode` |
| 管理 GitHub 仓库/PR/Issue | `github-pr-workflow` / `github-issues` / `github-code-review` |
| 系统调试（Hermes本身） | `hermes-debugging` / `systematic-debugging` |
| 安装新Skill + 推GitHub | `hermes-skills-install-push` |
| 审计现有Skills | `skills-audit` |
| Docker 容器管理 | `docker-management` |
| LLM 微调（LoRA/DPO/GRPO） | `peft-fine-tuning` / `unsloth` / `axolotl` / `grpo-rl-training` |
| LLM 推理服务部署 | `serving-llms-vllm` / `llama-cpp` |
| LLM 学术评测 | `evaluating-llms-harness` |
| 本地知识库搜索 | `qmd` |
| 网页搜索（无需Key） | `duckduckgo-search` |
| 域名情报 | `domain` |
| 论文搜索 | `arxiv` |
| 邮件管理 | `email`（himalaya） |
| 智能家居控制 | `openhue` |
| iMessage / 苹果生态 | `apple` 系列 |
| 宝可梦自动游戏 | `pokemon-player` |
| Minecraft 服务器 | `minecraft-modpack-server` |
| 视频字幕提取 | `youtube-content` |
| 频谱/音频分析 | `songsee` |
| ASCII 艺术/视频 | `ascii-art` / `ascii-video` |
| 数学动画视频 | `manim-video` |
| 推送通知 / Webhook | `webhook-subscriptions` |
| 预测市场数据 | `polymarket` |
| 博客 RSS 监控 | `blogwatcher` |
| W&B 实验追踪 | `weights-and-biases` |

---

## 重要原则

1. **遇到任何bug** → 先用 `systematic-debugging`，不准在没理解问题前修
2. **多步骤任务** → 先用 `writing-plans` 或 `plan`，不要直接动手
3. **代码改动后** → 用 `requesting-code-review` 过安全+质量门禁再提交
4. **GitHub 操作** → 优先用 `github-pr-workflow` 规范流程
5. **不确定用什么Skill** → 先 `skills-audit` 了解现状，再决定
6. **Hermes 本身问题** → 用 `hermes-debugging`，不要乱动 `.pyc`
7. **OpenClaw 是独立系统** → 永远不要跨到 OpenClaw 的目录或配置

---

## 调用约定

- Skill名称用 `backtick` 包裹，如 `github-pr-workflow`
- 多个Skill配合时，按顺序执行，并在每个Skill开始时说明用途
- Skill加载：`skill_view(name)` 查看完整内容，`skills_list()` 查看所有可用Skill

---

*最后更新：2026-04-16 | 映射 89 个Skills*
