# WDI-DIAG-001 完整交付报告（含文件清单、测试报告与已知限制）

- **任务编号**：WDI-DIAG-001
- **任务名称**：Windows 一键诊断信息采集工具（独立运行版）
- **所属项目**：WinDevice-Inspector
- **GitHub 仓库地址**：https://github.com/r3v01nter/WinDevice-Inspector
- **核验基准分支与 Commit SHA**：`main` / `a396da87bc371e3e06417800eda27e5fa40cdb33`（210 Commits，`docs: clarify TASK-0001 delivery branch base`）
- **交付日期**：2026-11-27
- **执行角色**：Google Gemini
- **独立审核者**：ChatGPT GPT（本交付等待独立审核，**不代表验收通过**）

## 1. 成品完整文件清单

解压 `WDI-DIAG-001_Win11_Diagnostic_Tool.zip` 后，目录内直接包含完整可运行程序与全部文档：

| 序号 | 相对路径 | 文件类型 | 编码 / 换行 | 用途说明 |
| :---: | :--- | :--- | :--- | :--- |
| 1 | `一键诊断采集.bat` | BAT 启动入口 | UTF-8 无 BOM / CRLF | 双击启动、环境与 PS 7/5.1 检测、中文路径安全传递、退出码与路径提示 |
| 2 | `scripts\Collect-WinDiagnostics.ps1` | PowerShell 核心采集脚本 | UTF-8 带 BOM / CRLF | PS 5.1 / 7 双兼容只读采集引擎（8 大模块、7 态规则、默认脱敏、JSON/TXT/CSV/日志生成） |
| 3 | `config\config.json` | JSON 配置文件 | UTF-8 无 BOM / LF | 日志回溯天数、条数上限、CSV 开关及 7 项独立隐私脱敏开关 |
| 4 | `docs\使用说明.md` | 使用指南 | UTF-8 | 面向用户的解压、双击运行、权限说明与配置指南 |
| 5 | `docs\采集项目说明.md` | 采集与规则说明 | UTF-8 | 8 大采集范围、7 态异常判定规则、PSU 免责与隐私脱敏细则 |
| 6 | `docs\技术方案.md` | 技术设计文档 | UTF-8 | 仓库核对结论、兼容性、编码与容错架构说明 |
| 7 | `docs\交付报告_WDI-DIAG-001.md` | 交付与测试报告 | UTF-8 | 本文件（含仓库 SHA、文件清单、测试报告、已知限制与未完成项） |

