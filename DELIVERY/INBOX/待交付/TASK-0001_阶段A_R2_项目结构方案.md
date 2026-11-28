# TASK-0001 阶段 A｜R2 项目结构方案（完整设备诊断演进基线）

- **任务编号**：TASK-0001（阶段 A — R2 架构方案修订）
- **方案状态**：待独立审查与项目负责人批准（仅文档修订，未创建或修改任何 `.sln`、`.csproj`、源码、脚本或测试项目，未进入阶段 B）
- **核验基准**：
  - 任务书基准提交：`de13ab6b6329a0067561f1051fae2682ecbf12ec`
  - 本次读取 `main` 最新 HEAD：`711b52e18845e8993e34bf17e906ad50fc6ad2e1`（`archive reviewed AI-WEB-FAST-002 R1 delivery`）
  - 依据文档：[docs/完整设备诊断与报告导出需求.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/%E5%AE%8C%E6%95%B4%E8%AE%BE%E5%A4%87%E8%AF%8A%E6%96%AD%E4%B8%8E%E6%8A%A5%E5%91%8A%E5%AF%BC%E5%87%BA%E9%9C%80%E6%B1%82.md)、[docs/reviews/TASK-0001_阶段A_R1_独立审查报告.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/reviews/TASK-0001_%E9%98%B6%E6%AE%B5A_R1_%E7%8B%AC%E7%AB%8B%E5%AE%A1%E6%9F%A5%E6%8A%A5%E5%91%8A.md)、[docs/TECHNICAL_ARCHITECTURE.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/TECHNICAL_ARCHITECTURE.md)、[docs/PRODUCT_REQUIREMENTS.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/PRODUCT_REQUIREMENTS.md)、[docs/ROADMAP.md](https://github.com/r3v01nter/WinDevice-Inspector/blob/main/docs/ROADMAP.md)
- **范围边界声明**：本方案在**架构与数据契约层面**全面承接完整设备诊断与四件套报告包（JSON/XLSX/HTML/AI 分析说明 ZIP）的长期产品目标，同时**严格维持 `TASK-0001` 阶段 B 仅实现最小垂直切片的授权边界**，不追溯扩大 Phase 1 编码范围，亦不替项目负责人裁决 C-02 或 `.sln` 位置。

---

## 1. 全量 PnP 设备架构（对应 R2-01）

R1 方案将设备采集按静态 9 类组织，无法直接承接“覆盖 Windows 当前可枚举全部设备”的正式产品目标。R2 改为**“通用全量 PnP 设备目录 + 多维视图分组”**架构：

### 1.1 通用设备枚举与四桶分类防重规则

在 `Core/Contracts/Devices/` 中定义统一设备集合 `DeviceCatalog` 与逐设备实体 `DeviceRecord`，通过规范化大写 `InstancePath`（`PNPDeviceID`）作为全局唯一去重键，并将所有枚举设备显式划分为 4 个互不重叠的分类桶（`DevicePresenceBucket`）：

| 分类桶 | 判定条件 | 是否计入“全部当前设备”主数 | 防重复与防误报规则 |
| :--- | :--- | :---: | :--- |
| `PresentPhysical` | `isPresent == true` 且非软件/虚拟/系统逻辑设备 | **计入** | 主故障排查对象；`ProblemCode != 0` 按规则评为 `Abnormal` 或 `Warning` |
| `PresentVirtualOrLogical` | `isPresent == true` 且属虚拟网卡、虚拟显示、软件打印、系统逻辑/根枚举设备（如 `ROOT\*`、`SWD\*`） | **计入总数，单列子计数** | 在总览与完整度统计中明确拆分“物理 vs 虚拟/逻辑”子计数，避免虚高或误导 |
| `HiddenOrNonPresent` | `isPresent == false` 且在设备管理器“显示隐藏设备”中可见 | **不计入当前设备主数** | 单独归入“隐藏与历史设备”视图/工作表，绝不与当前故障混报 |
| `HistoricalDisconnected` | 历史曾连接但当前离线/拔出的幽灵设备（如历史 USB 外设） | **不计入当前设备主数** | 仅作历史排查参考，绝不因 `Code 45`（未连接）触发当前设备 `Abnormal` 误报 |

### 1.2 逐设备字段落位（`Core/Contracts/Devices/DeviceRecord.cs`）

- **稳定标识与拓扑**：`deviceId`（由规范化 `instancePath` 派生的稳定短哈希/键，用于 XLSX/HTML/JSON 跨引用，不暴露多余结构）、`instancePath`（原始 `PNPDeviceID`）、`parentInstancePath`、`childDeviceIds[]`（显式父子拓扑）。
- **硬件与总线标识**：`hardwareIds[]`、`compatibleIds[]`、`deviceClass`、`classGuid`、`busType`、`interfacePath`、`serviceName`。
- **显示与分类属性**：`name`、`friendlyName`、`manufacturer`、`isPresent`、`isHidden`、`isVirtualOrSoftware`、`presenceBucket`。
- **状态与问题代码**：`pnpStatus`、`problemCode`（`ConfigManagerErrorCode`）、`problemDescription`。
- **驱动关联**：`driverRefId`（指向 `drivers[]` 中的稳定主键）及内联摘要 `driverSummary`（`infName`、`provider`、`version`、`driverDateUtc`、`isSigned`）。
- **双轴评估与证据引用**：`collectionStatus`、`diagnosticFinding`、`validityStatus`、`warnings[]`、`rawEvidenceRefId`。

---

## 2. 采集执行状态与诊断结论双轴模型（对应 R2-02）

为彻底杜绝“采集命令跑通就显示 Normal”或“读取失败被误判为正常/硬件损坏”，在**整次扫描、单个采集器、单个设备、单条传感器/健康指标**四个层级统一强制双轴分离存储，并叠加独立的数据有效性表达：

### 2.1 三组正交枚举（定义于 `Core/Contracts/Status/`）

1. **轴一：`CollectionStatus`（采集执行状态）**
   `Success` | `Partial` | `Unsupported` | `Unavailable` | `PermissionDenied` | `Failed` | `Skipped`
2. **轴二：`DiagnosticFinding`（诊断结论）**
   `Normal` | `Warning` | `Abnormal` | `CollectionFailed` | `Unsupported` | `Unavailable` | `Unknown`
3. **辅助轴：`DataValidityStatus`（数据有效性/可疑标记，含 `warnings[]`）**
   `Valid` | `Suspect` | `OutOfRange` | `Stale` | `Unverified`

### 2.2 强制映射规则与典型示例

| 场景示例 | `CollectionStatus` | `DataValidityStatus` | `DiagnosticFinding` | 规则说明 |
| :--- | :--- | :--- | :--- | :--- |
| 当前 GPU 在位，`ProblemCode = 0`，驱动已加载且有效 | `Success` | `Valid` | **`Normal`** | 采集成功且无异常证据 |
| 当前 USB 控制器在位，`ProblemCode = 43` | `Success` | `Valid` | **`Abnormal`** | **采集成功绝不等于健康正常** |
| 当前设备被手动禁用（`Code 22`），或近期有单条 `Kernel-Power 41` 历史日志 | `Success` | `Valid` | **`Warning`** | 需人工确认，不武断判为硬件损坏 |
| 传感器读到 `-273°C` 或 `65535 RPM` 等离群值 | `Success` | **`OutOfRange` / `Suspect`** | **`Warning`** 或 **`Unknown`** | 附独立警告，绝不按正常值采信 |
| 采集脚本超时、崩溃或返回畸形 JSON | `Failed` | `Unverified` | **`CollectionFailed`** | **严禁写成 `Normal` 或硬件损坏** |
| 非管理员读取受限通道或底层 SMART 接口被拒 | `PermissionDenied` | `Unverified` | **`Unavailable`** | 显式标注权限不足 |
| 台式机查询电池、或某硬件不支持温度传感器 | `Unsupported` | `Unverified` | **`Unsupported`** | 明确区分“不支持”与“故障” |
| 阶段未启用（如 Phase 1 暂不采集传感器） | `Skipped` | `Unverified` | **`Unknown`** | 显式记录至采集缺口，不隐瞒 |

---

## 3. 完整 Schema 与演进策略（对应 R2-03）

### 3.1 完整证据数据模型顶层结构（`Core/Contracts/Schema/`）

顶层契约 `ScanReport`（`schemaVersion = "1.0"`）固定包含 C-01 要求的全部基础字段，并以向后兼容的可选/扩展区块容纳完整诊断证据：

- **顶层元数据（Phase 1 必填）**：`schemaVersion`、`scanId`、`collectedAtUtc`、`timeZoneId`、`computerName`（不可用时按契约表达 `null` + `computerNameStatus: "Unavailable"`，绝不伪造）、`applicationVersion`、`collectorVersion`、`runtimeEnvironment`（实际使用的 PowerShell 版本与权限级别）。
- **核心证据区块**：
  - `categories[]`（兼容 C-01 逐类摘要：含 `id`、`name`、`collectionStatus`、`diagnosticFinding`、`source`、`collectedAtUtc`、`durationMs`、`queryParameters`、`warnings`、`data`）
  - `deviceCatalog`（`devices[]` 全量 PnP 设备 + 四桶统计口径）
  - `drivers[]`（签名驱动表）
  - `interfacesAndBuses[]`（PCI/PCIe、USB、SATA、NVMe、网络、音频、显示接口链路状态）
  - `sensors[]`（传感器读数：强制包含 `value`、`unit`、`source`、`collectedAtUtc`、`readMethod`、`validityCheck`、`referenceThresholdBasis`、`collectionStatus`、`diagnosticFinding`）
  - `storageHealth[]`（SMART / NVMe 健康指标与接口能力标记）
  - `systemEvents[]`（PnP 问题、Kernel-Power、BugCheck、WHEA-Logger、PCIe/存储/GPU/USB/网络/音频、RAC/WER 时间线，记录查询起止时间与参数）
  - `collectionGaps[]`（全部 `Failed`/`PermissionDenied`/`Unsupported`/`Unavailable`/`Skipped` 缺口汇总与原因）
  - `rawEvidenceRefs[]`（复杂原始字段/大块诊断文本的稳定 ID 引用索引，确保 XLSX 扁平化时不静默丢弃原始细节）
  - `completeness`（采集完整性统计对象）

### 3.2 纯合成数据示例（JSON 片段，不含任何真实机器标识或个人数据）

```json
{
  "schemaVersion": "1.0",
  "scanId": "00000000-0000-4000-8000-000000000001",
  "collectedAtUtc": "2026-11-27T12:00:00Z",
  "timeZoneId": "UTC",
  "computerName": "SYNTH-WORKSTATION-01",
  "applicationVersion": "0.1.0-alpha",
  "collectorVersion": "1.0.0",
  "runtimeEnvironment": {
    "powerShellEdition": "Core",
    "powerShellVersion": "7.4.6",
    "isAdministrator": false
  },
  "completeness": {
    "countingMethod": "PresentDevicesOnly_SplitPhysicalAndVirtual",
    "totalEnumeratedDevices": 3,
    "presentPhysicalCount": 1,
    "presentVirtualCount": 1,
    "hiddenOrHistoricalCount": 1,
    "collectionStatusCounts": { "Success": 2, "PermissionDenied": 1, "Skipped": 1 },
    "diagnosticFindingCounts": { "Normal": 1, "Abnormal": 1, "Unavailable": 1, "Unknown": 1 }
  },
  "devices": [
    {
      "deviceId": "dev-synth-001",
      "instancePath": "PCI\\VEN_10DE&DEV_0000\\SYNTH_0001",
      "hardwareIds": ["PCI\\VEN_10DE&DEV_0000"],
      "parentInstancePath": "PCI\\VEN_8086&DEV_0001\\SYNTH_ROOT",
      "childDeviceIds": [],
      "deviceClass": "Display",
      "name": "Synthetic GPU Adapter",
      "presenceBucket": "PresentPhysical",
      "isPresent": true,
      "isHidden": false,
      "isVirtualOrSoftware": false,
      "problemCode": 43,
      "driverRefId": "drv-synth-001",
      "collectionStatus": "Success",
      "diagnosticFinding": "Abnormal",
      "validityStatus": "Valid",
      "warnings": ["Device reported Problem Code 43"],
      "rawEvidenceRefId": "raw-dev-synth-001"
    }
  ],
  "sensors": [
    {
      "sensorId": "sns-synth-cpu-temp",
      "deviceId": "dev-synth-cpu",
      "metric": "Temperature",
      "value": -273.0,
      "unit": "C",
      "source": "SyntheticWmiThermalZone",
      "collectedAtUtc": "2026-11-27T12:00:01Z",
      "readMethod": "CIM:MSAcpi_ThermalZoneTemperature",
      "validityCheck": { "status": "OutOfRange", "reason": "Value below physical operating floor" },
      "referenceThresholdBasis": "Expected operating range 0..115 C",
      "collectionStatus": "Success",
      "diagnosticFinding": "Warning"
    }
  ],
  "collectionGaps": [
    {
      "area": "StorageHealth.NVMeSmart",
      "collectionStatus": "PermissionDenied",
      "diagnosticFinding": "Unavailable",
      "reason": "Raw SMART passthrough requires elevated privileges"
    }
  ]
}
```

### 3.3 版本演进与兼容策略

- **次版本增量演进（`1.0` → `1.1` → `1.2`）**：仅允许新增可选属性或新枚举扩展项，绝不删除或修改已有字段语义。Phase 1 产出 `1.0` 时，尚未启用的 Phase 2–3 区块（如 `sensors`、`systemEvents`）明确置空数组并在 `collectionGaps` 标为 `Skipped` + `Unknown`。
- **主版本升级（`2.0`）**：仅在发生结构性破坏变更时递增主版本，并通过 `Core` 中的 `IScanSchemaReader` / 版本分发反序列化器兼容读取历史 `1.x` 本地扫描记录。
- **反序列化容错**：JSON 反序列化默认忽略未知新增字段，避免旧版读取新版或未来演进时崩溃；同时使用 `ScanReportValidator` 严格校验必填字段、UTC ISO-8601 时间格式及禁止将密钥/任意命令文本写入 `queryParameters`。

---

## 4. 采集器与 Diagnostics 边界（对应 R2-04）

### 4.1 采集器模块拆分（`WinDeviceInspector.Collectors`）

`WinDeviceInspector.Collectors` 仅依赖 `Core`，内部按单一职责拆分为 6 个可独立单元测试的采集模块（共享受控 `IPowerShellRunner`）：

| 采集模块 | 职责范围 | 落地阶段 | 失败/权限降级与 PS 7/5.1 策略 |
| :--- | :--- | :---: | :--- |
| `PnpDeviceCollector` | 全量 PnP 设备枚举、父子拓扑、硬件 ID、Problem Code、在位/隐藏/虚拟标记 | Phase 1 起步，Phase 2 深化 | 只读 `Get-CimInstance` / PnP 查询；PS 7 & 5.1 双兼容 |
| `DriverCollector` | 签名驱动清单、版本/日期/提供商与设备绑定 | Phase 1 | 单项缺失标 `Unavailable`，不阻断其他设备 |
| `HardwareInventoryCollector` | OS、CPU、GPU、内存、主板、BIOS、磁盘/逻辑卷 | Phase 1 | 显存/序列号不可读标 `Unavailable`/`Unknown` |
| `InterfaceAndBusCollector` | PCI/PCIe 链路、USB、SATA/NVMe 控制器、网卡、音频、显示接口状态 | Phase 2 | 缺特定 cmdlet 时回退标准 CIM，不支持标 `Unsupported` |
| `SensorAndHealthCollector` | 受支持的传感器（含完整元数据与有效性）及 SMART/NVMe 存储健康 | Phase 2 | 非管理员受限标 `PermissionDenied`，硬件不支持标 `Unsupported` |
| `ReliabilityEventCollector` | PnP/Kernel-Power/BugCheck/WHEA/PCIe/存储/GPU/USB/网络/音频事件及 RAC/WER | Phase 3 | 必须记录精确查询窗口参数；空结果按 0 条 `Success`+`Normal` 处理 |

- **受控 PowerShell 7 & 5.1 双版本 Runner（C-03）**：优先探测 `pwsh.exe`（PS 7），回退 `powershell.exe`（PS 5.1）；强制 `-NoProfile`、固定随包只读脚本、UTF-8、stdout 纯 JSON 与 stderr 诊断分离、超时与取消终止子进程树；不修改机器级 ExecutionPolicy、不静默提权、不拼接任意命令，并记录实际运行的 PowerShell 版本。

### 4.2 `WinDeviceInspector.Diagnostics` 边界（Phase 3 触发创建）

- **依赖方向**：`Diagnostics` **仅依赖 `Core`**，**严禁依赖 `Collectors`、`Persistence` 或 `App`**。
- **核心职责**：只读消费 `Core` 的不可变 `ScanReport`，执行事件时间线规范化、跨源证据关联（例如将设备 `Code 43` 与驱动版本及 WHEA/BugCheck 关联）、传感器离群值校验、完整性汇总与双轴 `DiagnosticFinding` 综合评估。
- **硬安全约束**：`Diagnostics` 在类型依赖上完全接触不到 `IPowerShellRunner` 或 `IDeviceCollector`，**绝不可能启动扫描或修改系统**。

---

## 5. Reporting 与统一报告包架构（对应 R2-05）

### 5.1 模块边界与数据流

- **Phase 1（`TASK-0001` 阶段 B）**：仅实现原始 JSON 导出（由 `Core` 导出协调器 + `Persistence` 文件写出器完成），**暂不创建 `WinDeviceInspector.Reporting` 项目**。
- **Phase 4 触发创建 `WinDeviceInspector.Reporting`**：仅依赖 `Core`（及只读消费 `Diagnostics` 输出），严禁依赖 `App` 或 `Collectors`。
- **统一数据流**：
  `ScanReport（只读快照）` → `[可选：用户逐项勾选后的 RedactedReportCopy，绝不修改原件]` → 并行/顺序生成四件套：
  1. `JsonReportWriter` → `完整诊断数据.json`
  2. `XlsxWorkbookBuilder` → `设备状态清单.xlsx`
  3. `HtmlOverviewRenderer` → `诊断总览报告.html`
  4. `AiAnalysisGuideBuilder` → `AI分析说明.md`
  → `ReportPackageBundler` → 统一打包输出用户选定路径的 `.zip` 报告包。

### 5.2 `设备状态清单.xlsx` 工作表规划（共 11 张表）

| 序号 | 工作表名 | 行粒度与核心内容 | 复杂字段保真策略 |
| :---: | :--- | :--- | :--- |
| 1 | `诊断总览` | 扫描元信息、双轴状态统计、关键异常与警告摘要、完整性 KPI | 标注本次报告是“原始证据”还是“脱敏副本” |
| 2 | `全部当前设备` | **每个当前在位设备严格一行**（区分物理与虚拟子标识） | 含稳定 `deviceId` 与 `rawEvidenceRefId`，关联 `完整诊断数据.json`，**绝不静默丢弃复杂字段** |
| 3 | `异常设备` | 全部 `DiagnosticFinding == Abnormal` 设备明细 | 附 `ProblemCode`、错误释义与关联驱动 |
| 4 | `警告设备` | 全部 `DiagnosticFinding == Warning` 设备与可疑指标 | 注明警告原因与有效性检查结果 |
| 5 | `隐藏与历史设备` | 全部 `HiddenOrNonPresent` 与 `HistoricalDisconnected` 设备 | 独立成表，注明不计入当前设备故障统计 |
| 6 | `驱动清单` | 全部签名驱动（INF、提供商、版本、日期、签名状态、绑定设备 ID） | 通过 `driverRefId` 与设备表双向关联 |
| 7 | `接口与总线` | PCI/PCIe、USB、SATA/NVMe、网络、音频、显示控制器与链路状态 | 保留原始速率/状态与不支持说明 |
| 8 | `传感器与健康` | 传感器读数（数值、单位、来源、时间、方法、有效性、阈值依据）+ SMART/NVMe | 离群值显式标 `OutOfRange`/`Suspect` |
| 9 | `系统事件` | 按时间线排序的可靠性与错误事件 | 顶部写明精确查询起止 UTC 时间与参数 |
| 10 | `采集失败与无法检测` | 全部 `Failed`/`PermissionDenied`/`Unsupported`/`Unavailable`/`Skipped` 项 | 逐项列出原因与权限/环境说明 |
| 11 | `采集完整性` | 设备枚举总数、统计口径、各采集器耗时、双轴覆盖率统计 | 满足“全部汇报”原则 |

### 5.3 XLSX 与 ZIP 库候选评估（仅建议，本轮不新增生产依赖）

| 类别 | 候选库 | 许可证 | 维护与生态 | 体积与依赖 | .NET 10 兼容与可测试性 | 评估建议 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **ZIP** | **`System.IO.Compression.ZipArchive`**（BCL 内置） | MIT（.NET 官方） | 官方长期维护 | **零额外体积/依赖** | 原生支持，内存流测试极简 | **强烈推荐（无需第三方库）** |
| **XLSX** | **`ClosedXML`** | MIT | 社区极活跃，API 直观 | 中等（依赖 `DocumentFormat.OpenXml`） | 支持多表、冻窗、表头、自动列宽，内存流校验方便 | **Phase 4 首选候选** |
| **XLSX** | `DocumentFormat.OpenXml` | MIT（微软官方） | 官方维护 | 轻量 | 性能高但样式/表格手写繁琐、代码维护成本高 | 备选（极度追求低依赖时考虑） |
| **XLSX** | `MiniExcel` | Apache-2.0 | 活跃 | 小巧、流式低内存 | 适合大数据导出，但多表精细排版与表头样式能力弱于 ClosedXML | 备选（仅极简表格需求时考虑） |
| **XLSX** | `EPPlus` | Polyform Noncommercial / 商业许可 | 活跃 | 中等 | 存在非 MIT 商用许可限制 | **明确排除** |

*(注：本轮阶段 A 仅提出技术选型建议，不引入任何第三方生产依赖；实际引入须待 Phase 4 正式立项并由项目负责人批准。)*

---

## 6. 隐私与导出门禁（对应 R2-06）

在 `Core/Export/` 定义统一门禁 `IReportExportCoordinator` 与 `IExportConsentGate`，同时覆盖 **Phase 1 原始 JSON 导出（D-07）** 与 **Phase 4 统一 ZIP 报告包导出**：

1. **导出前统一提示**：无论导出单份原始 JSON 还是四件套 ZIP，在打开系统 `SaveFileDialog` 之前，必须先弹出一次明确的隐私风险提示，列出可能包含的敏感信息（计算机名、设备序列号、MAC/IP、用户名、路径、设备/系统元数据及事件日志）。
2. **取消绝对门禁**：用户点击取消时，协调器立即返回 `ExportResult.Canceled`，**绝不打开保存对话框、绝不创建临时文件、绝不调用任何文件写出或 ZIP 打包逻辑**。
3. **原始证据与脱敏分享副本严格分离**：
   - **原始证据报告（Raw Evidence）**：默认原样保留 100% 真实证据，**严禁静默删改或自动脱敏字段**；
   - **可选脱敏分享副本（Redacted Share Copy，Phase 4）**：仅当用户主动选择“生成脱敏分享副本”、逐项勾选排除字段并核对真实内容预览后，才基于只读快照生成独立脱敏副本，绝不覆盖原始历史文件。

---

## 7. 采集完整性统计与分阶段测试矩阵（对应 R2-07）

### 7.1 采集完整性统计模型（`CollectionCompleteness`）

每次扫描必须生成结构化完整性统计，包含：设备枚举总数、当前物理/虚拟子计数、隐藏与历史设备数、统计口径说明、逐采集器与逐类别的 `CollectionStatus`（7 态）计数、`DiagnosticFinding`（7 态）计数，以及 `Invalid / Suspect` 数据计数，确保任何缺失项都在 UI、JSON、XLSX 与 HTML 中透明汇报。

### 7.2 分阶段测试矩阵（2 个 Phase 1 测试项目 + 后续扩展）

- **Phase 1 创建的测试项目**：`tests/WinDeviceInspector.Core.Tests/`（`net10.0`，纯单元测试）与 `tests/WinDeviceInspector.Collectors.Tests/`（`net10.0-windows`，解析单元测试 + PowerShell 7/5.1 双版本集成测试）。所有测试夹具必须使用**纯合成数据**。

| 测试维度 | 所属阶段 | 负责测试项目 | 核心验收断言 |
| :--- | :---: | :--- | :--- |
| 启动/首页/读历史不触发采集；取消确认不启动进程；服务层门禁不可绕过 | **Phase 1 必测** | `Core.Tests` | Fake `IDeviceCollector` 调用次数严格为 `0`；无确认令牌直接调编排器必被拦截 |
| 通用 PnP 合成数据（重复实例去重、父子拓扑、隐藏/历史/虚拟分类、Problem Code） | **Phase 1 必测** | `Core.Tests` + `Collectors.Tests` | 离线 `Code 45` 不触发当前设备 `Abnormal`；`Code 43` 准确映为 `Success`+`Abnormal` |
| 双轴状态映射与完整性统计（禁将 Failed/Unsupported/Unavailable 写为 Normal） | **Phase 1 必测** | `Core.Tests` | 覆盖全部 7×7 关键组合与 `CollectionCompleteness` 计数一致性 |
| Schema v1 契约校验、未知字段向后兼容、禁写密钥/命令文本 | **Phase 1 必测** | `Core.Tests` | 必填/可空/UTC/时区校验；未知 JSON 字段反序列化不崩溃 |
| PowerShell 7（`pwsh.exe`）与 Windows PowerShell 5.1（`powershell.exe`）双版本实测 | **Phase 1 必测** | `Collectors.Tests` | 版本检测、实际版本记录、UTF-8、stdout/stderr 分离、超时/取消终止子进程树、非管理员降级 |
| 本地历史保存、读取、损坏 JSON 容错、打开历史不采集 | **Phase 1 必测** | `Core.Tests` | 隔离临时目录测试；损坏文件被隔离不崩溃 |
| 原始 JSON 导出前提示（继续 vs 取消路径）与原样保真 | **Phase 1 必测** | `Core.Tests` | 取消时 `SaveDialog` 与 `FileWriter` 调用次数均为 `0`；继续时输出未经脱敏修改 |
| 传感器离群/无效值检测与完整元数据校验 | **Phase 2 必测** | `Core.Tests` + `Collectors.Tests` | `-273°C` 等离群值标 `OutOfRange`+`Warning`，缺单位/来源/时间时校验报错 |
| SMART / NVMe 能力差异（NVMe/SATA/虚拟盘/无权限降级） | **Phase 2 必测** | `Collectors.Tests` | 权限不足标 `PermissionDenied`+`Unavailable`，不支持标 `Unsupported` |
| 事件时间线规范化与跨源证据关联（禁启动扫描） | **Phase 3 必测** | `Diagnostics.Tests` | 合成 WHEA/BugCheck/KP41 关联正确；项目引用图证明 `Diagnostics` 无法访问 `Collectors` |
| XLSX 11 表行数与 `deviceId` 一致性、HTML 渲染安全、ZIP 四件套完整性、脱敏副本不改原件 | **Phase 4 必测** | `Reporting.Tests` | 校验 11 张表存在、每个当前设备严格一行、ZIP 内四文件齐全且脱敏操作零修改原始快照 |

---

## 8. C-02（Persistence 边界）与 `.sln` 位置对比（对应 R2-08，待负责人批准）

### 8.0 解决方案项目与测试项目总览（与 `TASK-0001_阶段A_R2_项目依赖图.mmd` 节点严格一致）

| 项目全称 | 阶段 | 目标框架 | 核心职责 |
| :--- | :---: | :---: | :--- |
| `WinDeviceInspector.App` | Phase 1 | `net10.0-windows` (WPF) | 空状态首页、扫描确认弹窗、进度/取消、历史浏览、统一导出隐私提示与保存框、组合根装配 |
| `WinDeviceInspector.Core` | Phase 1 | `net10.0` | 全量 PnP `DeviceCatalog`、双轴状态、Schema v1 契约与校验、`CollectionCompleteness`、扫描与导出门禁、核心接口（零 WPF/磁盘 I/O 依赖） |
| `WinDeviceInspector.Collectors` | Phase 1 起步 | `net10.0-windows` | PS 7 & 5.1 双版本只读 Runner 与 6 大可独立测试采集模块 |
| `WinDeviceInspector.Persistence` | Phase 1（C-02 待批准） | `net10.0` | `LocalAppData` 扫描历史、原子 JSON 读写、损坏容错、原始证据 JSON 写出（若批准方案 2 则并入 `Core/Persistence`） |
| `WinDeviceInspector.Diagnostics` | Phase 3 触发 | `net10.0` | 事件时间线规范化、跨源证据关联、传感器离群校验与诊断结论综合（仅依赖 `Core`，严禁启动扫描） |
| `WinDeviceInspector.Reporting` | Phase 4 触发 | `net10.0` | 四件套报告包（JSON / 11 表 XLSX / HTML / AI 分析说明 / `ZipArchive`）与可选脱敏副本 |
| `WinDeviceInspector.Core.Tests` | Phase 1 | `net10.0` | 确认门禁、双轴状态、PnP 分类去重、Schema v1、完整性统计、本地历史容错与导出取消门禁测试 |
| `WinDeviceInspector.Collectors.Tests` | Phase 1 | `net10.0-windows` | PnP/ProblemCode 解析、畸形 JSON/stderr、PS 7 & 5.1 双版本集成测试、超时取消杀进程树 |
| `WinDeviceInspector.Diagnostics.Tests` | Phase 3 触发 | `net10.0` | 事件时间线规范化与跨源证据关联单元测试 |
| `WinDeviceInspector.Reporting.Tests` | Phase 4 触发 | `net10.0` | 11 表 XLSX、HTML、四件套 ZIP 完整性及脱敏不改原件单元测试 |

### 8.1 C-02：完整产品目标下的 Persistence 边界对比

在确认完整设备诊断、历史对比、四件套报告包与未来便携/安装双路径策略（D-06）后，两种方案对比如下：

| 方案 | Phase 1 源码项目 | 优点 | 缺点 | 在完整产品目标下的适配度 |
| :--- | :--- | :--- | :--- | :--- |
| **方案 1（推荐）：独立 `WinDeviceInspector.Persistence`** | 4 个（`App`、`Core`、`Collectors`、`Persistence`） | `Core` 保持 100% 纯契约与双轴/完整性逻辑（零磁盘 I/O）；`Diagnostics` 与 `Reporting` 仅依赖 `Core`，天然与磁盘历史和采集隔离；后续接 D-06（便携/安装路径）无需重构 `Core` | Phase 1 多 1 个轻量 `.csproj`，需在 `ADR-0001` 补注确认 6 区域口径 | **高（推荐提交负责人批准）** |
| **方案 2（备选）：并入 `WinDeviceInspector.Core/Persistence/`** | 3 个（`App`、`Core`、`Collectors`） | Phase 1 `.csproj` 数量最少，不超出 `ADR-0001` 原五项目清单 | `Core` 混入文件系统 I/O 与路径逻辑；未来 Phase 2/5 扩展历史索引与双分发路径时仍需拆出独立项目，引发命名空间重构 | **中（可行备选）** |

### 8.2 解决方案文件（`.sln`）位置对比

| 方案 | 路径 | 优点 | 缺点 |
| :--- | :--- | :--- | :--- |
| **位置 A（推荐）：仓库根目录** | `WinDeviceInspector.sln` | 覆盖同级 `src/` 与 `tests/` 最自然；Visual Studio、Rider 及根目录 `dotnet build` / `dotnet test` 开箱即认，符合 .NET 主流工程规范 | 仓库根目录多 1 个 `.sln` 文件 |
| **位置 B（备选）：`src/` 目录内** | `src/WinDeviceInspector.sln` | 根目录更简洁 | `tests/` 位于 `../tests/` 跨级引用略不对称；命令行构建每次需显式指定 `src/WinDeviceInspector.sln` |

> **审批声明**：上述 **C-02（方案 1 vs 方案 2）** 与 **`.sln` 位置（根目录 vs `src/`）** 均严格留待项目负责人最终批准。本方案仅作技术论证，不构成批准决定，亦未启动阶段 B。
