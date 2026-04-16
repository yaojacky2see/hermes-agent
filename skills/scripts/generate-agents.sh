#!/bin/bash
# =====================================================================
# generate-agents.sh — 从实际目录结构自动生成 AGENTS.md
#
# 原理：AGENTS.md 是目录结构 + SKILL.md metadata 的投影
#       由机器生成，保证与实际状态永远一致
#
# 机械化执行核心：lint 规则 -> 自动生成 -> 验证闭环
# =====================================================================
set -euo pipefail

SKILLS_DIR="$HOME/.hermes/hermes-agent/skills"
cd "$SKILLS_DIR"

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
BOLD='\033[1m'; RESET='\033[0m'
pass() { echo -e "${GREEN}[GEN]${RESET}  $1"; }

# ── 从 SKILL.md 提取真实描述（跳过 YAML frontmatter）─────────────
get_description() {
  local skill_md="$1"
  if [[ ! -f "$skill_md" ]]; then
    echo ""
    return
  fi

  # 检查是否有 YAML frontmatter
  if grep -q '^---$' "$skill_md" 2>/dev/null; then
    # 取 --- 之后、第一个 # 之前的实际描述文字
    # 通常 description: 字段在 frontmatter 里
    local desc=$(awk '/^---$/,/^---$/ {next} /^description:/ {sub(/^description:[[:space:]]*/, ""); print; exit}' "$skill_md")
    if [[ -n "$desc" ]]; then
      echo "$desc"
      return
    fi
  fi

  # 回退：取第一个非标题、非空、非 > 的行
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
    github)          echo "🐙 GitHub" ;;
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

# ── 生成根 AGENTS.md ─────────────────────────────────────────
generate_root_agents() {
  local out="AGENTS.md"

  {
    echo "# Hermes Agent Skills — 智能体地图"
    echo ""
    echo "> 本文件由 \`generate-agents.sh\` 自动生成 — 禁止手工编辑"
    echo "> **核心原则：仓库即记录系统。不在仓库里的约束，对智能体不存在。**"
    echo ""
    echo "---"
    echo ""
    echo "## 技能速查"
    echo ""

    # 遍历一级分类目录
    for cat_dir in */; do
      [[ -d "$cat_dir" && ! "$cat_dir" =~ ^(scripts|AGENTS\.md)/ ]] || continue
      [[ -f "${cat_dir}SKILL.md" || -d "${cat_dir}" ]] || continue

      cat_name="${cat_dir%/}"
      cat_label=$(get_category "$cat_name")

      if [[ -f "${cat_dir}AGENTS.md" ]]; then
        # 有子 AGENTS.md 的分类：显示引用链接
        echo "### $cat_label"
        echo ""
        echo "| Skill | 用途 |"
        echo "|-------|------|"
        # 从子 AGENTS.md 提取 skill 行
        awk '/^\| \`/ {print}' "${cat_dir}AGENTS.md" 2>/dev/null || true
        echo ""
        echo "> 详情：[${cat_name}/AGENTS.md](${cat_name}/AGENTS.md)"
        echo ""
      elif [[ "$cat_name" == "apple" ]]; then
        # apple 有嵌套子 skill
        echo "### $cat_label"
        echo ""
        echo "| Skill | 用途 |"
        echo "|-------|------|"
        for skill_dir in "${cat_dir}"*/; do
          [[ -d "$skill_dir" ]] || continue
          skill_name=$(basename "$skill_dir")
          [[ -f "${skill_dir}SKILL.md" ]] || continue
          desc=$(get_description "${skill_dir}SKILL.md")
          echo "| \`${skill_name}\` | ${desc:-—} |"
        done
        echo ""
      else
        # 单层分类
        echo "### $cat_label"
        echo ""
        echo "| Skill | 用途 |"
        echo "|-------|------|"
        for skill_dir in "${cat_dir}"*/; do
          [[ -d "$skill_dir" ]] || continue
          skill_name=$(basename "$skill_dir")
          [[ -f "${skill_dir}SKILL.md" ]] || continue
          desc=$(get_description "${skill_dir}SKILL.md")
          echo "| \`${skill_name}\` | ${desc:-—} |"
        done
        echo ""
      fi
    done

    echo "---"
    echo ""
    echo "*最后生成：$(date '+%Y-%m-%d %H:%M:%S')*"

  } > "$out"

  pass "生成 $out"
}

# ── 生成子目录 AGENTS.md（mlops 需要递归处理多级）─────────────────
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

      # mlops 有多级子目录（training/models/inference/cloud/evaluation/vector-databases）
      if [[ "$sub" == "mlops" ]]; then
        for sub2_dir in "$sub"/*/; do
          [[ -d "$sub2_dir" ]] || continue
          sub2_name=$(basename "$sub2_dir")
          if [[ -f "${sub2_dir}SKILL.md" ]]; then
            # 直接 skill
            desc=$(get_description "${sub2_dir}SKILL.md")
            echo "| $(echo "$desc" | cut -c1-50)… | \`${sub2_name}\` |"
            ((skill_count++)) || true
          else
            # 二级子目录
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
        # 标准子目录（creative/github/media/research）
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

      # mlops 多级详情
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
        # 标准详情
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