*(注：首次在 Windows 11 双击运行后，工具会自动在同级生成 `output\WDI_Diag_<时间戳>\` 目录，内含 `diagnostic_report.txt`、`diagnostic_data.json`、`run_log.txt` 及 `csv\` 下 5 份表格。)*

## 2. 测试报告（严格区分沙盒静态校验与未执行的 Windows 本机测试）

### 2.1 已在沙盒环境执行的静态与逻辑自检（Pass）

| 检查项 | 执行环境 | 结果 | 验证要点 |
| :--- | :--- | :---: | :--- |
| 只读安全红线静态扫描 | Linux 沙盒（Python AST/正则审计） | **Pass** | 核验脚本与 BAT 中零危险写入命令（无注册表写入、无驱动安装/卸载、无日志清理、无文件删除、无电源计划修改、无联网/上传命令） |
| 编码与换行符合规检查 | Linux 沙盒（字节级校验） | **Pass** | 确认 `.bat` 为 UTF-8 无 BOM + CRLF；`.ps1` 为 UTF-8 带 BOM + CRLF；`config.json` 为合法 JSON |
| PowerShell 5.1 语法兼容性静态检查 | Linux 沙盒（括号平衡与 7.x 专属语法扫描） | **Pass** | 确认大括号/小括号/方括号完全平衡，未混入 `??`、`?.`、`-AsArray`、`ForEach-Object -Parallel` 等 PS 7 专属语法 |
| 隐私脱敏正则逻辑仿真验证 | Linux 沙盒（Python 合成 PII 样本测试） | **Pass** | 验证用户名、主机名、私网/公网 IPv4、IPv6、MAC（保留 OUI）、磁盘序列号、PnP 实例 ID（保留 VEN/DEV 与 VID/PID）、SID 与邮箱均可准确脱敏 |
| 成品 ZIP 压缩包完整性校验 | Linux 沙盒（`zipfile.testzip()`） | **Pass** | 压缩包结构完整无损坏，解压后即可直接双击运行 |

### 2.2 尚未执行的真实 Windows 11 环境测试（Not run — 严禁伪造）

因当前执行环境为非 Windows 沙盒且未安装 `pwsh`，以下全部真机运行项均如实标注 **`Not run`**，必须在真实 Windows 11 电脑上执行后方可视为验证通过：

| 测试项（对应任务书第八节） | 状态 | 说明 |
| :--- | :---: | :--- |
| Windows 11 正常运行（PS 7 与 PS 5.1 双环境） | **Not run** | 需在真实 Windows 11 本机双击实测 |
| 普通权限运行 | **Not run** | 需核验普通权限下各模块正常采集及受限项准确标 `ACCESS_DENIED` |
| 管理员权限运行 | **Not run** | 需核验右键管理员运行时无错误且不触发系统修改 |
| 部分命令不可用时的回退处理 | **Not run** | 需验证 `Get-PhysicalDisk` / `Get-NetAdapter` 回退 CIM 路径 |
| 部分设备信息无法读取时的处理 | **Not run** | 需在真实硬件环境验证单类失败不崩溃且不误判 `NORMAL` |
| 日志查询为空时的处理 | **Not run** | 需在无错误日志的机器或极短窗口下实测 `NoMatchingEventsFound` 正常返回 0 条 |
| 中文路径运行（如 `C:\Users\测试\桌面\诊断\`） | **Not run** | 需在真实中文路径下双击 `.bat` 验证无乱码与路径截断 |
| 输出文件完整性与 Excel/记事本打开效果 | **Not run** | 需核验生成的 TXT/JSON/CSV 文件内容与中文显示 |
| 隐私脱敏真实报告复核 | **Not run** | 需在真实报告中复查是否残留未脱敏的个人主机名、用户名、IP、MAC 或序列号 |
| BAT 启动和退出逻辑 | **Not run** | 需验证正常退出码 `0`、缺失脚本退出码 `2` 及末尾 `pause` 停留效果 |

## 3. 已知限制

1. **沙盒无真实 Windows 运行环境**：本次交付未在真实 Windows 11 机器上执行运行时验证，可能存在特定硬件驱动返回字段为 `$null` 或特殊编码的边缘情况，待本机首测反馈修正。
2. **显存 >4GB 读取依赖驱动注册表**：`Win32_VideoController.AdapterRAM` 存在 32 位 4GB 上限截断，脚本已优先尝试只读注册表 `HardwareInformation.qwMemorySize`，但部分核显或虚拟显卡可能缺失该键，此时会如实标注来源与限制，绝不伪造数值。
3. **软件无法检测硬件物理状态**：不含 CPU/GPU 温度、电压、风扇转速、功耗或 PSU 供电纹波；PSU 硬件质量恒定标注为 `UNKNOWN`。
4. **事件日志通道权限边界**：非管理员模式下部分受限事件通道可能返回 `ACCESS_DENIED`，属 Windows 权限机制正常表现；脚本已如实标记，不强制提权。

## 4. 未完成事项

1. **真实 Windows 11 本机全量测试**（上述 10 项 `Not run` 用例的实机验证与结果归档）。
2. **ChatGPT GPT 独立技术审核**与可能产生的返修项跟进。
3. 本工具为独立交付成品，尚未按仓库主线流程合入 `WinDevice-Inspector` 仓库（是否以及放于仓库何处由用户最终决定）。
