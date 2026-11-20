# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: main
- Current stage: Repository foundation established; complete device diagnostics product scope confirmed; TASK-0001 Phase A proposal is awaiting independent review and owner decision.
- Closed management item: WDI-AUDIT-0001 R3 — independent document review passed and the owner explicitly accepted the result on 2026-11-20.
- Current task: TASK-0001 — First Runnable Vertical Slice; status: ready for Phase A proposal only. Phase B implementation is not authorized until the owner approves C-02.
- Application implementation: Not started / no application code accepted.
- Local development environment: Not yet verified from a complete owner-supplied environment report.

For the live task state, use the Chinese [任务中心](任务中心/README.md), especially [当前任务](任务中心/当前任务.md) and [任务索引](任务中心/任务索引.md). This status page is a high-level project summary, not a competing task tracker.

## Confirmed product and technical decisions

- C# / .NET 10 LTS / WPF; Windows 11 x64 first.
- Both portable and installer distributions are required for V1.
- Full and focused AI diagnostic briefs are required for V1 and generated locally.
- Every scan is manually initiated and requires explicit confirmation immediately before collection.
- No startup, background, scheduled, periodic, or unattended scans.
- Collection is read-only; no silent elevation, automatic repair, driver modification, telemetry, or automatic upload.
- Privacy requires clear collection notices and user-controlled review/selection before sharing. No silent inclusion or silent redaction.
- Local scan history is required in V1.
- PowerShell 7 and Windows PowerShell 5.1 are both in the supported target; both require explicit test evidence.
- Raw JSON export must display a sensitive-information warning before the save dialog; cancellation must not write a file.
- TASK-0001 Schema v1 includes time-zone context, application version, category duration where measurable, and actual query/collection parameters.
- C-02 is intentionally gated: Gemini proposes the smallest coherent project/module structure and dependency graph; the owner approves the Persistence boundary before implementation.

## Repository foundation

| Area | State |
|---|---|
| Root README and documentation index | Project navigation established |
| Product requirements and technical architecture | Updated with approved Schema/PowerShell/export decisions |
| Repository structure and roadmap | Documented |
| Collaboration workflow | Single Chinese-named delivery inbox |
| ADR-0001 | Desktop stack decision accepted |
| Task brief and completion receipt templates | Present |
| Chinese task center | Established with current-task pointer and indexes |
| WDI-AUDIT-0001 | R3 independently reviewed, owner accepted, closed |
| TASK-0001 | Formal brief published; Phase A structure proposal pending |
| Source/test directories | Placement guidance only; implementation pending |

## TASK-0001 readiness

The owner confirmed:
- C-01 = A: complete Schema v1 field set.
- C-02 = C: require a minimal structure proposal and dependency graph before deciding whether Persistence is a separate project.
- C-03 = A: support PowerShell 7 and Windows PowerShell 5.1 with separate test evidence.
- D-07 = A: show a sensitive-information warning before raw JSON export.

The current standalone execution contract is [TASK-0001 正式实现任务书](tasks/TASK-0001_正式实现任务书.md). The current authorization is limited to Phase A: a project/module structure proposal and dependency graph. No production source, solution, project, or test project may be created until the owner approves C-02.

D-01 (license) remains unselected and must be resolved before public reuse/distribution. D-06 (portable/installer packaging and final data-path strategy) remains a later-stage decision. D-08 (GitHub About metadata) does not block the vertical slice. D-09 (owner-supplied Windows/.NET/PowerShell environment report) remains outstanding and is required before final local verification and acceptance.

## Verification

- Local .NET 10 / WPF build: Not verified; no application implementation exists.
- Application runtime behavior: Not verified.
- PowerShell 7 integration: Not verified.
- Windows PowerShell 5.1 integration: Not verified.
- No claim of build, test, or runtime success is made.

## Decision log

### 2026-11-16 — Initial technical baseline
Confirmed the local-first Windows desktop application direction and initial C# / .NET 10 LTS / WPF stack.

### 2026-11-17 — Product behavior and collaboration
Confirmed portable + installer delivery, full + focused AI briefs, transparent privacy notice with user-controlled sharing, manual scans with explicit confirmation, local history, Gemini as primary producer, and ChatGPT as technical lead/reviewer.

### 2026-11-19 — Repository foundation
Added a project overview and repository structure guide, aligned architecture documentation with the consent gate, and organized the root README as the repository landing page.

### 2026-11-20 — Chinese task center and collaboration navigation
Added the Chinese task center, current-task pointer, task/review indexes, review and issue guidance, and synchronized repository documentation with the single DELIVERY/INBOX/待交付/ workflow.

### 2026-11-20 — WDI-AUDIT-0001 R3 acceptance
R3 passed independent review and was explicitly accepted by the project owner. The original R3 package and review report remain archived. WDI-AUDIT-0001 is closed.

### 2026-11-20 — TASK-0001 owner decisions
The owner confirmed C-01=A, C-02=C, C-03=A, and D-07=A. The formal task brief was published with a Phase A-only authorization gate.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.


## 2026-11-20 — Complete device diagnostics product direction confirmed

The project owner confirmed a product target of one-click comprehensive device diagnostics. The scope includes all currently enumerable Windows PnP devices (with hidden/disconnected/history/virtual devices classified separately), hardware identity and state, drivers, interfaces/buses, supported sensors and storage-health data, and system reliability/error evidence. All unsupported, unavailable, suspicious, permission-denied, and failed collection items must be reported with reasons.

The confirmed report package is ZIP containing canonical JSON, XLSX device workbook, HTML overview, and self-contained AI analysis instructions. JSON is the machine-readable evidence source; XLSX is for filtering/review; HTML is the human-readable overview. No automatic AI upload, repair, driver modification, or background scanning is permitted.

Detailed baseline: [完整设备诊断与报告导出需求](完整设备诊断与报告导出需求.md).

**Task gate unchanged:** TASK-0001 remains Phase A only. Its submitted Phase A package must be independently reviewed; C-02 still requires explicit owner approval. The new product scope does not authorize Phase B. Before Phase B authorization, architecture and the execution brief must be reconciled with this expanded product target.
