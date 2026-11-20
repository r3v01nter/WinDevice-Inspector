# Product Requirements — WinDevice Inspector

- Status: Confirmed product baseline
- Product: WinDevice Inspector
- Target: Windows desktop
- Initial platform: Windows 11 x64
- Release focus: user-controlled evidence collection, local history, and AI-ready diagnostic task generation

## 1. Product definition

WinDevice Inspector is a local-first Windows desktop utility. It collects a broad, evidence-based snapshot of hardware, devices, drivers, Windows configuration, reliability records, and system/application errors. It organizes the evidence and generates diagnostic briefs that the user can provide to an AI assistant.

The application is an evidence collector and organizer. It is not an autonomous repair tool and does not need to connect to an AI provider.

## 2. Non-negotiable user-control rule

**Every scan is manual and requires explicit user confirmation immediately before it starts.**

- No automatic scan at application startup.
- No background, scheduled, periodic, idle-time, or unattended scan.
- No automatic re-scan after a driver update, reboot, device change, or application update.
- The user must deliberately press the scan action and confirm the displayed collection scope.
- The confirmation screen must summarize categories, purpose, expected duration where known, and whether administrator permission is needed.
- If the user cancels or declines, no collection process starts.
- A scan already in progress may be cancelled by the user.
- Local history may be read when the application opens; reading saved local history is not a new system scan.

## 3. Primary user journey

1. User opens the application. No system scan starts.
2. Dashboard shows the last saved scan and locally stored summary, if available.
3. User selects a scan action.
4. The application shows a collection notice: categories, purpose, possible sensitive data, and privilege requirements.
5. User explicitly confirms or cancels.
6. Only after confirmation does the application start collection and display progress.
7. Each category is marked collected, partial, unsupported, unavailable, permission denied, failed, or skipped.
8. The user reviews results and may save them to local history.
9. User opens AI Diagnostic Brief, selects full or focused scope, reviews the fields to include, and generates a prompt/document.
10. User copies or exports the brief and manually provides it to their chosen AI assistant.

## 4. First-release functional requirements

### 4.1 Dashboard

- Show computer summary and Windows edition/version/build from the latest saved scan.
- Show last scan time, scan status, and local history count.
- Show collection coverage and notable findings from saved scan data.
- Clearly distinguish current saved data from live system state.
- Do not show fabricated live temperatures, utilization, health percentages, or sensor readings.
- Do not trigger a scan automatically.

### 4.2 Manual collection

Required categories, where accessible:
- Computer/system manufacturer, model, firmware, and OS.
- CPU, physical memory modules, motherboard, BIOS/UEFI, GPU, display adapters, monitors/EDID.
- Storage devices, partitions, volumes, bus/interface details, and supported health indicators.
- Network adapters, driver details, IP configuration, DNS, and connection state.
- Audio, Bluetooth, USB, and other Plug and Play devices.
- Installed device drivers, provider, version, date, signature status.
- Windows updates/hotfixes and boot/uptime information.
- PnP problem devices and Configuration Manager error codes.
- System and Application event logs for a user-visible configurable lookback period.
- Unexpected shutdowns, restarts, bugchecks, WHEA events, service failures, and relevant application crashes.
- Windows Error Reporting (WER), Reliability Monitor / RAC records, and diagnostic report files where supported and accessible.

The collection notice must be shown before each scan. The application must record source, collection time, query/window, outcome, and limitations for each category.

### 4.3 Event and reliability evidence

- Preserve event provider, Event ID, level, timestamp, record ID, channel, and useful event data.
- Correlate events into a timeline, but do not claim causality from temporal proximity alone.
- Treat Kernel-Power 41 and EventLog 6008 as evidence of an unexpected shutdown, not proof of its cause.
- Treat BugCheck 1001 as bugcheck-related evidence and retain available bugcheck code/dump references.
- Preserve WHEA-Logger severity and event details.
- Report missing logs, retention limits, inaccessible channels, and time-window limitations.

### 4.4 Device and driver inspection

- List detected devices and their class, manufacturer, hardware IDs where appropriate, status, and problem code.
- List driver provider, version, date, INF name, signer/signature status where accessible.
- Do not install, update, disable, or uninstall drivers.

