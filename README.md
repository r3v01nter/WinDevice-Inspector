# WinDevice Inspector

**A user-controlled Windows device and system evidence collector.**

WinDevice Inspector is a Windows desktop application project focused on collecting hardware, device, driver, operating-system, and reliability evidence in a structured way. It keeps scan history locally and helps users prepare diagnostic briefs for an AI assistant of their choice.

> **Project stage:** repository foundation and requirements are established. TASK-0001 is ready for implementation handoff. No application implementation has been accepted yet.

## At a glance

| Area | Direction |
|---|---|
| Application | Native Windows desktop application |
| Language / UI | C# / .NET 10 LTS / WPF |
| Initial target | Windows 11 x64 |
| Collection backend | Controlled, read-only PowerShell child process |
| Scan behavior | Manual start + explicit confirmation every time |
| Storage | Local scan history; versioned JSON |
| Diagnostic output | Full and focused AI diagnostic briefs |
| Distribution | Portable package + Windows installer |
| Network behavior | No automatic upload, telemetry, or AI-provider connection |
| Repair behavior | No automatic repair or driver modification |

## What it is intended to do

- Collect hardware and device inventory: CPU, motherboard, memory, GPU, monitors, storage, network, audio, USB, Bluetooth, PnP devices, and drivers.
- Collect Windows configuration and reliability evidence, including relevant event logs, unexpected shutdowns, bugchecks, WHEA, Reliability Monitor/RAC, and WER data as supported.
- Preserve collection sources, timestamps, warnings, and partial-failure states.
- Save scan snapshots locally and let users inspect previous scans.
- Generate full or issue-focused diagnostic briefs locally, for users to review and share manually.

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

Start with the [documentation index](docs/README.md) for the complete document map.

1. [Project overview](docs/PROJECT_OVERVIEW.md) — purpose, users, principles, scope, and milestones.
2. [Product requirements](docs/PRODUCT_REQUIREMENTS.md) — confirmed functional and non-functional requirements.
3. [Technical architecture](docs/TECHNICAL_ARCHITECTURE.md) — application layers, collection pipeline, contracts, and security boundaries.
4. [Repository structure](docs/REPOSITORY_STRUCTURE.md) — where each type of file belongs.
5. [Roadmap](docs/ROADMAP.md) — staged delivery plan.
6. [Project status](docs/PROJECT_STATUS.md) — current state and next actions.
7. [AI collaboration workflow](docs/AI_COLLABORATION.md) — Gemini production and ChatGPT technical leadership/review.
8. [TASK-0001](docs/tasks/TASK-0001-vertical-slice.md) — first implementation task.

Architecture decisions are recorded in docs/decisions/. Reusable task and receipt formats are in docs/templates/.

## Repository layout

- README.md and .gitignore: repository entry point and Git rules.
- src/: production application and library projects.
- tests/: automated tests, utilities, and synthetic fixtures.
- docs/: product, architecture, roadmap, status, decisions, tasks, and templates.
- DELIVERY/INBOX/: incoming AI implementation packages.
- DELIVERY/ARCHIVE/: original packages retained after review.

The src/ and tests/ directories initially contain placement guidance only. Gemini should inspect the current repository and TASK-0001 before creating the first solution structure.

## Collaboration model

- **Project owner:** product decisions, Windows environment, final acceptance, and delivery transfer.
- **Gemini:** primary implementation producer; reads the public repository and returns complete implementation packages.
- **ChatGPT:** technical lead; defines tasks, guides difficult implementation decisions, reviews code and test evidence, and directs revisions.
- **No unreviewed integration:** delivered code is checked against the task and acceptance criteria before becoming canonical project source.

See [AI collaboration workflow](docs/AI_COLLABORATION.md).

## License

No license has been selected. Until a license is added, do not assume that the source may be reused, modified, or redistributed.
