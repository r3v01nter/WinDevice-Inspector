# Roadmap — WinDevice Inspector

This roadmap is intentionally staged. The first milestone is reliable evidence collection, not live monitoring or automated repair.

## Phase 0 — Product and repository foundation

- [x] Confirm product direction and first-release exclusions.
- [x] Define ChatGPT/Gemini handoff and delivery-inbox workflow.
- [ ] Review and approve requirements and architecture.
- [ ] Select license.
- [ ] Confirm target .NET LTS and WPF baseline.

## Phase 1 — Technical proof of concept

- [ ] Create solution and project structure.
- [ ] Establish versioned scan/result contracts.
- [ ] Implement PowerShell child-process runner with timeout, cancellation, JSON output, stdout/stderr capture, and exit-code handling.
- [ ] Implement first collectors: OS, computer, CPU, motherboard/BIOS, memory, GPU, disks, network, PnP devices.
- [ ] Verify non-admin behavior and partial-failure handling.
- [ ] Add fixture-based tests.

**Exit criteria:** a repeatable CLI/test harness can collect a structured snapshot on the target Windows machine without modifying system state.

## Phase 2 — Desktop MVP

- [ ] Dashboard with last scan, hardware summary, coverage, and findings.
- [ ] Quick Collection page with progress and per-category outcomes.
- [ ] Device/system detail pages.
- [ ] Local scan persistence and history list.
- [ ] JSON and HTML export.

**Exit criteria:** a user can launch the app, run a scan, inspect results, and export them.

## Phase 3 — Reliability and error evidence

- [ ] System and Application event-log collection with configurable lookback.
- [ ] Unexpected shutdown and restart timeline.
- [ ] Bugcheck and WHEA event collection.
- [ ] Reliability Monitor/RAC data discovery.
- [ ] WER report discovery and safe metadata extraction.
- [ ] Event correlation with explicit evidence/uncertainty labels.

**Exit criteria:** the app can produce an evidence-based reliability timeline without asserting unsupported root causes.

## Phase 4 — AI Diagnostic Brief

- [ ] Full diagnostic brief.
- [ ] Quick diagnostic brief.
- [ ] Focused briefs for restart/BSOD/device/driver/storage/network/application issues.
- [ ] Redaction preview and copy/export.
- [ ] Prompt quality tests against representative fixtures.

**Exit criteria:** generated briefs are self-contained, traceable to collected evidence, and usable without an AI integration.

## Phase 5 — Stabilization and public release

- [ ] Installer/package strategy.
- [ ] Application logging and crash handling.
- [ ] Accessibility and localization.
- [ ] Security/privacy review.
- [ ] CI build and test workflow.
- [ ] Documentation, screenshots, release notes, and signed release process.

## Later / explicitly deferred

- Live sensor monitoring (temperature, power, fan speed, clocks).
- Online AI integrations.
- Automatic remediation and driver management.
- Benchmarking and stress testing.
- Advanced hardware telemetry requiring vendor-specific interfaces.
