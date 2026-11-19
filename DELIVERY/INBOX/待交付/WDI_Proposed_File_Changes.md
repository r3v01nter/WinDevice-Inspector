# WinDevice-Inspector 建议新增、修改、合并与保留文件清单（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（第二轮审查修订版）
- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **审计快照基准日期**：2026-11-19（截至提交 `29758c5`，共 21 个原始文件；历史快照，不代表当前实时仓库状态）
- **编制说明**：本清单严格区分**原始文件（2026-11-19 快照中的 21 个）**与**建议变更项（均尚未实施）**。本次审计未修改或覆盖任何原始文件，所有变更须经 ChatGPT 审查及用户最终确认后再执行。

## 1. 2026-11-19 快照中 21 个原始文件处置建议表

| 现有原始文件（快照） | 建议动作 | 具体理由与改动边界 |
| :--- | :--- | :--- |
| [.editorconfig](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/.editorconfig) | **保留不动** | 编码与缩进规范完整，直接适配 .NET/WPF/PowerShell |
| [.gitignore](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/.gitignore) | **保留不动** | 已覆盖构建产物、测试报告与扫描隐私导出文件 |
| [DELIVERY/ARCHIVE/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/ARCHIVE/README.md) | **保留不动** | 归档目录占位与边界说明清晰 |
| [src/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/src/README.md) | **保留（微调可选）** | 保留占位说明；建议删去对特定任务号 `TASK-0001` 的硬编码，改链 `docs/task-center/CURRENT_TASK.md` |
| [tests/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/tests/README.md) | **保留不动** | 测试放置与隐私/无扫描测试红线清晰 |
| [docs/PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) | **保留为核心 SSOT** | 产品需求第一权威基线，与 17 项不可变更约束完全一致，无需重写 |
| [docs/PROJECT_OVERVIEW.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_OVERVIEW.md) | **保留（轻度去重）** | 保留项目定位、痛点与 5 大原则；精简与 `PRODUCT_REQUIREMENTS.md` 重复的功能细目，改加交叉链接 |
| [docs/ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) | **保留（同步状态）** | 保持 Phase 0–5 规划不变；待用户选定许可证并完成本机环境验证后勾选 Phase 0 剩余 2 项 |
| [README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/README.md) | **建议修改** | 1. 去掉对当前活跃任务号的静态硬编码，改链 `docs/task-center/CURRENT_TASK.md`；2. 精简重复的约束细目，指向 `PRODUCT_REQUIREMENTS.md`；3. 补充任务中心入口链接 |
| [CONTRIBUTING.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/CONTRIBUTING.md) | **建议修改** | 在“修改前必读”中增加 `docs/task-center/CURRENT_TASK.md`，协作细则改链 `AI_COLLABORATION.md` 以减少重复 |
| [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) | **建议修改** | 在索引中新增 `task-center/`、`reviews/`、`issues/` 入口，维持其作为“文档优先级唯一真相源”的定位 |
| [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md) | **建议修改** | 1. 修复第 2 节被 Markdown 吞掉的尖括号占位符（`WinDeviceInspector..` → `` `WinDeviceInspector.<Project>` ``）；2. 补入 `task-center/`、`reviews/`、`issues/` 及正式交付入口 `DELIVERY/INBOX/待交付/` 说明；3. 第 3 节冲突优先级改为引用 `docs/README.md` |
| [docs/TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) | **建议修改** | 1. 与 `ADR-0001` 对齐 5/6 项目拆分（说明 `Persistence` 独立理由）；2. 在第 5 节与第 11 节补充 PowerShell 5.1 / 7 兼容性测试要求与验收口径；3. 后续增补“第 12 节：打包分发与便携/安装版数据路径策略” |
| [docs/decisions/ADR-0001-desktop-stack.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md) | **建议修改（附注修订）** | 保留原始决策正文，补充修订备注对齐 `WinDeviceInspector.Persistence` 项目（或在架构中注明 Phase 1 可先并入 `Core`） |
| [docs/AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md) | **建议修改** | 将旧交付路径更新为当前正式入口 **`DELIVERY/INBOX/待交付/`**，接入 9 态任务状态机、4 条验收铁律以及 `docs/reviews/`、`docs/issues/` 独立审查流转步骤；保持现有三方分工与手动投递流程不变 |
| [DELIVERY/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/README.md) | **建议修改** | 更新正式交付入口说明为 **`DELIVERY/INBOX/待交付/`**（不再沿用旧路径 `DELIVERY/INBOX/TASK-XXXX/`），明确交付包内部结构（`原始交付/` + 4 份配套文件）及“审查材料不放入收件箱”原则 |
| [DELIVERY/INBOX/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/README.md) | **建议修改** | 与 `DELIVERY/README.md` 同步更新为 **`DELIVERY/INBOX/待交付/`** 入口规范，保留“严禁删除占位 README”规则 |
| [docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | **建议修改（开工前对齐）** | 1. 元数据状态改为标准枚举 `待生产`；2. 按用户/ChatGPT 裁定对齐架构第 7 节的 4 个 JSON 字段（`timeZoneId`、`applicationVersion`、`durationMs`、查询参数）；3. 补充 PowerShell 5.1 / 7 兼容性测试要求说明；4. 将交付入口更新为 **`DELIVERY/INBOX/待交付/`** 并同步交付包内部结构（注：第 6 节已明确禁止未经确认的自动重试扫描，保持不变） |
| [docs/templates/TASK_BRIEF_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/TASK_BRIEF_TEMPLATE.md) | **建议修改** | 元数据状态字段改为 9 态+3 特殊态标准选项；更新第 9 节交付入口为 `DELIVERY/INBOX/待交付/` 与标准交付包结构 |
| [docs/templates/COMPLETION_RECEIPT_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/COMPLETION_RECEIPT_TEMPLATE.md) | **建议修改** | 对齐新交付包结构，明确与 `测试记录.md`、`已知问题.md`、`文件清单.md` 的分工，避免同一信息在回执和附件里重复手抄 |
| [docs/PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) | **待用户决策（合并或降级）** | 当前内容与建议新建的 `docs/task-center/` 高度重叠。**方案 A**：拆解吸收进 `task-center/`，并将本文件精简为指向任务中心的跳转页；**方案 B**：保留作为面向外部读者的阶段高层摘要，删去重复的产品决策列表与逐文件状态表 |

## 2. 建议新增的文件清单（均尚未实施）

| 优先级 | 建议新增路径 | 文件类型 | 核心用途 |
| :---: | :--- | :--- | :--- |
| P0 | `LICENSE` | 仓库根文件 | 补齐 Phase 0 缺失项，明确开源/使用授权（须由用户选定许可证类型） |
| P0 | `docs/task-center/README.md` | 任务中心 | 说明任务中心结构、9 态状态机、流转铁律与三方协作入口（不硬编码任务号） |
| P0 | `docs/task-center/CURRENT_TASK.md` | 任务中心 | 全仓库唯一当前任务指针 |
| P0 | `docs/task-center/TASK_INDEX.md` | 任务中心 | 全量任务生命周期台账（初始登记 `WDI-AUDIT-0001` 与 `TASK-0001`） |
| P0 | `docs/task-center/REVIEW_INDEX.md` | 任务中心 | 独立审查报告与本机验证记录索引 |
| P0 | `docs/task-center/CHANGELOG.md` | 任务中心 | 已验收变更历史（仅记录已合入 `main` 且有证据的变更） |
| P1 | `docs/reviews/README.md` | 审查目录占位 | 规定审查报告命名（`REV-TASK-XXXX-R1.md`）与“不与 `DELIVERY/INBOX/待交付/` 原始交付混放”原则 |
| P1 | `docs/issues/README.md` | 缺陷目录占位 | 规定缺陷单命名（`ISS-XXXX-slug.md`）与复验关闭条件 |
| P1 | `docs/templates/REVIEW_REPORT_TEMPLATE.md` | 模板 | ChatGPT 独立审查与用户本机验收记录标准模板 |
| P1 | `docs/templates/ISSUE_TEMPLATE.md` | 模板 | 缺陷登记与复验标准模板 |
| P2 | `docs/decisions/ADR-0002-packaging-and-data-paths.md` | 架构决策 | 明确便携版 vs Windows 安装版的打包方式与本地数据目录策略（建议在 Phase 2 持久化定型前补齐） |

## 3. 明确不建议做的变动（反过度治理红线）

1. **不搬迁 `docs/tasks/`、`docs/decisions/`、`docs/templates/`**：这三个目录已经就位且命名规范，直接复用即可，无需挪入 `task-center/` 内部造成大量失效链接。
2. **不恢复旧的 `DELIVERY/INBOX/TASK-XXXX/` 顶层交付入口**：统一以当前正式交付入口 `DELIVERY/INBOX/待交付/` 为准，避免并存双入口。
3. **不删除占位 README**：保留 `DELIVERY/INBOX/README.md`、`DELIVERY/ARCHIVE/README.md`、`src/README.md`、`tests/README.md` 等占位文件，保障 Git 目录结构稳定。
4. **不拆分或重写 `docs/PRODUCT_REQUIREMENTS.md`**：该文件已是清晰且无冲突的最高基线，应以“其他文档向它对齐并去重”为原则。
