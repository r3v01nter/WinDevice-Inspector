# WinDevice-Inspector 统一项目事实清单（WDI-AUDIT-0001）

- **任务编号**：WDI-AUDIT-0001（R3 返修版）
- **基准仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **多时间点核对基准说明**：
  - 初始审计历史快照：`2026-11-19`（短提交 `29758c5`，21 个文件；无法反查完整 40 位 SHA，不猜测）
  - R2 独立审查基准：`2026-11-20`（完整提交 SHA `fa8a54d0fc1c81b4423df015251a310e95e3b6d7`）
  - R3 返修实测核对基准：短提交 `397e53a`（累计 100 Commits，完整 40 位 SHA 未反查，不猜测）
- **编撰原则**：严格区分“已确认的项目事实”“已完成且有仓库证据的工作”“已确定但尚未实现的设计”“尚待决策的问题”与“未来规划”，绝不将提案写成已实施事实，亦不擅自裁决未决技术事项。

## 1. 已确认的项目事实（Confirmed Project Facts）

以下事实均由仓库权威文档或项目负责人正式决定锁定：

| 类别 | 已确认事实 | 权威来源 |
| :--- | :--- | :--- |
| 项目定位 | 面向 Windows 用户的本地优先、用户可控桌面设备与系统证据采集/诊断工具 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[PROJECT_OVERVIEW.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_OVERVIEW.md) |
| 核心技术栈 | **C# + .NET 10 LTS + WPF**；首期目标平台 **Windows 11 x64** | [ADR-0001](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| 采集与只读安全边界 | **PowerShell 受控只读子进程**；第一版以本地运行和本地保存为主；不自动上传、不接入后台遥测、不自动连接 AI 服务；不提供自动修复或驱动修改；不自动提权，普通采集尽量无需管理员权限 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| 扫描确认与禁止项 | 每次扫描必须由用户主动发起并在扫描前明确确认；严禁启动时扫描、后台扫描、定时扫描、空闲扫描与未经确认的自动重试扫描 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)、[TASK-0001](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md)（第 6 节） |
| 隐私分享与产出形态 | 扫描前明确告知采集范围；分享前提供真实内容预览并允许逐项选择字段和类别；V1 具备本地扫描历史与 JSON 导出，后续提供 HTML/TXT 报告及全量/专项 AI 诊断任务书；V1 发布形式包含便携版与 Windows 安装版 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) |
| **文档与技术标识语言规则（D-05 已明确）** | 面向项目负责人的管理文档（任务中心、任务书、审查报告、索引、说明等）**优先使用中文**；程序源码、项目名、API、JSON 字段、命令、技术标识与工具兼容路径**保留英文** | 项目负责人决定（R3 任务书 R3-05）及 `docs/任务中心/` 实际落地 |
| **`docs/PROJECT_STATUS.md` 定位（D-10 已明确）** | **`docs/PROJECT_STATUS.md` 目前作为高层项目状态摘要保留**，不阻塞任务中心运行 | [docs/PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md)（`5ec3e07`）及 R3 任务书 R3-05 |
| **三方协作与单一平面交付入口** | Gemini 公开读仓并把完整文件交给项目负责人 → 项目负责人检查后**直接平面放入唯一入口 `DELIVERY/INBOX/待交付/`**（不要求预建任务子目录或重组）→ ChatGPT 独立审查、按任务编号与轮次归档至 `DELIVERY/ARCHIVE/<TASK>/<R#>/` 并更新索引后清理待交付入口 → **项目负责人拥有最终决定权**；Gemini 不直接提交仓库 | [AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)、[DELIVERY/INBOX/待交付/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/INBOX/%E5%BE%85%E4%BA%A4%E4%BB%98/README.md) |
| **当前治理任务与软件任务区分** | 当前处理项为 **`WDI-AUDIT-0001`**（R3 返修，未验收）；下一项软件实现任务为 **`TASK-0001`**（状态 `待生产`，尚未开始实现，不是当前处理项） | [docs/任务中心/当前任务.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%BD%93%E5%89%8D%E4%BB%BB%E5%8A%A1.md)、[任务索引.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E4%BB%BB%E5%8A%A1%E7%B4%A2%E5%BC%95.md) |

## 2. 已完成且有仓库证据支持的工作（截至 R3 核对基准 `397e53a`）

