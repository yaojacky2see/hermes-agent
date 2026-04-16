#!/bin/bash
# =====================================================================
# Hermes Skills Linter — 机械化执行 + 熵管理
#
# 检查项：
#   1. 每个技能目录必须有 SKILL.md
#   2. 子 AGENTS.md 必须与父 AGENTS.md 交叉链接
#   3. AGENTS.md 引用的 skill 名称必须存在于实际目录
# =====================================================================
set -euo pipefail

SKILLS_DIR="$HOME/.hermes/hermes-agent/skills"
cd "$SKILLS_DIR"

ERRORS=0
WARNINGS=0

# ── 颜色输出 ──────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $1"; }
pass()    { echo -e "${GREEN}[PASS]${RESET}  $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $1"; WARNINGS=$((WARNINGS+1)); }
fail()    { echo -e "${RED}[FAIL]${RESET}  $1";  ERRORS=$((ERRORS+1)); }
header()  { echo -e "\n${BOLD}━━━ $1 ━━━${RESET}"; }

# ── 规则1：每个技能目录（深度2-3）必须有 SKILL.md ─────────────────
header "规则1：每个技能目录必须有 SKILL.md"

# 收集所有技能目录（跳过 AGENTS.md 和 scripts）
skill_dirs=$(find . -mindepth 2 -maxdepth 3 -type d ! -name 'scripts' 2>/dev/null | sort)
missing_skills=0
total_dirs=0

for dir in $skill_dirs; do
  total_dirs=$((total_dirs+1))
  if [[ ! -f "$dir/SKILL.md" ]]; then
    fail "缺少 SKILL.md: $dir"
    missing_skills=$((missing_skills+1))
  fi
done

if [[ $missing_skills -eq 0 && $total_dirs -gt 0 ]]; then
  pass "所有 ${total_dirs} 个技能目录都有 SKILL.md"
elif [[ $total_dirs -eq 0 ]]; then
  warn "未找到任何技能目录"
fi

# ── 规则2：子 AGENTS.md 必须与父 AGENTS.md 交叉链接 ──────────────
header "规则2：子 AGENTS.md 与父 AGENTS.md 交叉链接"

agents_files=$(find . -name "AGENTS.md" ! -path "./AGENTS.md" 2>/dev/null | sort)
if [[ -z "$agents_files" ]]; then
  warn "未找到子 AGENTS.md"
else
  for agents_file in $agents_files; do
    # 检查是否引用了父级
    if grep -q "AGENTS.md" "$agents_file" 2>/dev/null; then
      pass "$agents_file 引用了父级"
    else
      fail "子 AGENTS.md 未引用父级: $agents_file"
    fi
  done
fi

# ── 规则3：AGENTS.md 中引用的 skill 必须存在 ─────────────────────
header "规则3：AGENTS.md 引用的 skill 必须存在"

total_ref_errors=0
for agents_file in $(find . -name "AGENTS.md" 2>/dev/null | sort); do
  ref_errors=0
  
  # 提取 skill 引用（格式: `skill-name` 或 `skill-name/SKILL.md`）
  refs=$(grep -oE '`[a-z0-9-]+(/[a-z0-9-]+)?(/SKILL\.md)?`' "$agents_file" 2>/dev/null \
         | tr -d '`' | sed 's|/SKILL\.md$||' | sort -u)
  
  for ref in $refs; do
    # 跳过外部链接和特殊引用
    case "$ref" in
      http*|https*|~/|\.\.) continue ;;
    esac
    
    # 构造可能路径：相对于根目录
    root_target="$SKILLS_DIR/$ref"
    
    if [[ ! -d "$root_target" && ! -f "$root_target/SKILL.md" ]]; then
      fail "AGENTS.md 引用不存在的 skill: $ref (在 $agents_file)"
      ref_errors=$((ref_errors+1))
    fi
  done
  
  if [[ $ref_errors -eq 0 ]]; then
    # 只报告有引用的文件
    if echo "$refs" | grep -q '[a-z0-9]'; then
      pass "$agents_file 中的引用全部有效"
    fi
  fi
  total_ref_errors=$((total_ref_errors+ref_errors))
done

# ── 额外检查：SKILL.md 中是否有不应该出现的硬编码路径 ─────────────
header "额外检查：SKILL.md 路径引用检查"

hardcoded_paths=$(find . -mindepth 2 -maxdepth 3 -name "SKILL.md" \
  -exec grep -l '~/Projects/\|/Users/[^/]*/' {} \; 2>/dev/null)
if [[ -n "$hardcoded_paths" ]]; then
  for f in $hardcoded_paths; do
    warn "SKILL.md 包含硬编码路径: $f"
  done
else
  pass "未发现硬编码个人路径"
fi

# ── 汇总 ─────────────────────────────────────────────────────
header "汇总"
echo -e "  ${BOLD}ERRORS:${RESET}   $ERRORS"
echo -e "  ${BOLD}WARNINGS:${RESET} $WARNINGS"
echo -e "  ${BOLD}总计:${RESET}     $((ERRORS + WARNINGS)) 项问题"

if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
  echo -e "\n${GREEN}${BOLD}✓ 所有检查通过 — skills 目录处于最佳状态${RESET}"
  exit 0
elif [[ $ERRORS -eq 0 ]]; then
  echo -e "\n${YELLOW}有警告，建议修复${RESET}"
  exit 0
else
  echo -e "\n${RED}有错误需要修复${RESET}"
  exit 1
fi
