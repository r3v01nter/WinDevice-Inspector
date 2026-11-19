# WinDevice-Inspector 建议新增、修改、合并与保留文件清单（WDI-AUDIT-0001）

- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **编制说明**：本清单严格区分**原始文件（现有 21 个）**与**变更建议**。本次审计未修改或覆盖任何原始文件，所有变更须经用户与技术负责人（ChatGPT）确认后再执行。

## 1. 现有 21 个原始文件处置总表

| 现有原始文件 | 建议动作 | 具体理由与改动边界 |
| :--- | :--- | :--- |
| [.editorconfig](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/.editorconfig) | **保留不动** | 编码与缩进规范完整，直接适配 .NET/WPF/PowerShell |
| [.gitignore](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/.gitignore) | **保留不动** | 已覆盖构建产物、测试报告与扫描隐私导出文件 |
| [DELIVERY/ARCHIVE/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/ARCHIVE/README.md) | **保留不动** | 归档目录占位与边界说明清晰 |
| [src/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/src/README.md) | **保留（微调可选）** | 保留占位说明；建议删去对特定任务号 `TASK-0001` 的硬编码，改链 `CURRENT_TASK.md` |
| [tests/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/tests/README.md) | **保留不动** | 测试放置与隐私/无扫描测试红线清晰 |
| [docs/PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) | **保留为核心 SSOT** | 产品需求第一权威基线，无方向冲突，无需重写 |
| [docs/PROJECT_OVERVIEW.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_OVERVIEW.md) | **保留（轻度去重）** | 保留项目定位、痛点与 5 大原则；精简与 `PRODUCT_REQUIREMENTS.md` 重复的功能细目，改加交叉链接 |
| [docs/ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) | **保留（同步状态）** | 保持 Phase 0–5 规划不变；待许可证选定与本机环境验证后勾选 Phase 0 剩余 2 项 |
| [README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/README.md) | **建议修改** | 1. 去掉对当前活跃任务号的静态硬编码，改链 `docs/task-center/CURRENT_TASK.md`；2. 精简重复的约束细目，指向 `PRODUCT_REQUIREMENTS.md`；3. 补充任务中心入口链接 |
| [CONTRIBUTING.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/CONTRIBUTING.md) | **建议修改** | 在“修改前必读”中增加 `docs/task-center/CURRENT_TASK.md`，协作细则改链 `AI_COLLABORATION.md` 以减少重复 |
| [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) | **建议修改** | 在索引中新增 `task-center/`、`reviews/`、`issues/` 入口，维持其作为“文档优先级唯一真相源”的定位 |
| [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md) | **建议修改** | 1. 修复第 2 节被 Markdown 吞掉的尖括号占位符（`WinDeviceInspector..` → `` `WinDeviceInspector.<Project>` ``）；2. 补入 `task-center/`、`reviews/`、`issues/` 目录说明；3. 第 3 节冲突优先级改为引用 `docs/README.md` |
| [docs/TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) | **建议修改** | 1. 与 `ADR-0001` 对齐 5/6 项目拆分（说明 `Persistence` 独立理由）；2. 明确第 5 节 `powershell.exe` 兼容回退条件；3. 后续增补“第 12 节：打包分发与便携/安装版数据路径策略” |
| [docs/decisions/ADR-0001-desktop-stack.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md) | **建议修改（附注修订）** | 保留原始决策正文，补充修订备注对齐 `WinDeviceInspector.Persistence` 项目（或在架构中注明 Phase 1 可先并入 `Core`） |
| [docs/AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md) | **建议修改** | 接入 9 态任务状态机、4 条验收铁律以及 `docs/reviews/`、`docs/issues/` 独立审查流转步骤；保持现有三方分工与手动投递流程不变 |
| [DELIVERY/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/README.md) | **建议修改** | 更新 `TASK-XXXX/` 标准交付目录结构（`原始交付/`、`文件清单.md`、`完成回执.md`、`测试记录.md`、`已知问题.md` 或英文对应名），明确审查文件不放收件箱 |
| [DELIVERY/INBOX/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/README.md) | **建议修改** | 与 `DELIVERY/README.md` 同步交付子目录结构，保留“严禁删除本占位文件”规则 |
| [docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | **建议修改（开工前对齐）** | 1. 元数据状态改为标准枚举 `待生产`；2. 补齐架构第 7 节的 4 个 JSON 字段（`timeZoneId`、`applicationVersion`、`durationMs`、查询参数）；3. 在强制规则中显式补入“禁止自动重试扫描”；4. 同步新交付包目录结构 |
| [docs/templates/TASK_BRIEF_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/TASK_BRIEF_TEMPLATE.md) | **建议修改** | 元数据状态字段改为 9 态+3 特殊态标准选项；更新第 9 节交付包目录模板；补入“禁止自动重试扫描” |
| [docs/templates/COMPLETION_RECEIPT_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/COMPLETION_RECEIPT_TEMPLATE.md) | **建议修改** | 对齐新交付包结构，明确与 `测试记录.md`、`已知问题.md`、`文件清单.md` 的分工，避免同一信息在回执和附件里重复手抄 |
| [docs/PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) | **建议合并 / 降级定位** | 当前内容与 `docs/task-center/` 高度重叠。**方案 A（推荐）**：将其拆解吸收进 `task-center/CURRENT_TASK.md` + `TASK_INDEX.md` + `CHANGELOG.md`，并把 `PROJECT_STATUS.md` 精简为指向任务中心的重定向页或里程碑快照；**方案 B**：保留作为面向外部读者的月度/阶段高阶摘要，删去重复的产品决策列表与逐文件状态表 |

## 2. 建议新增的文件清单

| 优先级 | 建议新增路径 | 文件类型 | 核心用途 |
| :---: | :--- | :--- | :--- |
| P0 | `LICENSE` | 仓库根文件 | 补齐 Phase 0 缺失项，明确开源/使用授权（需用户选定许可证类型） |
| P0 | `docs/task-center/README.md` | 任务中心 | 说明任务中心结构、9 态状态机、流转铁律与三方协作入口（不硬编码任务号） |
| P0 | `docs/task-center/CURRENT_TASK.md` | 任务中心 | 全仓库唯一当前任务指针 |
| P0 | `docs/task-center/TASK_INDEX.md` | 任务中心 | 全量任务生命周期台账（初始登记 `WDI-AUDIT-0001` 与 `TASK-0001`） |
| P0 | `docs/task-center/REVIEW_INDEX.md` | 任务中心 | 独立审查报告与本机验证记录索引 |
| P0 | `docs/task-center/CHANGELOG.md` | 任务中心 | 已验收变更历史（从 Phase 0 仓库基础建设起记） |
| P1 | `docs/reviews/README.md` | 审查目录占位 | 规定审查报告命名（`REV-TASK-XXXX-R1.md`）与“不与原始交付混放”原则 |
| P1 | `docs/issues/README.md` | 缺陷目录占位 | 规定缺陷单命名（`ISS-XXXX-slug.md`）与复验关闭条件 |
| P1 | `docs/templates/REVIEW_REPORT_TEMPLATE.md` | 模板 | ChatGPT 独立审查与用户本机验收记录标准模板 |
| P1 | `docs/templates/ISSUE_TEMPLATE.md` | 模板 | 缺陷登记与复验标准模板 |
| P2 | `docs/decisions/ADR-0002-packaging-and-data-paths.md` | 架构决策 | 明确便携版 vs Windows 安装版的打包方式与本地数据目录策略（可在 Phase 2 前补齐） |

## 3. 明确不建议做的变动（反过度治理红线）

1. **不搬迁 `docs/tasks/`、`docs/decisions/`、`docs/templates/`**：这三个目录已经就位且命名规范，直接复用即可，无需挪入 `task-center/` 内部造成大量失效链接。
2. **不删除 `DELIVERY/INBOX/README.md`、`DELIVERY/ARCHIVE/README.md`、`src/README.md`、`tests/README.md`**：Git 不跟踪空目录，这些占位文件是目录结构稳定性的保障。
3. **不拆分或重写 `docs/PRODUCT_REQUIREMENTS.md`**：该文件已是清晰且无冲突的最高基线，应以“其他文档向它对齐并去重”为原则，而不是重造新需求文档。
