# WinDevice-Inspector 一页纸项目上下文快照（AI_CONTEXT_SNAPSHOT）

> **用途**：供项目负责人派发任务时直接作为聊天附件投喂给 Gemini 网页端或其他 AI，实现 0 秒冷启动，减少远程浏览 GitHub。
> **维护规则**：仅在重大决策变更或主线阶段切换时刷新，全文严格控制在 120 行以内。
> **基准仓库**：https://github.com/r3v01nter/WinDevice-Inspector （分支：`main`）
> **快照基准 Commit SHA**：`[Antigravity 落地时请替换为最新 40 位 main SHA；起草参考：a396da87bc371e3e06417800eda27e5fa40cdb33]`
> **最后更新日期**：2026-11-27

## 1. 项目定位与不可变更技术基线

- **产品定位**：面向 Windows 用户的本地优先、用户可控桌面设备与系统证据采集/诊断工具（证据采集与整理，非自动修复）。
- **核心技术栈**：`C#` / `.NET 10 LTS` / `WPF`；首发平台 `Windows 11 x64`；`PowerShell` 作为受控只读独立子进程采集后端。
- **不可违反的只读与隐私红线**：
  1. 启动应用、打开首页、查看历史记录时**严禁触发任何扫描**；
  2. 每次扫描必须由用户主动发起并**扫描前明确确认**（告知采集范围、敏感类别与权限要求）；取消绝不启动子进程；
  3. 严禁后台扫描、定时扫描、空闲扫描、恢复后自动扫描或未经确认的自动重试扫描；
  4. 严禁自动上传、后台遥测、云同步、自动连接 AI 服务、自动修复、驱动修改、注册表写入或静默提权；
  5. V1 具备本地扫描历史（`LocalAppData`）与 JSON 导出；后续阶段提供 HTML/TXT 报告、逐项字段勾选预览与 AI 诊断简报；V1 最终目标含便携版与安装版；
  6. 严禁将真实机器扫描数据、个人路径、凭据或令牌提交到仓库。

## 2. 已确认决策与未决事项

| 编号 | 事项 | 当前结论 / 状态 |
| :--- | :--- | :--- |
| **C-01** | JSON Schema v1 | **已确认（A）**：采用完整字段集（含 `timeZoneId`、`applicationVersion`、`durationMs` 与 `query/collectionParameters`） |
| **C-02** | `Persistence` 项目边界 | **已确认阶段门禁（C）**：先由架构方案提交最小结构与依赖图，经负责人明确批准后再进入编码 |
| **C-03** | PowerShell 版本支持 | **已确认（A）**：优先 `pwsh.exe`（PS 7），同时兼容 `powershell.exe`（5.1），双版本均须实测提供证据 |
| **D-05** | 仓库语言规则 | **已确认**：面向人的管理文档优先中文；源码、项目名、API、JSON 字段、命令与技术标识保留英文 |
| **D-07** | 原始 JSON 导出提示 | **已确认（A）**：打开保存框前显示一次敏感信息提示；取消不弹窗不写文件；导出保留真实证据不自动脱敏 |
| **D-10** | `docs/PROJECT_STATUS.md` | **已确认**：保留作为高层项目状态摘要 |
| **D-01 / D-06 / D-09** | 许可证 / 打包与数据路径 / 本机环境报告 | **待决策或待核验**：不得擅自选许可证、不得提前创建 `ADR-0002`、不得虚构 Windows 本机测试通过 |

## 3. 当前任务态势（实时状态以 `docs/任务中心/当前任务.md` 为准）

- **当前主线任务**：`TASK-0001`（首个可运行垂直切片）— **阶段 A 架构方案修订（R2）**；阶段 B 尚未授权，仓库 `src/` 与 `tests/` 暂无正式业务代码。
- **并行独立任务**：`WDI-DIAG-001`（独立 BAT + PowerShell 一键诊断工具，不替代 `TASK-0001` 主线）。
- **已关闭前序任务**：`WDI-AUDIT-0001`（R3 独立审查通过并经负责人验收关闭）。

## 4. 四方协作分工与交付红线

- **Gemini 网页端**：需求澄清、技术调研、方案对比、架构/流程审计、编写自包含任务书；默认无本地 Windows 环境与 Git 写权限，多文件交付打包为单个干净 ZIP。
- **Antigravity（本地代理）**：默认代码/文档实施者；本地读仓、编码、构建、双版本 PowerShell 测试、生成交付包并推送独立分支 `delivery/<TASK>-<R#>`（禁推 `main`，禁自动合并）。
- **ChatGPT GPT-6**：独立审查者，**仅在负责人明确触发后**审查、写审查报告与按轮次归档（`DELIVERY/ARCHIVE/`）。
- **项目负责人**：授权任务、决策拍板、触发审查与最终验收（唯一平面收件入口：`DELIVERY/INBOX/待交付/`；本地暂存：`DELIVERY/LOCAL_STAGING/待上传/`）。

## 5. 网页端高频核验 Raw 链接（按需打开，禁止全仓漫游）

- 全局协作规则：`https://raw.githubusercontent.com/r3v01nter/WinDevice-Inspector/refs/heads/main/AI_AGENT_GUIDE.md`
- 当前任务指针：`https://raw.githubusercontent.com/r3v01nter/WinDevice-Inspector/refs/heads/main/docs/%E4%BB%BB%E5%8A%A1%E4%B8%AD%E5%BF%83/%E5%BD%93%E5%89%8D%E4%BB%BB%E5%8A%A1.md`
- 交付中心规则：`https://raw.githubusercontent.com/r3v01nter/WinDevice-Inspector/refs/heads/main/DELIVERY/README.md`
