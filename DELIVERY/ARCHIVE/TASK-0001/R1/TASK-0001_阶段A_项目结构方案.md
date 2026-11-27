# TASK-0001 阶段 A｜最小项目结构方案

- **任务编号**：TASK-0001
- **所属阶段**：阶段 A（最小项目结构方案与依赖图，当前唯一授权阶段）
- **方案状态**：待独立审查与项目负责人批准（尚未进入阶段 B，未创建任何正式源码、解决方案或测试项目）
- **核验基准**：
  - 任务书基准 HEAD：`7d28957206d5ddeee7bfe447f68613776e08186f`
  - 本次读取 `main` 最新 HEAD：`edc0b2ff0bcd80e51dd6bc1c28a7152665763f0b`
  - 核验文档：`docs/TECHNICAL_ARCHITECTURE.md`（`a9a95cb`）、`docs/decisions/ADR-0001-desktop-stack.md`（`1859ba7`）、`docs/REPOSITORY_STRUCTURE.md`（`9a1675b`）、`docs/任务中心/任务创建与推进规范.md`（`8c7efb1`）

## 1. ADR-0001 五项目与技术架构六区域对比分析

仓库两份基线文档对逻辑模块划分存在如下口径差异（对应待决项 **C-02**）：

| 逻辑区域 | [ADR-0001](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/decisions/ADR-0001-desktop-stack.md)（5 项目） | [TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)（6 区域） | Phase 1（TASK-0001）垂直切片是否必需 |
| :--- | :---: | :---: | :--- |
| `WinDeviceInspector.App` | 包含 | 包含 | **必需**：WPF 空状态首页、扫描确认弹窗、进度/取消、历史浏览、原始 JSON 导出提示与保存对话框 |
| `WinDeviceInspector.Core` | 包含 | 包含 | **必需**：Schema v1 契约/DTO/校验、核心接口、服务层确认门禁与编排、导出提示门禁 |
| `WinDeviceInspector.Collectors` | 包含 | 包含 | **必需**：受控 PowerShell 7 / 5.1 双版本子进程 Runner、只读采集脚本与 9 类结果解析 |
| `WinDeviceInspector.Persistence` | 未单列 | **单列为独立区域** | **必需能力，边界待 C-02 批准**：本地扫描历史 JSON 读写、损坏容错、原始 JSON 文件写出 |
| `WinDeviceInspector.Diagnostics` | 包含 | 包含 | **Phase 1 不创建**：事件日志/异常关机/WHEA/Bugcheck/RAC/WER 时间线属 Phase 3 |
| `WinDeviceInspector.Reporting` | 包含 | 包含 | **Phase 1 不创建**：HTML/TXT 报告与全量/专项 AI 诊断简报属 Phase 4（Phase 1 仅做原始 JSON 导出） |

同时，`TECHNICAL_ARCHITECTURE.md` 第 2 节明确提出：**不为凑图而建空项目，`TASK-0001` 应采用能验证垂直切片的最小连贯方案**。因此，阶段 A 的核心决策点聚焦于两点：（1）**延迟创建 `Diagnostics` 与 `Reporting`**；（2）**明确 `Persistence` 在 Phase 1 的工程边界（C-02）**。

## 2. C-02 专项对比：Persistence 边界三种方案取舍

| 方案 | 源码项目数 | Persistence 放置位置 | 核心优点 | 核心缺点 / 风险 | 推荐评估 |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **方案 1（推荐）**：独立 `WinDeviceInspector.Persistence` 项目 | 4 个（`App`、`Core`、`Collectors`、`Persistence`） | 独立 `net10.0` 类库 `src/WinDeviceInspector.Persistence/` | 1. 严格对齐架构第 2 节职责隔离（`Core` 保持零文件 I/O、零平台路径耦合，纯内存可测）；2. `Persistence` 与 `Collectors` 完全隔离，无法触发采集；3. 为后续 `C-06 / D-06`（便携版 vs 安装版数据路径）与 Phase 2 历史管理预留干净边界，避免后期重构迁移命名空间 | 比 3 项目多 1 个轻量 `.csproj`；需在 `ADR-0001` 补一条附注或在决策记录中确认 6 区域口径 | **推荐提交负责人批准** |
| **方案 2（最小备选）**：作为 `WinDeviceInspector.Core` 内部模块 | 3 个（`App`、`Core`、`Collectors`） | `src/WinDeviceInspector.Core/Persistence/` | 1. Phase 1 项目数量最少（仅 3 个源码 `.csproj`）；2. 不超出 `ADR-0001` 原五项目清单 | 1. `Core` 混入 `System.IO` 文件读写与 `LocalApplicationData` 路径逻辑；2. 进入 Phase 2/5 扩展历史索引与便携数据路径时，仍大概率需拆出独立项目，造成命名空间调整 | **可行的最小备选**（若负责人倾向极简 `.csproj` 数） |
| **方案 3（不推荐）**：放入 `WinDeviceInspector.App` | 3 个 | `App` 内部服务目录 | 省去 1 个类库 | 违背架构“持久化不持有 UI 行为”原则；持久化与导出测试将被迫耦合 WPF 项目，破坏跨层测试隔离 | **明确排除** |

