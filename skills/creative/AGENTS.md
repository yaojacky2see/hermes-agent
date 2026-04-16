# Creative — 创意内容地图

> 入口：`skills/AGENTS.md`
> 本目录包含创意内容生成工具的子地图。

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| 文字 ASCII 艺术（海报/标题） | `ascii-art` |
| 视频转 ASCII / 音频可视化 | `ascii-video` |
| 手绘风格图表（架构/流程/序列图） | `excalidraw` |
| 数学动画视频（3Blue1Brown风格） | `manim-video` |
| 浏览器交互艺术/数据可视化 | `p5js` |
| 54种真实网站设计系统 | `popular-web-designs` |
| 歌曲创作 + AI音乐提示词 | `songwriting-and-ai-music` |

---

## Skill 详情

### `ascii-art` — ASCII 文字艺术
- **输入：** 文字、字体选择
- **输出：** 终端可打印的 ASCII 字符画
- **字体库：** 571种（pyfiglet）
- **适用：** 标题、海报、聊天装饰

### `ascii-video` — ASCII 视频流水线
- **输入：** 任意视频/音频/图片/文字
- **输出：** MP4、GIF、图片序列
- **能力：** 视频→ASCII、音频可视化、文字动画、Matrix风格效果

### `excalidraw` — 手绘风格图表
- **输入：** 图表描述（架构、流程、序列、概念图）
- **输出：** `.excalidraw` JSON 文件，可在 excalidraw.com 打开
- **适用：** 技术文档、演示文稿、头脑风暴

### `manim-video` — 数学动画
- **输入：** 数学概念、算法解释
- **输出：** MP4 动画（3Blue1Brown风格）
- **能力：** 几何动画、公式推导、数据故事
- **要求：** 需要 Manim Community Edition

### `p5js` — 交互艺术与数据可视化
- **输入：** 创意描述、交互需求
- **输出：** HTML、PNG、GIF、MP4、SVG
- **能力：** 2D/3D渲染、噪声/粒子系统、flow field、shader、数据可视化

### `popular-web-designs` — 真实网站设计系统
- **输入：** 目标网站名（Stripe、Linear、Vercel等）
- **输出：** 对应设计系统的完整 CSS 值（颜色、字体、组件）
- **覆盖：** 54种真实网站的设计规范

### `songwriting-and-ai-music` — 歌曲创作
- **输入：** 歌词想法、音乐风格
- **输出：** 歌曲结构建议 + Sunum AI 音乐生成提示词
- **能力：** 续写、改写、押韵技巧、多语言

---

## 重要约定

1. **技术文档配图** → 优先 `excalidraw`，手绘风格适合解释概念
2. **数学/算法视频** → `manim-video`，但生成耗时较长
3. **快速演示/聊天气泡** → `ascii-art` 最轻量
4. **数据可视化** → `p5js` 可做交互式，ASCII艺术适合纯文本环境
5. **如果要生成实际音乐** → 需要搭配 `media/heartmula`

---

*本目录是 `skills/AGENTS.md` 的子地图，渐进式披露。*
