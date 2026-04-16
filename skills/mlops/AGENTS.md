# MLOPS — 🤖 MLOps

> 入口：[skills/AGENTS.md](../AGENTS.md)
> 本文件由 `generate-agents.sh` 自动生成

---

## 快速路由

| 任务 | 使用 Skill |
|------|-----------|
| **cloud/** |
|   → Serverless GPU cloud platform for runnin… | `cloud/modal` |
| **evaluation/** |
|   → Evaluates LLMs across 60+ academic bench… | `evaluation/lm-evaluation-harness` |
|   → Track ML experiments with automatic logg… | `evaluation/weights-and-biases` |
| Hugging Face Hub CLI (hf) — search, download, and … | `huggingface-hub` |
| **inference/** |
|   → GGUF format and llama.cpp quantization f… | `inference/gguf` |
|   → Control LLM output with regex and gramma… | `inference/guidance` |
|   → Runs LLM inference on CPU, Apple Silicon… | `inference/llama-cpp` |
|   → Remove refusal behaviors from open-weigh… | `inference/obliteratus` |
|   → Guarantee valid JSON/XML/code structure … | `inference/outlines` |
|   → Serves LLMs with high throughput using v… | `inference/vllm` |
| **models/** |
|   → PyTorch library for audio generation inc… | `models/audiocraft` |
|   → OpenAI's model connecting vision and lan… | `models/clip` |
|   → Foundation model for image segmentation … | `models/segment-anything` |
|   → State-of-the-art text-to-image generatio… | `models/stable-diffusion` |
|   → OpenAI's general-purpose speech recognit… | `models/whisper` |
| **research/** |
|   → Build complex AI systems with declarativ… | `research/dspy` |
| **training/** |
|   → Expert guidance for fine-tuning LLMs wit… | `training/axolotl` |
|   → Expert guidance for GRPO/RL fine-tuning … | `training/grpo-rl-training` |
|   → Parameter-efficient fine-tuning for LLMs… | `training/peft` |
|   → Expert guidance for Fully Sharded Data P… | `training/pytorch-fsdp` |
|   → Fine-tune LLMs using reinforcement learn… | `training/trl-fine-tuning` |
|   → Expert guidance for fast fine-tuning wit… | `training/unsloth` |
| **vector-databases/** |

---

## Skill 详情

### 📁 cloud/

#### `modal`
- **描述：** Serverless GPU cloud platform for running ML workloads. Use when you need on-demand GPU access without infrastructure management, deploying ML models as APIs, or running batch jobs with automatic scaling.

### 📁 evaluation/

#### `lm-evaluation-harness`
- **描述：** Evaluates LLMs across 60+ academic benchmarks (MMLU, HumanEval, GSM8K, TruthfulQA, HellaSwag). Use when benchmarking model quality, comparing models, reporting academic results, or tracking training progress. Industry standard used by EleutherAI, HuggingFace, and major labs. Supports HuggingFace, vLLM, APIs.

#### `weights-and-biases`
- **描述：** Track ML experiments with automatic logging, visualize training in real-time, optimize hyperparameters with sweeps, and manage model registry with W&B - collaborative MLOps platform

### `huggingface-hub`
- **描述：** Hugging Face Hub CLI (hf) — search, download, and upload models and datasets, manage repos, query datasets with SQL, deploy inference endpoints, manage Spaces and buckets.

### 📁 inference/

#### `gguf`
- **描述：** GGUF format and llama.cpp quantization for efficient CPU/GPU inference. Use when deploying models on consumer hardware, Apple Silicon, or when needing flexible quantization from 2-8 bit without GPU requirements.

#### `guidance`
- **描述：** Control LLM output with regex and grammars, guarantee valid JSON/XML/code generation, enforce structured formats, and build multi-step workflows with Guidance - Microsoft Research's constrained generation framework

#### `llama-cpp`
- **描述：** Runs LLM inference on CPU, Apple Silicon, and consumer GPUs without NVIDIA hardware. Use for edge deployment, M1/M2/M3 Macs, AMD/Intel GPUs, or when CUDA is unavailable. Supports GGUF quantization (1.5-8 bit) for reduced memory and 4-10× speedup vs PyTorch on CPU.

#### `obliteratus`
- **描述：** Remove refusal behaviors from open-weight LLMs using OBLITERATUS — mechanistic interpretability techniques (diff-in-means, SVD, whitened SVD, LEACE, SAE decomposition, etc.) to excise guardrails while preserving reasoning. 9 CLI methods, 28 analysis modules, 116 model presets across 5 compute tiers, tournament evaluation, and telemetry-driven recommendations. Use when a user wants to uncensor, abliterate, or remove refusal from an LLM.

#### `outlines`
- **描述：** Guarantee valid JSON/XML/code structure during generation, use Pydantic models for type-safe outputs, support local models (Transformers, vLLM), and maximize inference speed with Outlines - dottxt.ai's structured generation library

#### `vllm`
- **描述：** Serves LLMs with high throughput using vLLM's PagedAttention and continuous batching. Use when deploying production LLM APIs, optimizing inference latency/throughput, or serving models with limited GPU memory. Supports OpenAI-compatible endpoints, quantization (GPTQ/AWQ/FP8), and tensor parallelism.

### 📁 models/

#### `audiocraft`
- **描述：** PyTorch library for audio generation including text-to-music (MusicGen) and text-to-sound (AudioGen). Use when you need to generate music from text descriptions, create sound effects, or perform melody-conditioned music generation.

#### `clip`
- **描述：** OpenAI's model connecting vision and language. Enables zero-shot image classification, image-text matching, and cross-modal retrieval. Trained on 400M image-text pairs. Use for image search, content moderation, or vision-language tasks without fine-tuning. Best for general-purpose image understanding.

#### `segment-anything`
- **描述：** Foundation model for image segmentation with zero-shot transfer. Use when you need to segment any object in images using points, boxes, or masks as prompts, or automatically generate all object masks in an image.

#### `stable-diffusion`
- **描述：** State-of-the-art text-to-image generation with Stable Diffusion models via HuggingFace Diffusers. Use when generating images from text prompts, performing image-to-image translation, inpainting, or building custom diffusion pipelines.

#### `whisper`
- **描述：** OpenAI's general-purpose speech recognition model. Supports 99 languages, transcription, translation to English, and language identification. Six model sizes from tiny (39M params) to large (1550M params). Use for speech-to-text, podcast transcription, or multilingual audio processing. Best for robust, multilingual ASR.

### 📁 research/

#### `dspy`
- **描述：** Build complex AI systems with declarative programming, optimize prompts automatically, create modular RAG systems and agents with DSPy - Stanford NLP's framework for systematic LM programming

### 📁 training/

#### `axolotl`
- **描述：** Expert guidance for fine-tuning LLMs with Axolotl - YAML configs, 100+ models, LoRA/QLoRA, DPO/KTO/ORPO/GRPO, multimodal support

#### `grpo-rl-training`
- **描述：** Expert guidance for GRPO/RL fine-tuning with TRL for reasoning and task-specific model training

#### `peft`
- **描述：** Parameter-efficient fine-tuning for LLMs using LoRA, QLoRA, and 25+ methods. Use when fine-tuning large models (7B-70B) with limited GPU memory, when you need to train <1% of parameters with minimal accuracy loss, or for multi-adapter serving. HuggingFace's official library integrated with transformers ecosystem.

#### `pytorch-fsdp`
- **描述：** Expert guidance for Fully Sharded Data Parallel training with PyTorch FSDP - parameter sharding, mixed precision, CPU offloading, FSDP2

#### `trl-fine-tuning`
- **描述：** Fine-tune LLMs using reinforcement learning with TRL - SFT for instruction tuning, DPO for preference alignment, PPO/GRPO for reward optimization, and reward model training. Use when need RLHF, align model with preferences, or train from human feedback. Works with HuggingFace Transformers.

#### `unsloth`
- **描述：** Expert guidance for fast fine-tuning with Unsloth - 2-5x faster training, 50-80% less memory, LoRA/QLoRA optimization

### 📁 vector-databases/

*最后生成：2026-04-16 10:10:33*