| 阶段/批次 | 完成项 | 可核验的仓库证据 |
| :--- | :--- | :--- |
| 2026-11-19 基线（`29758c5`，21 文件） | 仓库基础配置、产品需求、技术架构、路线图、ADR-0001、TASK-0001 任务书、英文模板及 `src/`/`tests/` 占位 | `.editorconfig`、`.gitignore`、`PRODUCT_REQUIREMENTS.md`、`TECHNICAL_ARCHITECTURE.md`、`ROADMAP.md`、`ADR-0001-desktop-stack.md`、`TASK-0001-vertical-slice.md`、`src/README.md`、`tests/README.md` |
| 2026-11-20 治理落地（R2 基准 `fa8a54d0...` 至 R3 核对 `397e53a`） | **中文任务中心正式建立** | `docs/任务中心/README.md`、`当前任务.md`、`任务索引.md`、`审查索引.md`、`开发变更记录.md` |
| 同上 | **审查目录、缺陷目录与 4 份中文模板落地** | `docs/reviews/README.md`、`docs/issues/README.md`、`docs/templates/任务书模板.md`、`完成回执模板.md`、`审查报告模板.md`、`缺陷记录模板.md` |
| 同上 | **单一平面交付入口与 R1/R2 轮次归档落地** | `DELIVERY/INBOX/待交付/README.md`、`DELIVERY/ARCHIVE/WDI-AUDIT-0001/`、`DELIVERY/ARCHIVE/WDI-AUDIT-0001/R2/REVIEW_REPORT.md` |
| 同上 | **协作规范与高层状态摘要同步** | `docs/AI_COLLABORATION.md`（`dca3a6c`）、`docs/PROJECT_STATUS.md`（`5ec3e07`） |

## 3. 已确定但尚未实现的设计（截至 `397e53a`，应用代码实现进度为 0%）

1. **解决方案与模块化拆分**：`WinDeviceInspector.sln` 及分层架构，扫描确认边界强制落于编排/服务层，`Core` 不依赖 WPF（[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)）。
2. **Phase 1 垂直切片（`TASK-0001`，状态 `待生产`，尚未启动）**：WPF 无扫描初始界面与确认弹窗、受控 PowerShell 只读子进程执行器、9 类初始硬件/系统采集、7 态类别结果模型、本地扫描历史（`LocalAppData`）与显式原始 JSON 导出、自动化单元测试。
3. **Phase 2–5 规划能力**：完整硬件/驱动清单与历史对比、Windows 事件日志/WHEA/Bugcheck/异常关机/RAC/WER 证据时间线、全量与专项 AI 诊断简报（含真实预览与逐项字段选择、HTML/TXT 输出）、便携版与 Windows 安装版打包及 CI/发布流程。

## 4. 仍待项目负责人决策的问题（Pending Decisions，均未擅自裁决）

*(注：原 `D-05` 语言规则与 `D-10` `PROJECT_STATUS.md` 定位已由项目负责人明确，已移入第 1 节已确认事实，不再列为待决项。)*

| 编号 | 仍待决策问题 | 当前现状 | 影响范围 |
| :---: | :--- | :--- | :--- |
| D-01 | **开源许可证选型** | 无 `LICENSE` 文件，`PROJECT_STATUS.md` 标明尚未选定 | 仓库合规与分发 |
| D-02 | **项目结构拆分口径统一（C-02）** | `ADR-0001` 为 5 项目，`TECHNICAL_ARCHITECTURE.md` 为 6 项目（含 `Persistence`） | `TASK-0001` 解决方案初始化与模块边界 |
| D-03 | **`TASK-0001` JSON Schema 4 个字段口径（C-01）** | 架构第 7 节含 `timeZoneId`、`applicationVersion`、`durationMs` 与查询参数，`TASK-0001` 未列出 | Phase 1/2 本地历史 JSON 兼容性 |
| D-04 | **PowerShell 5.1/7 兼容性测试范围与验收标准（C-03）** | 架构允许测试兼容下支持 Windows PowerShell，`TASK-0001` 要求优先 `pwsh.exe` 回退 `powershell.exe`，具体测试矩阵待明确 | `TASK-0001` 脚本实现与本机验收清单 |
| D-06 | **便携版 vs 安装版打包方案与数据目录策略（C-06）** | 架构文档尚无打包章节；未定打包形态与便携模式数据路径（不得提前创建 `ADR-0002`） | Phase 2 持久化定型与 Phase 5 分发 |
| D-07 | **Phase 1 原始 JSON 导出敏感提示策略** | `TASK-0001` 仅导出原始 JSON，逐项勾选排在 Phase 4 | 是否在 Phase 1 导出前加简要敏感提示 |
| D-08 | **GitHub 仓库元数据设置** | 2026-11-19 快照 About 简介、网站与 Topics 为空 | 仓库可读性与检索 |
| D-09 | **本机开发环境验证基线** | `PROJECT_STATUS.md`（`5ec3e07`）仍标明等待项目负责人提供 Windows 11 x64 本机 PowerShell 环境验证输出 | Phase 0 收尾与 `TASK-0001` 本机验收前置条件 |

## 5. 未来规划与明确延后项（Future Roadmap & Deferred Scope）

- **V1 路线图内后续阶段**：Phase 2（完整硬件/驱动清单与历史管理）、Phase 3（可靠性与错误事件时间线）、Phase 4（全量/专项 AI 诊断简报与隐私字段勾选）、Phase 5（便携版/安装版分发、崩溃处理、CI 与发布）。
- **明确延后 / V1 排除项**：实时传感器监控（温度/功耗/风扇/频率面板）、在线 AI 直连与云端自动上传、自动修复/驱动修改/清注册表/跑分烤机、证据不足时武断归因。
