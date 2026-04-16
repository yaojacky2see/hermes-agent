# Media — 媒体内容地图

> 入口：`skills/AGENTS.md`
> 本目录包含音视频处理与内容提取工具的子地图。

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| 搜索并下载 GIF | `gif-search` |
| 生成音乐（Suno-like） | `heartmula` |
| 音频频谱可视化 | `songsee` |
| YouTube 字幕提取 / 总结 / 改写 | `youtube-content` |

---

## Skill 详情

### `gif-search` — GIF 搜索
- **来源：** Tenor
- **能力：** 搜索、下载 GIF
- **用途：** 聊天反应 GIF、内容视觉增强
- **依赖：** curl + jq，无其他依赖

### `heartmula` — 音乐生成
- **能力：** HeartMuLa 模型族（Suno-like），从歌词+标签生成完整歌曲
- **支持：** 多语言
- **前提：** 需要模型权重（开源，可本地部署）
- **用途：** 原创音乐生成、配乐

### `songsee` — 频谱可视化
- **输入：** 任意音频文件
- **输出：** 可视化图像（频谱图）
- **支持类型：** mel、chroma、MFCC、tempogram
- **用途：** 音频分析、音乐制作调试、文档可视化

### `youtube-content` — YouTube 内容提取
- **输入：** YouTube URL 或视频链接
- **能力：** 字幕获取、章节识别、内容总结、文章改写
- **输出格式：** 字幕文本、结构化总结、线程（thread）、博客文章
- **适用：** 知识摄取、内容搬运、二次创作

---

## 重要约定

1. **聊天 GIF** → `gif-search`，最快最轻
2. **YouTube 内容摄取** → `youtube-content` 是首选，自动处理字幕
3. **音乐生成** → `heartmula`，但需要模型部署（比 GIF 复杂得多）
4. **音频分析/可视化** → `songsee`，适合调试或制作文档
5. **如果要生成视频内容** → 参看 `creative/ascii-video` 和 `creative/manim-video`

---

*本目录是 `skills/AGENTS.md` 的子地图，渐进式披露。*
