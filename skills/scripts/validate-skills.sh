#!/bin/bash
# =====================================================================
# Hermes Skills Linter — 机械化执行 + 熵管理
#
# 背压强度 = PASSES / TOTAL_CHECKS
# 100% = 零熵（最佳状态）
# <80% = 熵积累严重，需要垃圾回收
#
# 检查项：
#   R1. 每个技能目录必须有 SKILL.md（分组目录除外）
#   R2. 子 AGENTS.md 与父 AGENTS.md 交叉链接
#   R3. AGENTS.md 引用的 skill 必须存在于目录
#   R4. 根 AGENTS.md ≤60行（Agent Readability 约束）
#   R5. SKILL.md 无硬编码个人路径
# =====================================================================

SKILLS_DIR="$HOME/.hermes/hermes-agent/skills"
cd "$SKILLS_DIR"

ERRORS=0; PASSES=0; WARNINGS=0; TOTAL_CHECKS=0

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

pass()    { echo -e "${GREEN}[PASS]${RESET}  $1"; PASSES=$((PASSES+1)); TOTAL_CHECKS=$((TOTAL_CHECKS+1)); }
fail()    { echo -e "${RED}[FAIL]${RESET}  $1";  ERRORS=$((ERRORS+1));  TOTAL_CHECKS=$((TOTAL_CHECKS+1)); }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $1"; WARNINGS=$((WARNINGS+1)); }
header()  { echo -e "\n${BOLD}━━━ $1 ━━━${RESET}"; }

# ── R1: 每个技能目录必须有 SKILL.md ─────────────────────────
header "R1: SKILL.md 存在性"

skill_dirs=$(find . -mindepth 2 -maxdepth 3 -type d ! -name 'scripts' 2>/dev/null | sort)
total=0; missing=0

for dir in $skill_dirs; do
  case "$dir" in
    */templates|*/references|*/assets) continue ;;
  esac
  total=$((total+1))

  # 分组目录（mlops/cloud, mlops/training 等）有子 skill 子目录
  # 只要有任何一个子目录（排除 templates/references），就视为分组目录
  has_subs=$(find "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
    | grep -v '/templates$' | grep -v '/references$')
  if [[ -n "$has_subs" && ! -f "$dir/SKILL.md" ]]; then
    total=$((total-1))
    continue
  fi

  if [[ -f "$dir/SKILL.md" ]]; then
    pass "SKILL.md 存在: $dir"
  else
    fail "缺少 SKILL.md: $dir"
    missing=$((missing+1))
  fi
done

[[ $total -gt 0 ]] && [[ $missing -eq 0 ]] && pass "所有 ${total} 个技能目录都有 SKILL.md"

# ── R2: 子 AGENTS.md 交叉链接父 ─────────────────────────────
header "R2: AGENTS.md 交叉链接"

for agents_file in $(find . -name "AGENTS.md" ! -path "./AGENTS.md" 2>/dev/null | sort); do
  if grep -q "AGENTS.md" "$agents_file" 2>/dev/null; then
    pass "$agents_file → 父级链接"
  else
    fail "$agents_file 未引用父级"
  fi
done

# ── R3: AGENTS.md skill 引用有效性 ──────────────────────────
# 关键：引用相对于 AGENTS.md 所在目录解析
header "R3: Skill 引用有效性"

# skill 引用黑名单（文档标记，非真实 skill 路径）
check_ref() {
  local ref="$1"
  local agents_file="$2"

  case "$ref" in
    http*|https*|skill_view|~\/|../) return 1 ;;
  esac
  return 0
}

for agents_file in $(find . -name "AGENTS.md" 2>/dev/null | sort); do
  # 找到 AGENTS.md 所在的分类目录（如 mlops, github, creative）
  # 根 AGENTS.md 在 skills/ 下
  agents_dir=$(dirname "$agents_file")  # 如 ./mlops 或 .

  # Only check backtick refs inside table rows (| ... | `ref` |), skip markdown headings
  refs=$(grep '^[[:space:]]*|' "$agents_file" 2>/dev/null \
         | grep -oE '`[a-z0-9-]+(/[a-z0-9-]+)*' \
         | tr -d '`' | sort -u)

  for ref in $refs; do
    check_ref "$ref" "$agents_file" || continue

    # 构造两个可能路径：
    # 1. 相对于 AGENTS.md 所在目录（如 mlops/inference/gguf）
    # 2. 相对于 skills/ 根（如 mlops/inference/gguf → mlops/inference/gguf/SKILL.md）
    target1="$SKILLS_DIR/$agents_dir/$ref"
    target2="$SKILLS_DIR/$ref"

    if [[ -d "$target1" || -f "$target1/SKILL.md" || -d "$target2" || -f "$target2/SKILL.md" ]]; then
      pass "引用有效: $ref → $agents_file"
    else
      fail "引用无效: $ref (在 $agents_file)"
    fi
  done
done

# ── R4: 根 AGENTS.md ≤60行 ──────────────────────────────────
header "R4: Agent Readability（≤60行）"

root_lines=$(wc -l < "AGENTS.md" 2>/dev/null || echo 999)
if [[ $root_lines -le 60 ]]; then
  pass "根 AGENTS.md: ${root_lines}行（≤60 ✓）"
else
  fail "根 AGENTS.md: ${root_lines}行（>60行限制）"
fi

# ── R5: SKILL.md 无硬编码个人路径 ───────────────────────────
header "R5: 无硬编码路径"

hardcoded=$(find . -mindepth 2 -maxdepth 3 -name "SKILL.md" \
  -exec grep -l '~/Projects/\|/Users/[^/]*/\|C:\\Users\|D:\\' {} \; 2>/dev/null)
if [[ -n "$hardcoded" ]]; then
  for f in $hardcoded; do
    fail "硬编码路径: $f"
  done
else
  pass "无硬编码个人路径"
fi

# ── 背压强度评分 ──────────────────────────────────────────────
header "背压强度评分"

pass_rate=0
if [[ $TOTAL_CHECKS -gt 0 ]]; then
  pass_rate=$(( (PASSES * 100) / TOTAL_CHECKS ))
fi
entropy_rate=$(( 100 - pass_rate ))

echo ""
echo "  检查项  : $TOTAL_CHECKS"
echo "  通过    : $PASSES"
echo "  失败    : $ERRORS"
echo "  警告    : $WARNINGS"
echo ""
echo -e "  ${BOLD}背压强度:${RESET}  ${PASSES}/${TOTAL_CHECKS} = ${pass_rate}%"
echo -e "  ${BOLD}熵积累率:${RESET}  ${entropy_rate}%"

echo ""
if [[ $pass_rate -ge 95 ]]; then
  echo -e "${GREEN}${BOLD}✓ 优秀 — 零熵或极低熵，系统处于最佳状态${RESET}"
elif [[ $pass_rate -ge 80 ]]; then
  echo -e "${YELLOW}良好 — 有少量漂移，建议修复${RESET}"
else
  echo -e "${RED}警告 — 熵积累严重，需要垃圾回收${RESET}"
  echo -e "${RED}  运行: bash skills/scripts/generate-agents.sh${RESET}"
fi
