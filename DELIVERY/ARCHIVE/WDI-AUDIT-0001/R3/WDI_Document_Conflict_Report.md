# WinDevice-Inspector 文档冲突、重复与过期内容报告（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（R3 返修版）
- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **多时间点基准说明**：
  - 初始全量审计快照：`2026-11-19`（短提交 `29758c5`，21 个文件；完整 40 位 SHA 未反查，不猜测）
  - R2 独立审查基准：`2026-11-20`（完整提交 `fa8a54d0fc1c81b4423df015251a310e95e3b6d7`）
  - R3 返修实测核对基准：短提交 `397e53a`（累计 100 Commits，完整 40 位 SHA 未反查，不猜测）
- **审计原则**：区分“已于后续提交解决的管理问题”与“截至 R3 仍待决定的技术/文档问题”，不自行裁决未决技术事项，不覆盖原始文档。

## 1. 不可变更技术约束合规性总检

对照项目确认的 **17 项不可变更技术约束**：

- **总体结论**：现有文档与全部 17 项不可变更技术约束**完全一致，不存在方向性冲突，也不存在核心红线约束缺失**。
- **专项核验确认**：[docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md)（`29758c5`）**第 6 节明确规定** `Do not add scheduled/background scanning or automatic retries that start a new scan without confirmation.`，已清晰禁止未经用户确认的自动重试扫描，与 [docs/TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) 第 3 节及产品需求保持一致。

## 2. 仍待处理的技术口径差异与文档缺陷清单（未擅自裁决）

