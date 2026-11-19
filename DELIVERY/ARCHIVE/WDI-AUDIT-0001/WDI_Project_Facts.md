# WinDevice-Inspector 统一项目事实清单（WDI-AUDIT-0001）

- **基准仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）
- **核对日期**：2026-11-19
- **编撰原则**：严格区分“已确认事实”“已确定未实现设计”“尚待决策问题”“未来规划”与“已完成且有证据的工作”，绝不将计划、设计或模板写成已完成的代码成果。

## 1. 已确认的项目事实（Confirmed Project Facts）

以下事实均有公开仓库文档或本次任务书明确锁定，属于项目当前不可变更的基线：

| 类别 | 已确认事实 | 权威来源 |
| :--- | :--- | :--- |
| 项目定位 | 面向 Windows 用户的本地优先、用户可控桌面设备与系统证据采集/诊断工具 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[PROJECT_OVERVIEW.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_OVERVIEW.md) |
| 核心技术栈 | **C# + .NET 10 LTS + WPF** | [ADR-0001](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| 首期目标平台 | **Windows 11 x64** | [ADR-0001](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md)、[PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md) |
| 采集执行机制 | **PowerShell 受控只读子进程**（独立进程、固定内置脚本、只读、不修改系统执行策略） | [ADR-0001](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| 数据归属与联网边界 | 第一版以**本地运行与本地保存**为主；**不自动上传、不接入后台遥测、不自动连接 AI 服务** | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[CONTRIBUTING.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/CONTRIBUTING.md) |
| 只读安全边界 | **不提供自动修复或驱动修改**；**不自动提权**，普通采集尽量无需管理员权限 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| 扫描触发与确认边界 | **每次扫描必须由用户主动发起并在扫描前明确确认**；严禁启动时扫描、后台扫描、定时扫描、空闲扫描与自动重试扫描 | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| 隐私与分享边界 | 扫描前明确告知采集范围；分享前提供**真实内容预览**并允许用户**逐项选择分享字段与类别** | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md) |
| V1 核心产出形态 | 第一版具备**本地扫描历史**与 **JSON 导出**；后续阶段提供 **HTML/TXT 报告**及**全量/专项 AI 诊断任务书（AI Diagnostic Brief）** | [PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) |
| 分发形式 | V1 发布形式同时包含**便携版（Portable）**与 **Windows 安装版（Installer）** | [README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/README.md)、[ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) |
| 三方协作模式 | Gemini 读取公开仓并交付完整文件给用户 → 用户检查后放入交付目录 → ChatGPT 负责技术指导、独立审查与验收意见 → **用户拥有最终决定权**；Gemini 不直接提交仓库 | [AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)、[DELIVERY/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/DELIVERY/README.md) |
| 文档冲突裁决顺序 | 1. 已确认产品需求 → 2. 已接受 ADR → 3. 技术架构 → 4. 活跃任务书 → 5. 路线图与状态摘要 | [docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) |

## 2. 已完成且有证据支持的工作（Completed Work with Evidence）

