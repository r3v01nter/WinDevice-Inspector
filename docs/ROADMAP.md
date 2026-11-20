# Roadmap — WinDevice Inspector

The roadmap is staged around one-click, comprehensive, user-controlled device diagnostics and AI-ready evidence exports. The application must never scan automatically or repair the system. The detailed product baseline is [完整设备诊断与报告导出需求](完整设备诊断与报告导出需求.md).

## Phase 0 — Product and repository foundation

- [x] Confirm product direction and first-release exclusions.
- [x] Confirm C# / .NET 10 LTS / WPF and Windows 11 x64 baseline.
- [x] Confirm manual scan + explicit confirmation rule.
- [x] Confirm local-first privacy and user-controlled sharing.
- [x] Define Gemini primary producer / ChatGPT technical lead and review workflow.
- [x] Establish project overview, repository navigation, and file-placement rules.
- [x] Publish TASK-0001 standalone formal task brief and record owner decisions.
- [ ] Approve the Phase 1 minimal project/module structure and Persistence boundary (C-02).
- [ ] Select project license.
- [ ] Verify owner development environment.

## Phase 1 — First runnable vertical slice

- [ ] Create solution and minimal WPF project structure (only after C-02 approval).
- [ ] Establish complete Schema v1 scan/result contracts, including time-zone context, application version, category duration where measurable, and actual query/collection parameters.
- [ ] Implement pre-scan notice and explicit confirmation.
- [ ] Prove no scan starts at application startup or without user confirmation.
- [ ] Implement PowerShell child-process runner supporting both PowerShell 7 and Windows PowerShell 5.1, with test evidence for each version.
- [ ] Implement timeout, cancellation, JSON output, stdout/stderr capture, and exit-code handling.
- [ ] Implement initial collectors: OS, computer, CPU, motherboard/BIOS, memory, GPU, disks, network, and PnP problem devices.
- [ ] Display progress and per-category outcomes.
- [ ] Save completed scans locally and show a basic history list.
- [ ] Allow explicit user-selected JSON export with a pre-export sensitive-information warning.
- [ ] Add fixture-based tests and verify non-admin behavior.

**Exit criteria:** on Windows 11 x64, a user can deliberately start and confirm a read-only scan, inspect structured results, save the result locally, reopen it from history, and export JSON. No scan runs without consent; both PowerShell versions have test evidence; raw export cancellation performs no write.

## Phase 2 — Inventory and history MVP

- [ ] Expand hardware/device coverage: monitors/EDID, audio, Bluetooth, USB, detailed drivers, storage interfaces, and supported health metadata.
- [ ] Improve history browsing and user-controlled deletion.
- [ ] Add reliable scan-to-scan comparison.
- [ ] Add readable HTML and TXT reports.
- [ ] Add actual-content preview and user-controlled field/category inclusion before sharing.

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

**Exit criteria:** both portable and installer distributions can be launched safely and updated according to documented release procedures.

## Later / explicitly deferred

- Live sensor monitoring (temperature, power, fan speed, clocks).
- Online AI integrations.
- Automatic remediation and driver management.
- Benchmarking and stress testing.
- Advanced hardware telemetry requiring vendor-specific interfaces.
- Any automatic, scheduled, or background scan mode.


## Product direction update — 2026-11-20

The project owner confirmed that the product's target is comprehensive one-click device diagnostics, not merely a short inventory scan. The following capability sequence is the authoritative expansion of the roadmap; older phase bullets should be interpreted in this order and must not be used to narrow the confirmed product scope.

### Comprehensive device coverage
- Enumerate all currently present Windows PnP devices and classes, including unknown/problem devices.
- Classify hidden, disconnected, historical, virtual, and logical devices separately.
- Collect device IDs, instance paths, parent/location relationships, status, Problem Codes, driver metadata, and available interface/bus details.
- Expand hardware coverage across PCI/PCIe, USB, storage controllers, network, audio, display, input, camera, biometric, power, and other device classes.

### Hardware telemetry and interface health
- Collect supported CPU/GPU/motherboard/memory/storage/network sensor snapshots.
- Collect SMART/NVMe health and error information where exposed by the controller/driver.
- Inspect supported PCI/PCIe, USB, SATA/NVMe, network, audio, and display interface state.
- Record source, unit, timestamp, validity, threshold basis, and hardware limitations for each value.
- Explicitly report unsupported sensors, inaccessible interfaces, suspicious values, and failed reads.

### Reliability and error evidence
- Collect configurable-window System/Application events, unexpected shutdowns/restarts, BugCheck, WHEA, storage/filesystem/controller, PCIe, USB, display, network, and device-reset evidence.
- Discover Reliability Monitor/RAC and WER records where supported.
- Correlate evidence by time without asserting unsupported causality.

### Complete report package and AI handoff
- Canonical structured JSON with raw evidence, device records, statuses, sources, and collection completeness.
- XLSX workbook with overview, all devices, abnormal/warning devices, drivers, interfaces, sensors, events, and collection gaps.
- HTML diagnostic overview and detailed evidence views.
- Self-contained AI analysis instructions requiring evidence-based reasoning and explicit uncertainty.
- ZIP packaging, preview, and user-controlled sensitive-field inclusion.

### Stabilization and distribution
- After collection and report-package acceptance: portable package, Windows installer, CI, accessibility/localization, security/privacy review, and release process.

Continuous live monitoring, automatic repair, driver management, stress testing, online AI integration, automatic upload, and background/scheduled scanning remain outside the confirmed scope.
