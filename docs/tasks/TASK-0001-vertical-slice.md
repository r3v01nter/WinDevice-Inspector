# TASK-0001 — WPF Shell, Consent-Gated Quick Collection, and Local History

- Status: Ready for Gemini implementation
- Milestone: Phase 1 — First runnable vertical slice
- Technical lead/reviewer: ChatGPT
- Primary implementation producer: Gemini
- Repository: https://github.com/r3v01nter/WinDevice-Inspector
- Target: Windows 11 x64, C# / .NET 10 / WPF

## 1. Read the public repository first

The repository is public. Read the current contents of these files before implementation:
- `README.md`
- `CONTRIBUTING.md`
- `docs/README.md`
- `docs/PROJECT_OVERVIEW.md`
- `docs/REPOSITORY_STRUCTURE.md`
- `docs/PRODUCT_REQUIREMENTS.md`
- `docs/TECHNICAL_ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/AI_COLLABORATION.md`
- `docs/decisions/ADR-0001-desktop-stack.md`
- This task brief.

Also inspect any existing source and tests before creating files. Do not assume the repository is still empty or that this brief overrides newer repository decisions.

Public read access does not imply permission or capability to push to GitHub, run commands on the owner's PC, or execute a Windows build. Return a complete delivery package. Report all commands that were not actually run as Not run.

## 2. Product context

WinDevice Inspector is a local-first Windows desktop evidence collector. It collects hardware/system information and organizes it for later inspection and AI-assisted diagnosis. It does not repair the system, install drivers, or upload data.

**Non-negotiable:** every scan is started manually by the user and requires explicit confirmation immediately before collection. No startup/background/scheduled/automatic scan is permitted.

## 3. Objective

Build a first runnable vertical slice proving this complete flow:

1. WPF application opens to a no-scan-yet dashboard.
2. User deliberately clicks **Start Quick Collection**.
3. App displays a collection notice listing categories, purpose, and potentially sensitive information.
4. User must explicitly confirm or cancel. Cancel means no collector process starts.
5. After confirmation, app launches a controlled PowerShell child process.
6. Collector returns structured JSON for initial system/hardware categories.
7. UI displays progress and category outcomes.
8. A completed scan can be saved locally and appears in a basic history list.
9. User can reopen a prior scan and explicitly export its raw JSON to a chosen path.

This is a deliberately limited vertical slice. Do not attempt to implement the entire V1 product in this task.

## 4. Technology and environment

- C#.
- .NET 10 LTS target: `net10.0-windows`.
- WPF.
- Windows 11 x64.
- Avoid third-party NuGet dependencies unless necessary; explain each dependency.
- Do not install software or change the owner's machine.
- The owner has not yet supplied the latest development-environment verification report. Do not claim the environment is ready or that a local build passed without evidence.
- If you cannot run Windows-specific build/tests in your environment, provide complete source and mark those checks Not run. Include exact commands for the owner to run.

## 5. Initial collection categories

Collect these only after the user's explicit confirmation, where available:
- Windows product name, edition, version, build, architecture, install date, and last boot time.
- Computer manufacturer, model, and system type.
- CPU name, core count, and logical processor count.
- Motherboard manufacturer/product and BIOS vendor/version/date.
- Physical memory total and per-module capacity/manufacturer/part number/speed where exposed.
- GPU name, driver version, and driver date where exposed.
- Physical disks and logical volumes: model, media/interface type where exposed, size, drive letter, filesystem, and free space.
- Network adapters: name, description, status, MAC address, link speed, IP and DNS configuration where exposed.
- PnP devices with non-OK status and their problem codes.

Do not add temperature, power, fan, real-time utilization, or benchmark collection.

## 6. Mandatory consent and scan lifecycle

- The app must not scan at startup, on dashboard load, on resume, or due to a timer/event.
- The only entry point to a scan is an explicit user action.
- Before each scan, show a modal or equivalent clear confirmation view.
- Explain the categories to be queried, why they are queried, and that results may include identifying values such as computer name, device serials, MAC/IP addresses, local paths, and event/device metadata.
- Show whether the requested collection requires administrator privileges. This task's normal collection path must not require elevation.
- The user must choose Confirm or Cancel. The collector process must not be created/launched before Confirm.
- If cancelled, record no scan as completed and do not launch PowerShell.
- User may cancel an active scan; terminate the child process tree safely.
- Do not add scheduled/background scanning or automatic retries that start a new scan without confirmation.

## 7. Collection result contract

Return one JSON document with:
- `schemaVersion`
- `scanId`
- `collectedAtUtc`
- `computerName` (raw local result; never put real machine data in fixtures or examples)
- `collectorVersion`
- `categories` array

Each category must include:
- stable `id`
- human-readable `name`
- `status`: Success, Partial, Unsupported, Unavailable, PermissionDenied, Failed, or Skipped
- `source`
- `collectedAtUtc`
- `data` (structured object/array; empty when unavailable)
- `warnings` array

The top-level result must remain valid JSON even if one category fails. A category failure must not discard other successful categories.

## 8. PowerShell process requirements

