# Technical Architecture — WinDevice Inspector

- Status: Proposed baseline; implementation details require validation during prototype work.

## 1. Recommended direction

Use **C# with a supported .NET LTS release** for the application and collection engine. Start with **WPF** unless a documented prototype demonstrates a compelling reason to use WinUI 3. WPF offers a mature Windows desktop ecosystem and a straightforward path for a first Windows-only utility.

Keep UI, collection, data contracts, diagnostics, and report generation separated. Do not build a monolithic window with PowerShell scripts embedded in event handlers.

## 2. Proposed solution layout

```text
src/
  WinDeviceInspector.App/          # WPF UI, navigation, view models
  WinDeviceInspector.Core/         # domain models, orchestration, status types
  WinDeviceInspector.Collectors/   # PowerShell, CIM, Windows API collectors
  WinDeviceInspector.Diagnostics/  # event normalization and timeline analysis
  WinDeviceInspector.Reporting/    # JSON, HTML, TXT and AI brief generation
tests/
  WinDeviceInspector.Core.Tests/
  WinDeviceInspector.Collectors.Tests/
  WinDeviceInspector.Reporting.Tests/
```

Names and boundaries may be adjusted after a working vertical slice, but dependency direction should remain inward: UI depends on Core abstractions; collectors implement Core contracts; reporting consumes versioned data contracts.

## 3. Collection pipeline

1. Create a scan session with a unique ID, timestamp, time zone, application version, and schema version.
2. Execute independent collectors asynchronously with bounded concurrency.
3. Record per-collector status, duration, source, query window, and warnings.
4. Normalize collected results into versioned domain contracts without discarding source-specific fields.
5. Run deterministic diagnostics and event correlation.
6. Persist the raw structured scan locally.
7. Generate redacted exports and AI diagnostic briefs on user request.

Suggested result states:
- Success
- Partial
- Unsupported
- Unavailable
- PermissionDenied
- Failed
- Skipped

Never substitute guessed values for missing values.

## 4. PowerShell integration

PowerShell is a collection backend, not the whole application.

- Launch a child PowerShell process with a controlled executable path and explicit arguments.
- Prefer signed or application-shipped scripts/resources; do not build command strings from untrusted UI text.
- Use non-interactive execution, a controlled working directory, and explicit output encoding.
- Capture stdout, stderr, exit code, timeout, and cancellation.
- Prefer structured JSON output with a versioned schema over parsing formatted tables.
- Keep scripts read-only. Do not invoke arbitrary user-provided commands.
- Do not require an elevated process for ordinary collection.
- If an administrator-only collector is added, explain exactly what it reads and request explicit consent for that operation.
- Avoid logging secrets or full environment variables.

Use CIM/WMI and native PowerShell cmdlets for baseline inventory. Use Windows APIs or specialized, well-reviewed libraries only where the required data is not exposed reliably through CIM.

## 5. Windows data-source map

| Information | Initial source candidates | Notes |
|---|---|---|
| OS/system/BIOS/CPU/board | CIM classes and Windows APIs | Validate missing/virtualized fields |
| Memory modules | Win32_PhysicalMemory and related CIM | Timings/channel topology may be unavailable |
| GPU/display | Win32_VideoController, DisplayConfig APIs, EDID | Adapter memory and active mode can be misreported by older WMI fields |
| Storage | Storage cmdlets, CIM, NVMe/SMART interfaces | Health counters vary by controller/driver |
| PnP devices | Get-PnpDevice, Win32_PnPEntity, SetupAPI | Preserve problem codes and hardware IDs |
| Drivers | Get-CimInstance Win32_PnPSignedDriver, PnP/SetupAPI | Driver date/version/provider/signature availability varies |
| Network | Get-NetAdapter, Get-NetIPConfiguration, CIM | Redact IP/MAC data in shareable output |
| System/application errors | Get-WinEvent | Access and retention depend on channel and permissions |
| Unexpected shutdowns | System event log providers and IDs | Evidence, not root-cause proof |
| Reliability history | Reliability WMI classes / RAC records where present | Availability differs by Windows version and system configuration |
| WER | WER report directories and related events | Some content may be access-restricted or contain personal paths |
| Diagnostic reports | Existing Windows report locations and supported APIs | Discover rather than assume fixed file availability |

## 6. Event handling

Keep both normalized fields and original event evidence:
- Channel/log name
- Provider/source
- Event ID
- Record ID
- Level
- UTC timestamp and rendered local timestamp
- Machine name as locally stored, with redaction in shareable output
- Event message and selected event data
- Original XML where appropriate and size-limited

Build timelines using timestamps. Do not equate correlation with causation. In particular, Kernel-Power 41 and EventLog 6008 indicate an unexpected shutdown was observed; neither alone identifies whether the cause was power loss, a forced reset, a crash, or another failure. BugCheck 1001 and dump metadata may add evidence but still require interpretation.

## 7. Data storage and export

- Canonical scan format: versioned JSON.
- Local history: SQLite or JSON-per-scan for the first prototype; choose after testing expected data volume and comparison needs.
- User-facing exports: HTML and TXT, plus JSON for machine-readable analysis.
- Store raw evidence separately from redacted/shareable output.
- Include schema version, collector version, scan ID, time zone, and collection outcomes in every export.

## 8. Security and privacy

- Local-first; no automatic upload.
- Read-only collection.
- Least privilege.
- No silent elevation.
- Redaction before sharing.
- Explicit preview before copying/exporting an AI brief.
- Treat event messages, paths, usernames, serial numbers, IP/MAC addresses, and crash metadata as potentially sensitive.
- Validate and bound all imported or generated content.
- Do not execute collected strings or event content as commands.

## 9. Testing strategy

- Unit-test normalization, schema versioning, redaction, event correlation, and brief generation.
- Use fixture data for known Windows event records.
- Integration-test collectors on supported Windows versions.
- Test non-admin execution and permission-denied behavior.
- Test partial failure: one failed collector must not discard successful categories.
- Validate JSON/HTML output and ensure sensitive-value redaction.
- Maintain a test matrix for Windows build, PowerShell version, and hardware vendor variation.
