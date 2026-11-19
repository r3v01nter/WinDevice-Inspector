# WinDevice-Inspector 统一任务中心设计方案（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（第二轮审查修订版）
- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **参考对象**：[r3v01nter/Cultivation-Fantasy](https://github.com/r3v01nter/Cultivation-Fantasy) 的 [任务中心/](https://github.com/r3v01nter/Cultivation-Fantasy/tree/main/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83) 单点指针与只增不改索引模式
- **方案状态**：建议设计方案（尚未在正式仓库中实施，待 ChatGPT 第二轮审查与用户最终确认后落地）
- **设计原则**：最大限度复用现有 `docs/` 与 `DELIVERY/` 结构，不无意义搬迁已有文件；严格对齐当前正式交付入口 **`DELIVERY/INBOX/待交付/`**，不恢复旧路径也不另建冲突入口；保留现有“Gemini 公开读仓并交付文件 → 用户核查放入交付入口 → ChatGPT 技术指导与独立审查 → 用户最终决策”的三方协作流程。

## 1. 借鉴 `Cultivation-Fantasy` 的工程化改良要点

通过核查 [Cultivation-Fantasy/任务中心/](https://github.com/r3v01nter/Cultivation-Fantasy/tree/main/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83)，提炼 3 条适用于 `WinDevice-Inspector` 的经验与避坑点：

1. **保留单点当前任务指针（`CURRENT_TASK.md`）**：借鉴其 [当前任务.md](https://github.com/r3v01nter/Cultivation-Fantasy/blob/main/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%BD%93%E5%89%8D%E4%BB%BB%E5%8A%A1.md) 设计，整个仓库只在 `docs/task-center/CURRENT_TASK.md` 一处声明当前唯一活跃任务。
2. **避免总说明硬编码任务号（教训规避）**：在 `Cultivation-Fantasy` 中，[任务中心/README.md](https://github.com/r3v01nter/Cultivation-Fantasy/tree/main/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83) 曾滞后于 `当前任务.md`（前者写 `V6.8.7`，后者已至 `V6.8.8`）。因此本方案规定：`docs/task-center/README.md`、`README.md`、`src/README.md` 等**一律不硬编码当前任务号**，只链接 `CURRENT_TASK.md`。
3. **补齐软件工程必需的审查、缺陷与本机验证门禁**：桌面软件工程必须将“代码生成”“独立代码审查”“自动化测试”“本机 Windows 11 x64 编译运行与硬件实测”严格解耦，因此建议增设 `docs/reviews/`、`docs/issues/`、`REVIEW_INDEX.md` 与 `CHANGELOG.md`。

## 2. 推荐目录结构（复用优先）

在完整保留现有 `docs/tasks/`、`docs/decisions/`、`docs/templates/` 与 `DELIVERY/` 路径的前提下，仅做增量扩展（以下标注 `[新增]` 均为建议项，尚未实施）：

```text
docs/
├── README.md                      # [保留并更新] 文档总导航与冲突裁决优先级（SSOT）
├── PROJECT_OVERVIEW.md            # [保留] 项目定位、痛点与愿景
├── PRODUCT_REQUIREMENTS.md        # [保留] 产品需求与不可变更约束（SSOT）
├── TECHNICAL_ARCHITECTURE.md      # [保留并补全] 技术架构与 Schema（SSOT）
├── REPOSITORY_STRUCTURE.md        # [保留并修复] 目录规范与命名约定
├── ROADMAP.md                     # [保留] 中长期阶段路线图
├── AI_COLLABORATION.md            # [保留并升级] 三方协作流程、正式交付入口与状态机对接
├── PROJECT_STATUS.md              # [待用户决定] 合并入 task-center 或保留为高阶快照
├── task-center/                   # [建议新增] 统一任务中心
│   ├── README.md                  # 任务中心使用规则、状态机定义与入口（不硬编码任务号）
│   ├── CURRENT_TASK.md            # 唯一当前任务指针（SSOT）
│   ├── TASK_INDEX.md              # 全部任务台账（只增不删，含状态与关联链接）
│   ├── REVIEW_INDEX.md            # 全部独立审查与验证记录索引
│   └── CHANGELOG.md               # 项目开发与验收变更历史
├── tasks/                         # [复用] 历次任务书（只增不改历史，如 TASK-0001-vertical-slice.md）
├── reviews/                       # [建议新增] ChatGPT 独立审查报告与本机验证证据（与原始交付物理隔离）
│   └── README.md
├── issues/                        # [建议新增] 缺陷登记、根因追踪与复验记录
│   └── README.md
├── decisions/                     # [复用] 架构决策记录（如 ADR-0001-desktop-stack.md）
└── templates/                     # [复用并扩充] 任务书、回执、审查报告、缺陷单模板
```

## 3. 核心索引文件字段规范与 `TASK-0001` 指针关系

### 3.1 `docs/task-center/CURRENT_TASK.md`（唯一当前任务指针）

- **与 `TASK-0001` 的关系**：当前审计任务 `WDI-AUDIT-0001` 仍处于审查修订阶段，任务中心尚未正式落地；待本方案获批落地且 `TASK-0001` 完成开工前文档对齐（JSON Schema 字段、PowerShell 兼容性测试口径、正式交付入口同步）后，`CURRENT_TASK.md` 才将唯一指针切换至 `TASK-0001`（状态为 `待生产`）。
- 建议包含以下固定元数据区块（下表为落地切换至 `TASK-0001` 后的示意格式）：

| 字段 | 说明 | 落地后切换至 `TASK-0001` 的示意值 |
| :--- | :--- | :--- |
| 当前任务编号 | 唯一活跃任务 ID | `TASK-0001` |
| 当前任务名称 | 与任务书标题一致 | First Runnable Vertical Slice |
| 当前状态 | 严格取自第 4 节 9 态枚举 | `待生产` |
| 任务书链接 | 仓库内相对路径 + Raw 链接 | `docs/tasks/TASK-0001-vertical-slice.md` |
| 上游基线 | 依赖的文档版本或前置任务 | `PRODUCT_REQUIREMENTS.md`、`ADR-0001`、`TECHNICAL_ARCHITECTURE.md` |
| 正式交付入口 | 固定指向当前正式交付入口 | `DELIVERY/INBOX/待交付/`（本任务包置于其下 `TASK-0001/`） |
| 最新审查记录 | 关联的审查文件路径或“暂无” | 暂无 |
| 最后更新日期 | YYYY-MM-DD | （以实际更新日为准） |

### 3.2 `docs/task-center/TASK_INDEX.md`（全量任务台账）

表格字段：`任务编号 | 任务名称 | 所属阶段 | 当前状态 | 任务书 | 交付入口/归档位置 | 审查记录 | 最后更新 | 备注`。历史任务只增不删，完成后转为 `验收通过` 或 `已归档`。

### 3.3 `docs/task-center/REVIEW_INDEX.md`（独立审查索引）

表格字段：`审查编号 | 关联任务 | 审查轮次 | 审查人 | 审查日期 | 审查结论（通过/需返工/阻塞） | 本机验证状态 | 审查报告路径`。

### 3.4 `docs/task-center/CHANGELOG.md`（开发变更历史）

仅记录**已正式合入 `main` 分支且有证据支持**的变更（如基线文档建立、任务验收通过、架构决策更新），严禁将尚未验收的计划或建议写入变更日志。

## 4. 严格任务状态体系与流转门禁

### 4.1 标准主流程（9 态）

`待规划` → `待生产` → `生产中` → `待交付` → `审查中` → `返工中`（如需，返回 `待交付`/`审查中`） → `待本机验证` → `验收通过` → `已归档`

### 4.2 特殊终止/挂起状态（3 态）

- `已暂停`：因外部依赖或优先级调整临时搁置，需记录暂停原因与恢复条件。
- `已取消`：需求变更或方向调整后不再执行，保留记录不删除。
- `被其他任务替代`：原任务拆解或合并至新任务书，须注明替代任务编号。

### 4.3 强制流转门禁（铁律）

| 状态跃迁 | 必需前置证据 | 禁止跨越的红线 |
| :--- | :--- | :--- |
| `待规划` → `待生产` | 任务书经 ChatGPT 审核、无未决阻断性口径差异、用户批准启动 | 存在未决阻断性 Schema/架构口径问题时不得进入生产 |
| `生产中` → `待交付` | Gemini 输出完整交付包与如实填写的完成回执 | **Gemini 生成代码不代表任务完成** |
| `待交付` → `审查中` | 用户检查交付内容无敏感信息后，手动放入正式交付入口 **`DELIVERY/INBOX/待交付/`** | 禁止 Gemini 直接提交仓库；禁止另建冲突交付入口 |
| `审查中` → `待本机验证` | ChatGPT 在 `docs/reviews/` 出具独立审查报告，结论为“代码审查通过” | **代码审查通过不代表本机运行通过** |
| `审查中` → `返工中` | ChatGPT 出具审查意见并登记缺陷至 `docs/issues/` | 不得口头返工而不留存审查/缺陷记录 |
| `待本机验证` → `验收通过` | 用户在 Windows 11 x64 本机完成编译、测试、非管理员真实运行与核心交互核验，并在 `docs/reviews/` 留存测试证据 | **构建通过不代表功能验收通过；未经实际验证，绝不得标记为验收通过** |
| `验收通过` → `已归档` | 代码/文档已合入主目录，原交付包按需移至 `DELIVERY/ARCHIVE/TASK-XXXX/`，`CHANGELOG.md` 已更新 | 不得将归档包当作主源码树引用 |

## 5. 统一交付与独立审查分离规范

保留用户现有三方协作闭环，**严格沿用当前正式交付入口 `DELIVERY/INBOX/待交付/`**，不得恢复旧的 `DELIVERY/INBOX/TASK-XXXX/` 顶层结构或新增冲突入口：

### 5.1 正式交付入口与任务包结构

```text
DELIVERY/INBOX/待交付/
└── TASK-XXXX/             # 当前待审任务交付包（由用户核查后放入正式入口）
    ├── 原始交付/          # Gemini 产出的全部源码、测试、脚本与任务内文档（原样保留）
    ├── 文件清单.md        # 本次交付全部文件的路径、用途与校验摘要
    ├── 完成回执.md        # 遵循回执模板：改动摘要、命令执行实况（未执行标 Not run）、自检表
    ├── 测试记录.md        # 已执行测试与未执行测试清单（严禁虚构本机测试结果）
    └── 已知问题.md        # 遗留限制、未覆盖场景、待本机确认的风险点
```

*(注：关于任务包内部 5 项文件采用中文名还是英文名 `raw-delivery/`、`FILE_MANIFEST.md`、`COMPLETION_RECEIPT.md`、`TEST_LOG.md`、`KNOWN_ISSUES.md`，列为待用户决策项 D-05；无论内部采用何种语言，外部正式入口统一为 `DELIVERY/INBOX/待交付/`。)*

### 5.2 审查与缺陷隔离存储

- **独立审查报告**：存放于 `docs/reviews/REV-TASK-XXXX-R1.md`（R1/R2 表示审查轮次），由 ChatGPT 撰写并可附带用户的本机验证记录，**严禁混入 `DELIVERY/INBOX/待交付/` 下的原始交付目录**。
- **缺陷与复验记录**：存放于 `docs/issues/ISS-XXXX-<short-slug>.md`，记录缺陷现象、复现步骤、关联任务、修复任务及复验结果（通过/未通过）。
- **审后归档**：任务验收通过后，待交付区对应包可按需移至 `DELIVERY/ARCHIVE/TASK-XXXX/` 留存备查，但主源码与正式文档仍归位至 `src/`、`tests/`、`docs/`。
