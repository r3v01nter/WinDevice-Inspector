# Technical Architecture — WinDevice Inspector

- Status: Accepted starting architecture; implementation details are validated through tasks.
- Target baseline: C# / .NET 10 LTS / WPF / Windows 11 x64.

## 1. Architecture goals

- Keep the application maintainable as a Windows-first desktop utility.
- Separate presentation, scan orchestration, data contracts, collectors, persistence, diagnostics, and report generation.
- Make collection read-only, explicit, cancellable, observable, and independently testable.
- Preserve source evidence and uncertainty instead of inventing missing values.
- Keep scan data local unless the user deliberately exports it.

## 2. Proposed solution layout

The exact project boundaries may be refined after the first vertical slice. The intended direction is:

- src/WinDeviceInspector.App/: WPF UI, views, view models, navigation.
- src/WinDeviceInspector.Core/: domain models, contracts, orchestration abstractions.
- src/WinDeviceInspector.Collectors/: PowerShell process runner and collectors.
- src/WinDeviceInspector.Persistence/: local scan history and serialization.
- src/WinDeviceInspector.Diagnostics/: event normalization and evidence correlation.
- src/WinDeviceInspector.Reporting/: JSON/HTML/TXT reports and AI diagnostic briefs.
- tests/: matching automated test projects.

Do not create every project merely to match this diagram. TASK-0001 should use the smallest coherent solution that proves its required vertical slice. Add project boundaries when they provide a concrete testability or dependency benefit.

Dependency direction:
- App depends on Core abstractions and presentation-facing services.
- Collectors implement Core collection contracts.
- Persistence stores versioned scan contracts and does not own UI behavior.
- Diagnostics and Reporting consume collected evidence; they do not start scans.
- Core must not depend on WPF views.

## 3. Mandatory scan-consent boundary

The scan lifecycle is a product-level safety boundary:

1. The application starts without querying hardware or system diagnostic sources.
2. The user deliberately activates a scan action.
3. The application presents the exact scan scope, purpose, potentially sensitive categories, and privilege requirements.
4. The user explicitly confirms or cancels.
5. Only after confirmation may the scan orchestrator create a collector process or invoke a collector.
6. The user can cancel an active scan.
7. Results are validated, displayed, and optionally saved locally.

No startup, background, scheduled, timer-driven, idle-time, resume-triggered, or automatic retry scan is permitted. Opening saved history is not a scan and must not invoke collectors.

Enforce this boundary in the orchestration/service layer, not only by hiding or disabling a UI button. Design the scan-start API so a confirmed user action is required and test that cancellation/startup paths never invoke a collector.

## 4. Collection pipeline

After consent has been granted:

1. Create a scan session with a unique ID, UTC timestamp, time-zone context, application version, collector version, and schema version.
2. Execute independent collectors asynchronously with bounded concurrency.
3. Record each collector's start/end time, duration, source, outcome, warnings, and query/lookback window.
4. Normalize results into versioned contracts while retaining relevant source-specific evidence.
5. Validate the complete result before presenting or persisting it.
6. Save the scan locally according to the user's selected save behavior.
7. Generate exports or AI briefs only after a separate user action and content review.

Suggested category states:
- Success
- Partial
- Unsupported
- Unavailable
- PermissionDenied
- Failed
- Skipped

A failure in one category must not discard successful results from other categories. Unknown or unavailable values must remain explicit.

## 5. PowerShell integration boundary

PowerShell is a controlled collection backend, not the application UI and not an unrestricted command console.

- Launch a separate non-interactive child process using a fixed, application-shipped script path.
- The project must support both PowerShell 7 and Windows PowerShell 5.1. Prefer PowerShell 7 when available; retain a tested 5.1 path.
- Both versions require explicit integration-test evidence for process launch, non-interactive execution, UTF-8 JSON, required CIM/commands, stdout/stderr, exit codes, timeout, cancellation, and non-admin behavior. Record the actual runtime version; never claim support for an untested version.
- Use explicit arguments, a controlled working directory, and predictable UTF-8 output.
- Capture stdout, stderr, exit code, elapsed time, timeout, and cancellation.
- Emit machine-readable JSON on stdout; diagnostic messages belong on stderr.
- Never build command text from user-entered strings or collected device values.
- Never execute event messages, device names, registry values, or other collected content.
- Do not change machine-wide execution policy.
- Do not silently elevate. Ordinary collection should not require administrator rights; a later collector needing elevation must be separately explained and explicitly consented.
- Terminate the child process tree safely on cancellation or timeout.
- No network requests, telemetry, uploads, registry writes, driver changes, or system configuration changes.

## 6. Initial Windows data-source map

