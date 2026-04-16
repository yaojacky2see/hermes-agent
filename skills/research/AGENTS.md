# Research — 研究工具地图

> 入口：`skills/AGENTS.md`
> 本目录包含学术研究、信息摄取、预测市场数据工具的子地图。

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| 搜索 arXiv 学术论文 | `arxiv` |
| 构建个人 LLM 知识库（Karpathy风格） | `llm-wiki` |
| 监控博客 / RSS / Atom 更新 | `blogwatcher` |
| 查询预测市场数据（价格/订单簿） | `polymarket` |
| 完整 ML/AI 论文流水线 | `research-paper-writing` |

---

## Skill 详情

### `arxiv` — 学术论文搜索
- **来源：** arXiv REST API（免费，无需 Key）
- **能力：** 按关键词、作者、分类、ID 搜索
- **后续处理：** 配合 `web_extract` 读全文，或 `ocr-and-documents` 处理 PDF
- **适用：** 论文调研、最新研究追踪

### `llm-wiki` — Karpathy LLM Wiki
- **用途：** 构建持久化、相互链接的 markdown 知识库
- **能力：** 摄取来源、查询编译知识、交叉链接一致性检查（lint）
- **适用：** 长期知识积累、系统性研究
- **触发时机：** 书评账号跑通3个月后，或项目规模起来需要系统研究时

### `blogwatcher` — 博客 RSS 监控
- **来源：** RSS / Atom feeds
- **能力：** 添加博客、扫描新文章、追踪阅读状态、按分类过滤
- **适用：** 追踪特定博客更新、持续关注某领域动态

### `polymarket` — 预测市场数据
- **来源：** Polymarket 公开 REST API（无需 Key）
- **能力：** 市场搜索、价格查询、订单簿、价格历史
- **适用：** 预测市场情绪、事件概率追踪（仅供研究）

### `research-paper-writing` — ML/AI 论文流水线
- **覆盖会议：** NeurIPS、ICML、ICLR、ACL、AAAI、COLM
- **能力：** 实验设计→分析→起草→修订→提交，全流程
- **特性：** 自动实验监控、统计分析、迭代写作、引用验证
- **适用：** 学术论文写作，从想法到发表

---

## 重要约定

1. **论文调研** → 先 `arxiv` 搜索，再决定是否需要读全文
2. **需要读 PDF 全貌** → 配合 `ocr-and-documents`（`productivity/`）
3. **构建长期知识体系** → `llm-wiki`，不是简单笔记
4. **追踪博客** → `blogwatcher`，不要手动定期检查
5. **预测市场仅供研究** → 数据是公开市场定价，不代表任何立场

---

*本目录是 `skills/AGENTS.md` 的子地图，渐进式披露。*
