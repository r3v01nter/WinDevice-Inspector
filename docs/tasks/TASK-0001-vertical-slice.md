# TASK-0001 — WPF Shell and Quick Collection Vertical Slice

- Status: Ready for owner handoff to Gemini
- Milestone: Phase 1 — Technical proof of concept
- Coordinator/reviewer: ChatGPT
- Implementer: Gemini Pro desktop task mode
- Repository: https://github.com/r3v01nter/WinDevice-Inspector

## 1. Context

Read these project documents before implementation:

- `README.md`
- `docs/PRODUCT_REQUIREMENTS.md`
- `docs/TECHNICAL_ARCHITECTURE.md`
- `docs/ROADMAP.md`
- `docs/AI_COLLABORATION.md`
- `docs/decisions/ADR-0001-desktop-stack.md`

The product is a local-first Windows desktop application for broad device/system information collection and AI diagnostic task generation. Live temperature, power, fan, and clock monitoring are explicitly out of scope.

The project owner transfers this task to Gemini manually. Gemini must not access, commit to, or push to the GitHub repository. Return a complete delivery package for the owner to place in `DELIVERY/INBOX/TASK-0001/`.

## 2. Objective

Build the first runnable vertical slice:

1. A minimal WPF desktop application shell.
2. A Quick Collection action.
3. A controlled PowerShell child-process runner.
4. A bundled, read-only PowerShell collector that returns structured JSON.
5. A results view that displays collected categories and their collection status.

This task proves the UI-to-collector-to-JSON-to-UI path. It is not the full collector.

## 3. Scope

### 3.1 Technology

- C#.
- .NET 10 LTS target: `net10.0-windows`.
- WPF.
- Windows 11 x64.
- Avoid third-party NuGet dependencies unless genuinely necessary. Explain any dependency added.

Before implementation, inspect the local development environment for installed .NET SDKs and PowerShell versions. Do not install software. If .NET 10 SDK is unavailable, report that and still provide project files; do not claim a successful build.

### 3.2 Initial collection categories

Collect the following when available:
- Windows product name, edition, version, build, architecture, install date, and last boot time.
- Computer manufacturer, model, system type.
- CPU name, core count, logical processor count, and maximum/current clock fields where exposed.
- Motherboard manufacturer, product, and BIOS vendor/version/date.
- Physical memory total and per-module capacity/manufacturer/part number/speed where exposed.
- GPU name, driver version, and driver date where exposed.
- Physical disks and logical volumes: model, media/interface type where exposed, size, drive letter, filesystem, and free space.
- Network adapters: name, manufacturer/description, status, MAC address, link speed, IP and DNS configuration where exposed.
- PnP devices with non-OK status and their problem codes.

Do not add temperature, power, fan, real-time utilization, or benchmark collection.

### 3.3 Collection result contract

Return one JSON document with:
- `schemaVersion`
- `scanId`
- `collectedAtUtc`
- `computerName` (raw local result; do not include in redacted public examples)
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

## 4. PowerShell process requirements

- Prefer `pwsh.exe` if present; fall back to Windows PowerShell `powershell.exe`.
- Launch a separate non-interactive child process with `-NoProfile` and a fixed script path.
- Do not construct a PowerShell command from user-entered text.
- Do not run arbitrary commands returned by collected device data.
- Use a controlled working directory and explicit UTF-8 output.
- Capture stdout, stderr, exit code, duration, timeout, and cancellation.
- Set a reasonable timeout and terminate the child process tree on cancellation/timeout.
- Ensure the script outputs machine-readable JSON only on stdout; diagnostic messages belong on stderr.
- Do not change machine-wide execution policy. If a process-scoped execution-policy option is required, document why.
- Collection must be read-only and must not require administrator privileges for the normal path.
- No network requests, telemetry, uploads, registry writes, driver changes, or system configuration changes.

## 5. UI requirements

A simple, clean WPF window is sufficient. Do not spend time on elaborate visual effects.

Minimum UI:
- App title: WinDevice Inspector.
- Dashboard summary with OS and computer model when collected.
- A clearly visible **Start Quick Collection** button.
- Progress indicator and current category/status.
- Results list grouped by category.
- Clear visual distinction between Success, Partial, Unsupported, PermissionDenied, and Failed.
- Error details that help troubleshoot missing PowerShell or collector failures.
- A button to save the raw JSON result to a user-selected location.

Do not display fake or hardcoded device values. If collection has not run, show an empty/never-scanned state.

## 6. Code quality and safety

- Separate UI from process execution and collection contracts.
- Use asynchronous process handling; keep the UI responsive.
- Use cancellation and dispose processes/streams correctly.
- Validate JSON before presenting it.
- Avoid swallowing exceptions.
- Do not log secrets or unnecessary personal identifiers.
- Add comments where process handling or encoding behavior is non-obvious.
- Do not implement automatic diagnosis or repair in this task.

## 7. Tests and verification

At minimum:
- Unit tests for JSON contract parsing and category status handling.
- Tests for malformed JSON and non-zero process exit behavior, using fixtures or a fake process runner where practical.
- Build the solution if the required SDK is installed.
- Report exact commands, exit codes, and test counts.
- Do not claim tests passed if they were not run.

## 8. Explicit non-goals

- Full event log collection.
- Unexpected shutdown timeline.
- Reliability Monitor/RAC and WER discovery.
- AI diagnostic brief generation.
- SQLite/history.
- Installer and auto-update.
- Live sensors, temperature, power, fan, frequency, utilization dashboard.
- Driver install/update/disable/uninstall.
- Administrator elevation.

These are later tasks.

## 9. Delivery package

Return all files needed to build and run the vertical slice, including:
- Solution and project files.
- Complete source files.
- Bundled PowerShell collector script.
- Tests and fixtures.
- README with prerequisites and run instructions.
- Completed `docs/templates/COMPLETION_RECEIPT_TEMPLATE.md` for TASK-0001.

Use this package layout:

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

## 10. Acceptance criteria

- [ ] Solution and WPF app project are present.
- [ ] The app starts on a supported Windows 11 machine.
- [ ] Quick Collection launches the bundled collector as a separate process.
- [ ] UI remains responsive during collection.
- [ ] JSON follows the specified schema and includes per-category outcomes.
- [ ] Partial collection failure does not discard successful categories.
- [ ] Hardware/system values are collected rather than hardcoded.
- [ ] Raw JSON can be saved by the user.
- [ ] Collection does not modify system state and does not silently elevate.
- [ ] Build/test results and known limitations are accurately reported.
- [ ] Complete delivery package and completion receipt are provided.

## 11. Completion response

Return a concise summary, complete file list, verification results, deviations, known limitations, and any manual prerequisites. Stop after delivering TASK-0001; do not begin later milestones.
