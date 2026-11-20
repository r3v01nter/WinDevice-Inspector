# WinDevice-Inspector 变更提案实施状态与文件处置清单（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（R3 返修版）
- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **核对基准**：
  - 初始审计历史快照：`2026-11-19`（短提交 `29758c5`，21 个文件）
  - R2 审查基准：`2026-11-20`（完整提交 `fa8a54d0fc1c81b4423df015251a310e95e3b6d7`）
  - R3 实测核对基准：短提交 `397e53a`（累计 100 Commits）
- **编制原则**：严格按当前仓库真实实施状态分为 **“已实施并可核验”**、**“已部分实施／仍需复核”** 与 **“尚未实施且待批准”** 三类；绝不把已落地文件继续列为“待新增”，也绝不把未批准提案写成已实施决定。

## 1. 已实施并可核验（基于 `397e53a` 实测确认）

以下提案内容已在仓库 `main` 分支落地并可逐一核验路径：

| 类别 | 真实仓库路径 | 落地状态与核验说明 |
| :--- | :--- | :--- |
| 中文任务中心首页 | [docs/任务中心/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/README.md) | **已实施**：含任务中心导航、三方职责与 9 态+3 特殊态状态机 |
| 唯一当前任务指针 | [docs/任务中心/当前任务.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%BD%93%E5%89%8D%E4%BB%BB%E5%8A%A1.md) | **已实施**：当前指向 `WDI-AUDIT-0001` R3，明确区分 `TASK-0001` 待生产 |
| 全量任务台账 | [docs/任务中心/任务索引.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E4%BB%BB%E5%8A%A1%E7%B4%A2%E5%BC%95.md) | **已实施**：已登记 `WDI-AUDIT-0001` 与 `TASK-0001` 及维护规则 |
| 独立审查索引 | [docs/任务中心/审查索引.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%AE%A1%E6%9F%A5%E7%B4%A2%E5%BC%95.md) | **已实施**：已登记 `REV-WDI-AUDIT-0001-R1`、`R2` 及严格验证口径 |
| 开发变更记录 | [docs/任务中心/开发变更记录.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%BC%80%E5%8F%91%E5%8F%98%E6%9B%B4%E8%AE%B0%E5%BD%95.md) | **已实施**：已记录 2026-11-20 管理整理，明确仅记实际已提交内容 |
| 独立审查目录 | `docs/reviews/README.md` | **已实施**：已在 `docs/reviews/` 建立占位说明 |
| 缺陷记录目录 | `docs/issues/README.md` | **已实施**：已在 `docs/issues/` 建立占位说明 |
| 4 份中文模板 | `docs/templates/任务书模板.md`、`docs/templates/完成回执模板.md`、`docs/templates/审查报告模板.md`、`docs/templates/缺陷记录模板.md` | **已实施**：已在 `docs/templates/` 补齐中文模板，同时保留既有英文模板 |
| 单一平面交付入口 | [DELIVERY/INBOX/待交付/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/%E5%BE%85%E4%BA%A4%E4%BB%98/README.md) | **已实施**：确立为唯一常规交付入口 |
| 按任务/轮次归档与独立审查报告 | `DELIVERY/ARCHIVE/WDI-AUDIT-0001/`、`DELIVERY/ARCHIVE/WDI-AUDIT-0001/R2/REVIEW_REPORT.md` | **已实施**：R1、R2 原件与独立审查报告均已分轮次归档 |
| AI 协作规范更新 | [docs/AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md) | **已实施**：已接入中文任务中心、单一平面交付入口、按轮次归档与验收门禁 |
| 高层项目状态摘要保留与更新 | [docs/PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) | **已实施（D-10 已明确）**：明确保留为高层状态摘要并已同步至 `WDI-AUDIT-0001 R3` |
| 基础配置与目录占位保留 | `.editorconfig`、`.gitignore`、`src/README.md`、`tests/README.md`、`DELIVERY/ARCHIVE/README.md`、`docs/PRODUCT_REQUIREMENTS.md` | **已保留不动**：均保持原样作为仓库基线 |

## 2. 已部分实施／仍需复核

以下文件属于历史快照中提出过优化建议、但本轮 R3 聚焦必读清单未逐一重读其最新正文，或已明确存在局部待同步项的文件：

