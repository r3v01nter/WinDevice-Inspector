# WinDevice-Inspector 文档冲突、重复与过期内容报告（WDI-AUDIT-0001）

- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **核对日期**：2026-11-19
- **审计原则**：所有冲突均优先如实记录并指向具体文件与条款，不自行擅自裁决产品方向或覆盖原始文档。

## 1. 不可变更技术约束合规性总检

对照本次任务书第三节的 **17 项不可变更技术约束**，逐一核对仓库现有全部 21 份文件：

- **总体结论**：现有文档与 17 项核心约束**不存在方向性冲突**。
- **1 处局部遗漏**：[docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) 明确禁止了启动、后台、定时、自动扫描，但**未显式写入“禁止自动重试扫描（no automatic retry）”**（该约束已在 [docs/TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) 第 3 节写明，建议在 `TASK-0001` 生产前补入）。

## 2. 文档冲突与口径不一致清单（按严重度排序）

| 编号 | 冲突/不一致主题 | 涉及文件 | 具体差异描述 | 风险与建议动作 |
| :---: | :--- | :--- | :--- | :--- |
| C-01 | **JSON 结果 Schema 字段不一致** | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 7 节） vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 架构第 7 节要求规范 JSON 至少包含 `timeZoneId`、`applicationVersion`，且每个类别含 `durationMs` 与查询窗口/参数；但 `TASK-0001` 的结果契约省略了这 4 项字段 | **高风险**：按当前 `TASK-0001` 实现会导致 Phase 1 产出的本地历史 JSON 与架构基线不兼容。建议在 `TASK-0001` 进入生产前补齐这 4 个字段，或在架构中标明为 Phase 2 可选扩展字段 |
| C-02 | **解决方案项目拆分数量不一致** | [ADR-0001-desktop-stack.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md) vs. [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 2 节） | `ADR-0001` 列出 5 个项目（`App`、`Core`、`Collectors`、`Diagnostics`、`Reporting`）；架构第 2 节列出 6 个项目（新增 `Persistence`） | **中风险**：按 [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) 文档优先级，已接受 ADR 高于架构文档。建议增补修订说明或小幅更新 `ADR-0001` 明确 `Persistence` 归属 |
| C-03 | **Windows PowerShell 回退条件表述有偏差** | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 5 节） vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 架构称“优先 PowerShell 7，仅在测试兼容时支持 Windows PowerShell”；`TASK-0001` 直接要求“优先 `pwsh.exe`，回退 `powershell.exe`” | **中风险**：Windows 11 默认仅预装 `powershell.exe`（5.1）而不预装 `pwsh.exe`（7）。建议由 ChatGPT/用户明确：Phase 1 脚本必须按 5.1/7 双兼容编写并测试，并将架构表述同步 |
| C-04 | **交付包结构与审查隔离规范差异** | [DELIVERY/INBOX/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/README.md) & [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) vs. 本次任务书（二.5） | 现有规范要求 `TASK-0001/` 含 `source/`、`tests/`、`docs/IMPLEMENTATION_NOTES.md`、`COMPLETION_RECEIPT.md`；新任务中心方案建议 `TASK-XXXX/` 含 `原始交付/`、`文件清单.md`、`完成回执.md`、`测试记录.md`、`已知问题.md`，并把审查材料独立放入 `docs/reviews/` | **中风险**：存在新旧两套交付结构。建议待用户确认统一方案后，一次性同步更新 `DELIVERY/` README、模板与 `TASK-0001` |
| C-05 | **任务状态词汇不统一且无状态机约束** | [PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) vs. [TASK_BRIEF_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/TASK_BRIEF_TEMPLATE.md) | `TASK-0001` 写作 `Ready for Gemini implementation`，`PROJECT_STATUS.md` 写作 `Ready for Gemini handoff`，缺乏标准化的 9 态流转与验收门槛 | **中风险**：后续多任务并行或返工时易混淆“已生成代码”“已审查”与“本机验收通过”。应统一采用任务书定义的 9 态状态机 |
| C-06 | **架构文档缺失打包分发设计章节** | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) & [ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md)（Phase 5） vs. [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) | 需求与路线图均锁定 V1 同时提供便携版与 Windows 安装版，但架构文档止于第 11 节（测试策略），未覆盖打包形态、运行时依赖及便携模式数据存储策略 | **低-中风险**：短期不阻塞 Phase 1，但建议在 Phase 2 持久化稳定前补写架构第 12 节或独立 ADR，避免便携模式与 `%LOCALAPPDATA%` 耦合 |
| C-07 | **Markdown 语法渲染缺陷** | [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md)（第 2 节） | 命名规范中的尖括号占位符未被反引号包裹，在 GitHub 网页端被 HTML 解析器吞掉，渲染为 `WinDeviceInspector..` 与 `WinDeviceInspector..Tests.` | **低风险（可读性缺陷）**：建议改为反引号格式（如 `` `WinDeviceInspector.<Project>` ``） |

## 3. 信息高度重复与维护漂移风险清单