| Information | Candidate sources | Important limitations |
|---|---|---|
| OS, computer, BIOS, CPU, board | CIM/WMI and Windows APIs | Firmware fields may be missing or vendor-specific |
| Memory modules | Win32_PhysicalMemory and related CIM | Timings/channel topology may not be exposed |
| GPU/display | CIM, DisplayConfig APIs, EDID | WMI memory/mode fields can be inaccurate |
| Storage | Storage cmdlets, CIM, supported health interfaces | SMART/NVMe health depends on controller and driver |
| PnP devices | PnP cmdlets, CIM, SetupAPI | Preserve problem codes and hardware IDs |
| Drivers | Signed-driver CIM data, PnP/SetupAPI | Signature and date fields vary |
| Network | NetAdapter cmdlets and IP configuration APIs | IP/MAC values may identify the user/network |
| System/application errors | Event Log APIs / Get-WinEvent | Access and retention vary by channel |
| Unexpected shutdowns | Relevant System providers and event IDs | Evidence of an event, not proof of root cause |
| Reliability history | RAC data where present | Availability varies by Windows configuration |
| WER | Windows Error Reporting metadata | Paths/messages may contain personal information |

The actual collector must report unsupported or inaccessible sources rather than silently omit them.

## 7. Result contract and schema versioning

The canonical scan result is a versioned JSON document containing at least:
- schemaVersion (TASK-0001 baseline: v1)
- scanId
- collectedAtUtc
- timeZoneId or equivalent time-zone context
- computerName (local raw value where collected; unknown must be explicit)
- applicationVersion
- collectorVersion
- categories

TASK-0001 must implement and test this complete top-level field set; it is not permitted to omit time-zone context or application version.

Each category contains:
- Stable id and display name
- status
- source
- collectedAtUtc
- durationMs, where measurable
- Structured data
- warnings
- durationMs, where measurable
- Structured data
- warnings
- Relevant query window or collection parameters actually used by the collector

TASK-0001 category contracts must include the full field set above. Query/collection parameters must reflect actual execution and must not contain secrets or arbitrary command text.

Schema changes must be deliberate and documented. Fixtures must use synthetic values, never real machine identifiers or user scan exports.

## 8. Local persistence and exports

- Keep local scan history under the current user's local application data directory.
- Do not store real scan data in the repository.
- JSON is the canonical machine-readable snapshot format.
- HTML and TXT are user-facing report formats.
- Include schema version, application/collector version, scan ID, timestamps, and category outcomes in exports.
- Allow users to open and delete local history.
- Opening history must never initiate a new scan.
- Export/copy must be an explicit user action.
- For raw JSON export, show a sensitive-information warning before opening the save dialog. The user may continue or cancel; cancel must not open the save dialog or write a file. This warning is not automatic redaction: raw evidence remains unchanged.

The first implementation may use one JSON file per scan. Revisit SQLite only if history size, querying, or comparison requirements justify it.

## 9. Privacy and sharing

- Explain collection scope and purpose before each scan.
- Warn that identifiers, serial numbers, usernames, machine names, paths, IP/MAC addresses, and event text may be sensitive.
- Raw JSON export must show a one-time warning before the save dialog, naming likely sensitive categories. If the user cancels, no save dialog or file write may occur.
- Keep raw local evidence separate from the shareable content the user selects.
- Before generating a shareable report or AI brief, show the actual content and let the user include/exclude fields and categories.
- Do not silently redact fields the user expects to inspect, and do not silently expose sensitive fields.
- No automatic upload, telemetry, cloud sync, or AI-provider connection.

## 10. Reliability evidence and interpretation

Preserve both normalized fields and relevant original event evidence: channel, provider, event ID, record ID, level, timestamp, machine context, message, and selected event data. Original XML may be retained where useful, bounded in size, and handled as potentially sensitive.

Build timelines by timestamps but do not equate correlation with causation. Kernel-Power 41 and EventLog 6008 indicate an unexpected shutdown was observed; neither alone identifies whether the cause was power loss, forced reset, crash, or another failure. BugCheck 1001 and dump metadata add evidence but still require interpretation.

## 11. Testing strategy

- Unit-test schema parsing, validation, status handling, serialization, and version compatibility.
- Test the consent gate: app startup and Cancel must not invoke a collector.
- Test process timeout, cancellation, stderr/stdout handling, non-zero exit, and malformed JSON.
- Test local history save/load/delete and corrupt-entry handling.
- Use synthetic fixture events for event normalization and correlation.
- Integration-test collectors on supported Windows versions and non-admin accounts.
- Test partial failure and unsupported data sources.
- Test report previews and user-selected field inclusion.
- Record Windows build and PowerShell version in integration-test evidence.
