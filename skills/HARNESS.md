# Hermes Agent Harness — 状态文档

> 本文件记录 Hermes Agent 的 harness 组件状态。
> 由 `validate-skills.sh` 定期验证。

---

## 2×2 Guides × Sensors 矩阵

| | 计算性（确定性） | 推理性（语义） |
|--|---------|---------|
| **引导器（前馈）** | ✅ bootstrap脚本 | ✅ AGENTS.md ✅ Skills |
| **传感器（反馈）** | ✅ validate-skills.sh | ⚠️ 待实现 |

---

## 引导器（Guides）— 已实现

### AGENTS.md（路由入口）
- 路径：`skills/AGENTS.md`
- 行数：42行（≤60行 ✓）
- 内容：按任务类型引导至子地图
- 生成方式：`generate-agents.sh` 自动维护

### Skills（渐进式知识包）
- 数量：82个 skill
- 组织：按领域分类（github/mlops/creative/research/...）
- 格式：每个 skill 有 `SKILL.md`
- 加载方式：`skill_view(name="category/skill-name")`

---

## 传感器（Sensors）— 已实现

### validate-skills.sh（计算性传感器）
- 路径：`skills/scripts/validate-skills.sh`
- 规则数：5条
- 背压强度：141/141 = **100%**（2026-04-16）
- 规则：
  - R1: SKILL.md 存在性
  - R2: AGENTS.md 交叉链接
  - R3: 表格引用有效性
  - R4: 根 AGENTS.md ≤60行
  - R5: 无硬编码路径

### generate-agents.sh（计算性引导器）
- 路径：`skills/scripts/generate-agents.sh`
- 功能：从实际目录结构自动生成 AGENTS.md
- 触发：skills 变更后运行

---

## 传感器（Sensors）— 缺失（待实现）

### AI Code Review（推理性传感器）
- 描述：Agent 提交后，自动触发 LLM 审查代码质量
- 优先级：高
- 依赖：`subagent-driven-development` skill

### LLM-as-Judge（推理性传感器）
- 描述：用 LLM 评估 Agent 输出质量，作为背压评分补充
- 优先级：中
- 备注：当前 linter 是纯结构检查，无法判断语义质量

---

## 三大监管维度成熟度

| 维度 | 成熟度 | 现状 |
|------|--------|------|
| 可维护性 Harness | ✅ 成熟 | linter + 生成器 + 背压评分 |
| 架构适应度 Harness | ⚠️ 中等 | 有 Skills 分类，无架构约束规则 |
| 行为 Harness | ❌ 弱 | 无 LLM-as-Judge，无 AI Code Review |

---

## 背压强度历史

| 日期 | 分数 | 备注 |
|------|------|------|
| 2026-04-16 | 100% (141/141) | 初始机械化执行系统上线 |

---

## 快速命令

```bash
# 验证当前状态
bash ~/.hermes/hermes-agent/skills/scripts/validate-skills.sh

# 同步 AGENTS.md（skills 变更后）
bash ~/.hermes/hermes-agent/skills/scripts/generate-agents.sh

# 查看背压强度
bash ~/.hermes/hermes-agent/skills/scripts/validate-skills.sh | grep 背压
```

---

*文档版本：v1.0 — 2026-04-16*
