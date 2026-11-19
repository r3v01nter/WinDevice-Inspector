# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: main
- Current stage: Repository foundation prepared; TASK-0001 ready for Gemini handoff
- Application implementation: Not started / no code accepted
- Current milestone: Phase 1 — First runnable vertical slice

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
- Gemini is the primary implementation producer. ChatGPT is technical lead, provides implementation guidance, independently reviews code and evidence, and directs revisions. The owner makes final decisions and transfers deliverables.

## Repository foundation

| Area | State |
|---|---|
| Root README | Project entry point and navigation |
| Project overview | Added |
| Product requirements | Confirmed and documented |
| Technical architecture | Aligned with explicit consent and local-first rules |
| Repository structure | Added |
| Roadmap | Staged milestones documented |
| Collaboration workflow | Gemini production / ChatGPT technical leadership and review |
| ADR-0001 | Desktop stack decision accepted |
| Task brief template | Present |
| Completion receipt template | Present |
| TASK-0001 | Ready for implementation handoff |
| Delivery inbox/archive | Present with permanent README placeholders |
| Source/test directories | Placement guidance only; implementation pending |

## Development readiness

- Developer environment report: Awaiting the owner's PowerShell verification output.
- Local .NET 10 / WPF build: Not yet verified on the owner's Windows machine.
- Application runtime behavior: Not yet verified.
- License: Not selected.
- GitHub repository description metadata: Should be set to the concise description in the README/project overview through repository settings if not already configured.

## Immediate next steps

1. Gemini reads the public repository, project overview, product requirements, architecture, collaboration rules, ADR-0001, and TASK-0001.
2. Gemini returns a complete TASK-0001 source/test/documentation package.
3. The owner places it under DELIVERY/INBOX/TASK-0001/.
4. ChatGPT reviews the implementation and evidence, then provides any required revision instructions.
5. Build and runtime verification must be performed on Windows 11 x64. Do not mark these as passed until actual evidence is supplied.

## Decision log

### 2026-11-16 — Initial technical baseline
Confirmed the local-first Windows desktop application direction and initial C# / .NET 10 LTS / WPF stack.

### 2026-11-17 — Product behavior and collaboration
Confirmed portable + installer delivery, full + focused AI briefs, transparent privacy notice with user-controlled sharing, manual scans with explicit confirmation, local history, Gemini as primary producer, and ChatGPT as technical lead/reviewer.

### 2026-11-19 — Repository foundation
Added a project overview and repository structure guide, aligned architecture documentation with the consent gate, and organized the root README as the repository landing page.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.