| 完成项 | 仓库证据 | 状态核验 |
| :--- | :--- | :--- |
| 仓库初始化与基础工程配置 | [.editorconfig](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/.editorconfig)、[.gitignore](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/.gitignore)、[CONTRIBUTING.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/CONTRIBUTING.md)、[README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/README.md) | 已提交至 `main`（共 36 Commits） |
| 产品与架构核心文档基线 | [PROJECT_OVERVIEW.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_OVERVIEW.md)、[PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)、[REPOSITORY_STRUCTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/REPOSITORY_STRUCTURE.md)、[docs/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/README.md) | 已提交并互相链接 |
| 路线图与项目状态基线 | [ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md)、[PROJECT_STATUS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PROJECT_STATUS.md) | 已提交，Phase 0 完成 7/9 项 |
| 架构决策记录（桌面技术栈） | [ADR-0001-desktop-stack.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md) | 状态为 `Accepted`（2026-11-16） |
| AI 协作机制、模板与交付收件箱 | [AI_COLLABORATION.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/AI_COLLABORATION.md)、[TASK_BRIEF_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/TASK_BRIEF_TEMPLATE.md)、[COMPLETION_RECEIPT_TEMPLATE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/templates/COMPLETION_RECEIPT_TEMPLATE.md)、[DELIVERY/](https://github.com/r3v01nter/WinDevice-Inspector/tree/main/DELIVERY) | 已建立占位与规范 |
| 首期垂直切片任务书编写 | [TASK-0001-vertical-slice.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/tasks/TASK-0001-vertical-slice.md) | 已编写完成，待修补少量架构对齐细节后进入生产 |
| 代码与测试目录占位 | [src/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/src/README.md)、[tests/README.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/tests/README.md) | 仅有占位 README，无代码 |

## 3. 已确定但尚未实现的设计（Confirmed Design, Not Yet Implemented）

以下设计已在架构或任务书中明确定义，但**尚未有任何代码落地或本机验证**：

1. **解决方案与模块化拆分**：`WinDeviceInspector.sln` 及 `App`、`Core`、`Collectors`、`Persistence`、`Diagnostics`、`Reporting`（及对应 `*.Tests`）分层架构，其中 `Core` 不依赖 WPF，扫描确认边界强制落于编排/服务层（[TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)）。
2. **Phase 1 垂直切片（`TASK-0001`）**：
   - 无扫描初始界面与显式确认/取消弹窗；
   - 受控 PowerShell 子进程执行器（`-NoProfile`、固定脚本路径、UTF-8、stdout 纯 JSON、stderr 诊断、超时与取消时终止进程树）；
   - 9 类初始只读采集（OS、计算机型号、CPU、主板/BIOS、内存、GPU、物理磁盘/逻辑卷、网络适配器、非 OK 状态 PnP 设备及问题代码）；
   - 7 态类别结果模型（`Success` / `Partial` / `Unsupported` / `Unavailable` / `PermissionDenied` / `Failed` / `Skipped`）；
   - 本地扫描历史（当前用户 `LocalAppData`，单次扫描 JSON 文件）与显式原始 JSON 导出；
   - 针对确认门禁、JSON 解析、进程异常与历史损坏的自动化单元测试。
3. **Phase 2–4 完整功能设计**：完整硬件/驱动/显示器/USB/音频/蓝牙采集、历史对比与删除、Windows 事件日志/WHEA/Bugcheck/异常关机/RAC/WER 可靠性证据时间线、全量与专项 AI 诊断简报（含真实内容预览、敏感字段逐项勾选、HTML/TXT/剪贴板输出）。
4. **Phase 5 分发与稳定化设计**：便携版与 Windows 安装包打包、应用日志与崩溃处理、CI 工作流与签名发布流程。

## 4. 尚待决策的问题（Pending Decisions）

以下事项在仓库中处于明确空缺或存在冲突，需要**用户（及技术负责人 ChatGPT）拍板**：

| 编号 | 尚待决策问题 | 当前现状 | 影响范围 |
| :---: | :--- | :--- | :--- |
| D-01 | **开源许可证选型** | 无 `LICENSE` 文件，`ROADMAP.md` Phase 0 未勾选，`README.md` 标明暂不可复用 | 仓库合规性、外部使用与分发 |
| D-02 | **项目结构拆分口径统一** | `ADR-0001` 为 5 项目，`TECHNICAL_ARCHITECTURE.md` 为 6 项目（多 `Persistence`） | `TASK-0001` 解决方案初始化与后续模块边界 |
| D-03 | **TASK-0001 JSON Schema 完整度** | `TASK-0001` 省略了架构定义的 `timeZoneId`、`applicationVersion`、`durationMs` 与查询参数字段 | Phase 1 产出的 JSON 是否需在 Phase 2 破坏性升级 |
| D-04 | **`powershell.exe` 回退策略** | 架构要求“仅测试兼容时支持”，`TASK-0001` 要求“优先 `pwsh.exe` 回退 `powershell.exe`” | Win11 默认无 `pwsh` 机器的开箱可用性与测试范围 |
| D-05 | **文档与交付目录语言规范** | 仓库现有 21 个文件全部为英文，本次任务书建议交付包内使用中文文件名（如 `原始交付/`、`完成回执.md`）而 `docs/task-center/` 使用英文名 | 仓库风格统一与跨 AI 读取一致性 |
| D-06 | **便携版 vs 安装版的打包方案与数据路径** | 架构文档尚无打包章节；未定自包含还是框架依赖、安装器选型（MSIX/WiX/Inno Setup）及便携模式数据目录位置 | Phase 5 分发架构与本地持久化路径设计 |
| D-07 | **原始 JSON 导出时的敏感信息提示策略** | `TASK-0001` 仅导出原始 JSON，逐项脱敏/勾选排在 Phase 4 | 是否在 Phase 1 导出原始 JSON 前增加简要风险确认提示 |
| D-08 | **GitHub 仓库元数据设置** | About 简介、网站与 Topics 为空 | 仓库可读性与检索 |
| D-09 | **本机开发环境验证基线** | 用户 Windows 11 x64 的 `.NET 10 SDK` 与 PowerShell 环境检查尚未记录 | Phase 0 收尾与 `TASK-0001` 本机验收前置条件 |

## 5. 未来规划与明确延后项（Future Roadmap & Deferred Scope）

依据 [docs/ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md) 与 [docs/PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)：

- **V1 路线图内后续阶段**：
  - **Phase 2（Inventory and history MVP）**：补全完整硬件/外设/驱动清单、完善历史记录管理与对比；
  - **Phase 3（Reliability and error evidence）**：System/Application 事件日志、异常关机、Bugcheck/WHEA、RAC 与 WER 证据时间线；
  - **Phase 4（AI Diagnostic Brief）**：全量/专项诊断简报、真实内容预览与逐项字段控制、HTML/TXT/复制输出；
  - **Phase 5（Stabilization and distribution）**：便携版与 Windows 安装版打包、崩溃处理、无障碍与本地化、安全隐私审查、CI 与签名发布。
- **明确延后 / V1 排除项（Later / Explicitly Deferred）**：
  - 实时硬件传感器监控（温度、功耗、风扇转速、实时频率与利用率面板）；
  - 在线 AI 服务直连与云端自动上传；
  - 自动修复、驱动安装/修改、注册表清理、性能跑分与烤机工具；
  - 在证据不足时输出武断的单一根因结论。