| 编号 | 主题与分类 | 涉及文件 | 具体差异与事实核对 | 风险评估与建议处理 |
| :---: | :--- | :--- | :--- | :--- |
| C-01 | **JSON 结果 Schema 字段不一致**（契约差异，待决策） | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 7 节） vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 架构第 7 节要求规范 JSON 至少包含 `timeZoneId`、`applicationVersion`，且每个类别含 `durationMs` 与查询窗口/参数；`TASK-0001` 的结果契约未列出这 4 项字段 | **高优先级（待决策）**：建议在 `TASK-0001` 进入生产前由项目负责人与 ChatGPT 明确：提前补齐 4 个字段，或在架构中标明为 Phase 2 可选扩展 |
| C-02 | **解决方案项目拆分数量不一致**（架构口径差异，待决策） | [ADR-0001-desktop-stack.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md) vs. [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 2 节） | `ADR-0001` 列出 5 个项目（`App`、`Core`、`Collectors`、`Diagnostics`、`Reporting`）；架构第 2 节列出 6 个项目（含 `Persistence`） | **中优先级（待决策）**：按文档优先级，已接受 ADR 高于架构文档。待决定是附注对齐为 6 项目，还是 Phase 1 先并入 `Core`；不得擅自改动正式 ADR |
| C-03 | **PowerShell 兼容性测试要求尚未明确**（测试与说明待补全，非架构冲突） | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（第 5 节） vs. [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 架构第 5 节定义的是**架构允许的兼容条件**（优先 PowerShell 7，在测试兼容前提下支持 Windows PowerShell）；`TASK-0001` 定义的是**具体回退实现要求**（优先 `pwsh.exe`，回退 `powershell.exe`）。两者并非不可调和的架构冲突，但目前缺少 PowerShell 5.1/7 兼容性测试范围与验收标准 | **中优先级（待补全测试标准）**：建议在测试策略与 `TASK-0001` 验收清单中补充 5.1/7 兼容性测试要求，使架构条件与回退实现闭环 |
| C-04 | **`TASK-0001` 交付章节尚未同步至现行单一平面入口**（局部遗留） | [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md)（第 14 节） vs. [AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md) & [DELIVERY/INBOX/待交付/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/%E5%BE%85%E4%BA%A4%E4%BB%98/README.md) | 仓库已确立唯一平面收件入口 `DELIVERY/INBOX/待交付/`（不要求项目负责人预建任务子目录），但 `TASK-0001` 仍为 `29758c5` 版本，第 14 节仍写旧的 `TASK-0001/` 嵌套交付包结构 | **中优先级（开工前同步）**：在 `TASK-0001` 启动前同步更新第 14 节为现行单一平面入口规范；另 `DELIVERY/README.md` 与 `DELIVERY/INBOX/README.md` 需以最新提交复核是否已完全同步 |
| C-06 | **架构文档尚未覆盖打包分发与数据目录设计**（设计待补全） | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) & [ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md)（Phase 5） vs. [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) | 需求与路线图均锁定 V1 同时提供便携版与 Windows 安装版，但架构文档止于第 11 节，尚未定义打包形态与便携模式数据路径 | **低-中优先级（待决策）**：不阻塞 `TASK-0001`，建议在 Phase 2 持久化定型前由项目负责人与 ChatGPT 确定方案（不得提前创建 `ADR-0002`） |
| C-07 | **Markdown 渲染缺陷（2026-11-19 快照检出，需以最新文本复核）** | [docs/REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md)（第 2 节） | 2026-11-19 快照中尖括号占位符未被反引号包裹，渲染为 `WinDeviceInspector..` 与 `WinDeviceInspector..Tests.` | **低优先级**：本轮 R3 未重读该文件最新提交，若仍存在建议改为反引号包裹 |

## 3. 自 2026-11-19 快照以来已解决的管理类问题（留痕归档）

| 原编号 | 原审计问题 | 当前核验结果（`397e53a`） |
| :---: | :--- | :--- |
| 原 C-05 | 缺少统一任务状态机与验收门禁 | **已解决**：[docs/任务中心/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/README.md)、[审查索引.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%AE%A1%E6%9F%A5%E7%B4%A2%E5%BC%95.md) 与 [AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md) 已落地 9 态+3 特殊态状态机及严格验收门禁 |
| 原管理缺口 | 缺少任务中心、审查目录、缺陷目录与开发变更记录 | **已解决**：已落地 `docs/任务中心/` 5 份核心文件、`docs/reviews/README.md`、`docs/issues/README.md` 及 4 份中文模板 |
| 原 C-04 主体 | 交付入口与轮次归档规则未统一 | **主体已解决**：已确立 `DELIVERY/INBOX/待交付/` 单一平面入口及 `DELIVERY/ARCHIVE/<TASK>/<R#>/` 按轮次归档（仅余 `TASK-0001` 第 14 节待同步） |

## 4. 信息重复维护提醒与现行单点真相源（SSOT）映射

在 2026-11-19 快照中检出的核心约束多处重复（`README.md`、`PROJECT_OVERVIEW.md`、`PRODUCT_REQUIREMENTS.md` 等）仍建议在后续维护中遵循以下**已落地与推荐结合的 SSOT 分工**（注：`docs/PROJECT_STATUS.md` 已明确保留为高层状态摘要，不与任务中心冲突）：

| 信息类型 | 现行唯一事实源（SSOT） | 落地状态 |
| :--- | :--- | :---: |
| 产品范围、用户行为、隐私与 V1 排除项 | `docs/PRODUCT_REQUIREMENTS.md` | 已落地 |
| 技术边界、模块依赖、JSON Schema、测试策略 | `docs/TECHNICAL_ARCHITECTURE.md` | 已落地 |
| 不可逆/重大架构选型及理由 | `docs/decisions/ADR-XXXX-*.md` | 已落地 |
| 当前唯一活跃任务指针 | `docs/任务中心/当前任务.md` | **已落地** |
| 全部任务全生命周期状态台账 | `docs/任务中心/任务索引.md` | **已落地** |
| 全部独立审查与测试证据台账 | `docs/任务中心/审查索引.md` + `docs/reviews/` + `DELIVERY/ARCHIVE/` 独立审查报告 | **已落地** |
| 缺陷登记与本机复验记录 | `docs/issues/` | **已落地** |
| 实际已提交变更历史 | `docs/任务中心/开发变更记录.md` | **已落地** |
| 高层项目状态摘要 | `docs/PROJECT_STATUS.md` | **已明确保留** |
| AI 三方协作规范与单一平面交付入口 | `docs/AI_COLLABORATION.md` + `DELIVERY/INBOX/待交付/README.md` | **已落地** |
