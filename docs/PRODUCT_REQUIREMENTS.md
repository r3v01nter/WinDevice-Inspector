# Product Requirements — WinDevice Inspector

- Status: Draft baseline
- Product: WinDevice Inspector
- Target: Windows desktop
- Release focus: comprehensive one-time collection and AI-ready diagnostic task generation

## 1. Product definition

WinDevice Inspector is a local-first Windows desktop utility. It collects a broad, evidence-based snapshot of a computer's hardware, devices, drivers, Windows configuration, reliability records, and system/application errors. It then organizes that information and generates a diagnostic task brief that the user can give to an AI assistant.

The application is an evidence collector and organizer. It is not an autonomous repair tool and does not need to connect to an AI provider.

## 2. Primary user journey

1. User opens the application.
2. Dashboard shows the last scan, device summary, collection coverage, and notable findings.
3. User starts **Quick Collection**.
4. The application runs the collection pipeline and displays progress by category.
5. Each item is marked as collected, partial, unsupported, unavailable, permission denied, or failed.
6. User inspects hardware, Windows, driver, and reliability details.
7. User opens **AI Diagnostic Brief**, chooses a diagnostic scope, reviews the included data and redactions, and generates a prompt/document.
8. User copies or exports the brief and manually provides it to their preferred AI assistant.

## 3. First-release functional requirements

### 3.1 Dashboard

- Show computer summary, Windows edition/version/build, last scan time, and scan status.
- Show collection coverage and counts of detected device problems and relevant system events.
- Show concise recent reliability indicators without asserting a root cause.
- Clearly distinguish current scan data from historical scan data.
- Do not show fabricated live temperatures, utilization, health percentages, or sensor readings.

### 3.2 Quick Collection

Collection should be broad by default, with category-level progress and explicit outcomes.

Required categories:
- Computer/system manufacturer, model, firmware, and OS.
- CPU, physical memory modules, motherboard, BIOS/UEFI, GPU, display adapters, monitors/EDID where accessible.
- Storage devices, partitions, volumes, bus/interface details, and supported health indicators.
- Network adapters, driver details, IP configuration, DNS, and connection state.
- Audio, Bluetooth, USB, and other Plug and Play devices where discoverable.
- Installed device drivers, provider, version, date, signature status where available.
- Windows updates/hotfixes and boot/uptime information.
- PnP problem devices and Configuration Manager error codes.
- System and Application event logs for a configurable default lookback period.
- Unexpected shutdowns, restarts, bugchecks, WHEA events, service failures, and relevant application crashes.
- Windows Error Reporting (WER), Reliability Monitor / Windows Reliability Analysis Component records, and diagnostic report files where supported and accessible.

The collector must record the source, collection time, query/window, outcome, and limitations for each category.

### 3.3 Event and reliability evidence

- Preserve event provider, Event ID, level, timestamp, record ID, channel, and useful event data.
- Correlate events into a timeline, but do not claim causality from temporal proximity alone.
- Treat Kernel-Power 41 and EventLog 6008 as evidence of an unexpected shutdown, not proof of its cause.
- Treat BugCheck 1001 as bugcheck-related evidence and retain any available bugcheck code/dump reference.
- Include WHEA-Logger records as hardware-error evidence, while preserving the event's own severity and details.
- Report missing logs, retention limits, inaccessible channels, and time-window limitations.

### 3.4 Device and driver inspection

- List detected devices and their class, manufacturer, hardware IDs where appropriate, status, and problem code.
- List driver provider, version, date, INF name, signer/signature status where accessible.
- Do not install, update, disable, or uninstall drivers in the first release.

### 3.5 AI Diagnostic Brief

The application must generate a structured, self-contained prompt from the selected scan data.

Output profiles:
- **Full diagnostic brief:** broad device/system snapshot and relevant event evidence.
- **Quick brief:** concise system summary and top findings.
- **Focused brief:** selected scope such as unexpected restarts, blue screens, device/driver problems, storage, networking, or application crashes.

The brief should include:
- Role and task for the receiving AI.
- Computer and OS context.
- Collection timestamp and time zone.
- Findings grouped by category.
- Relevant event timeline and raw event identifiers/details.
- Collection gaps and unsupported fields.
- Redaction notes.
- Explicit instructions to separate confirmed facts, hypotheses, and unknowns; avoid inventing data; avoid claiming root cause from a single event; and propose safe, verifiable next steps.

No AI API key, account connection, or automatic upload is required.

### 3.6 Local reports and history

- Save scan results locally in a documented, versioned format.
- Support JSON as the canonical structured export.
- Support a readable HTML report and plain-text output.
- Retain scan timestamps and collector/schema version.
- Allow comparison of two scans, including changes in hardware/driver inventory and reliability indicators.
- Allow user-controlled deletion of local history.

### 3.7 Settings and privacy

- Configure event lookback period and report storage location.
- Provide a preview of data included in an AI brief.
- Redact serial numbers, machine identifiers, usernames, local paths, IP/MAC addresses, and other potentially identifying values in shareable output by default where practical.
- Keep raw local scan data separate from redacted shareable exports.
- No telemetry or network upload by default.

## 4. Non-functional requirements

- Windows 11 first; compatibility with supported Windows 10 builds may be evaluated separately.
- Responsive UI while collection runs asynchronously.
- Collection failures must not crash the whole scan.
- Each collector should be independently testable.
- Structured schema must be versioned.
- No fabricated values; unknown is a valid result.
- Read-only behavior by default.
- Administrator elevation must never occur silently.
- Clear diagnostic logging for the application itself, without logging secrets.

## 5. Explicit exclusions for V0.1

- Live CPU/GPU temperature, power, fan, or frequency dashboard.
- Online AI chat or automatic upload to AI providers.
- Automatic driver installation or system repair.
- Stress tests, benchmarks, registry cleaning, or tuning.
- Claims that a single Windows event identifies the root cause of a shutdown.
- Mandatory third-party sensor utilities.

## 6. V0.1 acceptance criteria

- A user can run a scan from the desktop UI without manually opening PowerShell.
- Core hardware, OS, PnP, driver, and event-log categories are collected where the OS exposes them.
- Every category reports a meaningful outcome and source.
- Permission-denied and unsupported data are clearly identified.
- Unexpected-shutdown and bugcheck evidence is presented as a timestamped timeline with original event identifiers.
- A full, quick, and focused AI diagnostic brief can be generated without network access.
- JSON and readable HTML exports are valid and include schema/collector version.
- Shareable output is previewable and redacted by default.
- The application performs no system modification during collection.