| 仓库路径 | 当前核验状态 | 剩余工作与核验依据 |
| :--- | :--- | :--- |
| [docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | **已核验未更新（仍为 `29758c5`）** | 第 6 节已明确禁止未经确认的自动重试扫描（无需改）；但第 14 节仍写旧 `TASK-0001/` 交付结构，尚未同步至单一平面入口 `DELIVERY/INBOX/待交付/`；且需待 C-01（4 个 JSON 字段）、C-03（PowerShell 兼容性测试要求）拍板后一并更新 |
| `README.md`、`CONTRIBUTING.md`、`docs/README.md`、`docs/REPOSITORY_STRUCTURE.md`、`DELIVERY/README.md`、`DELIVERY/INBOX/README.md` | **待结合当前分支最新内容复核** | 2026-11-19 快照（`29758c5`）至当前（`397e53a`）期间新增了 60+ 次提交，其中部分导航/入口链接可能已同步更新；本轮 R3 未逐一重读上述 6 份文件全文，具体剩余改动（如 `REPOSITORY_STRUCTURE.md` 尖括号渲染、各处任务中心链接去重）须以 `main` 最新文本核对为准 |
| `docs/PROJECT_OVERVIEW.md`、`docs/ROADMAP.md` | **保持保留，局部状态待闭环** | `ROADMAP.md` Phase 0 仍待许可证（D-01）与本机环境核查（D-09）完成后勾选；`PROJECT_OVERVIEW.md` 轻度去重仅作为低优先级可选建议 |

## 3. 尚未实施且待批准（严格保留为提案，不得视为已决定）

以下事项在仓库中尚未实施，须由项目负责人与 ChatGPT 决定是否采纳，**本报告不代为拍板**：

| 优先级 | 提案目标路径或事项 | 对应问题编号 | 提案说明（未批准） |
| :---: | :--- | :---: | :--- |
| P0 | 新增根目录 `LICENSE` | D-01 | 补齐 Phase 0 缺失项；具体许可证类型完全由项目负责人决定 |
| P0 | 更新 `docs/tasks/TASK-0001-vertical-slice.md` 与 `docs/TECHNICAL_ARCHITECTURE.md`（JSON Schema 4 字段对齐） | C-01 / D-03 | 待决定是在 `TASK-0001` 中补齐 `timeZoneId`、`applicationVersion`、`durationMs` 与查询参数，还是在架构中标明为 Phase 2 扩展 |
| P1 | 附注对齐 `docs/decisions/ADR-0001-desktop-stack.md` 与 `docs/TECHNICAL_ARCHITECTURE.md`（`Persistence` 拆分口径） | C-02 / D-02 | 待决定是 6 项目统一口径还是 Phase 1 先并入 `Core`；不得擅自修改正式 ADR |
| P1 | 在 `docs/TECHNICAL_ARCHITECTURE.md` 与 `TASK-0001` 补充 PowerShell 5.1 / 7 兼容性测试范围与验收标准 | C-03 / D-04 | 明确双环境测试清单与验收门槛 |
| P2 | 未来补写便携版/安装版打包与数据路径架构设计（是否单立 ADR 待定） | C-06 / D-06 | 建议在 Phase 2 持久化定型前评估，**当前不得提前创建 `ADR-0002`** |
| P2 | 英文模板 `TASK_BRIEF_TEMPLATE.md` / `COMPLETION_RECEIPT_TEMPLATE.md` 同步更新（可选） | — | 若后续仅以中文模板为主，英文模板可保持归档参考或择机同步 |
| P3 | 对 `docs/PROJECT_STATUS.md` 职责做进一步微调（可选提案） | D-10 延伸 | **现行决定为保留作高层摘要且不阻塞任务中心**；仅在项目负责人认为维护负担过高时再讨论精简 |

## 4. 明确禁止或不再提出的变动

1. **禁止另建英文 `docs/task-center/` 或第二套英文任务索引**：中文 `docs/任务中心/` 已正式落地并作为唯一任务中心运行。
2. **禁止要求项目负责人建立 `TASK-XXXX/原始交付/` 投递目录**：维持 `DELIVERY/INBOX/待交付/` 单一平面收件入口，由 ChatGPT 审查后统一按任务与轮次归档。
3. **禁止搬迁 `docs/tasks/`、`docs/decisions/`、`docs/templates/` 或删除各目录占位 `README.md`**。
4. **禁止擅自修改 `docs/PRODUCT_REQUIREMENTS.md`、`docs/decisions/ADR-0001-desktop-stack.md` 或提前创建 `ADR-0002`**。
