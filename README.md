# WinDevice Inspector

**A user-controlled Windows device diagnostics and AI-ready report generator.**

WinDevice Inspector is a Windows desktop application project focused on one-click, comprehensive collection of Windows-recognized devices, hardware state, interfaces, drivers, supported sensor/health data, and operating-system reliability evidence. It preserves collection gaps and raw evidence, then exports JSON, XLSX, HTML, and AI analysis instructions as a report package.

> **Project stage:** repository foundation and project-management workflow established. The Chinese task center is the project-management entry point. WDI-AUDIT-0001 R3 has passed independent review, been accepted by the owner, and is closed. TASK-0001 Phase A three-file delivery is in the inbox awaiting independent review. Phase B coding is not authorized until the owner approves C-02. No application implementation has been accepted yet.

## Project management — start here

- **[任务中心](docs/任务中心/README.md)** — main project-management entry point.
- **[完整设备诊断与报告导出需求](docs/完整设备诊断与报告导出需求.md)** — confirmed product scope and report-package requirements.
- [当前任务](docs/任务中心/当前任务.md) — the single current work pointer.
- [TASK-0001 正式实现任务书](docs/tasks/TASK-0001_正式实现任务书.md) — current standalone task brief; Phase A proposal only is authorized.
- [TASK-0001 开工准备与决策确认书](docs/tasks/TASK-0001_开工准备与决策确认书.md) — historical record of the owner's four decisions.
- [任务创建与推进规范](docs/任务中心/任务创建与推进规范.md) — reusable rules for task creation, standalone briefs, progress, review, and archiving.
- [任务索引](docs/任务中心/任务索引.md) — task status and direct links to briefs and delivery records.
- [审查索引](docs/任务中心/审查索引.md) — independent review and verification history.
- [唯一交付入口](DELIVERY/INBOX/待交付/) — owner-reviewed Gemini delivery files.
- [交付归档](DELIVERY/ARCHIVE/) — preserved original delivery batches.

## At a glance

| Area | Direction |
|---|---|
| Application | Native Windows desktop application |
| Language / UI | C# / .NET 10 LTS / WPF |
| Initial target | Windows 11 x64 |
| Collection backend | Controlled, read-only PowerShell child process |
| Scan behavior | Manual start + explicit confirmation every time |
| Storage | Local scan history; versioned JSON |
| Diagnostic output | ZIP report: JSON + XLSX + HTML + AI analysis instructions |
| Distribution | Portable package + Windows installer |
| Network behavior | No automatic upload, telemetry, or AI-provider connection |
| Repair behavior | No automatic repair or driver modification |

## What it is intended to do

- Collect hardware and device inventory: CPU, motherboard, memory, GPU, monitors, storage, network, audio, USB, Bluetooth, PnP devices, and drivers.
- Collect Windows configuration and reliability evidence, including relevant event logs, unexpected shutdowns, bugchecks, WHEA, Reliability Monitor/RAC, and WER data as supported.
- Preserve collection sources, timestamps, warnings, and partial-failure states.
- Save scan snapshots locally and let users inspect previous scans.
- Generate full or issue-focused diagnostic report packages locally, for users to review and share manually.\n- Export complete JSON evidence, an Excel device workbook, an HTML overview, and AI analysis instructions in one ZIP.

## What it will not do

- Start a scan when the application opens.
- Run scheduled, periodic, idle-time, or background scans.
- Upload scan data automatically or connect to an AI service without the user's action.
- Install, update, disable, or remove drivers.
- Automatically repair, tune, benchmark, or stress-test the computer.
- Pretend unavailable hardware values are known.

## User control and privacy

Before each scan, the application must explain the collection scope, purpose, and known sensitive data categories. The user must confirm or cancel. Before sharing a report or AI brief, the user can review the actual content and choose which fields/categories to include. The application must neither silently redact nor silently expose sensitive fields.

Scan history remains on the local computer unless the user explicitly exports it.

## Project documentation

Start with the [documentation index](docs/README.md).

1. [Project overview](docs/PROJECT_OVERVIEW.md) — purpose, users, principles, scope, and milestones.
2. [Product requirements](docs/PRODUCT_REQUIREMENTS.md) — confirmed functional and non-functional requirements.
3. [Technical architecture](docs/TECHNICAL_ARCHITECTURE.md) — application layers, collection pipeline, contracts, and security boundaries.
4. [Repository structure](docs/REPOSITORY_STRUCTURE.md) — where each type of file belongs.
5. [Roadmap](docs/ROADMAP.md) — staged delivery plan.
6. [Project status](docs/PROJECT_STATUS.md) — current verified state and next actions.
7. [AI collaboration workflow](docs/AI_COLLABORATION.md) — Gemini production and ChatGPT technical leadership/review.
8. [TASK-0001 正式实现任务书](docs/tasks/TASK-0001_正式实现任务书.md) — current implementation task brief and phase gates.

Architecture decisions are recorded in `docs/decisions/`. Reusable task and completion-receipt formats are in `docs/templates/`.

## Repository layout

- `src/`: production application and library projects.
- `tests/`: automated tests, utilities, and synthetic fixtures.
- `docs/`: product, architecture, roadmap, status, decisions, tasks, templates, task center, reviews, and issues.
- `DELIVERY/INBOX/待交付/`: the single incoming delivery location.
- `DELIVERY/ARCHIVE/`: original packages retained by task and delivery round.

The `src/` and `tests/` directories initially contain placement guidance only. Gemini should inspect the current repository and the precise files named in the active task brief before creating or modifying the solution structure.

## Collaboration model

- **Project owner:** product decisions, Windows environment, final acceptance, and manual delivery transfer.
- **Gemini:** primary implementation producer; follows the standalone task brief and checks only relevant repository files. It returns complete implementation packages and does not directly commit to this repository.
- **ChatGPT:** technical lead; defines self-contained tasks, guides implementation, reviews code and test evidence, directs revisions, and maintains task/review records.
- **No unreviewed integration:** delivered code is checked against the task and acceptance criteria before becoming canonical project source.

See [AI collaboration workflow](docs/AI_COLLABORATION.md) and the [任务中心](docs/任务中心/README.md).

## License

No license has been selected. Until a license is added, do not assume that the source may be reused, modified, or redistributed.


## Complete device diagnostics direction

The confirmed product target is comprehensive one-click device diagnostics, not a limited inventory summary. The application should enumerate all currently available PnP devices, collect supported hardware/interface/driver/sensor and reliability evidence, report every collection gap, and export a ZIP containing canonical JSON, an XLSX device workbook, an HTML overview, and AI analysis instructions. See [完整设备诊断与报告导出需求](docs/完整设备诊断与报告导出需求.md).

This product direction does not change the current TASK-0001 Phase A-only authorization. C-02 approval and the explicit Phase B gate remain in force; the Phase B task brief must first reconcile the expanded product scope.
