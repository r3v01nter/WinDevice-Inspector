# WinDevice-Inspector 文档冲突、重复与过期内容报告（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（第二轮审查修订版）
- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **审计快照基准日期**：2026-11-19（截至提交 `29758c5`，共 21 个文件；历史快照，不代表当前实时仓库状态）
- **审计原则**：所有差异均如实记录并指向具体文件与条款，区分“架构/契约不一致”“测试与说明待补全”“流程路径待同步”与“格式缺陷”，不自行裁决产品方向，不覆盖原始文档。

## 1. 不可变更技术约束合规性总检

对照本次任务书第三节的 **17 项不可变更技术约束**，逐一核对 2026-11-19 快照中的全部 21 份文件：

- **总体结论**：现有文档与全部 17 项不可变更技术约束**完全一致，不存在方向性冲突，也不存在核心红线约束缺失**。
- **专项复核确认**：经第二轮复核确认，[docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) **第 6 节已经明确禁止未经用户确认的自动重试扫描**，与 [docs/TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) 第 3 节及产品需求保持一致（已修正首轮报告中对此项的误判）。

## 2. 文档不一致、待明确项与缺陷清单（按性质与优先级分类）

| 编号 | 主题与分类 | 涉及文件 | 具体差异与事实核对 | 风险评估与建议处理 |
| :---: | :--- | :--- | :--- | :--- |
| C-01 | **JSON 结果 Schema 字段不一致**（契约差异） | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 7 节） vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 架构第 7 节要求规范 JSON 至少包含 `timeZoneId`、`applicationVersion`，且每个类别含 `durationMs` 与查询窗口/参数；而 `TASK-0001` 的结果契约未列出这 4 项字段 | **高优先级**：若按当前 `TASK-0001` 实现，Phase 1 产出的本地历史 JSON 将与架构基线字段不一致。建议在 `TASK-0001` 进入生产前由 ChatGPT/用户明确：是提前补齐这 4 个字段，还是在架构中标明为 Phase 2 可选扩展字段 |
| C-02 | **解决方案项目拆分数量不一致**（架构口径差异） | [ADR-0001-desktop-stack.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md) vs. [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 2 节） | `ADR-0001` 列出 5 个项目（`App`、`Core`、`Collectors`、`Diagnostics`、`Reporting`）；架构第 2 节列出 6 个项目（新增 `Persistence`） | **中优先级**：按 [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) 文档优先级，已接受 ADR 高于架构文档。建议补充修订备注对齐 `Persistence` 归属（或在架构中注明 Phase 1 可先并入 `Core`） |
| C-03 | **PowerShell 兼容性测试要求尚未明确**（测试与说明待补全，非架构冲突） | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 5 节） vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 架构第 5 节定义的是**架构允许的兼容条件**（优先 PowerShell 7，在经过兼容性测试验证的前提下支持 Windows PowerShell）；`TASK-0001` 定义的是**具体回退实现要求**（优先 `pwsh.exe`，回退 `powershell.exe`）。两者并无不可调和的架构矛盾，但目前缺少针对 Windows PowerShell 5.1 与 PowerShell 7 双环境的兼容性测试范围与验收标准说明 | **中优先级（可通过测试与文档补充解决）**：建议在测试策略与 `TASK-0001` 验收清单中补充 PowerShell 5.1 / 7 兼容性测试要求（如字符编码、JSON 序列化行为与非管理员实测项），使架构条件与任务回退要求形成闭环 |
| C-04 | **交付入口路径与审查隔离规范待同步**（流程路径待对齐） | [DELIVERY/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/README.md)、[DELIVERY/INBOX/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/README.md)、[AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)、[TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 2026-11-19 快照中的旧文档仍写交付路径为 `DELIVERY/INBOX/TASK-XXXX/`（内含 `source/`、`tests/` 等）；当前正式交付入口已确定为 **`DELIVERY/INBOX/待交付/`**，且新任务中心方案要求交付包采用 `原始交付/` + 4 份配套文件，并将审查报告独立存放于 `docs/reviews/` | **中优先级**：需将上述旧文档中的路径说明统一更新指向 `DELIVERY/INBOX/待交付/`，不得恢复旧的 `DELIVERY/INBOX/TASK-XXXX/` 入口，避免形成双入口冲突 |
| C-05 | **任务状态词汇不统一且缺少状态机约束**（管理口径待统一） | [PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) vs. [TASK_BRIEF_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/TASK_BRIEF_TEMPLATE.md) | 快照中 `TASK-0001` 写作 `Ready for Gemini implementation`，`PROJECT_STATUS.md` 写作 `Ready for Gemini handoff`，缺乏标准化的 9 态流转与本机验收门禁 | **中优先级**：建议统一采用 9 态主流程 + 3 特殊态，并与 `docs/task-center/TASK_INDEX.md` 绑定 |
| C-06 | **架构文档尚未覆盖打包分发设计**（设计待补全） | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) & [ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md)（Phase 5） vs. [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) | 需求与路线图均锁定 V1 同时提供便携版与 Windows 安装版，但架构文档止于第 11 节（测试策略），尚未写明打包形态、运行时依赖及便携模式数据目录策略 | **低-中优先级**：短期不阻塞 `TASK-0001`，但建议在 Phase 2 持久化定型前补写架构第 12 节或独立 `ADR-0002`，避免便携模式与 `%LOCALAPPDATA%` 路径耦合 |
| C-07 | **Markdown 语法渲染缺陷**（格式缺陷） | [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md)（第 2 节） | 命名规范中的尖括号占位符未被反引号包裹，在 GitHub 网页端被 HTML 解析器吞掉，渲染为 `WinDeviceInspector..` 与 `WinDeviceInspector..Tests.` | **低优先级**：建议改为反引号格式（如 `` `WinDeviceInspector.<Project>` ``） |

## 3. 信息高度重复与维护漂移风险清单

以下内容在 2026-11-19 快照的多份文件中重复书写，任何一次调整都需要同时修改多处，极易出现类似 [Cultivation-Fantasy](https://github.com/r3v01nter/Cultivation-Fantasy) 中 `任务中心/README.md` 滞后于 `当前任务.md` 的状态漂移问题：

| 重复主题 | 重复出现的文件集合 | 建议唯一事实源（SSOT） | 其他文件处理建议 |
| :--- | :--- | :--- | :--- |
| **17 项核心产品原则与禁止行为** | `README.md`、`CONTRIBUTING.md`、`PROJECT_OVERVIEW.md`、`PRODUCT_REQUIREMENTS.md`、`PROJECT_STATUS.md`、`TECHNICAL_ARCHITECTURE.md`、`ADR-0001`、`TASK-0001`、`TASK_BRIEF_TEMPLATE.md`（共 9 处） | [docs/PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) | 其他文档改为 3–5 行精简摘要 + 链接指向 SSOT；任务书仅引用基线并列出本任务特化约束 |
| **当前阶段与当前活跃任务指针** | `README.md`、`PROJECT_STATUS.md`、`ROADMAP.md`、`TASK-0001`、`src/README.md`（共 5 处） | 建议新建 `docs/task-center/CURRENT_TASK.md` 与 `TASK_INDEX.md` | `README.md`、`src/README.md` 等不硬编码当前任务号，统一指向 `CURRENT_TASK.md` |
| **AI 三方协作流程与交付目录规则** | `README.md`、`CONTRIBUTING.md`、`AI_COLLABORATION.md`、`REPOSITORY_STRUCTURE.md`、`DELIVERY/README.md`、`DELIVERY/INBOX/README.md`、`DELIVERY/ARCHIVE/README.md`（共 7 处） | [docs/AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)（流程）+ [DELIVERY/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/README.md)（交付结构与 `DELIVERY/INBOX/待交付/` 入口） | 其余文件仅保留简短入口指引与链接 |
| **文档权责与冲突裁决优先级** | [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) 与 [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md)（第 3 节） | [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) | `REPOSITORY_STRUCTURE.md` 聚焦目录与命名规范，冲突优先级改链至 `docs/README.md` |
| **产品简介与目标清单** | `README.md`、`PROJECT_OVERVIEW.md`、`PRODUCT_REQUIREMENTS.md`（共 3 处） | 入口概览归 `README.md`，定位/愿景归 `PROJECT_OVERVIEW.md`，需求约束归 `PRODUCT_REQUIREMENTS.md` | 精简 `PROJECT_OVERVIEW.md` 与 `PRODUCT_REQUIREMENTS.md` 之间重叠的功能列举 |

## 4. 过期内容与待补齐缺口核查（截至 2026-11-19 快照）

- **是否已有完全过期的文档**：**无**。快照中的全部 21 份文件均为近期（2026-11-16 至 2026-11-19）新建的初始文档基线，不存在历史遗留的废弃代码文档或旧架构废稿。
- **但存在以下“静态化风险 / 尚未闭环项”**：
  1. [docs/PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) 当前扮演了“半个任务中心 + 半个决策摘录”的角色；一旦开始多任务迭代，若继续手工维护其中的逐文件状态表与产品决策摘录，会迅速过期。
  2. [docs/ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) Phase 0 的 `Select project license` 与 `Verify local development environment` 在快照时刻仍未打勾，需尽快闭环。
  3. 快照中尚无 `CHANGELOG.md`、`docs/reviews/`、`docs/issues/`，且旧交付说明尚未更新至当前正式入口 `DELIVERY/INBOX/待交付/`。

## 5. 应集中管理的信息与单点真相源（SSOT）建议映射

*(注：以下为建议方案，尚未在正式仓库中实施，待用户确认后落地。)*

| 信息类型 | 建议唯一事实源（SSOT） | 维护责任方 |
| :--- | :--- | :--- |
| 产品范围、用户行为、隐私与 V1 排除项 | `docs/PRODUCT_REQUIREMENTS.md` | 用户决策 + ChatGPT 维护 |
| 技术边界、模块依赖、JSON Schema、测试策略 | `docs/TECHNICAL_ARCHITECTURE.md` | ChatGPT 维护 |
| 不可逆/重大架构选型及理由 | `docs/decisions/ADR-XXXX-*.md` | ChatGPT 起草 + 用户批准 |
| 当前唯一活跃任务指针 | `docs/task-center/CURRENT_TASK.md`（建议新增） | ChatGPT/用户更新 |
| 全部任务全生命周期状态台账 | `docs/task-center/TASK_INDEX.md`（建议新增） | ChatGPT/用户更新 |
| 全部独立审查与测试证据台账 | `docs/task-center/REVIEW_INDEX.md` + `docs/reviews/`（建议新增） | ChatGPT 撰写 |
| 缺陷登记与本机复验记录 | `docs/issues/`（建议新增） | ChatGPT/用户维护 |
| 项目里程碑与变更历史 | `docs/task-center/CHANGELOG.md`（建议新增） | 随任务验收同步更新 |
| AI 三方协作规范与交付入口 | `docs/AI_COLLABORATION.md` + `DELIVERY/README.md`（指向 `DELIVERY/INBOX/待交付/`） | ChatGPT/用户维护 |
