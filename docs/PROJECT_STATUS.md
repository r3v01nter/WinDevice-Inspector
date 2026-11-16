# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: `main`
- Current stage: Product baseline established; first implementation task ready
- Application code: Not yet accepted
- Current milestone: Phase 1 — Technical proof of concept

## Confirmed decisions

- Full Windows desktop application.
- Quick Collection is the first-release core.
- PowerShell is an internal read-only collection backend, not the user-facing product.
- Collect broad hardware, OS, PnP/driver, reliability, shutdown, bugcheck, WHEA, and application/system error evidence.
- Generate local AI diagnostic task briefs; no automatic AI upload or provider integration.
- No live sensor dashboard in the first release.
- No automatic repair or driver modification.
- Initial stack: C# / .NET 10 LTS / WPF, Windows 11 x64.
- ChatGPT coordinates and reviews; Gemini implements from task briefs; the owner manually transfers delivery packages through `DELIVERY/INBOX/`.

## Current work

| Item | State |
|---|---|
| Repository inspection | Complete: repository was empty at initial inspection |
| Product requirements baseline | Added |
| Technical architecture baseline | Added |
| Roadmap | Added |
| AI collaboration workflow | Added |
| Delivery inbox and archive placeholders | Added |
| Task brief and completion receipt templates | Added |
| Desktop technology decision ADR-0001 | Added |
| TASK-0001 WPF + PowerShell vertical slice | Ready for owner handoff to Gemini |
| Application solution | Not started |
| License selection | Pending |
| .NET/WPF prototype | Pending TASK-0001 delivery |

## Next action

Owner reviews and submits [TASK-0001](tasks/TASK-0001-vertical-slice.md) to Gemini. The complete returned package should be placed under `DELIVERY/INBOX/TASK-0001/` for review. Gemini must not operate the GitHub repository.

## Decision log

### 2026-11-16 — Initial project baseline

Confirmed the first release as a local-first Windows desktop app for broad device/system collection and AI diagnostic brief generation. Live hardware sensors and online AI integration are deferred.

### 2026-11-16 — ADR-0001

Selected C# / .NET 10 LTS / WPF as the starting implementation baseline, with a separate read-only PowerShell child process for Quick Collection. The decision may be revisited only with prototype evidence.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.
