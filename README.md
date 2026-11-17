# WinDevice Inspector

**WinDevice Inspector** is a Windows desktop application for manually initiated device information collection, Windows system-state inspection, local scan history, and AI-ready diagnostic task generation.

The application is an evidence collector and organizer. It does not perform background scans, silently upload information, or automatically repair the system.

## Product goals

- Collect useful, supportable Windows hardware, device, driver, configuration, and reliability evidence.
- Preserve source details, timestamps, collection status, and known limitations.
- Keep scan history on the local computer.
- Generate full and focused diagnostic briefs that users can review and provide to an AI assistant themselves.
- Give users clear notice of collection and control over what is included in shareable output.

## First-release scope

1. Manually initiated hardware and device inventory.
2. Windows version, configuration, update, and boot information.
3. PnP device and driver inventory, including problem codes.
4. System/application event evidence, unexpected shutdowns, bugchecks, WHEA, and reliability history.
5. Local scan history and structured exports.
6. Full and focused AI diagnostic brief generation, without an AI provider connection.
7. Both portable and installer distribution packages.

**Not in the first release:** continuous hardware sensor monitoring, online AI integration, automatic repair, driver installation/removal, stress tests, or system tuning.

## User control and privacy

- Every scan must be started manually by the user.
- Before each scan, show what categories will be collected and ask for explicit confirmation.
- No background, scheduled, startup, or unattended scans.
- Explain collection purpose and potentially sensitive fields before the user shares data.
- Let users review and choose which fields are included in AI briefs and shareable exports. Do not silently remove or silently include sensitive fields.
- Store scan history locally. No automatic upload or telemetry.

## Technology

- C# / .NET 10 LTS / WPF.
- Windows 11 x64 initial target.
- PowerShell is a controlled, read-only child-process collection backend, not the user-facing application.

## Project status

Product decisions are confirmed. The repository contains the planning baseline and TASK-0001 implementation brief. Application code has not yet been accepted. The developer environment must be verified before claiming a successful local build.

See:
- [Product requirements](docs/PRODUCT_REQUIREMENTS.md)
- [Technical architecture](docs/TECHNICAL_ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [AI collaboration workflow](docs/AI_COLLABORATION.md)
- [Project status](docs/PROJECT_STATUS.md)
- [TASK-0001](docs/tasks/TASK-0001-vertical-slice.md)
- [Delivery inbox](DELIVERY/INBOX/README.md)

## Collaboration model

- **Project owner:** makes product decisions, provides the development environment, and transfers Gemini deliverables.
- **Gemini:** primary implementation producer. It reads the public repository and task brief, then returns complete source files and a truthful completion receipt.
- **ChatGPT:** technical lead and acceptance reviewer. It defines tasks, guides implementation decisions, reviews code, checks tests/build evidence, identifies defects, and directs revisions.
- **Delivery inbox:** the owner places each complete delivery package in `DELIVERY/INBOX/`. Accepted files are integrated only after review.

## Engineering principles

- Explicit user initiation and confirmation for every scan.
- Read-only collection; no silent elevation.
- No automatic network upload or AI-provider connection.
- No fabricated values; unknown and unavailable are valid outcomes.
- Distinguish observed facts, hypotheses, and unknowns.
- Preserve event identifiers, providers, timestamps, and relevant source details.
- Do not make destructive system changes.

## License

No license has been selected yet. Until a license is added, do not assume that the source code may be reused, modified, or redistributed.
