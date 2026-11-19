# WinDevice-Inspector 下一步开发建议与路线图（WDI-AUDIT-0001）

* **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）

* **当前真实阶段**：**Phase 0 收尾（7/9 项完成）→ Phase 1（`TASK-0001`）待生产**；仓库内尚无任何已提交或已验收的应用源码与测试代码。

* **规划原则**：先用最小成本消除阻断性文档冲突并落地任务中心，再立刻推进首个可运行垂直切片 `TASK-0001`，避免陷入“持续写文档而不出代码”的文档膨胀陷阱。

## 1. 近期执行顺序建议（4 步走）

### 第一步：Phase 0 轻量收尾与 5 项前置决策（预计 1 次决策会话）

在启动任何 C# 代码生产前，建议用户与 ChatGPT 一次性拍板以下阻塞/基础项：

1. **选定许可证**：添加根目录 `LICENSE` 文件（并顺手填写 GitHub 仓库 About 简介与 Topics）。

2. **记录本机开发环境基线**：用户在 Windows 11 x64 本机运行一次环境检查（`dotnet --info`、`pwsh --version`、`powershell $PSVersionTable`），确认 `.NET 10 SDK` 与 PowerShell 环境就绪。

3. **统一 3 项技术口径**：

   * `TASK-0001` 是否采用完整架构 JSON Schema（补入 `timeZoneId`、`applicationVersion`、`durationMs`、查询参数）；

   * `ADR-0001` 与 `TECHNICAL_ARCHITECTURE.md` 对 `WinDeviceInspector.Persistence` 项目的拆分口径；

   * `powershell.exe`（5.1）回退是否作为 Phase 1 强制兼容要求。

4. **确认文件命名语言**：确定 `DELIVERY/INBOX/TASK-XXXX/` 内使用中文文件名还是与全仓一致的英文文件名，以及 `PROJECT_STATUS.md` 的去留方式。

### 第二步：落地任务中心并修订 `TASK-0001`（建议作为极简治理任务 `WDI-GOV-0001` 或由 ChatGPT/用户直接合入）

* 按 `WDI_Task_Center_Design.md` 新增 `docs/task-center/`（5 个核心文件）、`docs/reviews/`、`docs/issues/` 及 2 份新模板；

* 按 `WDI_Proposed_File_Changes.md` 同步更新 `TASK-0001-vertical-slice.md`（补齐 4 个 JSON 字段、补入“禁止自动重试扫描”、统一状态为 `待生产`、对齐交付包结构）；

* 将 `docs/task-center/CURRENT_TASK.md` 正式指向 `TASK-0001`。

### 第三步：执行首个开发任务 `TASK-0001`（建议的下一项核心开发任务）

* **推荐下一项开发任务**：**`TASK-0001` — First Runnable Vertical Slice（首个可运行垂直切片）**。

* **推荐理由**：

  * 这是唯一能打通“WPF 界面 → 显式扫描确认门禁 → 受控 PowerShell 只读子进程 → 版本化 JSON 契约 → 本地历史保存与原始 JSON 导出 → 单元测试”全链路的核心里程碑；

  * 只有 `TASK-0001` 在用户 Windows 11 x64 本机跑通并通过验收，后续 Phase 2–5 才建立在真实可运行工程之上。

* **严格验收门槛（本机实测清单）**：

  1. 启动应用后不触发任何 PowerShell 进程或硬件查询；

  2. 点击 `Start Quick Collection` 展示采集范围与敏感提示，点击取消绝不启动子进程；

  3. 非管理员权限下确认扫描，能成功产出符合架构 Schema 的本地 JSON 并展示 9 类初始类别状态（单项失败不影响其他类别）；

  4. 取消/超时能安全终止 PowerShell 子进程树；

  5. 关闭重启后可重新打开本地历史且不触发新扫描，可显式导出原始 JSON；

  6. `dotnet build` 与 `dotnet test` 在本机 Windows 11 x64 实测通过，证据归档至 `docs/reviews/` 后方可标记 `验收通过`。

### 第四步：Phase 2–5 渐进式任务拆解建议（规划参考，暂不提前立项）

| 阶段 | 建议任务编号与主题 | 核心交付目标 | 前置依赖 | 
| ----- | ----- | ----- | ----- | 
| Phase 2 | `TASK-0002` 完整硬件与驱动清单采集扩展 | 补齐显示器、音频、USB、蓝牙、完整驱动列表及存储健康只读采集 | `TASK-0001` 验收通过 | 
| Phase 2 | `TASK-0003` 本地历史管理与扫描记录对比 | 历史删除、筛选、双次扫描差异对比及损坏文件容错增强 | `TASK-0002` | 
| Phase 2 收尾 | `ADR-0002` 打包形态与便携/安装版数据路径决策 | 锁定便携版与安装版的数据目录隔离机制，避免后期重构持久化层 | `TASK-0003` | 
| Phase 3 | `TASK-0004` Windows 可靠性与错误事件时间线 | System/Application 日志回溯窗口、异常关机、Bugcheck/WHEA、RAC、WER 证据采集与不确定性标注 | `TASK-0002` | 
| Phase 4 | `TASK-0005` 隐私预览选择与全量/专项 AI 诊断简报 | 真实内容预览、敏感字段逐项勾选/排除、Full/Focused 简报及 HTML/TXT/复制导出 | `TASK-0004` | 
| Phase 5 | `TASK-0006` 便携版/安装版打包、CI 与发布就绪 | 便携包 + Windows 安装器、崩溃日志、隐私安全复核、GitHub Actions CI 与发布流程 | `TASK-0005` + `ADR-0002` | 

## 2. 需用户拍板的决策汇总表

| 序号 | 待用户决策事项 | 可选方案 | 推荐倾向 | 
| ----- | ----- | ----- | ----- | 
| 1 | 开源许可证选择 | MIT / Apache-2.0 / GPL-3.0 / 暂保留所有权利 | 若希望个人桌面工具广泛易用，通常可选 MIT 或 Apache-2.0（由用户最终决定） | 
| 2 | 交付包内文件命名语言 | 方案 A：中文名（`原始交付/`、`完成回执.md` 等）；方案 B：全仓统一英文名（`raw-delivery/`、`COMPLETION_RECEIPT.md` 等） | 若仓库其余 21 文件及代码均面向英文工程体系，建议**全仓统一英文文件名**（文档正文可按需中英双语），或明确规定仅 `DELIVERY/` 使用中文 | 
| 3 | `docs/PROJECT_STATUS.md` 处置 | 方案 A：合并至 `docs/task-center/` 并改为精简跳转页；方案 B：保留为阶段高层摘要，删去重复细目 | **方案 A**（最大程度消除状态多处同步负担） | 
| 4 | `TASK-0001` JSON Schema 口径 | 方案 A：开工前补齐架构第 7 节的 4 个字段；方案 B：Phase 1 保持精简，Phase 2 升 Schema 版本 | **方案 A**（增加成本极低，避免 Phase 2 破坏性历史文件迁移） | 
| 5 | `WinDeviceInspector.Persistence` 拆分口径 | 方案 A：在 `ADR-0001` 增补备注统一为 6 项目；方案 B：Phase 1 先合入 `Core`，Phase 2 再独立 | **方案 A（架构文档对齐）+ Phase 1 按需最小化落地** | 
| 6 | `powershell.exe`（5.1）回退定位 | 方案 A：Phase 1 即要求 `pwsh.exe` 优先、`powershell.exe` 兼容回退；方案 B：仅支持 PowerShell 7 | **方案 A**（Windows 11 默认不带 `pwsh.exe`，兼容 5.1 能显著提升开箱体验） | 
