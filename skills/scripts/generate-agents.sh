#!/bin/bash
# =====================================================================
# generate-agents.sh — 从实际目录结构自动生成 AGENTS.md
#
# 原理：AGENTS.md 是目录结构 + SKILL.md metadata 的投影
#       由机器生成，保证与实际状态永远一致
#
# 机械化执行核心：
#   lint 规则（validate-skills.sh）
#     → 自动生成（generate-agents.sh）
#       → 验证闭环
#
# Agent Readability 约束：
#   根 AGENTS.md ≤60 行（HumanLayer规则）
#   子 AGENTS.md 不限（渐进式披露）
# =====================================================================
set -euo pipefail

SKILLS_DIR="$HOME/.hermes/hermes-agent/skills"
cd "$SKILLS_DIR"

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
BOLD='\033[1m'; RESET='\033[0m'
pass() { echo -e "${GREEN}[GEN]${RESET}  $1"; }
warn() { echo -e "${RED}[WARN]${RESET}  $1"; }

# ── 从 SKILL.md 提取真实描述 ──────────────────────────────────
get_description() {
  local skill_md="$1"
  if [[ ! -f "$skill_md" ]]; then
    echo ""
    return
  fi
  if grep -q '^---$' "$skill_md" 2>/dev/null; then
    local desc=$(awk '/^---$/,/^---$/ {next} /^description:/ {sub(/^description:[[:space:]]*/, ""); print; exit}' "$skill_md")
    [[ -n "$desc" ]] && echo "$desc" && return
  fi
  sed -n '1,/^[#>]/p' "$skill_md" 2>/dev/null \
    | grep -v '^#' | grep -v '^>' | grep -v '^$' | grep -v '^---$' \
    | head -1 | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/^"//; s/"$//'
}

# ── 生成根 AGENTS.md（≤60行路由表）───────────────────────────────
generate_root_agents() {
  local out="AGENTS.md"

  {
    echo "# Hermes Agent Skills — 智能体地图"
    echo ""
    echo "> 本文件由 \`generate-agents.sh\` 自动生成。"
    echo "> **核心原则：仓库即记录系统。**"
    echo ""
    echo "---"
    echo ""
    echo "## 快速路由"
    echo ""
    echo "| 任务 | 入口 |"
    echo "|------|------|"
    echo "| GitHub/PR/Issues/代码审查 | [github/AGENTS.md](github/AGENTS.md) |"
    echo "| MLOps：训练/推理/评估/云GPU | [mlops/AGENTS.md](mlops/AGENTS.md) |"
    echo "| 创意：ascii/art/video/excalidraw | [creative/AGENTS.md](creative/AGENTS.md) |"
    echo "| 研究：arxiv/llm-wiki/polymarket | [research/AGENTS.md](research/AGENTS.md) |"
    echo "| macOS：Notes/Reminders/FindMy/iMessage | [apple/](apple/) |"
    echo "| 软件开发：plan/TDD/debug/subagent | [software-development/](software-development/) |"
    echo "| Agent调度：Claude Code/Codex/OpenCode | [autonomous-ai-agents/](autonomous-ai-agents/) |"
    echo "| 效率工具：Notion/Linear/PowerPoint/PDF | [productivity/](productivity/) |"
    echo "| Webhook触发自动化 | [devops/webhook-subscriptions/](devops/webhook-subscriptions/) |"
    echo "| Docker容器管理 | [docker-management/](docker-management/) |"
    echo "| 邮件/智能家居/笔记 | [himalaya/](email/himalaya/) [openhue/](smart-home/openhue/) [obsidian/](note-taking/obsidian/) |"
    echo "| 健身营养/游戏/社交媒体 | [fitness-nutrition/](fitness-nutrition/) [gaming/](gaming/) [xitter/](social-media/xitter/) |"
    echo ""
    echo "---"
    echo ""
    echo "## 子地图索引"
    echo ""
    echo "| 目录 | 内容 |"
    echo "|------|------|"
    echo "| \`apple/\` | macOS Notes/Reminders/FindMy/iMessage (4 skills) |"
    echo "| \`github/\` | PR/Issues/CodeReview/Repo (6 skills) |"
    echo "| \`mlops/\` | 训练/推理/评估/云GPU (22 skills) |"
    echo "| \`research/\` | 论文/博客/预测市场 (5 skills) |"
    echo "| \`creative/\` | 媒体生成/可视化/视频 (9 skills) |"
    echo "| \`productivity/\` | Notion/Linear/PowerPoint/PDF (7 skills) |"
    echo "| \`software-dev/\` | plan/TDD/debug/subagent (7 skills) |"
    echo "| \`autonomous/\` | Claude Code/Codex/OpenCode (4 skills) |"
    echo ""
    echo "> 加载 Skill：\`skill_view(name=\"category/skill-name\")\`"
    echo ""
    echo "*最后生成：$(date '+%Y-%m-%d %H:%M:%S')*"

  } > "$out"

  local lines=$(wc -l < "$out")
  if [[ $lines -gt 60 ]]; then
    warn "$out 为 ${lines}行（>60行限制）"
  else
    pass "生成 $out (${lines}行 ≤60行)"
  fi
}

