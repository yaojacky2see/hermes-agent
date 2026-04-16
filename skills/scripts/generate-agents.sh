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

# ── 从 SKILL.md 提取真实描述（跳过 YAML frontmatter）─────────────
get_description() {
  local skill_md="$1"
  if [[ ! -f "$skill_md" ]]; then
    echo ""
    return
  fi

  if grep -q '^---$' "$skill_md" 2>/dev/null; then
    local desc=$(awk '/^---$/,/^---$/ {next} /^description:/ {sub(/^description:[[:space:]]*/, ""); print; exit}' "$skill_md")
    if [[ -n "$desc" ]]; then
      echo "$desc"
      return
    fi
  fi

  sed -n '1,/^[#>]/p' "$skill_md" 2>/dev/null \
    | grep -v '^#' | grep -v '^>' | grep -v '^$' | grep -v '^---$' \
    | head -1 \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/^"//; s/"$//'
}

# ── 分类标签 ─────────────────────────────────────────────────
get_category() {
  case "$1" in
    apple)          echo "🍎 Apple 系统" ;;
    creative)       echo "🎨 创意工具" ;;
    data-science)   echo "📊 数据科学" ;;
    devops)         echo "🔧 DevOps" ;;
    docker*)        echo "🐳 Docker" ;;
    dogfood)        echo "🐕 Dogfood" ;;
    domain)         echo "🌐 域名/网站" ;;
    email)          echo "📧 邮件" ;;
    feeds)          echo "📡 信息源" ;;
    fitness*)       echo "💪 健身/营养" ;;
    gaming)         echo "🎮 游戏" ;;
    gifs)           echo "🎬 GIF" ;;
    github)         echo "🐙 GitHub" ;;
    index-cache)    echo "🗂️ 索引/缓存" ;;
    leisure)        echo "🌿 生活休闲" ;;
    mcp)            echo "🔌 MCP 协议" ;;
    media)          echo "🎞️ 媒体处理" ;;
    mlops)          echo "🤖 MLOps" ;;
    note-taking)    echo "📝 笔记" ;;
    one-three-one*) echo "⚖️ 决策框架" ;;
    productivity)   echo "📎 生产力" ;;
    qmd)            echo "🧠 QMD 知识库" ;;
    red-teaming)    echo "🛡️ 红队/越狱" ;;
    research)       echo "🔬 研究工具" ;;
    smart-home)     echo "🏠 智能家居" ;;
    social-media)   echo "📱 社交媒体" ;;
    software-dev*)  echo "💻 软件开发" ;;
    testing)        echo "🧪 测试" ;;
    autonomous*)    echo "🤖 AI Agent 调度" ;;
    *)              echo "📦 工具" ;;
  esac
}

