# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: `main`
- Current stage: Product baseline confirmed; TASK-0001 ready for implementation handoff
- Application code: No implementation accepted yet
- Current milestone: Phase 1 — First runnable vertical slice

## Confirmed product decisions

- Desktop application using C# / .NET 10 LTS / WPF; Windows 11 x64 first.
- Both portable and installer distributions are required for V1.
- Every scan is manually initiated and requires explicit confirmation immediately before collection.
- No startup, background, scheduled, periodic, or unattended scans.
- Collection is read-only; no silent elevation, automatic repair, driver modification, telemetry, or automatic upload.
- Privacy is handled through clear collection notices and user-controlled review/selection of fields before sharing. No silent inclusion or silent redaction.
- Local scan history is required in V1.
- AI diagnostic output includes full and focused briefs, generated locally without an AI-provider integration.
- PowerShell is a controlled child-process collection backend, not the user-facing application.
- Gemini is the primary implementation producer. ChatGPT is technical lead, provides implementation guidance, independently reviews evidence, and directs revisions. The owner makes final decisions and transfers deliverables.

## Current repository baseline

The repository already contains product requirements, technical architecture, roadmap, collaboration workflow, task/receipt templates, ADR-0001, delivery inbox/archive placeholders, and the initial TASK-0001 brief. The baseline is being updated to reflect the confirmed user decisions.

## Current work

| Item | State |
|---|---|
| Product requirements | Confirmed; updated baseline |
| Technical architecture | Proposed; requires alignment with manual consent and local history |
| Roadmap | Updated to staged delivery |
| AI collaboration workflow | Updated: Gemini produces, ChatGPT leads and verifies |
| Delivery inbox/archive | Present |
| Task brief and completion receipt templates | Present |
| ADR-0001 desktop stack | Accepted |
| TASK-0001 | Updated for first manual-confirmation vertical slice |
| Application solution | Not started / no accepted code |
| Developer environment report | Awaiting user's PowerShell report |
| Local Windows build verification | Not yet performed |
| License selection | Pending |

## Immediate next steps

1. Gemini reads the public repository and TASK-0001.
2. Gemini produces the complete TASK-0001 source/test/documentation package.
3. The owner places the package in `DELIVERY/INBOX/TASK-0001/`.
4. ChatGPT performs code and evidence review and issues any required revisions.
5. Build and runtime verification must be performed on a suitable Windows 11 x64 environment. Do not mark these as passed until evidence is available.

## Decision log

### 2026-11-16 — Initial project baseline
Confirmed the local-first Windows desktop application direction and the initial C# / .NET 10 LTS / WPF stack.

### 2026-11-17 — User-control, privacy, and collaboration decisions
Confirmed both installer and portable distribution; full and focused AI diagnostic briefs; explicit notice and user-controlled sharing; manually initiated scans with explicit confirmation every time; local history in V1; Gemini as primary producer with ChatGPT providing technical leadership, implementation guidance, independent review, and acceptance verification.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.
