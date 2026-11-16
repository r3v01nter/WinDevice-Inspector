# Project Status

- Project: WinDevice Inspector
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Default branch: `main`
- Current stage: Repository bootstrap / product planning
- Application code: Not started
- Current milestone: Phase 0 — Product and repository foundation

## Confirmed decisions

- Full Windows desktop application.
- Quick Collection is the first-release core.
- PowerShell is an internal read-only collection backend, not the user-facing product.
- Collect broad hardware, OS, PnP/driver, reliability, shutdown, bugcheck, WHEA, and application/system error evidence.
- Generate local AI diagnostic task briefs; no automatic AI upload or provider integration.
- No live sensor dashboard in the first release.
- No automatic repair or driver modification.
- ChatGPT coordinates and reviews; Gemini implements from task briefs; the owner manually transfers delivery packages through `DELIVERY/INBOX/`.

## Current work

| Item | State |
|---|---|
| Repository inspection | Complete: repository was empty at inspection time |
| Product requirements baseline | Added |
| Technical architecture baseline | Added |
| Roadmap | Added |
| AI collaboration workflow | Added |
| Delivery inbox | Added |
| Application solution | Not started |
| License selection | Pending |
| .NET/WPF prototype | Not started |

## Decision log

### 2026-11-16 — Initial project baseline

Confirmed the first release as a local-first Windows desktop app for broad device/system collection and AI diagnostic brief generation. Live hardware sensors and online AI integration are deferred.

## Update rule

Update this file whenever a milestone, architecture decision, accepted delivery, or release status changes. Do not mark work complete without evidence.
