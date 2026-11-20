# WinDevice-Inspector 统一任务中心设计方案与落地对照（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（R3 返修版）
- **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **核对基准**：
  - 初始审计历史快照：`2026-11-19`（短提交标识 `29758c5`，完整 40 位 SHA 未在公开网页反查，不猜测；当时共 21 个文件）
  - R2 独立审查基准：`2026-11-20`（完整提交 SHA `fa8a54d0fc1c81b4423df015251a310e95e3b6d7`）
  - R3 返修实测核对基准：短提交标识 `397e53a`（累计 100 Commits，完整 40 位 SHA 未反查，不猜测）
- **文档定位**：记录当前仓库**已经正式落地的中文任务中心与交付协作体系**，对照原审计设计方案说明采纳情况、实际差异及仍待项目负责人决定的事项。**不得另建英文 `docs/task-center/` 或第二套英文任务索引。**

## 1. 当前仓库已落地的任务中心实况（已核验）

仓库已于 2026-11-20 正式建立面向项目负责人的**中文任务中心**，并配套落地审查目录、缺陷目录、中文模板与单一平面交付入口。以下全部路径均已在 `main` 分支（`397e53a`）核验存在：

```text
docs/
├── 任务中心/                          # [已落地] 唯一中文任务中心
│   ├── README.md                      # 任务中心导航、三方分工与 9 态+3 特殊态状态流转
│   ├── 当前任务.md                     # 唯一当前任务指针（当前指向 WDI-AUDIT-0001 R3）
│   ├── 任务索引.md                     # 全量任务台账（已登记 WDI-AUDIT-0001 与 TASK-0001）
│   ├── 审查索引.md                     # 独立审查与本机验证索引（已登记 R1、R2）
│   └── 开发变更记录.md                 # 仅记录实际已提交变更（已记录 2026-11-20 管理整理）
├── tasks/                             # [已复用] 历次任务书（含 TASK-0001 与 WDI-AUDIT-0001 R3 任务书）
├── reviews/                           # [已落地] 独立审查目录占位（README.md）
├── issues/                            # [已落地] 缺陷记录目录占位（README.md）
├── decisions/                         # [已复用] 架构决策记录（ADR-0001-desktop-stack.md）
├── templates/                         # [已扩充] 保留既有英文模板 + 新增 4 份中文模板
│   ├── TASK_BRIEF_TEMPLATE.md
│   ├── COMPLETION_RECEIPT_TEMPLATE.md
│   ├── 任务书模板.md
│   ├── 完成回执模板.md
│   ├── 审查报告模板.md
│   └── 缺陷记录模板.md
├── PROJECT_STATUS.md                  # [已明确保留] 高层项目状态摘要
└── AI_COLLABORATION.md                # [已更新] 对接中文任务中心、单一平面收件入口与按轮次归档

DELIVERY/
├── INBOX/
│   ├── README.md
│   └── 待交付/                         # [已落地] 唯一平面收件入口（保留 README.md 占位）
└── ARCHIVE/
    ├── README.md
    └── WDI-AUDIT-0001/                # [已落地] ChatGPT 审查后按任务编号与轮次归档
        ├── README.md / REVIEW_REPORT.md / R1 原始交付文件
        └── R2/                        # R2 独立归档（含 REVIEW_REPORT.md 与 R2 原始交付文件）
```

## 2. 原设计方案采纳情况与实际落地差异对照

| 设计维度 | R1/R2 原审计建议 | 仓库当前实际落地情况（`397e53a` 核验） | 差异说明与结论 |
| :--- | :--- | :--- | :--- |
| **任务中心目录与文件名** | 建议新建英文 `docs/task-center/` 及 `CURRENT_TASK.md` 等 5 个英文文件 | 已落地中文 `docs/任务中心/` 及 `README.md`、`当前任务.md`、`任务索引.md`、`审查索引.md`、`开发变更记录.md` | **以已落地中文路径为准**；符合项目负责人已明确的语言规则（管理文档中文、代码与技术标识英文），严禁另建英文第二套任务中心 |
| **审查与缺陷目录** | 建议新增 `docs/reviews/` 与 `docs/issues/` | 已落地 `docs/reviews/README.md` 与 `docs/issues/README.md` | **已采纳并落地** |
| **模板体系** | 建议补充审查报告与缺陷记录模板 | 已在 `docs/templates/` 保留英文模板，并新增 `任务书模板.md`、`完成回执模板.md`、`审查报告模板.md`、`缺陷记录模板.md` | **已采纳并落地** |
| **任务状态机** | 9 态主流程 + 3 特殊态 + 4 条验收铁律 | [docs/任务中心/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/README.md) 与 [审查索引.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%AE%A1%E6%9F%A5%E7%B4%A2%E5%BC%95.md) 已正式采纳该 9 态+3 特殊态流程及“审查通过≠本机验证通过≠验收通过”门禁 | **已采纳并落地** |
| **交付入口与投递结构** | 原建议项目负责人建 `TASK-XXXX/原始交付/` 嵌套目录 | 现行正式流程已确立为**单一平面收件入口 `DELIVERY/INBOX/待交付/`**，由 ChatGPT 审查后按任务编号和轮次归档至 `DELIVERY/ARCHIVE/<TASK>/<R#>/` | **以现行单一平面入口为准**；不得要求项目负责人在投递前建子目录或拆包重组 |
| **`docs/PROJECT_STATUS.md`** | 原建议并入任务中心或降级为跳转页 | 项目负责人已明确将其**作为高层项目状态摘要保留**，并已同步更新至 `WDI-AUDIT-0001 R3` 状态 | **以现行保留决定为准**；不阻塞任务中心运行 |

