# WinDevice Inspector

**WinDevice Inspector** is an open-source Windows desktop application for comprehensive device information collection, Windows system-state inspection, and AI-ready diagnostic task generation.

The first release focuses on collecting and organizing evidence—not live hardware monitoring, online AI diagnosis, or automatic repair.

## Project goals

- Collect as much useful, supportable Windows device and system information as possible in one guided scan.
- Inspect device and driver status, Windows reliability history, unexpected shutdowns, bugchecks, hardware-related events, and application/system errors.
- Preserve source details, timestamps, collection status, and known limitations so findings remain auditable.
- Generate structured diagnostic task briefs that users can copy or export and provide to ChatGPT, Gemini, Claude, or another AI assistant.
- Keep user data local by default. No automatic upload to an AI service.

## First-release scope

1. Device and hardware inventory.
2. Windows version, configuration, update, and boot information.
3. PnP device and driver inventory, including problem codes.
4. System and application event-log collection.
5. Unexpected shutdown, restart, bugcheck, WHEA, and reliability-history evidence.
6. Discovery of relevant Windows diagnostic and Windows Error Reporting (WER) records where accessible.
7. Local scan history and structured exports.
8. AI diagnostic task generation from collected evidence.

**Not in the first release:** continuous CPU/GPU temperature or power monitoring, fan monitoring, online AI integration, automatic repair, driver installation/removal, or system tuning.

## Project status

<badge>Planning / repository bootstrap</badge>

The repository is being initialized. No production application code has been accepted yet.

See:
- [Product requirements](docs/PRODUCT_REQUIREMENTS.md)
- [Technical architecture](docs/TECHNICAL_ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [AI collaboration workflow](docs/AI_COLLABORATION.md)
- [Delivery inbox](DELIVERY/INBOX/README.md)

## Collaboration model

- **Project owner:** makes product decisions and manually transfers deliverables.
- **ChatGPT:** product and technical coordination, task briefs, review, integration planning, and repository organization.
- **Gemini:** implementation assistant that receives scoped task briefs and returns code plus a completion receipt. Gemini does not independently operate this GitHub repository.
- **Delivery inbox:** the owner places each Gemini delivery package in `DELIVERY/INBOX/`. After review, accepted work is moved into the appropriate project location and the inbox is cleared of delivery files. The inbox's README stays in place.

## Principles

- Read-only collection by default.
- No silent elevation. Any administrator-only collection must be explained and explicitly approved.
- Never present unavailable or unsupported data as if it had been collected.
- Distinguish observed facts, inferred findings, and unknowns.
- Preserve original event identifiers, providers, timestamps, and relevant event details.
- Minimize collection of personal identifiers and redact sensitive values in shareable outputs.
- Do not make destructive system changes.

## License

No license has been selected yet. Until a license is added, do not assume that the source code may be reused, modified, or redistributed.
