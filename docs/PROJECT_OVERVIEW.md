# Project Overview — WinDevice Inspector

## 1. One-sentence definition

WinDevice Inspector is a Windows desktop tool that lets a user deliberately collect a structured snapshot of device, hardware, driver, Windows, and reliability evidence, keep it locally, and prepare diagnostic material for human-reviewed AI assistance.

## 2. Problem being addressed

When a Windows computer behaves unexpectedly, useful evidence is scattered across Device Manager, system settings, driver metadata, event logs, Reliability Monitor, WER folders, and hardware-specific utilities. Users often have to gather this information manually and may share incomplete or poorly structured descriptions when asking for help.

WinDevice Inspector aims to make evidence collection repeatable and understandable without taking control away from the user.

## 3. Product goals

1. Collect broad, relevant system evidence from supported Windows interfaces.
2. Show where each value came from and whether collection succeeded.
3. Preserve partial results and clearly report unavailable information.
4. Keep scan history local so users can revisit earlier snapshots.
5. Help users prepare complete or issue-focused diagnostic briefs.
6. Make privacy and consent understandable before collection and sharing.
7. Remain read-only and avoid unnecessary privileges.

## 4. Product principles

### User agency first
No scan starts by itself. Every scan requires a deliberate action and an explicit confirmation immediately before collection. The user can cancel.

### Evidence before conclusions
The application records observations, not unsupported diagnoses. Event correlation is not proof of causation. Missing values remain missing.

### Local-first by default
Scan data is stored locally. No automatic telemetry, cloud sync, AI connection, or upload.

### Transparent sharing
The application explains potentially sensitive fields and shows the actual shareable content. The user decides what to include. Neither hidden blanket redaction nor silent sensitive-data disclosure is acceptable.

### Least privilege and read-only behavior
Normal collection must not require administrator rights. The app does not change drivers, services, registry settings, or Windows configuration.

### Graceful partial success
One inaccessible or failed source must not invalidate all other collected evidence.

## 5. Intended users and scenarios

- A Windows user preparing a structured support request.
- A user investigating unexpected restarts, blue screens, device errors, driver problems, storage issues, network problems, or application failures.
- A technically capable user comparing snapshots before and after a deliberate change.
- A user preparing evidence for ChatGPT, Gemini, or another assistant while retaining control over what is shared.

## 6. Main user journey

1. Open the application; no scan runs.
2. Review the dashboard and any previously saved scan.
3. Choose a scan action.
4. Read the collection notice and inspect categories and sensitive-data warnings.
5. Confirm or cancel.
6. If confirmed, monitor collection progress and per-category outcomes; cancel if desired.
7. Inspect the result and save it to local history.
8. Choose a full or focused diagnostic brief.
9. Preview the actual content and choose included fields/categories.
10. Copy or export it and manually share it with an AI assistant or support person.

## 7. Scope by milestone

### First vertical slice — TASK-0001
- WPF application shell and empty state.
- Manual scan action and explicit pre-scan confirmation.
- Controlled PowerShell child process.
- Initial OS/computer/CPU/board/BIOS/memory/GPU/disk/network/PnP-problem-device collection.
- Structured JSON result and per-category status.
- Local scan history and explicit JSON export.
- Tests proving startup and Cancel do not start collection.

### V1 completion
- Broader device inventory and drivers.
- Reliability/event evidence including unexpected shutdowns, bugchecks, WHEA, RAC, and WER where supported.
- Full and focused AI diagnostic briefs generated locally.
- User-controlled share preview and field selection.
- HTML/TXT/JSON exports.
- Portable package and Windows installer.

### Later possibilities — not committed to V1
- Live sensor monitoring.
- Optional online AI integration.
- Advanced scan comparison and visualization.
- Automated remediation or driver management (requires a separate product/security decision; not part of current scope).

## 8. Technical baseline

- C# / .NET 10 LTS.
- WPF desktop UI.
- Windows 11 x64 initial support.
- PowerShell child process for read-only collection.
- Versioned JSON result contract.
- Local application-data storage.

See [Technical Architecture](TECHNICAL_ARCHITECTURE.md) and [ADR-0001](decisions/ADR-0001-desktop-stack.md).

## 9. Explicit non-goals

- Silent or automatic scans.
- Background/scheduled scanning.
- Automatic uploads, telemetry, or cloud synchronization.
- Automatic root-cause claims.
- Driver or system repair.
- Live monitoring in the first release.
- Stress testing or benchmark suites.

## 10. Current project state

The product baseline and first implementation task are documented. The repository is in the foundation/handoff stage; no application code has yet passed acceptance. See [Project Status](PROJECT_STATUS.md).