> **决策声明**：本方案建议采纳 **方案 1（独立 `WinDeviceInspector.Persistence`）**，同时保留 **方案 2** 供项目负责人二选一。最终采用哪一方案完全由项目负责人批准 C-02 后确定，阶段 B 严格按批准结果建仓。

## 3. 推荐的 Phase 1 最小解决方案结构（以方案 1 为主展示）

解决方案文件：`src/WinDeviceInspector.sln`（或根目录 `WinDeviceInspector.sln`，与 `docs/REPOSITORY_STRUCTURE.md` 及 `src/README.md` 保持一致；建议放于 `src/WinDeviceInspector.sln` 以便 `src/` 自包含，若负责人偏好根目录 `.sln` 可在阶段 B 授权时指定）。

### 3.1 阶段 B 实际创建的项目（4 源码 + 2 测试）

| 项目路径 | 目标框架 | 职责边界 | 允许依赖 | 明确禁止 |
| :--- | :---: | :--- | :--- | :--- |
| `src/WinDeviceInspector.Core/` | `net10.0` | Schema v1 正式 DTO/契约/枚举/校验规则、核心接口（`IScanConsentPrompt`、`IScanOrchestrator`、`IDeviceCollector`、`IPowerShellRunner`、`IScanHistoryStore`、`IExportWarningPrompt`、`IRawJsonExporter`）、**服务层扫描确认门禁（`ScanOrchestrator`）**、**原始 JSON 导出提示门禁（`RawJsonExportCoordinator`）** | 仅 .NET 基础库（零第三方必需依赖） | **严禁依赖 WPF / `App` / `Collectors` / `Persistence` / PowerShell / 磁盘 I/O** |
| `src/WinDeviceInspector.Collectors/` | `net10.0-windows` | 受控 PowerShell 子进程执行器（`PowerShellProcessRunner`：优先 `pwsh.exe` 回退 `powershell.exe`、版本检测、`-NoProfile`、固定随包脚本路径、UTF-8、stdout/stderr 分离、超时与取消终止子进程树）、捆绑只读采集脚本 `Scripts/Collect-QuickInventory.ps1`（9 类首轮采集）、结果解析与状态映射 | 仅依赖 `Core` | **严禁依赖 `App` / `Persistence`；严禁修改执行策略、自动提权、网络请求或系统写入** |
| `src/WinDeviceInspector.Persistence/` | `net10.0` | 本地扫描历史存储（`%LOCALAPPDATA%\WinDeviceInspector\History\`，单次扫描一个 JSON 文件、原子写入、历史列表读取、损坏 JSON 容错隔离）、原始 JSON 文件写出器（原样保留真实证据，绝不静默脱敏或改写字段） | 仅依赖 `Core` | **严禁依赖 `App` / WPF / `Collectors`；读取历史绝不触发任何采集** |
| `src/WinDeviceInspector.App/` | `net10.0-windows`（WPF） | 组合根（手工装配或轻量 DI，不引入重型框架）、无扫描空状态首页、扫描范围/敏感数据/权限确认弹窗、进度与取消界面、9 类结果展示、历史记录列表与详情视图、原始 JSON 导出前一次性敏感提示弹窗与 `SaveFileDialog` | 依赖 `Core`；组合根装配 `Collectors` 与 `Persistence`；ViewModel/视图仅调用 `Core` 抽象 | **严禁在构造函数、`OnStartup`、`Loaded`、历史打开或定时器中触发采集；严禁绕过服务层确认门禁** |
| `tests/WinDeviceInspector.Core.Tests/` | `net10.0`（xUnit） | 纯单元测试：Schema v1 契约/序列化/未知值/校验、服务层确认门禁、导出提示继续/取消门禁、本地历史读写与损坏文件容错（使用临时目录与合成数据） | 依赖 `Core`、`Persistence` | 严禁依赖 WPF 窗口、真实机器扫描结果或真实用户目录 |
| `tests/WinDeviceInspector.Collectors.Tests/` | `net10.0-windows`（xUnit） | 解析器单元测试（合成 JSON/畸形 JSON/stderr/非零退出码/部分失败）+ **PowerShell 7 与 Windows PowerShell 5.1 双版本集成测试**（标记 `[Trait("Category", "Integration")]`，验证双版本检测、UTF-8 输出、超时/取消终止进程树与非管理员降级） | 依赖 `Core`、`Collectors` | 严禁提交真实机器标识/序列号/用户路径；未在 Windows 11 x64 实测不得标通过 |

*(注：若项目负责人批准 C-02 为**方案 2**，则去掉 `src/WinDeviceInspector.Persistence/`，将其三个类移至 `src/WinDeviceInspector.Core/Persistence/`，其余 3 个源码项目与 2 个测试项目边界、依赖方向与测试矩阵完全保持不变。)*

### 3.2 Phase 1 暂不创建的项目与后续拆分触发条件

| 暂不创建的项目 | 对应阶段 | 明确拆分触发条件 |
| :--- | :---: | :--- |
| `src/WinDeviceInspector.Diagnostics/`（及对应测试） | Phase 3 | 启动 Windows System/Application 事件日志回溯、异常关机、Bugcheck/WHEA、RAC、WER 证据规范化与不确定性时间线关联时创建；依赖 `Core`，禁止依赖 `App` 与 `Collectors` |
| `src/WinDeviceInspector.Reporting/`（及对应测试） | Phase 4 | 启动全量/专项 AI Diagnostic Brief 生成、HTML/TXT 模板渲染、分享前真实内容预览与逐项字段勾选脱敏时创建；依赖 `Core`（及只读消费 `Diagnostics` 输出），禁止依赖 `App` 与 `Collectors` |
| 独立 `tests/WinDeviceInspector.Persistence.Tests/` | Phase 2 | 当本地历史引入索引、筛选、双次扫描差异对比或便携/安装双路径策略（C-06）导致持久化测试显著增长时，再从 `Core.Tests` 拆出独立测试项目 |

## 4. 核心能力在方案中的落位说明

1. **JSON Schema v1（C-01）**：集中定义于 `Core/Contracts/`（`ScanReportV1`、`CategoryResultV1`、`CategoryStatus`、`CollectionParameters`、`ScanReportValidator`、`ScanJsonSerializer`），固定 `schemaVersion = "v1"`，覆盖全部 8 个顶层必填/明确可空字段与 8 个类别字段；`CollectionParameters` 仅记录白名单执行参数，校验器拒绝秘密/令牌/任意命令文本；单元测试直接校验契约与边界值。
2. **PowerShell 7 & 5.1 双版本 Runner（C-03）**：封装于 `Collectors/PowerShell/`（`PowerShellLocator`、`PowerShellProcessRunner`、`PowerShellExecutionResult`）。按顺序探测 `pwsh.exe`（优先）与 `powershell.exe`（5.1 回退），执行固定随包脚本并传显式白名单参数，强制 UTF-8 编码、stdout 纯 JSON、stderr 诊断分离，记录实际运行时版本号（`runtimeName` / `runtimeVersion`）；超时或用户取消时调用 `Process.Kill(entireProcessTree: true)` 安全清理子进程树。
3. **扫描编排与服务层确认门禁**：位于 `Core/Orchestration/ScanOrchestrator.cs`。**确认门禁不仅在 UI，更在服务层强制执行**：`ExecuteScanAsync(ScanConsentGrant grant, CancellationToken ct)` 要求传入由显式确认动作颁发的不可伪造一次性格外令牌/授权对象（`grant.IsExplicitlyConfirmed == true` 且非空作用域）；若未确认或取消，服务层直接返回 `Canceled` 或抛出门禁异常，**绝不调用 `IDeviceCollector`**。应用层无任何启动扫描、定时器或自动重试循环。
4. **本地扫描历史（LocalApplicationData）**：位于 `Persistence/LocalScanHistoryStore.cs`（方案 1）或 `Core/Persistence/`（方案 2）。写入目录固定为 `%LOCALAPPDATA%\WinDeviceInspector\History\`（绝不写入仓库目录）；采用“写临时文件再原子替换”防止半写损坏；列表加载时对单个损坏 JSON 文件隔离报错而不崩溃，且打开任意历史记录只调用 `IScanHistoryStore`，在类型依赖上完全无法接触 `IDeviceCollector`。
5. **原始 JSON 导出前敏感信息提示（D-07）**：由 `Core/Export/RawJsonExportCoordinator.cs` 编排：
   - 第 1 步：调用 `IExportWarningPrompt.ShowRawExportWarningAsync()`（展示包含计算机名、序列号、MAC/IP、用户名、路径及设备元数据的风险提示）；
   - 第 2 步：若返回 `false`（用户取消），**立即中止，绝不调用文件保存对话框，绝不调用文件写出器**；
   - 第 3 步：仅在返回 `true` 后，才打开保存对话框获取目标路径，并由 `IRawJsonExporter` 原样写出未经修改、未脱敏的真实原始 JSON。

## 5. 依赖规则与测试覆盖映射

### 5.1 强制依赖约束（对照 `TASK-0001_阶段A_项目依赖图.mmd`）

- **单向无环（DAG）**：严格禁止任何循环依赖。
- **`Core` 零 UI / 零平台实现污染**：`Core` 不引用 `WPF`、`Collectors` 或 `Persistence`。
- **采集与持久化正交**：`Collectors` 与 `Persistence` 互不引用，确保“读历史绝不可能触发采集”。
- **面向接口装配**：`App` 仅在启动组合根组装具体实现，UI 层通过 `Core` 接口交互，保证门禁逻辑可脱离 WPF 窗口完成 100% 单元测试。

### 5.2 测试覆盖矩阵（对应任务书第 7 节验收标准）

| 验收维度 | 负责测试项目 | 验证方式与关键断言 |
| :--- | :--- | :--- |
| 启动/首页/读历史不触发采集；取消确认不启动进程；服务层门禁不可绕过 | `WinDeviceInspector.Core.Tests` | 使用 Fake `IDeviceCollector` 断言调用次数为 `0`；绕过确认直接调用 `ScanOrchestrator` 断言被门禁拦截 |
| Schema v1 字段、7 态枚举、UTC/时区、未知值、禁止密钥/命令文本 | `WinDeviceInspector.Core.Tests` | 合成 JSON 往返序列化、缺失必填字段校验失败、未知 `computerName` 显式表达、单类失败保留其余成功类 |
| 原始 JSON 导出提示（继续 vs 取消路径）与原样写出不脱敏 | `WinDeviceInspector.Core.Tests` | Fake `IExportWarningPrompt` 返回 `false` 时断言 `SaveDialog` 与 `FileWriter` 调用次数均为 `0`；返回 `true` 时断言输出字节与原始证据一致 |
| 本地历史保存、读取、损坏文件容错、打开历史不采集 | `WinDeviceInspector.Core.Tests` | 使用隔离临时目录测试正常读写与畸形 JSON 文件隔离，断言无采集调用 |
| stdout/stderr 分离、畸形 JSON、非零退出、部分失败、超时与取消杀进程树 | `WinDeviceInspector.Collectors.Tests` | 合成输出单元测试 + 真实子进程超时/取消集成测试 |
| PowerShell 7（`pwsh.exe`）与 Windows PowerShell 5.1（`powershell.exe`）双版本支持 | `WinDeviceInspector.Collectors.Tests` | Windows 11 x64 本机集成测试分别显式指定 `pwsh.exe` 与 `powershell.exe` 运行，核验版本检测、UTF-8 JSON、CIM 可用性与非管理员降级，记录实际运行版本与日志 |

## 6. 阶段 A 停止声明

本方案仅完成阶段 A 的结构设计、依赖边界与 C-02 取舍分析，**不代表方案已获批准，亦未启动阶段 B 编码**。后续须等待：
1. ChatGPT 对阶段 A 三份文件完成独立审查；
2. 项目负责人明确批准 **C-02**（确认采纳方案 1 还是方案 2，以及 `.sln` 放置位置偏好）；
3. ChatGPT 更新任务书与状态并正式发布阶段 B 开工授权后，方可执行阶段 B。
