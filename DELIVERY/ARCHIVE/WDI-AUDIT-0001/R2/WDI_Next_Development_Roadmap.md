# WinDevice-Inspector 下一步开发建议与路线图（WDI-AUDIT-0001）

* **任务编号**：WDI-AUDIT-0001（第二轮审查修订版）

* **目标仓库**：[r3v01nter/WinDevice-Inspector](https://github.com/r3v01nter/WinDevice-Inspector)（`main` 分支）

* **审计快照基准日期**：2026-11-19（截至提交 `29758c5`，共 21 个文件；历史快照，不代表当前实时仓库状态）

* **快照时刻真实阶段**：**Phase 0 收尾（7/9 项完成）→ Phase 1（`TASK-0001`）待生产**；快照时刻仓库内尚无任何已提交或已验收的应用源码与测试代码。

* **规划原则**：先用最小成本解决阻断性口径差异、落地任务中心并补齐 Phase 0 前置条件，再立即推进首个可运行垂直切片 `TASK-0001`，避免陷入“持续写文档而不出代码”的文档膨胀陷阱。以下所有安排均为**建议方案（尚未实施）**。

## 1. 下一步开发路线与未决决策的依赖关系

为避免在未决架构/管理问题上盲目开工或返工，以下明确标注各阶段对尚待决策事项（编号与 `WDI_Project_Facts.md` 第 4 节一致）的依赖关系：

| 后续阶段 / 任务 | 直接依赖的未决事项 | 是否阻塞开工 | 处理策略 | 
| ----- | ----- | ----- | ----- | 
| **Phase 0 正式收尾** | D-01（许可证）、D-08（GitHub 元数据）、D-09（本机开发环境核查） | **阻塞 Phase 0 闭环** | 由用户决策许可证并运行一次本机环境核查 | 
| **任务中心与交付规范落地** | D-05（交付包内部命名语言）、D-10（`PROJECT_STATUS.md` 去留） | **阻塞任务中心正式合入** | 与 `DELIVERY/INBOX/待交付/` 入口一并确认后一次性落地 | 
| **`TASK-0001`（Phase 1 垂直切片）** | D-02（`Persistence` 项目拆分口径）、D-03（JSON Schema 4 个缺失字段）、D-04（PowerShell 5.1/7 兼容性测试要求与验收口径）、D-07（原始 JSON 导出敏感提示） | **D-02 / D-03 / D-04 建议开工前先拍板** | 均属轻量口径与测试标准确认，拍板并更新任务书后再交给 Gemini 生产，可避免 Phase 2 返工 | 
| **Phase 2 持久化定型 & Phase 5 打包分发** | D-06（便携版 vs 安装版打包方案与数据路径，`ADR-0002`） | **不阻塞 `TASK-0001`，但阻塞 Phase 2 收尾与 Phase 5** | 在 Phase 2 历史管理定型前通过 `ADR-0002` 锁定，避免后期重构持久化路径 | 

## 2. 近期执行顺序建议（4 步走）

### 第一步：Phase 0 轻量收尾与前置决策（预计 1 次决策会话）

在启动任何 C# 代码生产前，建议用户与 ChatGPT 一次性确认以下前置项：

1. **选定许可证与补全元数据（D-01 / D-08）**：确定开源许可证类型以添加根目录 `LICENSE`，并填写 GitHub 仓库 About 简介与 Topics。

2. **记录本机开发环境基线（D-09）**：用户在 Windows 11 x64 本机运行一次环境检查（`dotnet --info`、`pwsh --version`、`powershell $PSVersionTable`），确认 `.NET 10 SDK` 与 PowerShell 环境就绪。

3. **统一 `TASK-0001` 开工前 3 项技术/测试口径（D-02 / D-03 / D-04）**：

   * `TASK-0001` 是否提前补齐架构第 7 节的 4 个 JSON 字段（`timeZoneId`、`applicationVersion`、`durationMs`、查询参数）；

   * `ADR-0001` 与 `TECHNICAL_ARCHITECTURE.md` 对 `WinDeviceInspector.Persistence` 项目的拆分口径；

   * 明确 PowerShell 5.1（`powershell.exe`）与 PowerShell 7（`pwsh.exe`）的双环境兼容性测试要求与验收标准（同时明确 D-07 原始 JSON 导出前是否加简要敏感提示）。

4. **确认任务中心与交付包细节（D-05 / D-10）**：在统一沿用正式交付入口 **`DELIVERY/INBOX/待交付/`** 的前提下，确定任务包内部 5 份文件采用中文名还是英文名，以及 `docs/PROJECT_STATUS.md` 的去留方式。

### 第二步：落地任务中心并同步更新 `TASK-0001`（待用户确认后执行）

* 按 `WDI_Task_Center_Design.md` 新增 `docs/task-center/`（5 个核心文件）、`docs/reviews/`、`docs/issues/` 及 2 份新模板；

* 将 `DELIVERY/README.md`、`DELIVERY/INBOX/README.md`、`docs/AI_COLLABORATION.md` 与 `TASK-0001` 的交付路径统一更新为 **`DELIVERY/INBOX/待交付/`**；

* 按第一步的决策结论同步更新 `TASK-0001-vertical-slice.md`（统一状态为 `待生产`、对齐 JSON Schema 字段与 PowerShell 兼容性测试要求；第 6 节既有的“禁止未经确认的自动重试扫描”条款保持不变）；

* 将 `docs/task-center/CURRENT_TASK.md` 正式指向 `TASK-0001`。

### 第三步：执行首个开发任务 `TASK-0001`（建议的下一项核心开发任务）

* **推荐下一项开发任务**：**`TASK-0001` — First Runnable Vertical Slice（首个可运行垂直切片）**。

* **推荐理由**：

  * 这是唯一能打通“WPF 界面 → 显式扫描确认门禁 → 受控 PowerShell 只读子进程 → 版本化 JSON 契约 → 本地历史保存与原始 JSON 导出 → 单元测试”全链路的核心里程碑；

  * 只有 `TASK-0001` 在用户 Windows 11 x64 本机跑通并通过验收，后续 Phase 2–5 才建立在真实可运行工程之上。

* **严格验收门槛（本机实测清单，未实测不得标为 `验收通过`）**：

  1. 启动应用后不触发任何 PowerShell 进程或硬件查询；

  2. 点击 `Start Quick Collection` 展示采集范围与敏感提示，点击取消绝不启动子进程；

  3. 非管理员权限下确认扫描，能成功产出符合架构 Schema 的本地 JSON 并展示 9 类初始类别状态（单项失败不影响其他类别，失败不自动重试）；

  4. 取消/超时能安全终止 PowerShell 子进程树，并完成约定范围内的 PowerShell 5.1/7 兼容性核验；

  5. 关闭重启后可重新打开本地历史且不触发新扫描，可显式导出原始 JSON；

  6. `dotnet build` 与 `dotnet test` 在本机 Windows 11 x64 实测通过，交付包经 `DELIVERY/INBOX/待交付/` 交由 ChatGPT 独立审查并将审查与实测证据归档至 `docs/reviews/` 后，方可标记 `验收通过`。

### 第四步：Phase 2–5 渐进式任务拆解建议（规划参考，暂不提前立项）

| 阶段 | 建议任务编号与主题 | 核心交付目标 | 前置依赖 | 
| ----- | ----- | ----- | ----- | 
| Phase 2 | `TASK-0002` 完整硬件与驱动清单采集扩展 | 补齐显示器、音频、USB、蓝牙、完整驱动列表及存储健康只读采集 | `TASK-0001` 验收通过 | 
| Phase 2 | `TASK-0003` 本地历史管理与扫描记录对比 | 历史删除、筛选、双次扫描差异对比及损坏文件容错增强 | `TASK-0002` | 
| Phase 2 收尾 | `ADR-0002` 打包形态与便携/安装版数据路径决策 | 锁定便携版与安装版的数据目录隔离机制，解决 D-06，避免后期重构持久化层 | `TASK-0003` | 
| Phase 3 | `TASK-0004` Windows 可靠性与错误事件时间线 | System/Application 日志回溯窗口、异常关机、Bugcheck/WHEA、RAC、WER 证据采集与不确定性标注 | `TASK-0002` | 
| Phase 4 | `TASK-0005` 隐私预览选择与全量/专项 AI 诊断简报 | 真实内容预览、敏感字段逐项勾选/排除、Full/Focused 简报及 HTML/TXT/复制导出 | `TASK-0004` | 
| Phase 5 | `TASK-0006` 便携版/安装版打包、CI 与发布就绪 | 便携包 + Windows 安装器、崩溃日志、隐私安全复核、GitHub Actions CI 与发布流程 | `TASK-0005` + `ADR-0002` | 

## 3. 仍需用户决策的事项汇总表（不替用户拍板）

| 决策编号 | 待用户决策事项 | 备选方案说明 | 备注 | 
| ----- | ----- | ----- | ----- | 
| D-01 | 开源许可证选择 | MIT / Apache-2.0 / GPL-3.0 / 暂保留所有权利 | 影响仓库合规与分发，须由用户最终决定 | 
| D-02 | `WinDeviceInspector.Persistence` 拆分口径 | 方案 A：在 `ADR-0001` 附注对齐为 6 项目；方案 B：Phase 1 先合入 `Core`，Phase 2 再独立 | 建议开工前明确 | 
| D-03 | `TASK-0001` JSON Schema 字段口径 | 方案 A：开工前补齐架构第 7 节的 4 个字段；方案 B：Phase 1 保持精简，Phase 2 升 Schema 版本 | 影响 Phase 1/2 历史文件兼容性 | 
| D-04 | PowerShell 5.1 / 7 兼容性测试要求与验收口径 | 方案 A：明确 5.1 与 7 双环境均需纳入兼容性测试清单；方案 B：限定特定版本的支持边界并同步修改任务书 | 需补入测试策略与 `TASK-0001` 验收表 | 
| D-05 | 交付包内部文件命名语言 | 方案 A：中文名（`原始交付/`、`完成回执.md` 等）；方案 B：英文名（`raw-delivery/`、`COMPLETION_RECEIPT.md` 等） | 外部正式入口统一维持 `DELIVERY/INBOX/待交付/` | 
| D-06 | 便携版 vs 安装版打包方案与数据路径（`ADR-0002`） | 自包含 vs 框架依赖、安装器选型、便携模式数据目录位置 | 可在 Phase 2 持久化定型前拍板 | 
| D-07 | Phase 1 原始 JSON 导出敏感提示 | 方案 A：导出原始 JSON 前加简要风险确认提示；方案 B：Phase 1 直接导出，Phase 4 统一做字段预览与勾选 | 属用户体验与隐私细节 | 
| D-08 | GitHub 仓库元数据设置 | 填写 About 简介、网站与 Topics | 轻量完善项 | 
| D-09 | 本机开发环境验证基线 | 在 Windows 11 x64 本机记录 `.NET 10 SDK`、`pwsh`、`powershell` 版本 | 闭环 Phase 0 必需项 | 
| D-10 | `docs/PROJECT_STATUS.md` 处置方式 | 方案 A：并入 `docs/task-center/` 并改为精简跳转页；方案 B：保留为阶段高层摘要，删去重复细目 | 消除状态多处同步负担 | 
