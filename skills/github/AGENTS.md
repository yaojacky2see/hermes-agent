# GITHUB — 🐙 GitHub

> 入口：[skills/AGENTS.md](../AGENTS.md)
> 本文件由 `generate-agents.sh` 自动生成

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| Inspect and analyze codebases using pygo… | `codebase-inspection` |
| Set up GitHub authentication for the age… | `github-auth` |
| Review code changes by analyzing git dif… | `github-code-review` |
| Create, manage, triage, and close GitHub… | `github-issues` |
| Full pull request lifecycle — create bra… | `github-pr-workflow` |
| Clone, create, fork, configure, and mana… | `github-repo-management` |

---

## Skill 详情

### `codebase-inspection`
- **描述：** Inspect and analyze codebases using pygount for LOC counting, language breakdown, and code-vs-comment ratios. Use when asked to check lines of code, repo size, language composition, or codebase stats.

### `github-auth`
- **描述：** Set up GitHub authentication for the agent using git (universally available) or the gh CLI. Covers HTTPS tokens, SSH keys, credential helpers, and gh auth — with a detection flow to pick the right method automatically.

### `github-code-review`
- **描述：** Review code changes by analyzing git diffs, leaving inline comments on PRs, and performing thorough pre-push review. Works with gh CLI or falls back to git + GitHub REST API via curl.

### `github-issues`
- **描述：** Create, manage, triage, and close GitHub issues. Search existing issues, add labels, assign people, and link to PRs. Works with gh CLI or falls back to git + GitHub REST API via curl.

### `github-pr-workflow`
- **描述：** Full pull request lifecycle — create branches, commit changes, open PRs, monitor CI status, auto-fix failures, and merge. Works with gh CLI or falls back to git + GitHub REST API via curl.

### `github-repo-management`
- **描述：** Clone, create, fork, configure, and manage GitHub repositories. Manage remotes, secrets, releases, and workflows. Works with gh CLI or falls back to git + GitHub REST API via curl.

*最后生成：2026-04-16 10:10:33*
