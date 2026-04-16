# MLOps — 智能体地图

> 入口：`skills/AGENTS.md`
> 本目录包含 MLOps 全套工具的子地图。按工作流阶段分流。

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| **训练** | |
| LLM 高效微调（LoRA/QLoRA） | `peft` |
| 快速微调（2-5x 提速） | `unsloth` |
| Axolotl 微调框架（100+模型） | `axolotl` |
| RLHF / DPO / PPO / GRPO | `trl-fine-tuning` / `grpo-rl-training` |
| PyTorch FSDP 分布式训练 | `pytorch-fsdp` |
| **推理与服务** | |
| vLLM 高吞吐推理服务 | `vllm` |
| llama.cpp CPU/Apple Silicon 推理 | `llama-cpp` / `gguf` |
| Modal 无服务器 GPU | `modal` |
| 结构化生成（JSON/代码保证） | `outlines` / `guidance` |
| **评测** | |
| LLM 学术评测（MMLU/HumanEval/GSM8K） | `lm-evaluation-harness` |
| 实验追踪与可视化 | `weights-and-biases` |
| **推理脚本** | |
| 脚本管理 | `inference` |
| **模型管理** | |
| HuggingFace Hub（模型/数据集） | `huggingface-hub` |
| 音频模型（MusicGen/AudioGen） | `audiocraft` |
| CLIP 视觉-语言 | `clip` |
| SAM 图像分割 | `segment-anything` |
| Whisper 语音识别 | `whisper` |
| Stable Diffusion 文生图 | `stable-diffusion` |
| 移除 LLM 拒答行为 | `obliteratus` |
| **云服务** | |
| Modal 无服务器 GPU | `modal` |
| **向量数据库** | |
| 向量数据库（待填充） | `vector-databases/` |

---

## Skill 详情

### 训练（training/）

| Skill | 用途 | 关键特性 |
|-------|------|---------|
| `peft` | LoRA/QLoRA 高效微调 | ≤1% 参数，HuggingFace 生态 |
| `unsloth` | 快速微调 | 2-5x 提速，50-80% 显存节省 |
| `axolotl` | 微调框架 | 100+ 模型，DPO/KTO/ORPO/GRPO |
| `trl-fine-tuning` | RLHF 全套 | SFT、DPO、PPO、GRPO |
| `grpo-rl-training` | GRPO 训练 | TRL 支持，推理优化 |
| `pytorch-fsdp` | 分布式训练 | 参数分片、混合精度、CPU卸载 |

### 推理与服务（inference/）

| Skill | 用途 | 关键特性 |
|-------|------|---------|
| `vllm` | vLLM 推理 | PagedAttention、连续批处理、OpenAI兼容 |
| `llama-cpp` | CPU/Apple Silicon | GGUF量化，消费级硬件 |
| `gguf` | GGUF 量化 | 2-8bit 量化，无需GPU |
| `outlines` | 结构化生成 | Pydantic模型，JSON保证 |
| `guidance` | 受控生成 | regex/grammar 约束 |

### 评测（evaluation/）

| Skill | 用途 | 关键特性 |
|-------|------|---------|
| `lm-evaluation-harness` | LLM 学术评测 | 60+基准，EleutherAI标准 |
| `weights-and-biases` | 实验追踪 | 实时可视化、超参搜索 |

### 云（cloud/）

| Skill | 用途 | 关键特性 |
|-------|------|---------|
| `modal` | 无服务器GPU | 按需GPU、自动扩缩容 |

---

## 重要约定

1. **微调之前**，先确认：数据集是否准备好、基座模型是否合适、目标硬件是否足够
2. **评测 LLM** → 永远用 `lm-evaluation-harness`，不用自己写的评测脚本
3. **生产推理** → 优先 `vllm`，次选 `llama-cpp`（无GPU时）
4. **分布式训练** → 8卡以上考虑 `pytorch-fsdp`，否则 `unsloth` 更简单
5. **量化推理** → 消费级硬件用 `gguf`，有GPU且需要高吞吐用 `vllm`

---

*本目录是 `skills/AGENTS.md` 的子地图，渐进式披露。*
