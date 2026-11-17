# Roadmap — WinDevice Inspector

This roadmap prioritizes reliable, user-controlled evidence collection. The application must never scan automatically or repair the system.

## Phase 0 — Product and repository foundation

- [x] Confirm product direction and first-release exclusions.
- [x] Confirm Windows desktop stack: C# / .NET 10 LTS / WPF.
- [x] Confirm manual scan + explicit confirmation rule.
- [x] Confirm local-first privacy and user-controlled sharing.
- [x] Define ChatGPT technical lead / Gemini primary producer workflow.
- [ ] Select license.

## Phase 1 — First runnable vertical slice

- [ ] Create solution and WPF project structure.
- [ ] Establish versioned scan/result contracts.
- [ ] Implement a pre-scan notice and explicit confirmation flow.
- [ ] Ensure no scan starts at app launch or without user confirmation.
- [ ] Implement PowerShell child-process runner with timeout, cancellation, JSON output, stdout/stderr capture, and exit-code handling.
- [ ] Implement initial collectors: OS, computer, CPU, motherboard/BIOS, memory, GPU, disks, network, and PnP problem devices.
- [ ] Display category progress and collection outcomes.
- [ ] Save a completed scan locally and show it in a basic history list.
- [ ] Allow user-selected JSON export.
- [ ] Add fixture-based tests and verify non-admin behavior.

**Exit criteria:** on Windows 11 x64, a user can deliberately start and confirm a read-only scan, view structured results, save the result locally, reopen it from history, and export JSON. No scan runs without consent.

## Phase 2 — Inventory and history MVP

- [ ] Expand hardware/device coverage: monitors/EDID, audio, Bluetooth, USB, detailed drivers, storage interfaces, and supported health metadata.
- [ ] Improve history browsing and deletion.
- [ ] Add reliable scan-to-scan comparison.
- [ ] Add readable HTML and TXT reports.
- [ ] Add field-level data preview and user-controlled inclusion/exclusion before sharing.

**Exit criteria:** users can inspect broad inventory, browse local scans, compare snapshots, and control what leaves the machine.

## Phase 3 — Reliability and error evidence

- [ ] System and Application event-log collection with visible configurable lookback.
- [ ] Unexpected shutdown and restart timeline.
- [ ] Bugcheck and WHEA event collection.
- [ ] Reliability Monitor/RAC data discovery.
- [ ] WER report discovery and safe metadata extraction.
- [ ] Event correlation with explicit evidence/uncertainty labels.

**Exit criteria:** the app can produce an evidence-based reliability timeline without asserting unsupported root causes.

## Phase 4 — AI Diagnostic Brief

- [ ] Full diagnostic brief.
- [ ] Focused briefs for restart/BSOD/device/driver/storage/network/application issues.
- [ ] Preview of exact included content and user-controlled sensitive-field selection.
- [ ] Copy, TXT, and HTML output.
- [ ] Prompt quality tests against representative fixtures.

**Exit criteria:** generated briefs are self-contained, traceable to collected evidence, and usable without an AI integration.

## Phase 5 — Stabilization and distribution

- [ ] Portable package.
- [ ] Windows installer package.
- [ ] Application logging and crash handling.
- [ ] Accessibility and localization.
- [ ] Security/privacy review.
- [ ] CI build and test workflow.
- [ ] Documentation, screenshots, release notes, and signed release process.

**Exit criteria:** both portable and installer distributions can be installed/launched safely and updated according to documented release procedures.

## Later / explicitly deferred

- Live sensor monitoring (temperature, power, fan speed, clocks).
- Online AI integrations.
- Automatic remediation and driver management.
- Benchmarking and stress testing.
- Advanced hardware telemetry requiring vendor-specific interfaces.
- Any automatic, scheduled, or background scan mode.