- Prefer `pwsh.exe` if present; fall back to Windows PowerShell `powershell.exe`.
- Launch a separate non-interactive child process with `-NoProfile` and a fixed bundled script path.
- Do not construct PowerShell commands from user-entered text.
- Do not run arbitrary commands returned by collected device data.
- Use a controlled working directory and explicit UTF-8 output.
- Capture stdout, stderr, exit code, duration, timeout, and cancellation.
- Set a reasonable timeout and terminate the child process tree on cancellation/timeout.
- Ensure script outputs machine-readable JSON only on stdout; diagnostic messages belong on stderr.
- Do not change machine-wide execution policy. If a process-scoped option is required, document why.
- Collection must be read-only and must not require administrator privileges for the normal path.
- No network requests, telemetry, uploads, registry writes, driver changes, or system configuration changes.

## 9. Local history and export

- Save each successfully parsed scan as a separate local JSON record in an application-owned data directory under the current user's local application data.
- Do not write scan history into the repository or a shared cloud directory.
- Include schema version, scan ID, timestamps, and collector version.
- Show a basic list of saved scans with date/time and outcome.
- Allow opening a saved scan without performing a new scan.
- Allow explicit user-initiated JSON export through a save dialog.
- Do not add cloud sync, automatic sharing, or automatic export.
- Handle malformed/corrupt history entries without crashing the application; show an actionable error and preserve the original file.

## 10. UI requirements

A simple, clean WPF window is sufficient. Prioritize clarity and user control over visual effects.

Minimum UI:
- App title: WinDevice Inspector.
- Dashboard with OS/computer summary only after data has been collected or loaded from history.
- Clearly visible **Start Quick Collection** button.
- Collection notice/confirmation showing categories and privacy information.
- Progress indicator and current category/status.
- Results list grouped by category.
- Clear visual distinction between Success, Partial, Unsupported, PermissionDenied, Failed, and Skipped.
- Basic local history list and ability to open a previous scan.
- Button to export raw JSON to a user-selected location.
- Error details that help troubleshoot missing PowerShell or collector failures.

Do not display fake or hardcoded device values. Before any scan/history exists, show an empty/never-scanned state.

## 11. Code quality and safety

- Separate UI from process execution, persistence, and collection contracts.
- Use asynchronous process handling; keep UI responsive.
- Use cancellation and dispose processes/streams correctly.
- Validate JSON before presenting or persisting it.
- Avoid swallowing exceptions.
- Do not log secrets or unnecessary personal identifiers.
- Add comments where process handling, persistence, or encoding behavior is non-obvious.
- Do not implement automatic diagnosis, AI brief generation, or repair in this task.

## 12. Tests and verification

At minimum:
- Unit tests for JSON contract parsing and category status handling.
- Test malformed JSON and non-zero process exit behavior using fixtures or a fake process runner where practical.
- Test that Cancel does not create/start the collector process (use an injectable/fake process launcher).
- Test that no scan is triggered during application startup.
- Test local history save/load and malformed-history handling.
- Build the solution if a suitable Windows/.NET 10 environment is available.
- Report exact commands, environment, exit codes, test counts, and relevant output.
- Do not claim tests passed if they were not run. Separate static code review from actual execution.

## 13. Explicit non-goals

- Full event log collection, unexpected shutdown timeline, RAC/WER discovery.
- AI diagnostic brief generation.
- Advanced history comparison.
- Installer and portable packaging.
- Live sensors, temperature, power, fan, frequency, utilization dashboard.
- Driver install/update/disable/uninstall.
- Administrator elevation.
- Automatic scan, background scan, scheduled scan, telemetry, or upload.

These are later tasks.

## 14. Delivery package

Return all files needed to build and run the vertical slice, including:
- Solution and project files.
- Complete source files.
- Bundled PowerShell collector script.
- Tests and fixtures.
- README with prerequisites and run instructions.
- `docs/IMPLEMENTATION_NOTES.md`.
- Completed `COMPLETION_RECEIPT.md` based on the repository template.

Package layout:

```text
TASK-0001/
  source/
    [complete solution and source tree]
  tests/
    [test projects and fixtures, if separate]
  docs/
    IMPLEMENTATION_NOTES.md
  COMPLETION_RECEIPT.md
```

Do not return only snippets or patches. Include complete file contents. Do not include secrets or machine-specific scan data.

## 15. Acceptance criteria

- [ ] Solution and WPF app project are present.
- [ ] App starts on supported Windows 11 x64.
- [ ] No scan runs at startup or without explicit user confirmation.
- [ ] Cancelled confirmation does not launch PowerShell.
- [ ] Quick Collection launches the bundled collector as a separate process only after confirmation.
- [ ] UI remains responsive during collection.
- [ ] JSON follows the specified schema and includes per-category outcomes.
- [ ] Partial collection failure does not discard successful categories.
- [ ] Hardware/system values are collected rather than hardcoded.
- [ ] Completed scans are stored locally and can be reopened from history.
- [ ] Raw JSON export is explicitly user initiated.
- [ ] Collection does not modify system state, upload data, or silently elevate.
- [ ] Build/test results and known limitations are accurately reported.
- [ ] Complete delivery package and completion receipt are provided.

## 16. Completion response

Return a concise summary, complete file list, verification evidence, deviations, known limitations, and any manual prerequisites. Stop after delivering TASK-0001; do not begin later milestones.
