# Hermes Agent Skills — 智能体地图

> 本文件由 `generate-agents.sh` 自动生成。完整详情在子目录 AGENTS.md。
> **核心原则：仓库即记录系统。**

---

## 路由表（按任务类型）

| 任务 | Skill | 入口 |
|------|-------|------|
| GitHub/PR/Issues | `github-pr-workflow` `github-code-review` `github-issues` | github/ |
| MLOps全流程 | 微调/推理/评估/云GPU | mlops/ |
| 创意媒体 | ascii/art/video, excalidraw, youtube, gif | creative/ |
| 预测市场/研究 | `polymarket` `arxiv` `llm-wiki` | research/ |
| macOS系统 | `apple-notes` `apple-reminders` `findmy` `imessage` | apple/ |
| 代码开发 | `plan` `systematic-debugging` `test-driven-development` `subagent-driven` | software-dev/ |
| Agent调度 | `claude-code` `codex` `opencode` | autonomous/ |
| 效率工具 | `notion` `linear` `powerpoint` `ocr-pdf` `google-workspace` | productivity/ |
| Webhook/自动化 | `webhook-subscriptions` | devops/ |
| Docker | `docker-management` | docker/ |
| 个人数据 | `openhue` `himalaya` `obsidian` | — |
| 健身/游戏 | `fitness-nutrition` `minecraft` `pokemon` | — |
| 社交媒体 | `xitter` | social-media/ |

---

## 子地图索引

| 目录 | 内容 |
|------|------|
| `apple/` | macOS Notes/Reminders/FindMy/iMessage (4 skills) |
| `github/` | PR/Issues/CodeReview/Repo全流程 (6 skills) |
| `mlops/` | 训练/推理/评估/云端GPU (22 skills) |
| `research/` | 论文/博客监控/预测市场 (5 skills) |
| `creative/` | 媒体生成/可视化/视频 (9 skills) |
| `productivity/` | Notion/Linear/PowerPoint/PDF (7 skills) |

> 加载 Skill：`skill_view(name="skill-name")`

*最后生成：2026-04-16 10:15:16*