# ── 生成根 AGENTS.md（≤60行紧凑路由表）─────────────────────────────
# HumanLayer规则：AGENTS.md >60行效果下降
# 约束越严，自主性越强
generate_root_agents() {
  local out="AGENTS.md"

  {
    echo "# Hermes Agent Skills — 智能体地图"
    echo ""
    echo "> 本文件由 \`generate-agents.sh\` 自动生成。完整详情在子目录 AGENTS.md。"
    echo "> **核心原则：仓库即记录系统。**"
    echo ""
    echo "---"
    echo ""
    echo "## 路由表（按任务类型）"
    echo ""
    echo "| 任务 | Skill | 入口 |"
    echo "|------|-------|------|"
    echo "| GitHub/PR/Issues | \`github-pr-workflow\` \`github-code-review\` \`github-issues\` | github/ |"
    echo "| MLOps全流程 | 微调/推理/评估/云GPU | mlops/ |"
    echo "| 创意媒体 | ascii/art/video, excalidraw, youtube, gif | creative/ |"
    echo "| 预测市场/研究 | \`polymarket\` \`arxiv\` \`llm-wiki\` | research/ |"
    echo "| macOS系统 | \`apple-notes\` \`apple-reminders\` \`findmy\` \`imessage\` | apple/ |"
    echo "| 代码开发 | \`plan\` \`systematic-debugging\` \`test-driven-development\` \`subagent-driven\` | software-dev/ |"
    echo "| Agent调度 | \`claude-code\` \`codex\` \`opencode\` | autonomous/ |"
    echo "| 效率工具 | \`notion\` \`linear\` \`powerpoint\` \`ocr-pdf\` \`google-workspace\` | productivity/ |"
    echo "| Webhook/自动化 | \`webhook-subscriptions\` | devops/ |"
    echo "| Docker | \`docker-management\` | docker/ |"
    echo "| 个人数据 | \`openhue\` \`himalaya\` \`obsidian\` | — |"
    echo "| 健身/游戏 | \`fitness-nutrition\` \`minecraft\` \`pokemon\` | — |"
    echo "| 社交媒体 | \`xitter\` | social-media/ |"
    echo ""
    echo "---"
    echo ""
    echo "## 子地图索引"
    echo ""
    echo "| 目录 | 内容 |"
    echo "|------|------|"
    echo "| \`apple/\` | macOS Notes/Reminders/FindMy/iMessage (4 skills) |"
    echo "| \`github/\` | PR/Issues/CodeReview/Repo全流程 (6 skills) |"
    echo "| \`mlops/\` | 训练/推理/评估/云端GPU (22 skills) |"
    echo "| \`research/\` | 论文/博客监控/预测市场 (5 skills) |"
    echo "| \`creative/\` | 媒体生成/可视化/视频 (9 skills) |"
    echo "| \`productivity/\` | Notion/Linear/PowerPoint/PDF (7 skills) |"
    echo ""
    echo "> 加载 Skill：\`skill_view(name=\"skill-name\")\`"
    echo ""
    echo "*最后生成：$(date '+%Y-%m-%d %H:%M:%S')*"

  } > "$out"

  # 验证行数约束
  local lines=$(wc -l < "$out")
  if [[ $lines -gt 60 ]]; then
    warn "$out 为 ${lines}行（>60行限制）"
  else
    pass "生成 $out (${lines}行 ≤60行)"
  fi
}

# ── 生成子目录 AGENTS.md（mlops 多级 + 其余标准）──────────────────
generate_sub_agents() {
  local sub_dirs="creative github media mlops research"

  for sub in $sub_dirs; do
    [[ -d "$sub" ]] || continue
    local out="$sub/AGENTS.md"

    {
      echo "# $(echo "$sub" | tr 'a-z' 'A-Z') — $(get_category "$sub")"
      echo ""
      echo "> 入口：[skills/AGENTS.md](../AGENTS.md)"
      echo "> 本文件由 \`generate-agents.sh\` 自动生成"
      echo ""
      echo "---"
      echo ""
      echo "## 快速路由"
      echo ""
      echo "| 任务 | 使用 Skill |"
      echo "|------|-----------|"

      skill_count=0

      if [[ "$sub" == "mlops" ]]; then
        for sub2_dir in "$sub"/*/; do
          [[ -d "$sub2_dir" ]] || continue
          sub2_name=$(basename "$sub2_dir")
          if [[ -f "${sub2_dir}SKILL.md" ]]; then
            desc=$(get_description "${sub2_dir}SKILL.md")
            echo "| $(echo "$desc" | cut -c1-50)… | \`${sub2_name}\` |"
            ((skill_count++)) || true
          else
            echo "| **${sub2_name}/** |"
            for skill_dir in "${sub2_dir}"*/; do
              [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
              skill_name=$(basename "$skill_dir")
              desc=$(get_description "${skill_dir}SKILL.md")
              echo "|   → $(echo "$desc" | cut -c1-40)… | \`${sub2_name}/${skill_name}\` |"
              ((skill_count++)) || true
            done
          fi
        done
      else
        for skill_dir in "$sub"/*/; do
          [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
          skill_name=$(basename "$skill_dir")
          desc=$(get_description "${skill_dir}SKILL.md")
          echo "| $(echo "$desc" | cut -c1-40)… | \`${skill_name}\` |"
          ((skill_count++)) || true
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

    pass "生成 $out ($skill_count 个 skill)"
  done
}

# ── 主流程 ──────────────────────────────────────────────────
echo -e "${BOLD}━━━ Hermes Skills AGENTS.md 生成器 ━━━${RESET}"
generate_root_agents
generate_sub_agents
echo ""
pass "完成 — 所有 AGENTS.md 已从实际目录结构同步"
