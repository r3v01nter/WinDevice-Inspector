# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: main
- Current stage: Repository foundation and project-management workflow established; TASK-0001 is in pre-start decision preparation.
- Closed management item: WDI-AUDIT-0001 R3 — independent document review passed and the owner explicitly accepted the result on 2026-11-20.
- Current task: TASK-0001 — First Runnable Vertical Slice; status: pending owner decisions on schema, project boundaries, PowerShell compatibility, and export privacy notice.
- Application implementation: Not started / no application code accepted.
- Local development environment: Not yet verified from a complete owner-supplied environment report.

For the live task state, use the Chinese [任务中心](任务中心/README.md), especially [当前任务](任务中心/当前任务.md) and [任务索引](任务中心/任务索引.md). This status page is a high-level project summary, not a competing task tracker.

## Confirmed product decisions

- C# / .NET 10 LTS / WPF; Windows 11 x64 first.
- Both portable and installer distributions are required for V1.
- Full and focused AI diagnostic briefs are required for V1 and generated locally.
- Every scan is manually initiated and requires explicit confirmation immediately before collection.
- No startup, background, scheduled, periodic, or unattended scans.
- Collection is read-only; no silent elevation, automatic repair, driver modification, telemetry, or automatic upload.
- Privacy requires clear collection notices and user-controlled review/selection before sharing. No silent inclusion or silent redaction.
- Local scan history is required in V1.
- PowerShell is a controlled child-process collection backend.
- Gemini is the primary implementation producer. ChatGPT is technical lead and independent reviewer. The owner makes final decisions, transfers deliverables, performs required local verification, and controls final acceptance.

## Repository foundation

| Area | State |
|---|---|
| Root README and documentation index | Project navigation established |
| Product requirements and technical architecture | Documented; product constraints remain authoritative |
| Repository structure and roadmap | Documented |
| Collaboration workflow | Single Chinese-named delivery inbox |
| ADR-0001 | Desktop stack decision accepted |
| Task brief and completion receipt templates | Present |
| Chinese task center | Established with current-task pointer and indexes |
| WDI-AUDIT-0001 | R3 independently reviewed, owner accepted, closed |
| TASK-0001 | Pre-start decisions pending; implementation not started |
| Source/test directories | Placement guidance only; implementation pending |

## TASK-0001 readiness

The existing English task brief was found to be stale in two respects: it uses the legacy nested delivery-package layout, and it does not fully align its JSON result contract with the current technical architecture. A Chinese standalone pre-start decision brief is the canonical current task document. The old English task brief is retained for historical traceability and is not an execution contract.

Open items:
- C-01: reconcile timeZoneId, applicationVersion, durationMs, and per-category query/collection parameters in the result schema.
- C-02: decide whether Persistence is a separate project in Phase 1 or remains a module/folder in the smallest coherent solution.
- C-03: define tested support and acceptance evidence for PowerShell 5.1 and PowerShell 7.
- D-07: decide whether raw JSON export displays an additional sensitive-data warning before the save dialog.
- D-09: owner-supplied Windows/.NET/PowerShell environment report remains outstanding.

D-01 (license) and D-08 (GitHub metadata) do not block preparing the implementation task, but D-01 must be resolved before public reuse/distribution. D-06 (portable/installer packaging and data paths) remains a later architecture decision and does not block this vertical slice.

## Verification

- Local .NET 10 / WPF build: Not verified.
- Application runtime behavior: Not verified.
- PowerShell 5.1 / 7 integration: Not verified.
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

### 2026-11-20 — TASK-0001 pre-start review
Identified stale delivery instructions and schema/project/PowerShell decision gaps in the legacy task brief. TASK-0001 remains pending owner decisions; implementation has not started.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.
