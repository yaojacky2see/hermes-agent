# Hermes Harness Engineering — Agent 部署指南

---

> **双层结构说明**
>
> **第一层（通用模板）：** 概念解释 + 可配置脚本模板。照此执行，遇到问题查第二层对应编号。
> **第二层（经验日志）：** 记录我们在 Hermes 项目部署时遇到的实际问题，仅供参考。

---

# ═══════════════════════════════
# 第一层：通用部署手册
# ═══════════════════════════════

---

## 目录

1. [概念速览](#1-概念速览)
2. [执行流程总览](#2-执行流程总览)
3. [Step 1：建入口地图](#step-1建入口地图)
4. [Step 2：写 Linter](#step-2写-linter)
5. [Step 3：写生成器](#step-3写生成器)
6. [Step 4：验证并达标](#step-4验证并达标)
7. [Step 5：精简入口文件](#step-5精简入口文件)
8. [Step 6：状态文档](#step-6状态文档)
9. [第二层导航索引](#第二层导航索引)

---

## 1. 概念速览

| # | 概念 | 核心原则 | 落地工具 |
|---|------|---------|---------|
| C1 | 地图而非手册 | 渐进式披露，入口简洁，细节在子地图 | 多级 AGENTS.md |
| C2 | 机械化执行 | lint 规则 = 修复指令，规则必须可执行 | validate-\*.sh |
| C3 | 熵管理 | 文档自动生成，消除手工维护造成的漂移 | generate-\*.sh |
| C4 | Agent 可读性 | 入口文件行数有上限约束，自主性来自约束 | 入口 ≤N 行 |
| C5 | 吞吐量与背压 | 小步快跑 + 质量门禁，无背压的吞吐量 = 熵扩散 | 背压评分 |
| C6 | Harness 精确定义 | Guide × Sensor 矩阵，计算性 + 推理性双重验证 | HARNESS.md |

**2×2 Guides × Sensors 矩阵**

| | 计算性（确定性） | 推理性（语义） |
|--|---------|---------|
| **引导器（前馈）** | bootstrap脚本 | AGENTS.md、Skills |
| **传感器（反馈）** | linter、类型检查 | AI code review、LLM-as-judge |

> ⚠️ **遇到问题** → 跳转至「第二层导航索引」，按问题类型查对应经验日志条目。

---

## 2. 执行流程总览

```
Step 1: 建入口 AGENTS.md（Map — C1）
Step 2: 写 Linter（C2）
Step 3: 写生成器（C3）
Step 4: 验证 → 达标 95%+
Step 5: 精简入口文件（C4）
Step 6: 建 HARNESS.md（C6）

每一步完成后：git commit
全部完成后：git push
```

---

## Step 1：建入口地图

### 目标
在 `skills/` 根目录创建入口 AGENTS.md。

### 原则
- **只引用实际存在的子目录**
- **禁止用 backtick 引用不存在的 skill**（backtick 引用会触发 linter 路径验证）
- **用 `[text](path/)` 链接格式**，不用 `` `bare-backtick` `` 格式
- **入口文件以后由生成器自动维护**，不要手工编辑内容

### 操作

#### 1.1 确认 skills 目录结构

```bash
cd $PROJECT_ROOT
ls -la skills/
# 记录你实际有哪些子目录
```

#### 1.2 创建入口文件模板

```markdown
# {{PROJECT_NAME}} Skills — 智能体地图

> 本文件由 `generate-agents.sh` 自动生成。
> **核心原则：仓库即记录系统。不要手工编辑此文件。**

---

## 快速路由

| 任务 | 入口 |
|------|------|
| {{CATEGORY_1}} | [{{dir}}/AGENTS.md]({{dir}}/AGENTS.md) |
| {{CATEGORY_2}} | [{{dir}}/AGENTS.md]({{dir}}/AGENTS.md) |

> 加载 Skill：`skill_view(name="category/skill-name")`

*最后生成：YYYY-MM-DD*
```

#### 1.3 实际创建的入口文件

将模板中的 `{{VARIABLE}}` 替换为你的实际值：

| 变量 | 替换为 |
|------|--------|
| `{{PROJECT_NAME}}` | 你的项目名（如 Hermes、MyAgent） |
| `{{CATEGORY_N}}` | 任务描述（如 GitHub、MLOps） |
| `{{dir}}` | 实际存在的子目录名 |

#### 1.4 验证

```bash
# 检查行数（以后生成器会管理，这里先确认结构）
wc -l skills/AGENTS.md
```

> ⚠️ **如果遇到：引用了不存在的 skill** → 第二层 [Q1](#q1-linter-r3-报告引用无效但目录确实存在)

---

## Step 2：写 Linter

### 目标
创建 `validate-skills.sh`，用脚本验证 skills 目录的健康度。

### 原则
- **lint 规则 = 修复指令**：每个 FAIL 附带清晰的修复方向
- **必须可执行**：bash 脚本，兼容 bash 3.2+（macOS 默认）
- **不含 bash 新特性**：不用 `mapfile`、`readarray`、`timeout`

### 操作

#### 2.1 创建脚本文件

```bash
mkdir -p skills/scripts
cat > skills/scripts/validate-skills.sh << 'LINTER_EOF'
#!/bin/bash
# =====================================================================
# validate-skills.sh — Skills 目录 Linter
#
# 检查项：
#   R1. 每个技能目录必须有 SKILL.md
#   R2. 子 AGENTS.md 与父 AGENTS.md 交叉链接
#   R3. AGENTS.md 表格引用必须指向真实目录
#   R4. 入口 AGENTS.md ≤{{MAX_LINES}}行
#   R5. SKILL.md 无硬编码个人路径
# =====================================================================
# ⚠️ 以下为模板，{{VARIABLE}} 需要替换为你的项目实际值
# =====================================================================

SKILLS_DIR="{{PROJECT_ROOT}}/skills"   # ← 替换为你的 skills 目录路径
MAX_LINES={{MAX_LINES}}                  # ← 替换为你的行数上限（如 60）

cd "$SKILLS_DIR"

ERRORS=0; PASSES=0; WARNINGS=0; TOTAL_CHECKS=0

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BOLD='\033[1m'; RESET='\033[0m'

pass()    { echo -e "${GREEN}[PASS]${RESET}  $1"; PASSES=$((PASSES+1)); TOTAL_CHECKS=$((TOTAL_CHECKS+1)); }
fail()    { echo -e "${RED}[FAIL]${RESET}  $1";  ERRORS=$((ERRORS+1));  TOTAL_CHECKS=$((TOTAL_CHECKS+1)); }
header()  { echo -e "\n${BOLD}━━━ $1 ━━━${RESET}"; }

# ── R1: 每个技能目录必须有 SKILL.md ─────────────────────────
header "R1: SKILL.md 存在性"

# ⚠️ 根据你的目录结构，调整 find 深度和排除模式
skill_dirs=$(find . -mindepth 2 -maxdepth 3 -type d ! -name 'scripts' 2>/dev/null | sort)
total=0; missing=0

for dir in $skill_dirs; do
  # ⚠️ 根据你的实际情况，调整排除列表
  case "$dir" in
    */templates|*/references|*/assets) continue ;;
  esac
  total=$((total+1))

  # 分组目录（内有子 skill 但自身无 SKILL.md）→ 跳过
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

# ── R3: AGENTS.md 表格引用有效性 ────────────────────────────
# ⚠️ 关键：只检查表格中的引用（| ... | `ref` |），跳过 markdown 标题
header "R3: Skill 引用有效性"

for agents_file in $(find . -name "AGENTS.md" 2>/dev/null | sort); do
  agents_dir=$(dirname "$agents_file")

  # ⚠️ 你的引用格式可能不同，调整此正则表达式
  # 模板假设引用格式为 `category/skill` 或 `skill`
  refs=$(grep '^[[:space:]]*|' "$agents_file" 2>/dev/null \
         | grep -oE '`[a-z0-9-]+(/[a-z0-9-]+)*' \
         | tr -d '`' | sort -u)

  for ref in $refs; do
    case "$ref" in
      http*|https*|skill_view|~\/|../) continue ;;
    esac
    # 引用可能相对于 AGENTS.md 所在目录
    target1="$SKILLS_DIR/$agents_dir/$ref"
    target2="$SKILLS_DIR/$ref"
    if [[ -d "$target1" || -f "$target1/SKILL.md" || -d "$target2" || -f "$target2/SKILL.md" ]]; then
      pass "引用有效: $ref"
    else
      fail "引用无效: $ref (在 $agents_file)"
    fi
  done
done

# ── R4: 入口 AGENTS.md ≤N行 ──────────────────────────────────
header "R4: Agent Readability（≤${MAX_LINES}行）"

root_lines=$(wc -l < "AGENTS.md" 2>/dev/null || echo 999)
if [[ $root_lines -le $MAX_LINES ]]; then
  pass "入口 AGENTS.md: ${root_lines}行（≤${MAX_LINES} ✓）"
else
  fail "入口 AGENTS.md: ${root_lines}行（>${MAX_LINES}行限制）"
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

echo ""
echo "  检查项  : $TOTAL_CHECKS"
echo "  通过    : $PASSES"
echo "  失败    : $ERRORS"
echo ""
echo -e "  ${BOLD}背压强度:${RESET}  ${PASSES}/${TOTAL_CHECKS} = ${pass_rate}%"
echo -e "  ${BOLD}熵积累率:${RESET}  $((100 - pass_rate))%"

echo ""
if [[ $pass_rate -ge 95 ]]; then
  echo -e "${GREEN}${BOLD}✓ 优秀 — 零熵或极低熵${RESET}"
elif [[ $pass_rate -ge 80 ]]; then
  echo -e "${YELLOW}良好 — 有少量漂移，建议修复${RESET}"
else
  echo -e "${RED}警告 — 熵积累严重，运行 generate-agents.sh${RESET}"
fi
LINTER_EOF
chmod +x skills/scripts/validate-skills.sh
```

#### 2.2 替换模板变量

| 变量 | 替换为 | 示例 |
|------|--------|------|
| `{{PROJECT_ROOT}}` | 你的项目根目录绝对路径 | `/Users/jacky/.hermes/hermes-agent` |
| `{{MAX_LINES}}` | 你设定的入口文件行数上限 | `60` |

#### 2.3 测试

```bash
bash skills/scripts/validate-skills.sh
```

> ⚠️ **如果遇到脚本提前退出（只跑一部分就停了）** → 第二层 [Q5](#q5-var-导致脚本提前退出)
> ⚠️ **如果 R3 报告大量误报** → 第二层 [Q3](#q3-r3-把-markdown-标题-中的-backtick-也当-skill-引用)

---

## Step 3：写生成器

### 目标
创建 `generate-agents.sh`，从实际目录结构自动生成 AGENTS.md。

### 原则
- **机器生成，人工不维护**：生成后的内容由脚本决定，禁止手工编辑
- **从目录结构投影**：skill 列表来自 `find` 命令，而非手写清单
- **消除手工漂移**：目录变了 → 运行生成器 → AGENTS.md 自动同步

### 操作

#### 3.1 创建脚本文件

```bash
cat > skills/scripts/generate-agents.sh << 'GEN_EOF'
#!/bin/bash
# =====================================================================
# generate-agents.sh — 从实际目录结构自动生成 AGENTS.md
#
# 原理：AGENTS.md 是目录结构 + SKILL.md metadata 的投影
#       由机器生成，保证与实际状态永远一致
#
# ⚠️ 模板 — 以下 {{VARIABLE}} 需要替换为你的项目实际值
# =====================================================================
set -euo pipefail

PROJECT_ROOT="{{PROJECT_ROOT}}"   # ← 替换为你的项目根目录
SKILLS_DIR="$PROJECT_ROOT/skills"
MAX_LINES={{MAX_LINES}}            # ← 替换为你的行数上限

cd "$SKILLS_DIR"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BOLD='\033[1m'; RESET='\033[0m'
pass() { echo -e "${GREEN}[GEN]${RESET}  $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET}  $1"; }

# ── 从 SKILL.md 提取描述 ─────────────────────────────────────
get_description() {
  local skill_md="$1"
  if [[ ! -f "$skill_md" ]]; then echo ""; return; fi

  # YAML frontmatter 中的 description 字段
  if grep -q '^---$' "$skill_md" 2>/dev/null; then
    local desc=$(awk '/^---$/,/^---$/ {next} /^description:/ {
      sub(/^description:[[:space:]]*/, ""); print; exit}' "$skill_md")
    [[ -n "$desc" ]] && echo "$desc" && return
  fi

  # 回退：第一个非标题行
  sed -n '1,/^[#>]/p' "$skill_md" 2>/dev/null \
    | grep -v '^#' | grep -v '^>' | grep -v '^$' | grep -v '^---$' \
    | head -1 | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

# ── 入口地图的分类标签映射 ─────────────────────────────────
get_category() {
  case "$1" in
    # ⚠️ 根据你的实际子目录，添加/修改此映射
    github)         echo "GitHub" ;;
    mlops)          echo "MLOps" ;;
    creative)       echo "创意工具" ;;
    research)       echo "研究工具" ;;
    productivity)   echo "生产力" ;;
    apple)          echo "Apple 系统" ;;
    software-dev*)  echo "软件开发" ;;
    autonomous*)    echo "AI Agent 调度" ;;
    *)              echo "工具" ;;
  esac
}

# ── 生成入口 AGENTS.md ──────────────────────────────────────
generate_root_agents() {
  local out="AGENTS.md"

  # ⚠️ 根据你的实际子目录列表，修改以下行
  # 示例格式："| 任务 | [dir/AGENTS.md](dir/) |"
  {
    echo "# {{PROJECT_NAME}} Skills — 智能体地图"
    echo ""
    echo "> 本文件由 \`generate-agents.sh\` 自动生成。"
    echo "> **核心原则：仓库即记录系统。禁止手工编辑此文件。**"
    echo ""
    echo "---"
    echo ""
    echo "## 快速路由"
    echo ""
    echo "| 任务 | 入口 |"
    echo "|------|------|"
    # ⚠️ 以下每行对应一个实际存在的子目录，按需添加/删除
    echo "| GitHub | [github/AGENTS.md](github/AGENTS.md) |"
    echo "| MLOps | [mlops/AGENTS.md](mlops/AGENTS.md) |"
    echo "| 创意媒体 | [creative/AGENTS.md](creative/AGENTS.md) |"
    echo "| 研究工具 | [research/AGENTS.md](research/AGENTS.md) |"
    echo ""
    echo "---"
    echo ""
    echo "## 子地图索引"
    echo ""
    echo "| 目录 | 内容 |"
    echo "|------|------|"
    echo "| \`github/\` | PR/Issues/CodeReview |"
    echo "| \`mlops/\` | 训练/推理/评估/云GPU |"
    echo "| \`creative/\` | 媒体生成/可视化 |"
    echo "| \`research/\` | 论文/博客/预测市场 |"
    echo ""
    echo "> 加载 Skill：\`skill_view(name=\"category/skill-name\")\`"
    echo ""
    echo "*最后生成：$(date '+%Y-%m-%d %H:%M:%S')*"

  } > "$out"

  local lines=$(wc -l < "$out")
  if [[ $lines -gt $MAX_LINES ]]; then
    warn "$out 为 ${lines}行（>${MAX_LINES}行限制）"
  else
    pass "生成 $out (${lines}行 ≤${MAX_LINES}行)"
  fi
}

# ── 生成子目录 AGENTS.md ────────────────────────────────────
generate_sub_agents() {
  # ⚠️ 根据你的实际子目录列表修改
  local sub_dirs="github mlops research creative"

  for sub in $sub_dirs; do
    [[ -d "$sub" ]] || continue
    local out="$sub/AGENTS.md"
    local count=0

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
      echo "| 任务 | Skill |"
      echo "|------|-------|"

      if [[ "$sub" == "mlops" ]]; then
        # ⚠️ 如果你的 mlops 没有多级子目录，删除这个分支
        # ⚠️ 如果有其他多级目录，参考此模式添加
        for sub2_dir in "$sub"/*/; do
          [[ -d "$sub2_dir" ]] || continue
          sub2_name=$(basename "$sub2_dir")
          if [[ -f "${sub2_dir}SKILL.md" ]]; then
            desc=$(get_description "${sub2_dir}SKILL.md")
            echo "| $(echo "$desc" | cut -c1-50)… | \`${sub2_name}\` |"
            count=$((count+1))
          else
            for skill_dir in "${sub2_dir}"*/; do
              [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
              skill_name=$(basename "$skill_dir")
              desc=$(get_description "${skill_dir}SKILL.md")
              # ⚠️ 路由表引用统一带 sub2 前缀（便于 linter R3 验证）
              echo "| $(echo "$desc" | cut -c1-40)… | \`${sub2_name}/${skill_name}\` |"
              count=$((count+1))
            done
          fi
        done
      else
        for skill_dir in "$sub"/*/; do
          [[ -d "$skill_dir" && -f "${skill_dir}SKILL.md" ]] || continue
          skill_name=$(basename "$skill_dir")
          desc=$(get_description "${skill_dir}SKILL.md")
          echo "| $(echo "$desc" | cut -c1-50)… | \`${skill_name}\` |"
          count=$((count+1))
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

    pass "生成 $out ($count 个 skill)"
  done
}

# ── 主流程 ──────────────────────────────────────────────────
echo -e "${BOLD}━━━ AGENTS.md 生成器 ━━━${RESET}"
generate_root_agents
generate_sub_agents
echo ""
pass "完成 — 所有 AGENTS.md 已同步"
GEN_EOF
chmod +x skills/scripts/generate-agents.sh
```

#### 3.2 替换模板变量

| 变量 | 替换为 |
|------|--------|
| `{{PROJECT_ROOT}}` | 你的项目根目录绝对路径 |
| `{{PROJECT_NAME}}` | 你的项目名 |
| `{{MAX_LINES}}` | 入口文件行数上限 |

#### 3.3 测试

```bash
bash skills/scripts/generate-agents.sh
```

#### 3.4 验证

```bash
bash skills/scripts/validate-skills.sh
```

> ⚠️ **如果生成后 R4 报告超行** → Step 5（精简入口文件）
> ⚠️ **如果 mlops 路由表和详情路径不一致** → 第二层 [Q6](#q6-mlops-路由表和详情路径不一致)

---

## Step 4：验证并达标

### 目标
运行 linter，背压强度 ≥95%。

### 操作

```bash
bash skills/scripts/validate-skills.sh
```

### 评分标准

| 分数 | 状态 | 行动 |
|------|------|------|
| 100% | 优秀 | ✅ 零熵，可以继续 |
| 95-99% | 良好 | ⚠️ 有少量漂移，逐一修复 FAIL 项 |
| <80% | 警告 | 🔴 运行 `generate-agents.sh`，然后再验证 |

### 常见 FAIL 项修复方向

| FAIL 项 | 修复方式 |
|---------|---------|
| R1 缺少 SKILL.md | 创建空的 SKILL.md 或确认该目录是否为分组目录 |
| R2 未引用父级 | 在子 AGENTS.md 添加 `[入口](../AGENTS.md)` |
| R3 引用无效 | 确认引用路径相对于哪个 AGENTS.md 目录 |
| R4 超行 | Step 5 精简入口文件 |
| R5 硬编码路径 | 在 SKILL.md 中替换为变量或通用路径 |

### 背压强度 ≥95% 后

```bash
git add skills/
git commit -m "feat(harness): initial mechanical enforcement — X% backpressure"
```

---

## Step 5：精简入口文件

### 目标
入口 AGENTS.md 行数 ≤ 设定上限（默认 60 行）。

### 操作

#### 5.1 检查当前行数

```bash
wc -l skills/AGENTS.md
```

#### 5.2 如果超行

**检查是哪些部分超了**：
- 有太多 skill 详情塞在入口？→ 移到子地图
- 有太多空行？→ 压缩
- 有太多子目录？→ 只留主要分类，其他的归到「其他」

**精简原则**：
- 入口 = 路由表，不是详情清单
- 详情全部放到子地图
- 删除任何重复内容

#### 5.3 重新生成验证

```bash
bash skills/scripts/generate-agents.sh
bash skills/scripts/validate-skills.sh | grep "R4\|入口"
```

> ⚠️ **如果入口结构本身简单但还是超行** → 第二层 [Q7](#q7-根-agentsmd-行数超过-60-行)

---

## Step 6：状态文档

### 目标
创建 `HARNESS.md`，记录 harness 组件状态，供其他 Agent 了解项目当前情况。

### 操作

```bash
cat > skills/HARNESS.md << 'HARNESS_EOF'
# {{PROJECT_NAME}} Harness — 状态文档

---

## 2×2 Guides × Sensors 矩阵

| | 计算性（确定性） | 推理性（语义） |
|--|---------|---------|
| **引导器（前馈）** | ✅ bootstrap脚本 | ✅ AGENTS.md ✅ Skills |
| **传感器（反馈）** | ✅ validate-skills.sh | ⚠️ 待实现 |

---

## 引导器 — 已实现

- **AGENTS.md**：入口路由表（N 行 ≤{{MAX_LINES}}）
- **Skills**：N 个渐进式知识包

---

## 传感器 — 已实现

- **validate-skills.sh**：{{RULES_COUNT}}条规则，背压评分
- **generate-agents.sh**：自动同步 AGENTS.md

---

## 传感器 — 缺失（待实现）

- **AI Code Review**：提交后自动 LLM 审查
- **LLM-as-Judge**：评估 Agent 输出质量

---

## 背压强度

| 日期 | 分数 |
|------|------|
| YYYY-MM-DD | {{BACKPRESSURE_SCORE}}% |

---

## 快速命令

```bash
# 验证
bash skills/scripts/validate-skills.sh

# 同步
bash skills/scripts/generate-agents.sh
```

---

*文档版本：v1.0*
HARNESS_EOF
```

---

## 第二层导航索引

> **以下为经验日志，仅供参考。** 遇到问题时，根据编号查对应条目。

| 问题 | 对应条目 |
|------|---------|
| 根 AGENTS.md 用了不存在的 skill 引用 | [Q1](#q1-linter-r3-报告引用无效但目录确实存在) |
| 分组目录（如 mlops/training/）被 R1 误报 | [Q2](#q2-linter-r1-报告分组目录缺少-skillmd) |
| R3 把 markdown 标题的 backtick 当 skill 引用 | [Q3](#q3-r3-把-markdown-标题-中的-backtick-也当-skill-引用) |
| macOS 报 `timeout: command not found` | [Q4](#q4-脚本在-macos-上报-timeout-command-not-found) |
| `((var))` 导致脚本提前退出 | [Q5](#q5-var-导致脚本提前退出) |
| mlops 路由表和详情路径不一致 | [Q6](#q6-mlops-路由表和详情路径不一致) |
| 根 AGENTS.md 超行 | [Q7](#q7-根-agentsmd-行数超过限制) |
| GitHub push 被拒绝 | [Q8](#q8-github-push-被拒绝) |

---

# ═══════════════════════════════
# 第二层：经验日志（仅供参考）
# ═══════════════════════════════

> **说明：** 本节记录我们在 Hermes 项目部署时遇到的实际问题。
> **不代表所有 agent 都会遇到这些问题。**
> 按需查阅，不要通读。

---

## Q1：linter R3 报告引用无效，但目录确实存在

**现象**：
```
[FAIL] 引用无效: apple-notes (在 ./AGENTS.md)
```

**原因分析**：
根 AGENTS.md 引用了 `` `apple-notes` ``，但实际目录是 `apple/apple-notes`。linter 在 `skills/` 下找 `apple-notes`，找不到。

**我们在 Hermes 的情况**：
- 根 AGENTS.md 手写了一行 `` `software-dev/` ``（实际目录叫 `software-development/`）
- linter 正确识别了这个错误

**修复方案**：

方案 A（推荐）：根 AGENTS.md 用链接格式，不用 backtick 引用
```markdown
# ✅ 推荐：链接格式，不触发 R3 验证
| 软件开发 | [software-development/](software-development/) |

# ❌ 避免：backtick 引用会触发路径验证
| 软件开发 | `software-development/` |
```

方案 B：确认引用路径正确
- 确认你写的 skill 名和实际目录名完全一致
- 注意 `/` 的位置——`category/skill` 和 `category-skill` 是不同的

**预防**：
生成器生成根 AGENTS.md 时，用链接格式 `[text](dir/)` 而不是 backtick。

---

## Q2：linter R1 报告分组目录缺少 SKILL.md

**现象**：
```
[FAIL] 缺少 SKILL.md: ./mlops/training
[FAIL] 缺少 SKILL.md: ./mlops/inference
```

**原因分析**：
`mlops/training/`、`mlops/inference/` 这种是**分组目录**（内有子 skill），自身不需要 SKILL.md。但 linter 的 R1 检测逻辑没有识别这一点。

**我们在 Hermes 的情况**：
```
mlops/
├── training/         ← 分组目录，内有 axolotl/, peft/ 等子 skill
│   ├── axolotl/
│   └── peft/
└── inference/        ← 分组目录，内有 gguf/, llama-cpp/ 等子 skill
    ├── gguf/
    └── llama-cpp/
```

**修复方案**：

在 linter R1 逻辑中加入分组目录检测：

```bash
for dir in $skill_dirs; do
  case "$dir" in
    */templates|*/references|*/assets) continue ;;
  esac
  total=$((total+1))

  # 分组目录（内有子 skill 但自身无 SKILL.md）→ 跳过
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
```

**判断是否为分组目录的规则**：
- 目录内有子 skill 目录（`*/skill-name/SKILL.md` 存在）
- 且目录自身没有 SKILL.md
- → 该目录是分组目录，不计入 R1 检查

---

## Q3：R3 把 markdown 标题中的 backtick 也当 skill 引用

**现象**：
```
[FAIL] 引用无效: axolotl (在 ./mlops/AGENTS.md)
[FAIL] 引用无效: gguf (在 ./mlops/AGENTS.md)
```
但 mlops/ 下的 `inference/gguf/`、`training/axolotl/` 目录确实存在。

**原因分析**：
linter R3 用 `grep -oE '`[a-z0-9-]+(/[a-z0-9-]+)*`'` 提取引用，这会匹配**所有** backtick 内容，包括 markdown 标题：

```markdown
#### `axolotl`        ← linter 提取到 `axolotl`，以为是 skill 引用
```

**我们在 Hermes 的情况**：
mlops/AGENTS.md 详情部分用 `#### \`axolotl\`` 作为标题，这是 markdown 标题，不是 skill 引用。但 linter 把它当成了 R3 检查对象。

**修复方案**：

R3 只检查**表格行**中的 backtick 引用，跳过 markdown 标题：

```bash
# ❌ 错误：匹配所有 backtick
refs=$(grep -oE '`[a-z0-9-]+(/[a-z0-9-]+)*`' "$agents_file" 2>/dev/null \
       | tr -d '`' | sort -u)

# ✅ 正确：只在表格行（| 开头）中查找
refs=$(grep '^[[:space:]]*|' "$agents_file" 2>/dev/null \
       | grep -oE '`[a-z0-9-]+(/[a-z0-9-]+)*' \
       | tr -d '`' | sort -u)
```

---

## Q4：脚本在 macOS 上报 `timeout: command not found`

**现象**：
```
timeout: command not found
```

**原因****：
macOS 默认的 bash 3.2.57 没有 `timeout` 命令。Linux 有。

**我们在 Hermes 的情况**：
我们的脚本没有使用 `timeout`，没有遇到这个问题。但如果你的脚本用 `timeout`，在 macOS 上会报错。

**修复方案**：
- 不使用 `timeout`，直接运行脚本
- 或使用 `gtimeout`（需要 `brew install coreutils`）

```bash
# ❌ macOS 不支持
timeout 30 bash script.sh

# ✅ 直接运行（linter 脚本不会长时间阻塞）
bash script.sh

# ✅ 或安装 gtimeout
brew install coreutils
gtimeout 30 bash script.sh
```

---

## Q5：`((var))` 导致脚本提前退出

**现象**：
脚本跑到一半就停了，只输出一部分结果。

**原因分析**：
`set -e`（脚本遇错即退）+ bash 3.2 中 `((0))` 返回退出码 1：
```bash
set -e
PASSES=0
((PASSES++))  # ((0)) → 退出码 1 → set -e 触发 → 脚本终止
```

**我们在 Hermes 的情况**：
linter R1-R5 循环中，每个 FAIL 都调用 `((ERRORS++))`。当第一个 FAIL 出现时，如果 `ERRORS` 刚从 0 变成 1，`((1))` 返回退出码 0，但紧接着下一次循环时... 实际上我们用了 `|| true` 解决了这个问题。但一开始没有，就出现了脚本提前退出的现象。

**修复方案**：

```bash
# ❌ 错误：可能触发 set -e
((PASSES++))
((ERRORS++))

# ✅ 正确：加 || true
((PASSES++)) || true
((ERRORS++)) || true

# ✅ 或者完全不用算数展开
PASSES=$((PASSES+1))
ERRORS=$((ERRORS+1))
```

---

## Q6：mlops 路由表和详情路径不一致

**现象**：
```
[FAIL] 引用无效: axolotl (在 ./mlops/AGENTS.md)
```
但 `training/axolotl/` 目录确实存在。

**原因分析**：
生成器 mlops 部分的路由表和详情区使用了不一致的路径格式：

```markdown
## 快速路由（路由表）
| ... | `training/axolotl` |     ← 带 sub2 前缀 ✅

## Skill 详情（详情区）
#### `axolotl`                   ← 裸名，无前缀 ❌
```

linter R3 只检查**路由表**（表格行）中的引用 `training/axolotl`（有效），但实际上它也在**详情区**找到了 `axolotl`（裸名），然后验证裸名 `axolotl` 相对于 `mlops/` 目录（失败）。

**我们在 Hermes 的情况**：
这是生成器本身的 bug——路由表写 `\`training/axolotl\``，详情写 `#### \`axolotl\``。linter 的 R3 修复后（只检查表格行），这个问题消失了，但生成器本身的路径逻辑仍然不一致。

**修复方案**：

生成器 mlops 详情区的标题也应该带前缀，或者统一不带：

方案 A（推荐）：路由表用全路径，详情区标题用纯 skill 名（因为详情区标题不会被 R3 检查）
```bash
# 路由表
echo "| ... | \`${sub2_name}/${skill_name}\` |"

# 详情标题（不会被 R3 检查，因为加了 ####）
echo "#### \`${skill_name}\`"
```

方案 B：详情标题也加前缀
```bash
echo "#### \`${sub2_name}/${skill_name}\`"
```

**关键**：路由表的 skill 引用格式要和实际目录结构匹配。路由表写了 `\`training/axolotl\``，linter 就去找 `mlops/training/axolotl/`。

---

## Q7：根 AGENTS.md 行数超过限制

**现象**：
```
[FAIL] 入口 AGENTS.md: 87行（>60行限制）
```

**原因分析**：
入口文件塞了太多内容：skill 详情、子目录列表、空行、分隔线等。

**我们在 Hermes 的情况**：
最开始入口有 ~80 行，内容包括每个子地图的描述、每个 skill 的列表等。

**修复方案**：

**原则**：入口 = 路由表，不是详情清单

入口只保留：
1. 标题
2. 快速路由表（每个子地图一行）
3. 子地图索引（简要描述）
4. 加载方式说明

所有详情移到子地图。

**入口模板（≤60行）**：
```markdown
# Skills — 智能体地图

> 本文件由 `generate-agents.sh` 自动生成。

---

## 快速路由

| 任务 | 入口 |
|------|------|
| GitHub | [github/AGENTS.md](github/AGENTS.md) |
| MLOps | [mlops/AGENTS.md](mlops/AGENTS.md) |
| 创意 | [creative/AGENTS.md](creative/AGENTS.md) |
| 研究 | [research/AGENTS.md](research/AGENTS.md) |

---

## 子地图

| 目录 | 内容 |
|------|------|
| `github/` | 6 skills |
| `mlops/` | 22 skills |

> 加载：`skill_view(name="category/skill-name")`

*最后生成：YYYY-MM-DD*
```

---

## Q8：GitHub push 被拒绝

**现象**：
```
Permission denied (publickey).
fatal: Could not read from remote repository.
```

**原因**：
- SSH key 未添加到 GitHub
- 或分支不存在

**修复方案**：

```bash
# 1. 检查 SSH key 是否生效
ssh -T git@github.com

# 2. 如果提示权限拒绝，添加 SSH key
# GitHub → Settings → SSH and GPG keys → New SSH key

# 3. 确认分支存在
git branch -a

# 4. 如果分支不存在，创建并推送
git checkout -b feat-optional-skills
git push -u origin feat-optional-skills

# 5. 如果分支已存在，确认远程配置正确
git remote -v
# 应该是：git@github.com:yaojacky2see/hermes-agent.git
```

---

## 文档版本

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 | 2026-04-16 | 初始双层结构版本 |

---

*文档版本：v1.0 — 2026-04-16*
*第一层：通用部署模板 | 第二层：经验日志（仅供参考）*
