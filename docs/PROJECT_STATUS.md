# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: main
- Current stage: Repository foundation and project-management workflow established; first software implementation task remains pending production.
- Current management item: WDI-AUDIT-0001 R2 — submitted and awaiting independent review.
- Application implementation: Not started / no application code accepted.
- Current software milestone: Phase 1 — First runnable vertical slice.

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
| Collaboration workflow | Updated to the single Chinese-named delivery inbox |
| ADR-0001 | Desktop stack decision accepted |
| Task brief and completion receipt templates | Present |
| Chinese task center | Established with current-task pointer and indexes |
| Review and issue directories | Established with README guidance and templates |
| WDI-AUDIT-0001 | R1 archived with rework required; R2 submitted and awaiting review |
| TASK-0001 | Task brief exists; pending production |
| Source/test directories | Placement guidance only; implementation pending |

## Development readiness

- Developer environment report: Awaiting the owner's PowerShell verification output.
- Local .NET 10 / WPF build: Not yet verified on the owner's Windows machine.
- Application runtime behavior: Not yet verified.
- License: Not selected.
- GitHub repository description metadata: Verify through repository settings when convenient.

## Immediate next steps

1. Independently review the six WDI-AUDIT-0001 R2 files currently in `DELIVERY/INBOX/待交付/`.
2. Record the review result and any remaining rework; do not treat the submitted proposal as an approved project decision.
3. After the owner confirms the management baseline, decide whether to hand TASK-0001 to Gemini for implementation.
4. The owner supplies the current development-environment verification report before any claim that the local .NET/WPF environment is ready.
5. Build and runtime verification must be performed on Windows 11 x64. Do not mark these as passed until actual evidence is supplied.

## Decision log

### 2026-11-16 — Initial technical baseline
Confirmed the local-first Windows desktop application direction and initial C# / .NET 10 LTS / WPF stack.

### 2026-11-17 — Product behavior and collaboration
Confirmed portable + installer delivery, full + focused AI briefs, transparent privacy notice with user-controlled sharing, manual scans with explicit confirmation, local history, Gemini as primary producer, and ChatGPT as technical lead/reviewer.

### 2026-11-19 — Repository foundation
Added a project overview and repository structure guide, aligned architecture documentation with the consent gate, and organized the root README as the repository landing page.

### 2026-11-20 — Chinese task center and collaboration navigation
Added the Chinese task center, current-task pointer, task/review indexes, review and issue guidance, and synchronized repository documentation with the single `DELIVERY/INBOX/待交付/` workflow.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.