## 3. 现行正式交付与审查流程（单一平面收件入口）

依据 [docs/AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)、[DELIVERY/INBOX/待交付/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/%E5%BE%85%E4%BA%A4%E4%BB%98/README.md) 及 R3 任务书确认的现行流程：

1. **Gemini 生产交付**：Gemini 读取公开仓库完成本轮任务后，将完整文件直接交给项目负责人（可附文件清单与修订/完成说明，不要求项目负责人重组目录）。
2. **项目负责人核查投递**：项目负责人自行检查无敏感信息与凭据后，将本轮文件**直接平面放入唯一收件入口 `DELIVERY/INBOX/待交付/`**（无需预先创建 `TASK-XXXX/`、`原始交付/` 等嵌套子目录，也不得删除 `DELIVERY/INBOX/待交付/README.md`）。
3. **ChatGPT 独立审查**：ChatGPT 从 `DELIVERY/INBOX/待交付/` 读取本轮文件并对照任务书独立审查，出具审查结论（通过 / 需返工 / 阻塞 / 待审查）。
4. **按任务与轮次归档并清理入口**：ChatGPT 按任务编号与轮次将原始交付归档至 `DELIVERY/ARCHIVE/<TASK-ID>/` 或 `R2/`、`R3/` 等独立目录（绝不覆盖历史原件），同步写入 `REVIEW_REPORT.md`、更新 `docs/任务中心/审查索引.md` 与 `任务索引.md`，随后清理 `DELIVERY/INBOX/待交付/`（保留其 `README.md`）。
5. **本机验证与最终验收**：涉及软件代码的任务（如 `TASK-0001`），须在代码审查通过后由项目负责人于 Windows 11 x64 本机完成编译、测试与非管理员实测；唯有审查通过且项目负责人明确批准，任务方可标记为 `验收通过`。

*(注：若未来需要调整上述单一平面交付流程，仅可作为待批准提案提交，不得擅自替换现行流程。)*

## 4. 当前任务指针与 `TASK-0001` 的关系（已核验）

依据 [docs/任务中心/当前任务.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%BD%93%E5%89%8D%E4%BB%BB%E5%8A%A1.md) 与 [docs/任务中心/任务索引.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E4%BB%BB%E5%8A%A1%E7%B4%A2%E5%BC%95.md)：

- **当前唯一处理项**：**`WDI-AUDIT-0001`**（仓库审计与协作管理整理），当前轮次 `R3`，当前状态 `待 Gemini 修订`，验收状态 `未验收`。
- **下一项软件实现任务**：**`TASK-0001`**（首个可运行垂直切片 / Phase 1 软件实现），任务书已存在（[docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md)），状态为 **`待生产`**，尚未开始实现，**不是当前处理项**。
- **切换门禁**：仅当 `WDI-AUDIT-0001` 通过 R3 审查并获项目负责人明确批准关闭，且 `TASK-0001` 开工前待决口径明确后，再将 `当前任务.md` 切换指向 `TASK-0001`。

## 5. 仍待项目负责人与技术负责人决定的关联事项

以下事项尚未在仓库中落定，保持待决策状态（不擅自裁决）：

1. **`TASK-0001` 第 14 节交付路径同步**：[docs/tasks/TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) 仍为 `29758c5` 版本，其第 14 节仍沿用旧 `TASK-0001/` 交付包结构，待同步为单一平面入口 `DELIVERY/INBOX/待交付/`。
2. **软件开发前待决技术口径**：`C-01`（JSON Schema 4 字段）、`C-02`（`Persistence` 拆分口径）、`C-03`（PowerShell 5.1/7 兼容性测试要求）、`C-06`（便携版/安装版打包与数据路径）以及 `D-01`（许可证）、`D-07`、`D-08`、`D-09`。