### 4.5 AI Diagnostic Brief

Generate self-contained diagnostic prompts locally, with no AI API or network connection.

Profiles:
- **Full diagnostic brief:** broad device/system snapshot and relevant event evidence.
- **Focused brief:** selected scope such as unexpected restarts, blue screens, device/driver problems, storage, networking, or application crashes.
- A concise quick summary may be offered as a presentation option, but it must not replace the full and focused profiles.

Every brief should include:
- Role and task for the receiving AI.
- Computer and OS context.
- Collection timestamp and time zone.
- Findings grouped by category.
- Relevant event timeline and raw event identifiers/details.
- Collection gaps and unsupported fields.
- A clear list of included/excluded sensitive fields.
- Instructions to separate confirmed facts, hypotheses, and unknowns; avoid inventing data; avoid claiming root cause from a single event; and propose safe, verifiable next steps.

The user must preview the actual content and choose which fields/categories to include before copying or exporting. The application must not silently upload anything.

### 4.6 Local reports and history

- Save scan results locally in a documented, versioned format.
- JSON is the canonical structured format.
- Support readable HTML and plain-text output.
- Retain scan timestamps, collector version, schema version, and category outcomes.
- First release must provide a local history list and allow opening a previous scan.
- Scan comparison may be implemented after reliable history persistence; it is not a prerequisite for the first vertical slice.
- Allow user-controlled deletion of local history.
- Do not synchronize history to cloud storage automatically.

### 4.7 Privacy and collection notice

- Before every scan, explain what will be collected, why, and any known limitations.
- Explain that device identifiers, serial numbers, usernames, machine names, paths, IP/MAC addresses, and event messages may contain identifying information.
- Do not claim that data is anonymous when it is not.
- Before generating a shareable brief/export, show a preview and provide user-controlled inclusion/exclusion for potentially sensitive fields and categories.
- Do not force blanket redaction that hides information from the user; do not silently include sensitive information either.
- Raw scan data stays local unless the user explicitly chooses to export/share it.
- When the user chooses raw JSON export, show a sensitive-information warning before the save dialog. The warning must explain that the file may contain computer/device identifiers, serial numbers, usernames, paths, IP/MAC addresses, and system metadata. Continue opens the save dialog; Cancel stops the export without opening the dialog or writing a file.
- This warning does not alter, redact, or silently remove fields from the raw evidence.
- No telemetry or network upload by default.

## 5. Non-functional requirements

- Responsive UI while collection runs asynchronously.
- Collection failures must not crash the whole scan.
- Each collector should be independently testable.
- Structured schema must be versioned.
- Unknown is a valid result; never fabricate values.
- Read-only behavior by default.
- Administrator elevation must never occur silently. Any elevated operation requires a separate explanation and explicit consent.
- Clear diagnostic logging for the application itself, without logging secrets.
- Scans must only run following explicit user action and confirmation.

## 6. Explicit exclusions for V1

- Live CPU/GPU temperature, power, fan, or frequency dashboard.
- Online AI chat or automatic upload to AI providers.
- Automatic driver installation or system repair.
- Stress tests, benchmarks, registry cleaning, or tuning.
- Claims that a single Windows event identifies the root cause of a shutdown.
- Mandatory third-party sensor utilities.
- Background or scheduled scans.

## 7. V1 acceptance criteria

- A user can run a scan from the desktop UI without manually opening PowerShell.
- No scan starts at startup or without explicit confirmation.
- Core hardware, OS, PnP, driver, and event-log categories are collected where the OS exposes them.
- Every category reports a meaningful outcome and source.
- Permission-denied and unsupported data are clearly identified.
- Unexpected-shutdown and bugcheck evidence is presented as a timestamped timeline with original event identifiers.
- Full and focused AI diagnostic briefs can be generated without network access.
- JSON and readable HTML exports are valid and include schema/collector version.
- Local scan history can be viewed and deleted by the user.
- Shareable output is previewable and the user controls sensitive-field inclusion.
- The application performs no system modification during collection.
