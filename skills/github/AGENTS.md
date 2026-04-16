# GitHub 操作 — 智能体地图

> 入口：`skills/AGENTS.md`
> 本目录包含 GitHub 全套操作的子地图。渐进式披露，按任务类型分流。

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| 认证 GitHub（SSH / HTTPS / gh CLI） | `github-auth` |
| 创建 PR → 合并的完整流程 | `github-pr-workflow` |
| 在 PR 上做代码审查 + 内联评论 | `github-code-review` |
| 创建 / 管理 / 搜索 Issue | `github-issues` |
| 克隆 / Fork / 配置仓库 | `github-repo-management` |
| 统计代码行数 / 语言分布 | `codebase-inspection` |

---

## Skill 详情

### `github-auth` — 认证
- **用途：** 设置 GitHub 认证（SSH key、HTTPS token、gh CLI）
- **适用场景：** 首次推送失败、token 失效、需要切换认证方式
- **自动检测流程：** 自动选择最优认证方式

### `github-pr-workflow` — PR 完整生命周期
- **用途：** 分支 → 提交 → PR → CI 监控 → 自动修复 → 合并
- **适用场景：** 任何需要提交代码的工作
- **核心原则：** 不要直接 push main，永远走 PR

### `github-code-review` — 代码审查
- **用途：** 分析 diff，在 PR 上留内联评论
- **适用场景：** 审查他人代码、验证自己改动
- **两种模式：** gh CLI（已登录）+ git+REST API（未登录）

### `github-issues` — Issue 管理
- **用途：** 创建、更新、搜索 Issue，添加标签、关联 PR
- **适用场景：** 记录问题、管理任务、追踪进度

### `github-repo-management` — 仓库管理
- **用途：** 克隆、创建、Fork、配置 remote、Secrets、Releases
- **适用场景：** 新项目初始化、仓库配置修改

### `codebase-inspection` — 代码统计
- **用途：** LOC 计数、语言组成、代码 vs 注释比例
- **适用场景：** 了解项目规模、评估开发成本

---

## 重要约定

1. **永远不要直接 push 到 main/main branch** — 用 PR 流程
2. **推送失败时**，先检查 `github-auth` 是否正常
3. **需要创建多个分支**时，用 `github-pr-workflow` 统一管理
4. **合并前**必须确认 CI 通过（如果配置了的话）

---

*本目录是 `skills/AGENTS.md` 的子地图，渐进式披露。*