以下内容在多份文件中重复书写，任何一次调整都需要同时修改 4–9 个文件，极易出现类似 [Cultivation-Fantasy](https://github.com/r3v01nter/Cultivation-Fantasy) 中 `任务中心/README.md` 停留在 `V6.8.7` 而 `当前任务.md` 已更新至 `V6.8.8` 的状态漂移问题：

| 重复主题 | 重复出现的文件集合 | 建议唯一事实源（SSOT） | 其他文件处理建议 |
| :--- | :--- | :--- | :--- |
| **17 项核心产品原则与禁止行为** | `README.md`、`CONTRIBUTING.md`、`PROJECT_OVERVIEW.md`、`PRODUCT_REQUIREMENTS.md`、`PROJECT_STATUS.md`、`TECHNICAL_ARCHITECTURE.md`、`ADR-0001`、`TASK-0001`、`TASK_BRIEF_TEMPLATE.md`（共 9 处） | [docs/PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) | 其他文档改为 3–5 行精简摘要 + 链接指向 SSOT；任务书仅引用基线并列出本任务特化约束 |
| **当前阶段与当前活跃任务指针** | `README.md`、`PROJECT_STATUS.md`、`ROADMAP.md`、`TASK-0001`、`src/README.md`（共 5 处） | 新建 `docs/task-center/CURRENT_TASK.md` 与 `TASK_INDEX.md` | `README.md`、`src/README.md` 等不硬编码当前任务号，统一指向 `CURRENT_TASK.md` |
| **AI 三方协作流程与交付目录规则** | `README.md`、`CONTRIBUTING.md`、`AI_COLLABORATION.md`、`REPOSITORY_STRUCTURE.md`、`DELIVERY/README.md`、`DELIVERY/INBOX/README.md`、`DELIVERY/ARCHIVE/README.md`（共 7 处） | [docs/AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)（流程）+ [DELIVERY/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/README.md)（交付结构） | 其余文件仅保留简短入口指引与链接 |
| **文档权责与冲突裁决优先级** | [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) 与 [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md)（第 3 节） | [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) | `REPOSITORY_STRUCTURE.md` 聚焦目录与命名规范，冲突优先级改链至 `docs/README.md` |
| **产品简介与目标清单** | `README.md`、`PROJECT_OVERVIEW.md`、`PRODUCT_REQUIREMENTS.md`（共 3 处） | 入口概览归 `README.md`，定位/愿景归 `PROJECT_OVERVIEW.md`，需求约束归 `PRODUCT_REQUIREMENTS.md` | 精简 `PROJECT_OVERVIEW.md` 与 `PRODUCT_REQUIREMENTS.md` 之间重叠的功能列举 |

## 4. 过期内容与待补齐缺口核查

- **是否已有完全过期的文档**：**无**。仓库所有 21 份文件均为近期（2026-11-16 至 2026-11-19）新建的初始文档基线，不存在历史遗留的废弃代码文档或旧架构废稿。
- **但存在以下“静态化风险 / 尚未闭环项”**：
  1. [docs/PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) 当前扮演了“半个任务中心 + 半个决策摘录”的角色；一旦开始多任务迭代，若继续手工维护其中的“仓库基础文件状态表”与“已确认产品决策”，会迅速过期。
  2. [docs/ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) Phase 0 的 `Select project license` 与 `Verify local development environment` 仍未打勾，需尽快闭环以免长期挂起。
  3. 缺少 `CHANGELOG.md`（项目变更历史）、`docs/reviews/`（独立审查与测试证据）、`docs/issues/`（缺陷与复验记录），导致未来审查意见无统一落脚点，极易散落在聊天记录或与原始交付混放。

## 5. 应集中管理的信息与单点真相源（SSOT）映射

| 信息类型 | 唯一事实源（SSOT） | 维护责任方 |
| :--- | :--- | :--- |
| 产品范围、用户行为、隐私与 V1 排除项 | `docs/PRODUCT_REQUIREMENTS.md` | 用户决策 + ChatGPT 维护 |
| 技术边界、模块依赖、JSON Schema、测试策略 | `docs/TECHNICAL_ARCHITECTURE.md` | ChatGPT 维护 |
| 不可逆/重大架构选型及理由 | `docs/decisions/ADR-XXXX-*.md` | ChatGPT 起草 + 用户批准 |
| 当前唯一活跃任务指针 | `docs/task-center/CURRENT_TASK.md` | ChatGPT/用户更新 |
| 全部任务全生命周期状态台账 | `docs/task-center/TASK_INDEX.md` | ChatGPT/用户更新 |
| 全部独立审查与测试证据台账 | `docs/task-center/REVIEW_INDEX.md` + `docs/reviews/` | ChatGPT 撰写 |
| 缺陷登记与本机复验记录 | `docs/issues/` | ChatGPT/用户维护 |
| 项目里程碑与变更历史 | `docs/task-center/CHANGELOG.md` | 随任务验收同步更新 |
| AI 三方协作规范与交付流程 | `docs/AI_COLLABORATION.md` | ChatGPT/用户维护 |
