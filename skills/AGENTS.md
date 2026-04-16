# Hermes Agent Skills — 智能体地图

> 本文件由 `generate-agents.sh` 自动生成 — 禁止手工编辑
> **核心原则：仓库即记录系统。不在仓库里的约束，对智能体不存在。**

---

## 技能速查

### 🍎 Apple 系统

| Skill | 用途 |
|-------|------|
| `apple-notes` | Manage Apple Notes via the memo CLI on macOS (create, view, search, edit). |
| `apple-reminders` | Manage Apple Reminders via remindctl CLI (list, add, complete, delete). |
| `findmy` | Track Apple devices and AirTags via FindMy.app on macOS using AppleScript and screen capture. |
| `imessage` | Send and receive iMessages/SMS via the imsg CLI on macOS. |

### 🤖 AI Agent 调度

| Skill | 用途 |
|-------|------|
| `claude-code` | Delegate coding tasks to Claude Code (Anthropic's CLI agent). Use for building features, refactoring, PR reviews, and iterative coding. Requires the claude CLI installed. |
| `codex` | Delegate coding tasks to OpenAI Codex CLI agent. Use for building features, refactoring, PR reviews, and batch issue fixing. Requires the codex CLI and a git repository. |
| `hermes-agent` | Complete guide to using and extending Hermes Agent — CLI usage, setup, configuration, spawning additional agents, gateway platforms, skills, voice, tools, profiles, and a concise contributor reference. Load this skill when helping users configure Hermes, troubleshoot issues, spawn agent instances, or make code contributions. |
| `opencode` | Delegate coding tasks to OpenCode CLI agent for feature implementation, refactoring, PR review, and long-running autonomous sessions. Requires the opencode CLI installed and authenticated. |

### 🎨 创意工具

| Skill | 用途 |
|-------|------|

> 详情：[creative/AGENTS.md](creative/AGENTS.md)

### 📊 数据科学

| Skill | 用途 |
|-------|------|
| `jupyter-live-kernel` | > |

### 🔧 DevOps

| Skill | 用途 |
|-------|------|
| `webhook-subscriptions` | Create and manage webhook subscriptions for event-driven agent activation. Use when the user wants external services to trigger agent runs automatically. |

### 📦 工具

| Skill | 用途 |
|-------|------|

### 🐳 Docker

| Skill | 用途 |
|-------|------|

### 🐕 Dogfood

| Skill | 用途 |
|-------|------|

### 🌐 域名/网站

| Skill | 用途 |
|-------|------|

### 📦 工具

| Skill | 用途 |
|-------|------|

### 📧 邮件

| Skill | 用途 |
|-------|------|
| `himalaya` | CLI to manage emails via IMAP/SMTP. Use himalaya to list, read, write, reply, forward, search, and organize emails from the terminal. Supports multiple accounts and message composition with MML (MIME Meta Language). |

### 📡 信息源

| Skill | 用途 |
|-------|------|

### 💪 健身/营养

| Skill | 用途 |
|-------|------|

### 🎮 游戏

| Skill | 用途 |
|-------|------|
| `minecraft-modpack-server` | Set up a modded Minecraft server from a CurseForge/Modrinth server pack zip. Covers NeoForge/Forge install, Java version, JVM tuning, firewall, LAN config, backups, and launch scripts. |
| `pokemon-player` | Play Pokemon games autonomously via headless emulation. Starts a game server, reads structured game state from RAM, makes strategic decisions, and sends button inputs — all from the terminal. |

### 🎬 GIF

| Skill | 用途 |
|-------|------|

### 🐙 GitHub

| Skill | 用途 |
|-------|------|

> 详情：[github/AGENTS.md](github/AGENTS.md)

### 🗂️ 索引/缓存

| Skill | 用途 |
|-------|------|

### 📦 工具

| Skill | 用途 |
|-------|------|

### 🌿 生活休闲

| Skill | 用途 |
|-------|------|
| `find-nearby` | Find nearby places (restaurants, cafes, bars, pharmacies, etc.) using OpenStreetMap. Works with coordinates, addresses, cities, zip codes, or Telegram location pins. No API keys needed. |

### 🔌 MCP 协议

| Skill | 用途 |
|-------|------|
| `mcporter` | Use the mcporter CLI to list, configure, auth, and call MCP servers/tools directly (HTTP or stdio), including ad-hoc servers, config edits, and CLI/type generation. |
| `native-mcp` | Built-in MCP (Model Context Protocol) client that connects to external MCP servers, discovers their tools, and registers them as native Hermes Agent tools. Supports stdio and HTTP transports with automatic reconnection, security filtering, and zero-config tool injection. |

### 🎞️ 媒体处理

| Skill | 用途 |
|-------|------|

> 详情：[media/AGENTS.md](media/AGENTS.md)

### 🤖 MLOps

| Skill | 用途 |
|-------|------|

> 详情：[mlops/AGENTS.md](mlops/AGENTS.md)

### 📝 笔记

| Skill | 用途 |
|-------|------|
| `obsidian` | Read, search, and create notes in the Obsidian vault. |

### ⚖️ 决策框架

| Skill | 用途 |
|-------|------|

### 📎 生产力

| Skill | 用途 |
|-------|------|
| `google-workspace` | Gmail, Calendar, Drive, Contacts, Sheets, and Docs integration for Hermes. Uses Hermes-managed OAuth2 setup, prefers the Google Workspace CLI (`gws`) when available for broader API coverage, and falls back to the Python client libraries otherwise. |
| `linear` | Manage Linear issues, projects, and teams via the GraphQL API. Create, update, search, and organize issues. Uses API key auth (no OAuth needed). All operations via curl — no dependencies. |
| `nano-pdf` | Edit PDFs with natural-language instructions using the nano-pdf CLI. Modify text, fix typos, update titles, and make content changes to specific pages without manual editing. |
| `notion` | Notion API for creating and managing pages, databases, and blocks via curl. Search, create, update, and query Notion workspaces directly from the terminal. |
| `ocr-and-documents` | Extract text from PDFs and scanned documents. Use web_extract for remote URLs, pymupdf for local text-based PDFs, marker-pdf for OCR/scanned docs. For DOCX use python-docx, for PPTX see the powerpoint skill. |
| `powerpoint` | "Use this skill any time a .pptx file is involved in any way — as input, output, or both. This includes: creating slide decks, pitch decks, or presentations; reading, parsing, or extracting text from any .pptx file (even if the extracted content will be used elsewhere, like in an email or summary); editing, modifying, or updating existing presentations; combining or splitting slide files; working with templates, layouts, speaker notes, or comments. Trigger whenever the user mentions \"deck,\" \"slides,\" \"presentation,\" or references a .pptx filename, regardless of what they plan to do with the content afterward. If a .pptx file needs to be opened, created, or touched, use this skill." |

### 🧠 QMD 知识库

| Skill | 用途 |
|-------|------|

### 🛡️ 红队/越狱

| Skill | 用途 |
|-------|------|
| `godmode` | "Jailbreak API-served LLMs using G0DM0D3 techniques — Parseltongue input obfuscation (33 techniques), GODMODE CLASSIC system prompt templates, ULTRAPLINIAN multi-model racing, encoding escalation, and Hermes-native prefill/system prompt integration. Use when a user wants to bypass safety filters, jailbreak a model, or red-team model robustness." |

### 🔬 研究工具

| Skill | 用途 |
|-------|------|

> 详情：[research/AGENTS.md](research/AGENTS.md)

### 🏠 智能家居

| Skill | 用途 |
|-------|------|
| `openhue` | Control Philips Hue lights, rooms, and scenes via the OpenHue CLI. Turn lights on/off, adjust brightness, color, color temperature, and activate scenes. |

### 📱 社交媒体

| Skill | 用途 |
|-------|------|
| `xitter` | Interact with X/Twitter via the x-cli terminal client using official X API credentials. Use for posting, reading timelines, searching tweets, liking, retweeting, bookmarks, mentions, and user lookups. |

### 💻 软件开发

| Skill | 用途 |
|-------|------|
| `plan` | Plan mode for Hermes — inspect context, write a markdown plan into the active workspace's `.hermes/plans/` directory, and do not execute the work. |
| `requesting-code-review` | > |
| `subagent-driven-development` | Use when executing implementation plans with independent tasks. Dispatches fresh delegate_task per task with two-stage review (spec compliance then code quality). |
| `systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior. 4-phase root cause investigation — NO fixes without understanding the problem first. |
| `test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code. Enforces RED-GREEN-REFACTOR cycle with test-first approach. |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task. Creates comprehensive implementation plans with bite-sized tasks, exact file paths, and complete code examples. |

---

*最后生成：2026-04-16 10:10:33*