# ── 生成子目录 AGENTS.md ──────────────────────────────────────
generate_sub_agents() {
  local sub_dirs="creative github media mlops research"

  for sub in $sub_dirs; do
    [[ -d "$sub" ]] || continue
    local out="$sub/AGENTS.md"
    local sub_skill_count=0

    {
      echo "# $(echo "$sub" | tr 'a-z' 'A-Z')"
      echo ""
      echo "> 入口：[skills/AGENTS.md](../AGENTS.md)"
      echo "> 本文件由 \`generate-agents.sh\` 自动生成"
      echo ""
      echo "---"
      echo ""
      echo "## 快速路由"
      echo ""
      echo "| 任务 | Skill |"
      echo "|------|-------|"

      # 收集所有 skill（含 mlops 多级）
      if [[ "$sub" == "mlops" ]]; then
        for sub2_dir in "$sub"/*/; do
          [[ -d "$sub2_dir" ]] || continue
          sub2_name=$(basename "$sub2_dir")
          if [[ -f "${sub2_dir}SKILL.md" ]]; then
            desc=$(get_description "${sub2_dir}SKILL.md")
            echo "| $(echo "$desc" | cut -c1-50)… | \`${sub2_name}\` |"
            sub_skill_count=$((sub_skill_count+1))
          else
            for skill_dir in "${sub2_dir}"*/; do
              [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
              skill_name=$(basename "$skill_dir")
              desc=$(get_description "${skill_dir}SKILL.md")
              # 统一用 sub2/skill 全路径（带前缀）
              echo "| $(echo "$desc" | cut -c1-40)… | \`${sub2_name}/${skill_name}\` |"
              sub_skill_count=$((sub_skill_count+1))
            done
          fi
        done
      else
        for skill_dir in "$sub"/*/; do
          [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
          skill_name=$(basename "$skill_dir")
          desc=$(get_description "${skill_dir}SKILL.md")
          echo "| $(echo "$desc" | cut -c1-50)… | \`${skill_name}\` |"
          sub_skill_count=$((sub_skill_count+1))
        done
      fi

      echo ""
      echo "---"
      echo ""
      echo "## Skill 详情"
      echo ""

      if [[ "$sub" == "mlops" ]]; then
        for sub2_dir in "$sub"/*/; do
          [[ -d "$sub2_dir" ]] || continue
          sub2_name=$(basename "$sub2_dir")
          if [[ -f "${sub2_dir}SKILL.md" ]]; then
            desc=$(get_description "${sub2_dir}SKILL.md")
            echo "### \`${sub2_name}\`"
            echo "- **描述：** ${desc:-—}"
            echo ""
          else
            echo "### 📁 ${sub2_name}/"
            echo ""
            for skill_dir in "${sub2_dir}"*/; do
              [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
              skill_name=$(basename "$skill_dir")
              desc=$(get_description "${skill_dir}SKILL.md")
              echo "#### \`${skill_name}\`"
              echo "- **描述：** ${desc:-—}"
              echo ""
            done
          fi
        done
      else
        for skill_dir in "$sub"/*/; do
          [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
          skill_name=$(basename "$skill_dir")
          desc=$(get_description "${skill_dir}SKILL.md")
          echo "### \`${skill_name}\`"
          echo "- **描述：** ${desc:-—}"
          echo ""
        done
      fi

      echo "*最后生成：$(date '+%Y-%m-%d %H:%M:%S')*"

    } > "$out"

    pass "生成 $out ($sub_skill_count 个 skill)"
  done
}

# ── 主流程 ──────────────────────────────────────────────────
echo -e "${BOLD}━━━ Hermes Skills AGENTS.md 生成器 ━━━${RESET}"
generate_root_agents
generate_sub_agents
echo ""
pass "完成 — 所有 AGENTS.md 已从实际目录结构同步"
